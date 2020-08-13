class Parser
  attr_accessor :parsed_orders

  def initialize
    self.parsed_orders = []
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

end

class CodeWriter
  attr_accessor :filename, :for_asm_orders

  def initialize(filename)
    self.filename = filename
    self.for_asm_orders = []
  end

  def write_file
    File.open(self.filename, 'w') do |file|
      self.for_asm_orders.each do |order|
        file.puts(order)
      end
    end
  end

  def set_asm_order_according_to_vm_order(line, i)
    splitted_order = line.split(' ')
    if splitted_order[0] == 'push'
      if splitted_order[1] == 'constant'
        create_orders_for_constant(splitted_order[2].to_i)
      elsif splitted_order[1] == 'local'
        create_order_for_push_local(splitted_order[2].to_i)
      elsif splitted_order[1] == "argument"
        create_order_for_push_arg(splitted_order[2].to_i)
      elsif splitted_order[1] == "this"
        create_order_for_push_this(splitted_order[2].to_i)
      elsif splitted_order[1] == "that"
        create_order_for_push_that(splitted_order[2].to_i)
      elsif splitted_order[1] == "temp"
        create_order_for_push_temp(splitted_order[2].to_i)
      end
    elsif splitted_order[0] == 'pop'
      if splitted_order[1] == 'local'
        create_order_for_pop_local(splitted_order[2].to_i)
      elsif splitted_order[1] == "argument"
        create_order_for_pop_arg(splitted_order[2].to_i)
      elsif splitted_order[1] == "this"
        create_order_for_pop_this(splitted_order[2].to_i)
      elsif splitted_order[1] == "that"
        create_order_for_pop_that(splitted_order[2].to_i)
      elsif splitted_order[1] == "temp"
        create_order_for_pop_temp(splitted_order[2].to_i)
      end
    elsif splitted_order[0] == 'add'
      create_orders_for_add_func
    elsif splitted_order[0] == 'sub'
      create_orders_for_sub_func
    elsif splitted_order[0] == 'neg'
      create_orders_for_neg_func
    elsif ['eq', 'gt', 'lt'].include?(splitted_order[0])
      create_orders_for_boolean_func(splitted_order[0], i)
    elsif ['and', 'or'].include?(splitted_order[0])
      create_orders_for_and_or_func(splitted_order[0])
    elsif splitted_order[0] == 'not'
      create_orders_for_not_func
    end
  end

  private

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

  def create_order_for_pop_local(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@LCL"
    arr << "A=M"
    (index).times do 
      arr << "A=A+1"
    end
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_local(index)
    arr = []
    arr << "@LCL"
    arr << "A=M"
    (index).times do
      arr << "A=A+1"
    end
    arr << "D=M"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_order_for_pop_arg(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@ARG"
    arr << "A=M"
    (index).times do 
      arr << "A=A+1"
    end
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_arg(index)
    arr = []
    arr << "@ARG"
    arr << "A=M"
    (index).times do
      arr << "A=A+1"
    end
    arr << "D=M"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_order_for_pop_this(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@THIS"
    arr << "A=M"
    (index).times do 
      arr << "A=A+1"
    end
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_this(index)
    arr = []
    arr << "@THIS"
    arr << "A=M"
    (index).times do
      arr << "A=A+1"
    end
    arr << "D=M"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_order_for_pop_that(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@THAT"
    arr << "A=M"
    (index).times do 
      arr << "A=A+1"
    end
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_that(index)
    arr = []
    arr << "@THAT"
    arr << "A=M"
    (index).times do
      arr << "A=A+1"
    end
    arr << "D=M"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_order_for_pop_temp(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@#{5+index}"
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_temp(index)
    arr = []
    arr << "@#{5+index}"
    arr << "D=M"
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


# 実際の処理
filename = ARGV[0].dup
parser = Parser.new

parser.file_open_and_parse(filename)
filename.slice!('.vm')
new_file_name = filename + '.asm'
puts new_file_name
code_writer = CodeWriter.new(new_file_name)

parser.parsed_orders.each_with_index do |order, i|
  code_writer.set_asm_order_according_to_vm_order(order, i)
end

code_writer.write_file




