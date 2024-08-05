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
	
	local lc = render.GetLightColor(data:GetStart()) * 255
	
	local forwardvel = ent:GetVelocity():Angle():Forward()
	local velmedian = math.abs((forwardvel.x + forwardvel.y + forwardvel.z) / 3)
	
	local emitter = ParticleEmitter( Pos )
	local minparticles = 5
	local maxparticles = 15
	local fpsthreshold = 50
	local threshholdvalue = math.Clamp(1/FrameTime(), minparticles, fpsthreshold)
	for i = 1, math.random(minparticles, math.Clamp(threshholdvalue, minparticles, maxparticles)) do
		local bubble = emitter:Add( "particle/particle_smokegrenade", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 

		if bubble then
--			bubble:SetPos(bboxpos + Vector(0, 0, 0))
			bubble:SetVelocity(Vector(math.random(-42,42),math.random(-42,42),math.random(0,0)) + (i * -forwardvel))
			bubble:SetLifeTime(0) 
			bubble:SetDieTime(math.Rand(0.1,5)) 
			bubble:SetStartAlpha(100)
			bubble:SetEndAlpha(0)
			bubble:SetStartSize(3) 
			bubble:SetEndSize(80 * velmedian)
			bubble:SetAngles( Angle(21,3,5) )
			bubble:SetAngleVelocity( Angle(3) ) 
			bubble:SetRoll(math.Rand( 0, 360 ))
			bubble:SetColor(lc.x, lc.y, lc.z)
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

