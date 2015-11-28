local background=display.newImageRect("paisaje.png" ,1324,768);
background.x=display.contentCenterX
background.y=display.contentCenterY
display.setStatusBar(display.HiddenStatusBar)

local bird=display.newImageRect("cartoon_bird.png" ,80,80)
bird.x=192
bird.y=512

local animalMaterial={density=1,friction=0.2,bounce=0.5}
local structureMaterial={density=2,friction=0.5}
local groundMaterial={density=5,friction=1}

local physics=require("physics" )
physics.start()
physics.addBody(bird,animalMaterial)

local ground=display.newRect(background.x,672,1366,192)
physics.addBody(ground,"static" ,groundMaterial)
ground.isVisible=false

local plank=display.newImageRect("Wood-Plank.png" ,200,30.5)
plank.x=800;plank.y=432
physics.addBody(plank,structureMaterial) 

local column1=display.newImageRect("column.png" ,30,122)
column1.x=720;column1.y=512
physics.addBody(column1,structureMaterial)

local column2=display.newImageRect("column.png" ,30,122)
column2.x=880;column2.y=512
physics.addBody(column2,structureMaterial)



-- local pig=display.newImageRect("Pig-Pink.png" ,80,74)
local pigSheet=graphics.newImageSheet("pigs.png" ,{width=80,height=80,numFrames=2,sheetContentWidth=160,sheetContentHeight=80})

local sequenceData={name="pigs" ,start=1,count=2}
local pig=display.newSprite(pigSheet,sequenceData)
pig:setSequence("pigs" )
pig:setFrame(1)
pig.x=800;pig.y=368
physics.addBody(pig,animalMaterial)

-- bird:applyLinearImpulse(200,0.5,bird.x,bird.y)

bird.x0=bird.x
bird.y0=bird.y
function onTouch(event)
       if event.phase=="began"  then
             display.getCurrentStage():setFocus(bird)
             physics.pause()
       elseif event.phase=="moved"  then
          local length=math.sqrt((event.x-bird.x0)^2+(event.y-bird.y0)^2)
          local d=length-64

          if length<=64 then 
              bird.x=event.x
              bird.y=event.y
          else
              bird.x=(64*event.x+bird.x0*d)/(64+d)  -- the range of bird
              bird.y=(64*event.y+bird.y0*d)/(64+d)
          end
        elseif event.phase=="ended" then
          display.getCurrentStage():setFocus(nil)
          bird:applyLinearImpulse((bird.x0-event.x),(bird.y0-event.y),bird.x,bird.y)
          physics.start()
      end
end

bird:addEventListener("touch" ,onTouch)

-- SCORE
local score=0
-- MUSIC
local bgMusic=audio.loadSound("Bird-Video-Game.mp3" )
audio.setVolume(0.3,{channel=1})
audio.play(bgMusic,{channel=1,loops=-1,fadein=5000})
function pigSound(event)
       local sound=audio.loadSound("pig.mp3" )
       audio.play(sound,{channel=2})
end
local timeld=timer.performWithDelay(2000,pigSound,0)
-- ACTION
function onPostCollision(event)
            if event.force>25 then
                 -- pig:removeSelf()
                  pig:setFrame(2)
                 
                  timer.cancel(timeld)

                  score=math.round(event.force)
                  local scoreText=display.newText("Testing" ,500,100,nil,32)
                  scoreText:setTextColor(255,127,0);
                  scoreText.text="SCORE:" ..score

                  pig:removeEventListener("postCollision" ,onPostCollision)
                  bird:removeEventListener("touch" ,onTouch)
            end
end

pig:addEventListener("postCollision" ,onPostCollision)
