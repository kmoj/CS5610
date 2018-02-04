defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "eval function" do
  	#assert Calc.eval("") == ""
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
  end
end
