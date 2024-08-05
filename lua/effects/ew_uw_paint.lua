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
	
	local forwardvel = ent:GetVelocity():Angle():Forward()
	local velmedian = math.abs((forwardvel.x + forwardvel.y + forwardvel.z) / 3)

	local emitter = ParticleEmitter( Pos )
	local minparticles = 25
	local maxparticles = 45
	local fpsthreshold = 15
	local threshholdvalue = math.Clamp(1/FrameTime(), minparticles, fpsthreshold)
	for i = 1, math.random(minparticles, math.Clamp(1 / FrameTime(), minparticles, maxparticles)) do
		local bubble = emitter:Add( "particle/smokestack", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 

		if bubble then
--			bubble:SetPos(bboxpos + Vector(0, 0, 0))
			bubble:SetVelocity(Vector(math.random(-2,2),math.random(-2,2),math.random(-2,2)) * i * forwardvel)
			bubble:SetLifeTime(0) 
			bubble:SetDieTime(math.Rand(0.2,5)) 
			bubble:SetStartAlpha(255)
			bubble:SetEndAlpha(0)
			bubble:SetStartSize(Lerp(0.1 * i, 1, 5)) 
			bubble:SetEndSize(math.Rand(0.5,2) * i)
			bubble:SetAngles( Angle(21,3,5) )
			bubble:SetAngleVelocity( Angle(3) ) 
			bubble:SetRoll(math.Rand( 0, 360 ))
			bubble:SetColor(255, 255, 255)
			bubble:SetGravity( Vector(0,0,0.25 * i)) 
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

