 require "src.states.CombinationStates"
 luaunit = require "tests.luaunit.luaunit"
 local combinations = Combinations()

function testCheckFlush()
    assert(combinations:checkFlush({{1, 1}, {2, 1}, {3, 1}}) == false, "Test 1 Failed")
    
    assert(combinations:checkFlush({{1, 1}, {1, 1}, {1, 1}}) == true, "Test 2 Failed")

    print("All tests passed!")
end

function testCheckChainStraight()

    
    assert(combinations:checkChainStraight({{1, 1}, {2, 1}, {3, 1}}) == false, "Test 1 Failed")


    assert(combinations:checkChainStraight({{1, 1}, {3, 1}, {2, 1}}) == false, "Test 2 Failed")

    assert(combinations:checkChainStraight({{1, 2}, {2, 3}, {3, 4}}) == true, "Test 3 Failed")
end

function testCheckThreeOfAKind()
  
     assert(combinations:checkThreeOfAKind({{1, 1}, {1, 3}, {3, 1}}) == true, "Test 1 Failed")

     assert(combinations:checkThreeOfAKind({{1, 1}, {3, 1}, {2, 1}}) == false, "Test 2 Failed")
 
    
     assert(combinations:checkThreeOfAKind({{1, 2}, {2, 3}, {3, 4}}) == true, "Test 3 Failed")
    
end

-- SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
function testCheckSimpleStraight()
    assert(combinations:checkSimpleStraight({{1, 2}, {2, 3}, {3, 4}}) == false, "Test 1 Failed")
    assert(combinations:checkSimpleStraight({{1, 2}, {3, 4}, {5, 6}}) == true, "Test 2 Failed")

end



os.exit(luaunit.LuaUnit.run())
