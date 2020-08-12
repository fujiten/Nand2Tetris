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
    arr << "@SP"
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

  private

  def set_orders_of_asms(arr)
    self.for_asm_orders << arr
    self.for_asm_orders.flatten!
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

parser.parsed_orders.each do |order|
  splitted_order = order.split(' ')
  if splitted_order[0] == 'push'
    if splitted_order[1] == 'constant'
      parser.create_orders_for_constant(splitted_order[2].to_i)
    end
  elsif splitted_order[0] == 'add'
    parser.create_orders_for_add_func
  end
end

filename.slice!('.vm')
new_file_name = filename + '.asm'
puts new_file_name
write_file(new_file_name, parser.for_asm_orders)




