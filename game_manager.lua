GameManager = Object:extend()
require "managerarrangment"
require "manager_knuckles"
require "src.managers.ButtonsManager"
require "Knuckle"


function GameManager:new()
    self.managerButtons = ManagerButtons()

    self.managerKnucle = ManagerKnuckles()
    self.managerKnucle:initialize()

    self.managerArrangment = ManagerArrangment(5, self.managerButtons, self.managerKnucle)
    self.managerArrangment:initialize()

    self.resetButon = false
    self.isResetStop = 0

    self.isFirstDealing = 0
    self.speed = 500
     
    self.resetKnucles = {}
    self.isAdNewKnucles = false

end

function GameManager:update(dt)
    --  добаить признак раздачи и сделать иф
    
    if self.isFirstDealing < 5 then
        self:firstDealing2(dt)
    end
   
--сброс карт 
    if self.resetButon then
        self:resetHandKnucles(dt)
    end
    
    -- добавление карт после сбороса
  
    if self.isAdNewKnucles then
       self:addNewKnucles(self.managerArrangment.decksize)   
    end


end

function GameManager:addNewKnucles(deksize)
     self.managerKnucle:addNewKnucles(deksize)



  
end


function GameManager:firstDealing2(dt)

-- получить свободные позиции для карт
    local freePositionsForKnucles =  self.managerArrangment.handsPositions
    for i = 1, #freePositionsForKnucles do
      print(freePositionsForKnucles[i].isFree)
      if freePositionsForKnucles[i].isFree
    end  

-- если есть свободная позиции  то взять карту необходимое количество карт  и поместить на эту позицию
     

  
end


function GameManager:firstDealing(dt)
    local hand = self.managerKnucle.handDeck
    -- if #hand ~= self.decksize then
    --  -- print("не совпадают размеры колоды и руки")
    -- end
  
    -- if self.move < 5  then
      for i = 1, #self.managerArrangment.handsPositions.x do
        if hand[i].isMove then
          local dx = self.managerArrangment.handsPositions.x[i] - hand[i].x
          local dy = self.managerArrangment.handsPositions.y[i] - hand[i].y
  
          if math.abs(dx) < 1 and math.abs(dy) < 1 then
            hand[i].isMove = false
            self.isFirstDealing = self.isFirstDealing + 1
          else
            local speed = self.speed * dt
            hand[i].x = hand[i].x + math.max(-speed * dt, math.min(speed , dx))
            hand[i].y = hand[i].y + math.max(-speed* dt, math.min(speed , dy))
  
            -- Увеличиваем угол вращения
            -- card.angle = card.angle + 5 * dt -- Измените 5 на любое значение для изменения скорости вращения
          end
        end
      end
  --  end
    
end


function GameManager:clickButton1(x, y)
    -- когда будут известны все зоны можно искать только в элеметах этой зоны

    if self.managerArrangment:isPlaceResetButtons(x, y) and self.resetButon ~= true then
      --  self.managerArrangment:showclickResetButton()
     -- if self.managerArrangment.move >4 then
        self.resetKnucles = self.managerKnucle:getSelectedKnucles()
   
      --   self.nowResetKnucle = man
         self.resetButon = true
        do return end
      end 


    
    if self.managerArrangment:isPlaceSteButtons(x, y) then
       -- self.managerArrangment:showclickSteButton()
        do return end
    end

    if self.managerArrangment:isPlaceDeckHand(x, y) and self.resetButon == false then
        self.managerArrangment:showSelectedKnucles(x, y)
        do return end
    end
end

function GameManager:resetHandKnucles(dt)
    local speed = self.speed * dt
    print(# self.resetKnucles )

    for i = 1, # self.resetKnucles  do
        print( self.resetKnucles [i].x)
        if  self.resetKnucles [i].isSelect then
            print("dwd" , self.resetKnucles [i].x)
            self.resetKnucles [i].isMove = true
             self.managerArrangment:moveKnucleToResetPosition(speed,  self.resetKnucles [i])
          
           -- handKnucles[i].move = isMove 
           
           --table.insert(resetKnucles, handKnucles[i])
            --self.managerArrangment:showResetKnucles(resetKnucles[i])
        end
       
    end

    local wasSelect = 0

    
    for i, value in ipairs(self.resetKnucles) do
        if value.isSelect then
            self.resetButon = true
            break
       else      
        wasSelect = i
        table.remove(self.resetKnucles, wasSelect)
      
        break
        end
    end
    
    if #self.resetKnucles == 0 then
        self.resetButon = false
      
        self.isAdNewKnucles = true
      
    end

    -- if wasSelect ~= 0 and self.resetKnucles[wasSelect].select == false then
    --     table.remove(self.resetKnucles, wasSelect)
    -- end

    -- if self.resetKnucles.length == 0 then
    --     self.resetButon = false
    -- end
    -- if wasSelect == 0 then
    --     self.resetButon = false
    -- end

    -- for i = 1, #resetKnucles do
    --      for j = 1, #handKnucles do
    --         if resetKnucles[i] == handKnucles[j] then
    --             table.remove(handKnucles, j)
    --            break
    --         end
    --      end
    
    -- end

    -- print(#handKnucles,    #resetKnucles)

end