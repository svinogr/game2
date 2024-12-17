require "src.states.combination.Combination"
require "src.states.CombinationStates"
require "src.objects.Knuckle"
luaunit = require "tests.luaunit.luaunit"
local Object = require "src.lib.classic"


function testGenerateCombinations()
    VIRTUAL_WIDTH = 600
    VIRTUAL_HEIGHT = 451
    DEFAULT_SIZE_KNUCKLES = { VIRTUAL_WIDTH / 10, VIRTUAL_HEIGHT / 4 }
    DEFAULT_START_POSITION_KNUCKLES = { VIRTUAL_WIDTH - (VIRTUAL_WIDTH - 10), VIRTUAL_HEIGHT - 10 -
    DEFAULT_SIZE_KNUCKLES[2] }

    local combinations = CombinationsStates()
    local k1 = Knuckle(1, { 1, 4 }, 10)
    local K2 = Knuckle(2, { 6, 4 }, 10)
    local K3 = Knuckle(3, { 3, 2 }, 10)
    local knuckles = { k1, K2, K3 }
    combinations:check(knuckles)

    for index, value in ipairs(combinations.allGenerationCombinations) do
        local p = OnePair()
        p.curentCombinationValues = value
        local res = p:check(value)
        print(value[1][1] ..
        "-" ..
        value[1][2] ..
        " | " .. value[2][1] .. "-" .. value[2][2] .. " | " .. value[3][1] .. "-" .. value[3][2] ..
        " | -- " .. tostring(res))                                                                                                                --value.twoValues[1][1]
    end

    for index, value in ipairs(combinations.allGenerationCombinations) do
        local p = OnePair()
        p.curentCombinationValues = value
        local res = p:check(value)
        if res then
            print(value[1][1] ..
            "-" ..
            value[1][2] ..
            " | " .. value[2][1] .. "-" .. value[2][2] .. " | " .. value[3][1] ..
            "-" .. value[3][2] .. " | -- " .. tostring(res))                                                                                           --value.twoValues[1][1]
        end
    end

    print("kolvo = " .. #combinations.allGenerationCombinations)
end

function testSpeedMethods()
    local startTime = os.clock()
    local k1 = Knuckle(1, { 1, 4 }, 10)
    local K2 = Knuckle(2, { 6, 4 }, 10)
    local K3 = Knuckle(3, { 3, 2 }, 10)
    local knuckles = { k1, K2, K3 }
    for i = 1, 100, 1 do
        CombinationsStates:generateCombinations(knuckles)
    end
    local elapsedTime1 = os.clock() - startTime

    startTime = os.clock()
    for i = 1, 100, 1 do
        CombinationsStates:generateCombinations2(knuckles)
    end
    local elapsedTime2 = os.clock() - startTime
    print("Время выполнения generateCombinations: " .. elapsedTime1)
    print("Время выполнения generateCombinations2: " .. elapsedTime2)
end

function testOnePair()
    local combinations = OnePair()
    -- assert(combinations:check({{1, 4}, {6, 4}, {3, 3}}) == true, "Test 1 Failed")
    -- assert(combinations:check({{3, 3}, {6, 4}, {1, 4}}) == true, "Test 2 Failed")
end

function testCheckFlush()
    local combinations = Flush()

    assert(combinations:check({ { 1, 1 }, { 2, 1 }, { 3, 1 } }) == false, "Test 1 Failed")

    assert(combinations:check({ { 1, 1 }, { 1, 1 }, { 1, 1 } }) == true, "Test 2 Failed")

    print("All tests passed!")
end

function testCheckChainStraight()
    local combinations = Straight()

    assert(combinations:check({ { 1, 1 }, { 2, 1 }, { 3, 1 } }) == false, "Test 1 Failed")


    assert(combinations:check({ { 1, 1 }, { 3, 1 }, { 2, 1 } }) == false, "Test 2 Failed")

    assert(combinations:check({ { 1, 2 }, { 2, 3 }, { 3, 4 } }) == true, "Test 3 Failed")

    assert(combinations:check({ { 2, 3 }, { 3, 4 }, { 4, 5 } }) == true, "Test 5 Failed")

    assert(combinations:check({ { 1, 6 }, { 6, 2 }, { 2, 1 } }) == false, "Test 4 Failed")
end

function testCheckThreeOfAKind()
    local combinations = ThreeOfKind()

    assert(combinations:check({ { 1, 1 }, { 1, 3 }, { 3, 1 } }) == true, "Test 1 Failed")

    assert(combinations:check({ { 1, 1 }, { 3, 1 }, { 2, 1 } }) == false, "Test 2 Failed")


    assert(combinations:check({ { 1, 2 }, { 2, 3 }, { 3, 4 } }) == true, "Test 3 Failed")
end

-- SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
function testCheckSimpleStraight()
    local combinations = SimpleStraight()
    assert(combinations:check({ { 1, 2 }, { 2, 3 }, { 3, 4 } }) == false, "Test 1 Failed")
    assert(combinations:check({ { 1, 2 }, { 3, 4 }, { 5, 6 } }) == true, "Test 2 Failed")
    assert(combinations:check({ { 2, 1 }, { 2, 4 }, { 5, 6 } }) == false, "Test 3 Failed")
end

os.exit(luaunit.LuaUnit.run())
