function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local ply = LocalPlayer()

	if Pos:DistToSqr(ply:GetPos()) > 10000 then
		return
	end
	
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
	for i = 1, math.random(5, 17) do
		local bubble = emitter:Add( "effects/bubble", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 

		if bubble then
			local posx = math.Rand(mins.x, maxs.x)
			local posy = math.Rand(mins.y, maxs.y)
			local posz = math.Rand(mins.z, maxs.z)
			
			local bboxpos = ent:LocalToWorld( Vector(posx, posy, posz) ) + forwardvel * 25
			
			local bubblemediansize = (posx + posy + posz) / 3 / 3
			
			local size = math.Rand(0, bubblemediansize)
			bubble:SetPos(bboxpos + Vector(0, 0, 0))
			bubble:SetVelocity(Vector(math.random(-42,42),math.random(-42,42),math.random(0,0)) + (i * forwardvel))
			bubble:SetLifeTime(0) 
			bubble:SetDieTime(math.Rand(0.1,2)) 
			bubble:SetStartAlpha(255)
			bubble:SetEndAlpha(0)
			bubble:SetStartSize(size) 
			bubble:SetEndSize(size)
			bubble:SetAngles( Angle(21,3,5) )
			bubble:SetAngleVelocity( Angle(15) ) 
			bubble:SetRoll(math.Rand( 0, 360 ))
			bubble:SetColor(255, 255, 255)
			bubble:SetGravity( Vector(0,0,i*7) - ent:GetVelocity():Angle():Forward() * 25 ) 
			bubble:SetAirResistance(2)  
			bubble:SetCollide(true)
			bubble:SetBounce(0.1419790559388)
		end
	end
	for i = 1,math.Rand(35, 125) do
	end
	emitter:Finish()
end

function EFFECT:Think()	
	return false
end

function EFFECT:Render()
end

