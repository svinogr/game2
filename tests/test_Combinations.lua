 require "src.states.combination.Combination"
luaunit = require "tests.luaunit.luaunit"
local Object = require "src.lib.classic"


function testCheckFlush()
    local combinations = Flush()      
  
    assert(combinations:check({{1, 1}, {2, 1}, {3, 1}}) == false, "Test 1 Failed")
    
    assert(combinations:check({{1, 1}, {1, 1}, {1, 1}}) == true, "Test 2 Failed")

    print("All tests passed!")
end

function testCheckChainStraight()
    local combinations = Straight()   
    
    assert(combinations:check({{1, 1}, {2, 1}, {3, 1}}) == false, "Test 1 Failed")


    assert(combinations:check({{1, 1}, {3, 1}, {2, 1}}) == false, "Test 2 Failed")

    assert(combinations:check({{1, 2}, {2, 3}, {3, 4}}) == true, "Test 3 Failed")
    
    assert(combinations:check({{2, 3}, {3, 4}, {4, 5}}) == true, "Test 5 Failed")

    assert(combinations:check({{1, 6}, {6, 2}, {2, 1}}) == false, "Test 4 Failed")
end

function testCheckThreeOfAKind()
    local combinations = ThreeOfKind()

     assert(combinations:check({{1, 1}, {1, 3}, {3, 1}}) == true, "Test 1 Failed")

     assert(combinations:check({{1, 1}, {3, 1}, {2, 1}}) == false, "Test 2 Failed")
 
    
     assert(combinations:check({{1, 2}, {2, 3}, {3, 4}}) == true, "Test 3 Failed")
     
    
end

-- SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
function testCheckSimpleStraight()
    local combinations = SimpleStraight()   
    assert(combinations:check({{1, 2}, {2, 3}, {3, 4}}) == false, "Test 1 Failed")
    assert(combinations:check({{1, 2}, {3, 4}, {5, 6}}) == true, "Test 2 Failed")
    assert(combinations:check({{2, 1}, {2, 4}, {5, 6}}) == false, "Test 3 Failed")

end



os.exit(luaunit.LuaUnit.run())
