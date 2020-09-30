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
    create_boot_strap_code()
  end

  def write_file
    File.open(self.filename + '.asm', 'w') do |file|
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
      elsif splitted_order[1] == 'pointer'
        create_order_for_push_pointer(splitted_order[2].to_i)
      elsif splitted_order[1] == 'static'
        create_order_for_push_static(splitted_order[2].to_i)
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
      elsif splitted_order[1] == 'pointer'
        create_order_for_pop_pointer(splitted_order[2].to_i)
      elsif splitted_order[1] == 'static'
        create_order_for_pop_static(splitted_order[2].to_i)
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
    elsif splitted_order[0] == 'label'
      create_order_for_label(splitted_order[1])
    elsif splitted_order[0] == 'goto'
      create_order_for_goto(splitted_order[1])
    elsif splitted_order[0] == 'if-goto'
      create_order_for_if_goto(splitted_order[1])
    elsif splitted_order[0] == 'function'
      create_order_for_function(splitted_order[1], splitted_order[2])
    elsif splitted_order[0] == 'return'
      create_order_for_return()
    elsif splitted_order[0] == 'call'
      create_order_for_call(splitted_order[1], splitted_order[2], i)
    end
  end

  private

  def set_initial_order
    arr = []
    arr << "@256"
    arr << "D=A"
    arr << "@SP"
    arr << "M=D"
    set_orders_of_asms(arr)
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

  def create_order_for_push_pointer(index)
    arr = []
    arr << "@#{3+index}"
    arr << "D=M"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_order_for_pop_pointer(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@#{3+index}"
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_static(index)
    arr = []
    arr << "@#{filename + '.' + index.to_s}"
    arr << "D=M"
    arr << "@SP"
    arr << "A=M"
    arr << "M=D"
    arr << "@SP"
    arr << "M=M+1"
    set_orders_of_asms(arr)
  end

  def create_order_for_pop_static(index)
    arr = []
    arr << "@SP"
    arr << "M=M-1"    
    arr << "A=M"
    arr << "D=M"
    arr << "@#{filename + '.' + index.to_s}"
    arr << "M=D"
    set_orders_of_asms(arr)
  end

  # 算術コマンド

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

  def create_order_for_label(label_name)
    arr = []
    arr << "(#{label_name})"
    set_orders_of_asms(arr)
  end

  def create_order_for_goto(label_name)
    arr = []
    arr << "@#{label_name}"
    arr << "0;JMP"
    set_orders_of_asms(arr)
  end

  def create_order_for_if_goto(label_name)
    arr = []
    arr << "@SP"
    arr << "M=M-1"
    arr << "A=M"
    arr << "D=M"
    arr << "@#{label_name}"
    arr << "D;JNE"
    set_orders_of_asms(arr)
  end

  def create_order_for_function(function_name, local_var_count)
    local_var_count = local_var_count.to_i
    arr = []
    arr << "(#{function_name})"
    local_var_count.times do 
      arr << "@0"
      arr << "D=A"
      arr << "@SP"
      arr << "A=M"
      arr << "M=D"
      arr << "@SP"
      arr << "M=M+1"
    end
    set_orders_of_asms(arr)
  end

  def create_order_for_return
    arr = []
    arr << "@LCL"
    arr << "D=M"
    arr << "@13"
    arr << "M=D"
    arr << "@13"
    arr << "D=M"
    arr << "@5"
    arr << "D=D-A"
    arr << "A=D"
    arr << "D=M"
    arr << "@14"
    arr << "M=D"
    
    # args.pop()
    arr <<'@SP'
    arr <<'A=M-1'
    arr <<'D=M'
    arr <<'@ARG'
    arr <<'A=M'
    arr <<'M=D'
    arr <<'@SP'
    arr <<'M=M-1'

    # SP = ARG + 1
    arr << "@ARG"
    arr << "D=M+1"
    arr << "@SP"
    arr << "M=D"

    arr << '@13'
    arr << 'A=M-1'
    arr << 'D=M'
    arr << '@THAT'
    arr << 'M=D'

    # THIS
    arr << '@13'
    arr << 'D=M'
    arr << '@2'
    arr << 'A=D-A'
    arr << 'D=M'
    arr << '@THIS'
    arr << 'M=D'

    arr << '@13'
    arr << 'D=M'
    arr << '@3'
    arr << 'A=D-A'
    arr << 'D=M'
    arr << '@ARG'
    arr << 'M=D'
  
    arr << '@13'
    arr << 'D=M'
    arr << '@4'
    arr << 'A=D-A'
    arr << 'D=M'
    arr << '@LCL'
    arr << 'M=D'
    
    arr << '@14'
    arr << 'A=M'
    arr << '0;JMP'
    set_orders_of_asms(arr)
  end

  def create_order_for_call(function_name, arg_count, i)
    arg_count = arg_count.to_i
    arr = []

    # RETURNアドレスの位置を格納
    arr << "@RETURN_ADDRESS_#{i}"
    arr << "D=A"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    # 現在のLCLの値をSPに格納
    arr << "@LCL"
    arr << "D=A"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    arr << "@ARG"
    arr << "D=M"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    arr << "@THIS"
    arr << "D=M"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    arr << "@THAT"
    arr << "D=M"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    # @ARGの示す位置を更新する
    arr << "@SP"
    arr << "D=M"
    arr << "@#{arg_count + 5}"
    arr << "D=D-A"
    arr << "@ARG"
    arr << "M=D"

    # LCLをSPの位置に宣言。呼び出され側が必要なローカル変数分、0を初期値として宣言していくが呼び出し側は気にしない
    arr << "@SP"
    arr << "D=M"
    arr << "@LCL"
    arr << "M=D"

    # goto f
    arr << "@#{function_name}"
    arr << "0;JMP"

    # リターンアドレスの宣言
    arr << "(RETURN_ADDRESS_#{i})"
    set_orders_of_asms(arr)
  end

  def create_boot_strap_code()
    arr = []
    arr << "@256"
    arr << "D=A"
    arr << "@SP"
    arr << "M=D"
    label_name = "return-address-sysinit"
    arr << "@#{label_name}"

    # 現在のLCLの値をSPに格納
    arr << "@LCL"
    arr << "D=A"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    arr << "@ARG"
    arr << "D=M"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    arr << "@THIS"
    arr << "D=M"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    arr << "@THAT"
    arr << "D=M"
    arr = arr + create_order_for_push_D_to_SP_and_plus1_on_SP

    # @ARGの示す位置を更新する
    arr << "@SP"
    arr << "D=M"
    arr << "@5"
    arr << "D=D-A"
    arr << "@ARG"
    arr << "M=D"

    # LCLをSPの位置に宣言。呼び出され側が必要なローカル変数分、0を初期値として宣言していくが呼び出し側は気にしない
    arr << "@SP"
    arr << "D=M"
    arr << "@LCL"
    arr << "M=D"

    # goto f
    arr << "@Sys.init"
    arr << "0;JMP"
    arr << "(#{label_name})"
    set_orders_of_asms(arr)
  end

  def create_order_for_push_D_to_SP_and_plus1_on_SP
    return ["@SP", "A=M", "M=D", "@SP", "M=M+1"]
  end
  
end


# 実際の処理
filename = ARGV[0].dup
parser = Parser.new

parser.file_open_and_parse(filename)
filename.slice!('.vm')
puts filename
code_writer = CodeWriter.new(filename)

parser.parsed_orders.each_with_index do |order, i|
  code_writer.set_asm_order_according_to_vm_order(order, i)
end

code_writer.write_file




