-- statusbar kikapcsolas

display.setStatusBar(display.HiddenStatusBar)

-- "physics" bekapcsolas

local physics = require "physics"
physics.start()
physics.setGravity(0, 0.4)

local widget = require "widget"

-- physics.setDrawMode("hybrid")

local SZ = display.contentWidth / 2    	-- kepernyo szelesseg kozepe
local H = display.contentHeight / 2			-- kepernyo magassag kozepe
local Vx, Vy, VxRound, VyRound 			-- hajo sebessege az X es Y tengelyen, hajo sebessege kerekitve
local VxText, VyText						-- hajo sebesseg kiirasa
local azelotti
local vege
local kiirVy, kiirH
local foldf								-- foldfelszin
local teglalap
local hatter, fold, hajo, menuhatter				
local egyszer
local faktor
local egesszam, osszeges, megeg
local balegesszam, balosszeges, balmegeg
local jobbegesszam, jobbosszeges, jobbmegeg
local tuzek = {}
tuzek[1]={}
tuzek[2]={}
local baltuz = {}
local jobbtuz = {}
local robbante, robbanas
local gombok
local jo

local beginX 
local beginY  
local endX  
local endY 
local xTavolsag  
local yTavolsag 

function main()

		menu()
		
	end

function  csillagkirajz()

		local csillagok = {"csillag1.png", "csillag2.png", "csillag3.png"}
		local allStars = {}
		local Nr, meret, i, j, el, csillag
		
		hatter = display.newImage("hatt.png", SZ, H)
	
		for i = 1, 15 do
		
			for j = 1, 9 do
			
				Nr = math.random(1, 3)
				meret = math.random(10, 20) / 100
				el = math.random(3,16)*5 
				csillag = display.newImage(csillagok[Nr])
				csillag.alpha=1
				csillag.x = 60*(j-1)+1+el
				csillag.y = 60*(i-1)+el
				csillag:scale(meret, meret)
				
			end
			
		end
		
	end

local function closeapp()
		if  system.getInfo("platformName")=="Android" then
		
           native.requestExit()
		   
		else
		
           os.exit() 
		   
		end

end

local function megnyom1()

		--gombok[1]:removeEventListener("touch", startgomb)
		if gombok[1].alpha==0 then 
		
			gombok[2].alpha=0
			gombok[1].alpha=1
			timer.performWithDelay( 500, start, 1)
		
		end
			
		if gombok[3].alpha==0 then
			
			gombok[4].alpha=0
			gombok[3].alpha=1
			timer.performWithDelay( 500, closeapp, 1)
			
		end
		
end			

function gombnyomas(event)

		if event.phase == "began" then
				
			if (event.x > SZ - gombok[1].contentWidth*0.5) and (event.x < SZ + gombok[1].contentWidth*0.5) then	
				
				if (event.y > H - 60 - gombok[1].contentHeight*0.5) and (event.y < H - 60 + gombok[1].contentHeight*0.5) then
				
					jo=true
					gombok[1].alpha=0
					gombok[2].alpha=1	
					
				end	
				
				if (event.y > H + 60 - gombok[1].contentHeight*0.5) and (event.y < H + 60 + gombok[1].contentHeight*0.5) then
				
					jo=true
					gombok[3].alpha=0
					gombok[4].alpha=1	
					print(gombok[3].alpha)
				end
				
			end
			
        end
		

        if (event.phase == "ended") and (jo == true)  then  

			jo=false
			timer.performWithDelay( 100, megnyom1, 1)
			
        end
		
end
	
function menu ()

		--print(SZ, H)
		gombok={}
		menuhatter = display.newImage("Menuhatt.png")
		menuhatter:scale(0.27,0.27)
		menuhatter.anchorX = 0.50
		menuhatter.anchorY = 0.50
		menuhatter.x=SZ
		menuhatter.y=H
		gombok[1] = display.newImage("Button1.png", SZ, H-60)
		gombok[2] = display.newImage("PressedButton1.png", SZ, H-60)
		gombok[3] = display.newImage("Button2.png", SZ, H+60)
		gombok[4] = display.newImage("PressedButton2.png", SZ, H+60)
		gombok[2].alpha = 0
		gombok[4].alpha = 0
		
		jo=false
		Runtime:addEventListener("touch", gombnyomas)
end
	
function start()
		
		menuhatter:removeEventListener("tap", start)	
		
		csillagkirajz()
		
		faktor=0.05
		-- hajo megjelenites, atalakitas

		hajo = display.newImage("Hajo.png")
		hajo.anchorX = 0.50
		hajo.anchorY = 1
		hajo:scale(0.5, 0.5)
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
	
		-- tuuuuuz
	
		for i = 1, 2 do	
		
			for j = 1, 3 do
			
				if (i+j)%2 == 0 then
				
					tuzek[i][j]=display.newImage("Tuz1.png")
				
				else
				
					tuzek[i][j]=display.newImage("Tuz2.png")
				
				end
	
				megeg=false
				tuzek[i][j].anchorX = 0.50
				tuzek[i][j].anchorY = 0
				tuzek[i][j]:scale(faktor, faktor)
				tuzek[i][j].x = hajo.x - hajo.contentWidth/2 + 160*faktor+637*faktor*(j-1)
				tuzek[i][j].y = hajo.y - 2
				tuzek[i][j].alpha=0
				
			end
			
		end	
		
		-- baloldalituz, jobboldalituz
			
		baltuz[1] = display.newImage("Tuz3.png")
		baltuz[2] = display.newImage("Tuz4.png")
		jobbtuz[1]=display.newImage("Tuz5.png")
		jobbtuz[2]=display.newImage("Tuz6.png")
		balmegeg=false
		jobbmegeg=false
		
		for i=1, 2 do
		
			baltuz[i].anchorX = 1
			baltuz[i].anchorY = 0.50	
			baltuz[i]:scale(faktor, faktor)
			baltuz[i].x = hajo.x - hajo.contentWidth/2 + 287*faktor
			baltuz[i].y = hajo.y - 845*faktor 
			baltuz[i].alpha=0
			jobbtuz[i].anchorX = 0
			jobbtuz[i].anchorY = 0.50	
			jobbtuz[i]:scale(faktor, faktor)
			jobbtuz[i].x = hajo.x + hajo.contentWidth/2 - 287*faktor
			jobbtuz[i].y = hajo.y - 845*faktor 
			jobbtuz[i].alpha=0
			
		end
		
	
		-- asteroidok
		-- asteroids()
		-- sebesseg, magassag kiirasa
		
		VyText=display.newText ("Vy=" , SZ-180, 40, "Arial", 40)
		VxText=display.newText ("Vx=" , SZ-180, 80, "Arial", 40)
		kiirVy=display.newText("0", SZ-110, 40, "Arial", 40)
		kiirVx=display.newText("0", SZ-110, 80, "Arial", 40)
		kiirH=display.newText(foldf-math.round(hajo.y)+1, SZ+160, 40, "Arial", 60)
		azelotti=0
		indit()
	
	end	

function indit()

	--print( "collectgarbage is " .. collectgarbage("count")  )
	robbante=false
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

function eges()

		--print(egesszam)
		for i=1, 3 do
		
			if (egesszam<osszeges) then
			
				if (egesszam%2==1) then 
				
					for j = 1, 3 do
						tuzek[2][j].y = hajo.y - 2
						tuzek[2][j].x = hajo.x - hajo.contentWidth/2 + 160*faktor+637*faktor*(j-1)
					end
					
					tuzek[2][i].alpha=1	
					tuzek[1][i].alpha=0
	
				else
				
					for j = 1, 3 do
						tuzek[1][j].y = hajo.y - 2
						tuzek[1][j].x = hajo.x - hajo.contentWidth/2 + 160*faktor+637*faktor*(j-1)
					end	
		
					tuzek[1][i].alpha=1
					tuzek[2][i].alpha=0
					
				end
				
			else 
			
			megeg=false
			
			for j = 1, 3 do
				tuzek[1][i].alpha=0
				tuzek[2][i].alpha=0
				
			end
			
			end	
			
		end

		egesszam=egesszam+1
		
	end	

function baleges()

		--print(balegesszam)
		
		if (balegesszam<balosszeges) then
		
			for i=1, 2 do
			
				baltuz[i].x = hajo.x - hajo.contentWidth/2 + 287*faktor
				baltuz[i].y = hajo.y - 845*faktor
				
			end	
			
			if (balegesszam%2==1) then 
					
					baltuz[2].alpha=1	
					baltuz[1].alpha=0
	
				else
		
					baltuz[1].alpha=1	
					baltuz[2].alpha=0
					
				end
				
		else 
			
			balmegeg=false
			
			for j = 1, 2 do
				
				baltuz[j].alpha=0
				
			end
			
		end	

		balegesszam=balegesszam+1
		
	end		
	
	function jobbeges()

		--print(jobbegesszam)
		
		if (jobbegesszam<jobbosszeges) then
		
			for i=1, 2 do
			
				jobbtuz[i].x = hajo.x + hajo.contentWidth/2 - 287*faktor
				jobbtuz[i].y = hajo.y - 845*faktor
				
			end	
			
			if (jobbegesszam%2==1) then 
					
					jobbtuz[2].alpha=1	
					jobbtuz[1].alpha=0
	
				else
		
					jobbtuz[1].alpha=1	
					jobbtuz[2].alpha=0
					
				end
				
		else 
			
			jobbmegeg=false
			
			for j = 1, 2 do
				
				jobbtuz[j].alpha=0
				
			end
			
		end	

		jobbegesszam=jobbegesszam+1
		
	end		
	
function idozitetteges()

		osszeges=20
		timer.performWithDelay( 50, eges, osszeges)
		
	end
	
function balidozitetteges()

		balosszeges=10
		timer.performWithDelay( 50, baleges, balosszeges)
		
	end
	
function jobbidozitetteges()

		jobbosszeges=10
		timer.performWithDelay( 50, jobbeges, jobbosszeges)
		
	end	

function effekt()

		megeg=true
		egesszam=1
		idozitetteges()
		
	end
	
function baleffekt()

		balmegeg=true
		balegesszam=1
		balidozitetteges()
		
	end	
	
function jobbeffekt()

		jobbmegeg=true
		jobbegesszam=1
		jobbidozitetteges()
		
	end		

function swipeirany()
 
        xDistance =  math.abs(endX - beginX)
        yDistance =  math.abs(endY - beginY)
        
        if xDistance > yDistance then
		
			if beginX > endX then
				
                --  print("swipe left")
				hajo:applyLinearImpulse(-2.5, 0, hajo.x, hajo.y)
				
				if jobbmegeg==false then 
				
					jobbeffekt()
				
				end
						
            else 
				
                --  print("swipe right")
				hajo:applyLinearImpulse( 2.5, 0, hajo.x, hajo.y)
				
				if balmegeg==false then 
				
					baleffekt()
				
				end
				
            end
				
        else 
		
            if beginY > endY then
				
                -- print("swipe up")
				hajo:applyLinearImpulse(0, -10.5, hajo.x, hajo.y)
						
				if megeg==false then
						
					effekt()
						
				end
						
			--else 
					
				--  print("swipe down")
				--	hajo:applyLinearImpulse(0, -10.5, hajo.x, hajo.y)
						
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
		Vx, Vy = hajo:getLinearVelocity()
		if ((hajo.x - hajo.width * 0.25) < 0) then
	
			hajo.x = hajo.width * 0.25
			hajo:setLinearVelocity(0, Vy)
		
		elseif ((hajo.x + hajo.width * 0.25) > display.contentWidth) then
		
			hajo.x = display.contentWidth - hajo.width * 0.25
			hajo:setLinearVelocity(0, Vy)
		
		end
	
	end	

function kiir()

		kiirH.text=foldf-math.round(hajo.y)+1
		Vx, Vy = hajo:getLinearVelocity()
		VxRound=math.round(Vx)
		VyRound=math.round(Vy)
		kiirVx.text=VxRound
	
		if math.abs(VyRound-azelotti)>=3 then
	
			kiirVy.text=VyRound
			azelotti=VyRound
		
		end
	
	end

function robban()
print("robban")
		robbante=true
		hajo.alpha=0
		robbanas=display.newImage("Robbanas.png")
		robbanas:scale(0.05,0.05)
		robbanas.x=hajo.x
		robbanas.y=hajo.y-hajo.contentHeight*0.5+5
		transition.to(robbanas, {time = 1000, xScale = 0.4, yScale =
			0.4, transition = easing.outExpo})
		transition.to(robbanas, {time = 1000, alpha=0,
			transition = easing.outExpo})
			
end	

local function AddCommas( number, maxPos )
        
        local s = tostring( number )
        local len = string.len( s )
        
        if len > maxPos then
                -- Add comma to the string
                local s2 = string.sub( s, -maxPos )             
                local s1 = string.sub( s, 1, len - maxPos )             
                s = (s1 .. "," .. s2)
        end
        
        maxPos = maxPos - 3             -- next comma position
        
        if maxPos > 0 then
                return AddCommas( s, maxPos )
        else
                return s
        end
 
end

	
function endgame()

	if hajo.y>=(H*2-fold.contentHeight-1) then
	
		kiirVy.text=0
		kiirVx.text=0
		kiirH.text=0
		listeners("megall")
		
		--vege=display.newText("The End!!!", SZ, H+200, "Arial", 50)
		egyszer=1
		hatter:addEventListener("tap", ujrakezd)
		egesszam=osszeges
		
		if (robbante == false) and (Vy>20) then 
		
			hajo:setLinearVelocity(0, 0)
			robban()
		
		else	

			hajo:setLinearVelocity(0, 0)
		
		end	
	end
	print( "TextureMemory: " .. AddCommas( system.getInfo("textureMemoryUsed"), 9 ) .. " bytes" )
	print( system.getInfo("textureMemoryUsed"))
end



function ujrakezd(event)

	if egyszer==1 then
	
		--vege:removeSelf()
		egyszer=0
		hatter:removeEventListener("tap", ujrakezd)
		hajo.x=SZ
		hajo.y=hajo.contentHeight
		hajo.alpha=1
		kiirH.text=foldf-math.round(hajo.y)+1
		physics.removeBody(hajo)
		if robbante==true then
		display.remove(robbanas)
		end
		indit()
	
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
	--print(rocks[1][1])
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
