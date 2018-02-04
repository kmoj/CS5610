defmodule Calc do
  @moduledoc """
  Documentation for Calc.
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


  #define struct exp
  #with four fields
  #int  integer   the opperands on ther right hand side
  #acc  integer   the results of math expression that has been evalued
  #expr list      the list of number and math op waiting to be evalued
  #error string   if there's any error in the math expression the error
  #massage is put in here

  #GIVEN: String
  #RETURN: the math evaluation result of the given str
  def eval(str) do
    str = String.trim(str)
    if String.length(str) == 0 || String.length(str) == 1 do
      str
    else

      exp = %{:int => nil, 
              :acc => nil, 
              :expr => syntax_process(str), 
              :error => nil
            }
      final_result = add_minus(exp)
      if final_result[:error] == nil do
        final_result[:acc]
      else
        final_result[:error]
      end

    end
  end

  #GIVEN: a string
  #RETURN: a list with all the number and math opperator
  #appeared in the given string as an item
  def syntax_process(str)  do
    str
    |>String.splitter("")
    |>Enum.map(fn (x) -> insert_space(x)  end)
    |>List.to_string()
    |>String.trim()
    |>String.split()
  end

  #GIVEN: a string which is either "+", "-", "*"
  #"/", "(", ")"
  #RETURN: a string like the given one with space 
  #concat to its both side 
  def insert_space(x) do
    if x == "+" || x == "-" || x == "*" || x == "/" || x == "(" || x == ")" do
      " "<>x<>" "
    else
      x
    end
  end

  #GIVEN: a exp
  #RETURN: the result from the math evaluation of it
  def add_minus(exp) do
    exp
    |>multi_div()
    |>add_minus_helper()
  end

  #GIVEN: a exp
  #RETURN: the result from the math evaluation of it
  #WHERE: the next math opperation going to do is either + or -
  def add_minus_helper(multi_div_result) do
      lhs = multi_div_result[:acc]
      op = List.first(multi_div_result[:expr])
      tail = Enum.take(multi_div_result[:expr], 1 - Enum.count(multi_div_result[:expr]))

      if op == "+" || op == "-" do
        new_exp = %{:acc => nil, 
                    :int => nil, 
                    :expr => tail, 
                    :error => multi_div_result[:error]
                  }
        rhs_exp = multi_div(new_exp)
        rhs = rhs_exp[:acc]

        if rhs == nil do
          rhs = 1
          error_flag = "Error: rhs is missing"
        else
          error_flag = rhs_exp[:error]
        end

        if op == "+" do
          calculate_result = %{:acc => lhs + rhs, 
                               :int => rhs_exp[:int], 
                               :expr => rhs_exp[:expr], 
                               :error => error_flag
                             }
        else
          calculate_result = %{:acc => lhs - rhs, 
                               :int => rhs_exp[:int], 
                               :expr => rhs_exp[:expr], 
                               :error => error_flag
                             }
        end
        add_minus_helper(calculate_result)

     else
      multi_div_result
    end
  end
  
  #GIVEN: a exp
  #RETURN: the result from the math evaluation of it
  def multi_div(exp) do
    exp
    |>factor()
    |>multi_div_helper()
  end

  #GIVEN: a exp
  #RETURN: the result from the math evaluation of it
  #WHERE: the next math opperation going to do is either * or /
  def multi_div_helper(factor_result) do
      lhs = factor_result[:acc]
      op = List.first(factor_result[:expr])
      tail = Enum.take(factor_result[:expr], 1 - Enum.count(factor_result[:expr]))
      if op == "*" || op == "/" do

        new_exp = %{:acc => factor_result[:acc], 
                    :int => factor_result[:int], 
                    :expr => tail, 
                    :error => factor_result[:error]
                  }
        rhs_exp = factor(new_exp)
        rhs = rhs_exp[:int]
        error_flag = rhs_exp[:error]
        if rhs == nil do
          rhs = 0
          error_flag = "Error: rhs is missing"
        end

       if op == "*" do
          calculate_result = %{:acc => lhs * rhs, 
                               :int => rhs_exp[:int], 
                               :expr => rhs_exp[:expr], 
                               :error => error_flag
                             }
       else
          if rhs == 0 || rhs == nil do
            rhs = 1
            error_flag = "Error: rhs of div opperation can not be 0"
          else
            error_flag = rhs_exp[:error]
          end
          calculate_result = %{:acc => div(lhs, rhs), 
                               :int => rhs_exp[:int], 
                               :expr => rhs_exp[:expr], 
                               :error => error_flag
                             }
       end
       multi_div_helper(calculate_result)

     else
      factor_result
    end
  end

  #GIVEN: a exp
  #RETURN: the result from the math evaluation of it
  #WHERE: the first item on the exp's expr field is 
  #either ( or is a integer string
  def factor(exp) do
    if exp[:expr] == nil ||  List.first(exp[:expr]) == nil do

      %{:acc => exp[:acc], 
        :int => nil, 
        :expr => exp[:expr], 
        :error => exp[:error]
      }

    else
      
      head = List.first(exp[:expr])
      tail = Enum.take(exp[:expr], 1 - Enum.count(exp[:expr]))

        if head == "(" do

          new_exp = %{:acc => nil, 
                      :int => nil, 
                      :expr => tail, 
                      :error => exp[:error]
                    }
          temp_result = add_minus(new_exp)
          if temp_result[:expr] == nil do
            tail = []
          else
            tail = Enum.take(temp_result[:expr], 1 - Enum.count(temp_result[:expr]))
          end
          if exp[:acc] == nil do
            %{:acc => temp_result[:acc], 
              :int => temp_result[:acc], 
              :expr => tail, 
              :error => temp_result[:error]
            }
          else
            %{:acc => exp[:acc], 
              :int => temp_result[:acc], 
              :expr => tail, 
              :error => temp_result[:error]
            }
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
            %{:acc => num, :int => num, :expr => tail, :error => error_flag}
          else
            %{:acc => exp[:acc], :int => num, :expr => tail, :error => error_flag}
          end
        end
    end
  end

  #GIVEN: a string
  #RETURN: boolean
  #ture if the string only contains char digits
  def is_integer?(arg) do
    list =  String.splitter(arg, "", trim: true)
    Enum.all?(list, fn(x) -> is_digit?(x) end)
  end

  #GIVEN: a string of length 1
  #RETURN: boolean
  #ture if the string is char digits
  def is_digit?(arg) do
    Enum.any?(["0","1","2","3","4","5","6","7","8","9"], fn(x) -> x == arg end)
  end

end