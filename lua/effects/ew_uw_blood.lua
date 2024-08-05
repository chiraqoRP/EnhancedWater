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
	
	local sname = ent:GetBoneSurfaceProp(0)
--	print(sname)
	
	local hblood = Color(255, 0, 0)
	local antblood = Color(225, 255, 0)
	local zblood = Color(255, 255, 0)
	
	local forwardvel = ent:GetVelocity():Angle():Forward()
	local velmedian = math.abs((forwardvel.x + forwardvel.y + forwardvel.z) / 3)
	
	local emitter = ParticleEmitter( Pos )
	local minparticles = 5
	local maxparticles = 25
	local fpsthreshold = 50
	local threshholdvalue = math.Clamp(1 / FrameTime(), minparticles, fpsthreshold)
	for i = 1, math.random(minparticles, math.Clamp(threshholdvalue, minparticles, maxparticles)) do
		local bubble = emitter:Add( "particle/particle_smokegrenade", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 

		if bubble then
			bubble:SetColor(hblood.r, hblood.g, hblood.b)
			if sname == "flesh" or sname == "zombieflesh" then
				bubble:SetColor(hblood.r, hblood.g, hblood.b)
			elseif sname == "antlion" then
				bubble:SetColor(antblood.r, antblood.g, antblood.b)
			elseif sname == "alienflesh" then
				bubble:SetColor(zblood.r, zblood.g, zblood.b)
			else end
		
--			bubble:SetPos(bboxpos + Vector(0, 0, 0))
			bubble:SetVelocity(Vector(math.random(-42,42),math.random(-42,42),math.random(-12,12)) + (i * -forwardvel))
			bubble:SetLifeTime(0) 
			bubble:SetDieTime(math.Rand(0.1,5)) 
			bubble:SetStartAlpha(math.Rand(100,255))
			bubble:SetEndAlpha(0)
			bubble:SetStartSize(3) 
			bubble:SetEndSize(80 * velmedian)
			bubble:SetAngles( Angle(21,3,5) )
			bubble:SetAngleVelocity( Angle(3) ) 
			bubble:SetRoll(math.Rand( 0, 360 ))
			bubble:SetGravity( Vector(0,0,i*2)) 
			bubble:SetAirResistance(2)  
			bubble:SetCollide(true)
			bubble:SetLighting(true)
			bubble:SetBounce(0.1419790559388)
		end
	end
	emitter:Finish()
end

function EFFECT:Think()	
	return false
end

function EFFECT:Render()
end

