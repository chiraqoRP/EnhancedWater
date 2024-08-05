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
	
	local minmedian = (mins.x + mins.y + mins.z) / 3
	local maxmedian = (maxs.x + maxs.y + maxs.z) / 3
	
	local emitter = ParticleEmitter( Pos )
	for i = 1,math.Rand(minmedian, maxmedian) do
		local splash = emitter:Add( "effects/splash2", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) )

		if splash then
			local posx = math.Rand(mins.x, maxs.x)
			local posy = math.Rand(mins.y, maxs.y)
			local posz = math.Rand(mins.z, maxs.z)
			
			local bboxpos = ent:LocalToWorld( Vector(posx, posy, posz) )
			
			local splashmediansize = (posx + posy + posz) / 3 / 3
			
			local size = math.Rand(2, splashmediansize)
			splash:SetPos(bboxpos)
			splash:SetVelocity(Vector(math.random(0,0),math.random(0,0),math.random(0,0)))
			splash:SetLifeTime(0) 
			splash:SetDieTime(math.Rand(0.1,1)) 
			splash:SetStartAlpha(150)
			splash:SetEndAlpha(0)
			splash:SetStartSize(size)
			splash:SetStartLength(size * 15)
			splash:SetEndLength(size * 55)
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

