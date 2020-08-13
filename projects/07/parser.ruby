class Parser
  attr_accessor :parsed_orders, :stack, :for_asm_orders

  def initialize
    self.parsed_orders = []
    self.stack = []
    self.for_asm_orders = []
  end

  def file_open_and_parse(filename)
    File.open(filename, "r:UTF-8") do |file|
      file.each do |line|
        line.strip!

        # コメント または 空行なら 命令(order) ではない
        if line.slice(0, 2) == '//' or line == ""
          next
        end
        parsed_orders << line
      end
    end
  end

  def create_orders_for_constant(const_value)
    arr = []
    arr << "@#{const_value}"
    arr << "D=A"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_orders_for_add_func
    arr = []
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "D=M"
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "M=M+D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_orders_for_sub_func
    arr = []
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "D=M"
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "M=M-D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_orders_for_neg_func
    arr = []
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "M=-M"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_orders_for_boolean_func(condition, index)
    arr = create_boolean_orders(condition, index)
    set_orders_of_asms(arr)
  end

  def create_orders_for_and_or_func(condition)
    arr = []
    if condition == 'and'
      asm_condition = '&'
    elsif condition == 'or'
      asm_condition = '|'
    end
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "D=M"
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "M=D#{asm_condition}M"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_orders_for_not_func
    arr = []
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "M=!M"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  private

  def set_orders_of_asms(arr)
    self.for_asm_orders << arr
    self.for_asm_orders.flatten!
  end

  def create_boolean_orders(condition, index)
    if condition == 'eq'
      jump_condition = 'EQ'
    elsif condition == 'gt'
      jump_condition = 'GT'
    elsif condition == 'lt'
      jump_condition = 'LT'
    end
    arr = []
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "D=M"
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "D=M-D"
    arr << "@IF_TRUE_#{index}"
    arr << "D;J#{jump_condition}"
    arr << "@SP"
    arr << "A=M"
    arr << "M=0"
    arr << "@AFTER_NOT_TRUE_#{index}"
    arr << "0;JMP"
    arr << "(IF_TRUE_#{index})"
    arr << "@SP"
    arr << "A=M"
    arr << "M=-1"
    arr << "(AFTER_NOT_TRUE_#{index})"
    arr << "@SP"
    arr << "M=M+1"
    arr
  end

end

def write_file(new_file_name, orders)
  File.open(new_file_name, 'w') do |file|
    orders.each do |order|
      file.puts(order)
    end
  end
end


# 実際の処理
filename = ARGV[0].dup
parser = Parser.new
parser.file_open_and_parse(filename)

parser.parsed_orders.each_with_index do |order, i|
  splitted_order = order.split(' ')
  if splitted_order[0] == 'push'
    if splitted_order[1] == 'constant'
      parser.create_orders_for_constant(splitted_order[2].to_i)
    end
  elsif splitted_order[0] == 'add'
    parser.create_orders_for_add_func
  elsif splitted_order[0] == 'sub'
    parser.create_orders_for_sub_func
  elsif splitted_order[0] == 'neg'
    parser.create_orders_for_neg_func
  elsif ['eq', 'gt', 'lt'].include?(splitted_order[0])
    parser.create_orders_for_boolean_func(splitted_order[0], i)
  elsif ['and', 'or'].include?(splitted_order[0])
    parser.create_orders_for_and_or_func(splitted_order[0])
  elsif splitted_order[0] == 'not'
    parser.create_orders_for_not_func
  end
end

filename.slice!('.vm')
new_file_name = filename + '.asm'
puts new_file_name
write_file(new_file_name, parser.for_asm_orders)




