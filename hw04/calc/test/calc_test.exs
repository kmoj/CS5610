defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "eval function" do
  	assert Calc.eval("") == ""
  	assert Calc.eval("1") == "1"
    assert Calc.eval("+") == "+"
    assert Calc.eval("1 +") == "Error: rhs is missing"
    assert Calc.eval("1 + +") == "Error: opperator error"
    assert Calc.eval("1.2 + 2") == "Error: opperator error"
    assert Calc.eval("1 /") == "Error: rhs of div opperation can not be 0"
    assert Calc.eval("6 /0") == "Error: rhs of div opperation can not be 0"
    assert Calc.eval("6*2") == 12
    assert Calc.eval("6*(2+1)") == 18
    assert Calc.eval("(6/2-1)*(2+1)") == 6
    assert Calc.eval("(6-4/2-1)*(2+1)/3-6") == -3
  end

  test "syntax_process function" do
  	assert Calc.syntax_process("") == []
  	assert Calc.syntax_process("1") == ["1"]
    assert Calc.syntax_process("1 +") == ["1", "+"]
    assert Calc.syntax_process("1.2 + 2") == ["1.2", "+", "2"]
    assert Calc.syntax_process("6 /0") == ["6", "/", "0"]
    assert Calc.syntax_process("6*2") == ["6", "*", "2"]
    assert Calc.syntax_process("6*(2+1)") == ["6", "*","(", "2", "+", "1", ")"]
  end

  test "insert_space function" do
  	assert Calc.insert_space("") == ""
  	assert Calc.insert_space("1") == "1"
    assert Calc.insert_space("+") == " + "
    assert Calc.insert_space("(") == " ( "
    assert Calc.insert_space("1.2") == "1.2"
  end

  test "add_minus function" do
  	assert Calc.add_minus(%{:int => nil, :acc => nil, :expr => ["1", "+"], :error => nil}) 
  	== %{:int => nil, :acc => 2, :expr => [], :error => "Error: rhs is missing"}
  	assert Calc.add_minus(%{:int => nil, :acc => nil, :expr => ["1.2", "+", "2"], :error => nil}) 
  	== %{:int => 2, :acc => 3, :expr => [], :error => "Error: opperator error"}
    assert Calc.add_minus(%{:int => nil, :acc => nil, :expr => ["6", "*","(", "2", "+", "1", ")"], :error => nil}) 
    == %{:int => 3, :acc => 18, :expr => [], :error => nil}
  end

  test "add_minus_helper function" do
  	assert Calc.add_minus_helper(%{:int => 1, :acc => 1, :expr => ["+"], :error => nil}) 
  	== %{:int => nil, :acc => 2, :expr => [], :error => "Error: rhs is missing"}
    assert Calc.add_minus_helper(%{:int => 2, :acc => 6, :expr => ["+", "1"], :error => nil}) 
    == %{:int => 1, :acc => 7, :expr => [], :error => nil}
  end

  test "multi_div function" do
  	assert Calc.multi_div(%{:int => nil, :acc => nil, :expr => ["1", "*"], :error => nil}) 
  	== %{:int => nil, :acc => 0, :expr => [], :error => "Error: rhs is missing"}
  	assert Calc.multi_div(%{:int => nil, :acc => nil, :expr => ["1.2", "*", "2"], :error => nil}) 
  	== %{:int => 2, :acc => 2, :expr => [], :error => "Error: opperator error"}
    assert Calc.multi_div(%{:int => nil, :acc => nil, :expr => ["6", "*","(", "2", "+", "1", ")"], :error => nil}) 
    == %{:int => 3, :acc => 18, :expr => [], :error => nil}
  end

  test "factor function" do
  	assert Calc.factor(%{:int => nil, :acc => nil, :expr => ["1.2", "*", "2"], :error => nil}) 
  	== %{:int => 1, :acc => 1, :expr => ["*", "2"], :error => "Error: opperator error"}
    assert Calc.factor(%{:int => nil, :acc => nil, :expr => ["2", "*", "5"], :error => nil}) 
    == %{:int => 2, :acc => 2, :expr => ["*", "5"], :error => nil}
    assert Calc.factor(%{:int => nil, :acc => 3, :expr => ["2", "*", "5"], :error => nil}) 
    == %{:int => 2, :acc => 3, :expr => ["*", "5"], :error => nil}
    assert Calc.factor(%{:int => nil, :acc => nil, :expr => ["(", "2", "+", "5", ")", "*", "2"], :error => nil}) 
    == %{:int => 7, :acc => 7, :expr => ["*", "2"], :error => nil}
  end

  test "is_integer? function" do
  	assert Calc.is_integer?("123") == true
    assert Calc.is_integer?("1.2") == false
    assert Calc.is_integer?("+") == false
  end

  test "is_digit? function" do
  	assert Calc.is_integer?("1") == true
    assert Calc.is_integer?(".") == false
    assert Calc.is_integer?("+") == false
  end

end
