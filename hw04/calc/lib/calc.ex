defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Calc.eval
      :world

  """

  def main() do
    case IO.gets(">") do
      :eof ->
        IO.puts "All done"
      {:error, reason} ->
        IO.puts "Error: #{reason}"
      str ->
        IO.puts(eval(str))
        main()
    end
  end


  def eval(str) do
    str = String.trim(str)
    if String.length(str) == 0 || String.length(str) == 1 do
      str
    else
      exp = %{:int => nil, :acc => nil, :expr => syntax_process(str), :error => nil}
      final_result = add_minus(exp)
      #IO.inspect(final_result[:error])
      if final_result[:error] == nil do
        final_result[:acc]
      else
        final_result[:error]
      end
    end
  end

  def syntax_process(str)  do
    str
    |>String.splitter("")
    |>Enum.map(fn (x) -> insert_space(x)  end)
    |>List.to_string()
    |>String.trim()
    |>String.split()
  end

  def insert_space(x) do
    if x == "+" || x == "-" || x == "*" || x == "/" || x == "(" || x == ")" do
      " "<>x<>" "
    else
      x
    end
  end

  def add_minus(exp) do
    exp
    |>multi_div()
    |>add_minus_helper()
    #multi_div_result = multi_div(exp)
    # #IO.puts("add_minus: " )
    # #IO.inspect(multi_div_result[:expr])
    #add_minus_helper(multi_div_result)
  end

  def add_minus_helper(multi_div_result) do
    # #IO.puts("add_minus: " )
    # #IO.inspect(exp[:expr])
    # cond do
    #   Enum.count(exp[:expr]) == 0 -> exp
    #   #Enum.count(exp[:expr]) == 1 -> %{:acc => String.to_float(List.first(exp[:expr])), :expr => exp[:expr]}
    #   true -> result = multi_div(exp)
    # end
      lhs = multi_div_result[:acc]
      #IO.puts("add_minus_helper")
      #IO.puts(multi_div_result[:expr])
      #IO.puts("add_minus_helper ")
      #IO.puts(Integer.to_string(lhs))
      op = List.first(multi_div_result[:expr])
      tail = Enum.take(multi_div_result[:expr], 1 - Enum.count(multi_div_result[:expr]))
      if op == "+" || op == "-" do
        new_exp = %{:acc => nil, :int => nil, :expr => tail, :error => multi_div_result[:error]}
        rhs_exp = multi_div(new_exp)
        #IO.puts("add_minus_helper find rhs")
        rhs = rhs_exp[:acc]
        #IO.puts(rhs_exp[:expr])
        # if rhs_exp[:expr] == nil do
        #   tail == []
        # else
        #   tail = Enum.take(rhs_exp[:expr], 1 - Enum.count(rhs_exp[:expr]))
        # end

       if op == "+" do
        #IO.puts("add_minus_helper rhs in *")
        #IO.inspect(rhs)
          calculate_result = %{:acc => lhs + rhs, :int => rhs_exp[:int], :expr => rhs_exp[:expr], :error => rhs_exp[:error]}
       else
          calculate_result = %{:acc => lhs - rhs, :int => rhs_exp[:int], :expr => rhs_exp[:expr], :error => rhs_exp[:error]}
       end
       #IO.puts(" add_minus_helper 111")
       #IO.puts(calculate_result[:expr])
       add_minus_helper(calculate_result)
     else
      multi_div_result
    end
  end
  
  def multi_div(exp) do
    exp
    |>factor()
    |>multi_div_helper()
    # #IO.puts("enter multi_div: ")
    # #IO.inspect(exp[:acc])
    # #IO.inspect(exp[:expr])
    # factor_result = factor(exp)
    # multi_div_helper(factor_result)
  end

  def multi_div_helper(factor_result) do
      lhs = factor_result[:acc]
      #IO.puts("multi_div_helper")
      #IO.puts(factor_result[:expr])
      #IO.puts("multi_div_helper2 ")
      #IO.inspect(lhs)
      op = List.first(factor_result[:expr])
      tail = Enum.take(factor_result[:expr], 1 - Enum.count(factor_result[:expr]))
      if op == "*" || op == "/" do
        new_exp = %{:acc => factor_result[:acc], :int => factor_result[:int], :expr => tail, :error => factor_result[:error]}
        rhs_exp = factor(new_exp)
        #IO.puts("find rhs")
        rhs = rhs_exp[:int]
        #IO.puts(rhs_exp[:expr])
        # if rhs_exp[:expr] == nil do
        #   tail == []
        # else
        #   tail = Enum.take(rhs_exp[:expr], 1 - Enum.count(rhs_exp[:expr]))
        # end

       if op == "*" do
        #IO.puts("rhs in *")
        #IO.inspect(rhs)
          calculate_result = %{:acc => lhs * rhs, :int => rhs_exp[:int], :expr => rhs_exp[:expr], :error => rhs_exp[:error]}
       else
          if rhs == 0 do
            rhs = 1
            error_flag = "Error: rhs of div opperation can not be 0"
          else
            error_flag = rhs_exp[:error]
          end
          calculate_result = %{:acc => div(lhs, rhs), :int => rhs_exp[:int], :expr => rhs_exp[:expr], :error => error_flag}
       end
       #IO.puts("111")
       #IO.puts(calculate_result[:expr])
       multi_div_helper(calculate_result)
     else
      factor_result
    end
  end

  def factor(exp) do
    #IO.puts("factor: " )
    #IO.inspect(exp[:expr])
    if exp[:expr] == nil ||  List.first(exp[:expr]) == nil do
      exp
    else
      
      head = List.first(exp[:expr])
      tail = Enum.take(exp[:expr], 1 - Enum.count(exp[:expr]))

        if head == "(" do
          new_exp = %{:acc => nil, :int => nil, :expr => tail, :error => exp[:error]}
          temp_result = add_minus(new_exp)
          if temp_result[:expr] == nil do
            tail = []
            #IO.puts("nil" )
          else
            tail = Enum.take(temp_result[:expr], 1 - Enum.count(temp_result[:expr]))
            #IO.puts("1" )
          end
          #IO.puts("factor2: " )
          #IO.inspect(tail)
          #IO.puts("factor after ) acc value 1: " )
          #IO.inspect(temp_result[:acc])
          #IO.puts("factor after ) int value 1: " )
          #IO.inspect(temp_result[:int])
          #IO.puts("factor after ) int value 2: " )
          #IO.inspect(exp[:int])

          if exp[:acc] == nil do
            %{:acc => temp_result[:acc], :int => temp_result[:acc], :expr => tail, :error => temp_result[:error]}
          else
            %{:acc => exp[:acc], :int => temp_result[:acc], :expr => tail, :error => temp_result[:error]}
          end
          
        else
          
          if is_integer?(head) do
            num = String.to_integer(head)
            error_flag = exp[:error]
          else
            num = 1
            error_flag = "Error: opperator error"
          end

          if exp[:acc] == nil do
            #IO.puts(":acc nil " )
            %{:acc => num, :int => num, :expr => tail, :error => error_flag}
          else
            #IO.puts(":acc: " )
            #IO.puts(Integer.to_string(exp[:acc]))
            #IO.puts(":int: " )
            #IO.puts(head)
            %{:acc => exp[:acc], :int => num, :expr => tail, :error => error_flag}
          end
        end
    end
  end

  def is_integer?(arg) do
    
    list =  String.splitter(arg, "", trim: true)
    ans = Enum.all?(list, fn(x) -> is_digit?(x) end)
    #Enum.all?(list, fn(x) -> is_digit?(x) end)
  end

  def is_digit?(arg) do
    Enum.any?(["0","1","2","3","4","5","6","7","8","9"], fn(x) -> x == arg end)
  end

end