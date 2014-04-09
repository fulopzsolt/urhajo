-- statusbar kikapcsolas

display.setStatusBar(display.HiddenStatusBar)

-- "physics" bekapcsolas

local physics = require "physics"
physics.start()
physics.setGravity(0, 1)
-- physics.setDrawMode("hybrid")

local SZ = display.contentWidth / 2    
local H = display.contentHeight / 2
local xV, yV, xVround, yVround 			-- hajo sebessege az X es Y tengelyen
local xVtext, yVtext
local azelotti
local vege
local kiirVy, kiirH
local foldf								-- foldfelszin
local teglalap
local hatter, fold, hajo				
local egyszer

local beginX 
local beginY  
local endX  
local endY 
local xTavolsag  
local yTavolsag 

function main()
	start()
end

function start()
	
	-- hatter megjelenites

	hatter = display.newImage("Hatter.png") 
	hatter.x = SZ
	hatter.y = H
	
	-- hajo megjelenites, atalakitas

	hajo = display.newImage("Hajo.png")
	hajo.anchorX = 0.50
	hajo.anchorY = 1
	hajo.x=SZ
	hajo.y=hajo.contentHeight

	-- fold megjelenites, atalakitas
	 
	fold = display.newImage("Fold.png")
	anchorX = 0.50
	fold.anchorY = 1
	fold.x = SZ
	fold.y = display.contentHeight
	foldf = H*2-fold.contentHeight			
	physics.addBody(fold, "static", {density = 1, friction = 0, bounce = 0})
	
	-- asteroidok
	asteroids()
	-- sebesseg, magassag kiirasa
	
	yVtext=display.newText ("Vy=" , SZ-180, 40, "Arial", 40)
	xVtext=display.newText ("Vx=" , SZ-180, 80, "Arial", 40)
	kiirVy=display.newText("0", SZ-110, 40, "Arial", 40)
	kiirVx=display.newText("0", SZ-110, 80, "Arial", 40)
	kiirH=display.newText(foldf-math.round(hajo.y)+1, SZ+160, 40, "Arial", 60)
	azelotti=0
	indit()
	
end	

function indit()

	teglalap=display.newRect(SZ, H, 300, 50)
	teglalap.anchorX=0.50
	teglalap.anchorY=0.50
	teglalap:addEventListener("tap", startgame)
	
end

function listeners(event)

	if event == "indul" then
		hatter:addEventListener("touch", swipe)
		Runtime:addEventListener("enterFrame", kiir)
		Runtime:addEventListener("enterFrame", endgame)
		Runtime:addEventListener("enterFrame", oldalhatar)
	
	elseif event == "megall" then
		hatter:removeEventListener("touch", swipe)
		Runtime:removeEventListener("enterFrame",kiir)
		Runtime:removeEventListener("enterFrame",havege)
		Runtime:removeEventListener("enterFrame", oldalhatar)
	end
	
end

function startgame()

	physics.addBody(hajo, "dynamic", {density = 1, friction = 0, bounce = 0})
	hajo.isFixedRotation=true
	listeners("indul")
	teglalap:removeEventListener("tap", startgame)
	teglalap:removeSelf()
	
end

function swipeirany()
 
        xDistance =  math.abs(endX - beginX)
        yDistance =  math.abs(endY - beginY)
        
        if xDistance > yDistance then
                if beginX > endX then
                      --  print("swipe left")
						hajo:applyLinearImpulse(-2.5, 0, hajo.x, hajo.y)
                else 
                      --  print("swipe right")
						hajo:applyLinearImpulse( 2.5, 0, hajo.x, hajo.y)
                end
        else 
                if beginY > endY then
                       -- print("swipe up")
						hajo:applyLinearImpulse(0, -10.5, hajo.x, hajo.y)
                else 
                      --  print("swipe down")
						hajo:applyLinearImpulse(0, -10.5, hajo.x, hajo.y)
                end
        end
        
end
 
 
function swipe(event)
        if event.phase == "began" then
			beginX = event.x
            beginY = event.y
        end
        
        if event.phase == "ended"  then
            endX = event.x
            endY = event.y
            swipeirany();
        end
		
end

function oldalhatar()
	
	xV, yV = hajo:getLinearVelocity()
	if((hajo.x - hajo.width * 0.5) < 0) then
		
		hajo.x = hajo.width * 0.5
		hajo:setLinearVelocity(0, yV)
		
	elseif((hajo.x + hajo.width * 0.5) > display.contentWidth) then
		
		hajo.x = display.contentWidth - hajo.width * 0.5
		hajo:setLinearVelocity(0, yV)
		
	end
	
end	

function kiir()

	kiirH.text=foldf-math.round(hajo.y)+1
	xV, yV = hajo:getLinearVelocity()
	xVround=math.round(xV)
	yVround=math.round(yV)
	kiirVx.text=xVround
	
	if math.abs(yVround-azelotti)>=3 then
		kiirVy.text=yVround
		azelotti=yVround
	end
	
end

function endgame()

	if hajo.y>=(H*2-fold.contentHeight-1) then
		kiirVy.text=0
		kiirVx.text=0
		kiirH.text=0
		listeners("megall")
		hajo:setLinearVelocity(0, 0)
		print("itt")
		--vege=display.newText("The End!!!", SZ, H+200, "Arial", 50)
		egyszer=1
		hatter:addEventListener("tap", ujra)
	end
	
end

function ujra(event)

	if egyszer==1 then
		--vege:removeSelf()
		egyszer=0
		hatter:removeEventListener("tap", ujra)
		hajo.x=SZ
		hajo.y=hajo.contentHeight
		kiirH.text=foldf-math.round(hajo.y)+1
		physics.removeBody(hajo)
		indit()
		print("ujra")	
	end	

end

--display asteroid objects
function asteroids()
	local rocks = 
				{ 
					{150,600 },
					{300, 450},
					{450, 250}
				}
	print(rocks[1][1])
	group = display.newGroup()
	for i=1,#rocks do
	    createAsteroids(rocks[i][1], rocks[i][2])
	end
	transition.to( group, { tag = "moveRock", time=2000, x=group.x, y=group.y + 5, delay=10, transition=ease, onComplete = asteroidsFloatDown() } )	
end

--create asteroid objects
function createAsteroids(xPos, yPos)
	local scaleFactor = 0.25
	local physicsData = (require "rock-shape").physicsData(scaleFactor)
	obj = display.newImage("rock.png")
	obj.width = obj.width/4
	obj.height = obj.height/4
	obj.x = xPos
	obj.y = yPos
	physics.addBody( obj, "kinematic", physicsData:get("rock") )
	group:insert( obj )
end

--move obj
function asteroidsFloatUp()
	transition.to( group, { tag = "moveRock", time=2000, x=group.x, y=group.y + 5, delay=10, transition=ease, onComplete = asteroidsFloatDown } )
end
function asteroidsFloatDown()
	transition.to( group, { tag = "moveRock", time=2000, x=group.x, y=group.y - 5, delay=10, transition=ease, onComplete = asteroidsFloatUp } )
end

main()
