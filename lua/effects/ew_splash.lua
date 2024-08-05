function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local ent = data:GetEntity()
	
	if !IsValid(ent) then
		return
	end

	local maxs = ent:OBBMaxs()
	local mins = ent:OBBMins()
	
	local posx = math.Rand(mins.x, maxs.x)
	local posy = math.Rand(mins.y, maxs.y)
	local posz = math.Rand(mins.z, maxs.z)
	
	local forwardvel = ent:GetVelocity():Angle():Forward()
	
	local emitter = ParticleEmitter( Pos )

	for i = 1, math.random(35, 125) do
		local bubble = emitter:Add( "effects/bubble", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 

		if bubble then
			local posx = math.Rand(mins.x, maxs.x)
			local posy = math.Rand(mins.y, maxs.y)
			local posz = math.Rand(mins.z, maxs.z)
			
			local bboxpos = ent:LocalToWorld( Vector(posx, posy, posz) ) + forwardvel * 25
			
			local bubblemediansize = (posx + posy + posz) / 3 / 3
			
			local size = math.Rand(0, bubblemediansize)
			bubble:SetPos(bboxpos + Vector(0, 0, 0))
			bubble:SetVelocity(Vector(math.random(-42,42),math.random(-42,42),math.random(0,0)) + (i * forwardvel * 5))
			bubble:SetLifeTime(0) 
			bubble:SetDieTime(math.Rand(0.1,1)) 
			bubble:SetStartAlpha(255)
			bubble:SetEndAlpha(0)
			bubble:SetStartSize(size) 
			bubble:SetEndSize(size)
			bubble:SetAngles( Angle(21,3,5) )
			bubble:SetAngleVelocity( Angle(15) ) 
			bubble:SetRoll(math.Rand( 0, 360 ))
			bubble:SetColor(255, 255, 255)
			bubble:SetGravity( Vector(0,0,i*5) - ent:GetVelocity():Angle():Forward() * 25 ) 
			bubble:SetAirResistance(2)  
			bubble:SetCollide(true)
			bubble:SetBounce(0.1419790559388)
		end
	end

	for i = 1, math.random(35, 125) do
		local splash = emitter:Add( "effects/splash2", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 

		if splash then
			local posx = math.Rand(mins.x, maxs.x)
			local posy = math.Rand(mins.y, maxs.y)
			local posz = math.Rand(mins.z, maxs.z)
			
			local bboxpos = ent:LocalToWorld( Vector(posx, posy, posz) ) + forwardvel * 25
			
			local splashmediansize = (posx + posy + posz) / 3 / 3
			
			local size = math.Rand(35, splashmediansize * 5)
			splash:SetPos(bboxpos + Vector(0, 0, -10))
			splash:SetVelocity(Vector(math.random(-42,42),math.random(-42,42),math.random(0,0)) + (i * -forwardvel * 5))
			splash:SetLifeTime(0) 
			splash:SetDieTime(math.Rand(0.1,1)) 
			splash:SetStartAlpha(255)
			splash:SetEndAlpha(0)
			splash:SetStartSize(size) 
			splash:SetEndSize(size)
			splash:SetAngles( Angle(21,3,5) )
			splash:SetAngleVelocity( Angle(3) ) 
			splash:SetRoll(math.Rand( 0, 360 ))
			splash:SetColor(255, 255, 255)
			splash:SetGravity( Vector(0,0,-600)) 
			splash:SetAirResistance(2)  
			splash:SetCollide(true)
			splash:SetBounce(0.1419790559388)
		end
	end

	emitter:Finish()
end

function EFFECT:Think()	
	return false
end

function EFFECT:Render()
end

