--[[

	Enhanced Water for Garry's Mod.

	Written by Vuthakral.
	http://steamcommunity.com/profiles/76561198050250649
	
	You may NOT reupload this addon/script to the Steam Workshop or any other third-party distributors without modification.
	All derivatives of this mod must attribute credit to the original, and must adhere to these same guidelines.
	This script & its related effect scripts may not be sold individually or as a package. Anywhere.
	As well, modifications may not be sold, traded, etc.

--]]

local dust = {
	["default"] = true,
	["default_silent"] = true,
	["dirt"] = true,
	["mud"] = true,
	["quicksand"] = true,
	["sand"] = true,
	["antlionsand"] = true,
	["snow"] = true,
	["foliage"] = true
}

local wood = {
	["wood"] = true,
	["wood_box"] = true,
	["wood_crate"] = true,
	["wood_furniture"] = true,
	["wood_lowdensity"] = true,
	["wood_plank"] = true,
	["wood_panel"] = true,
	["wood_solid"] = true
}

local metal = {
	["canister"] = true,
	["chain"] = true,
	["chainlink"] = true,
	["combine_metal"] = true,
	["crowbar"] = true,
	["floating_metal_barrel"] = true,
	["grenade"] = true,
	["gunship"] = true,
	["metal"] = true,
	["metal_barrel"] = true,
	["metal_bouncy"] = true,
	["metal_box"] = true,
	["metal_seafloorcar"] = true,
	["metalgrate"] = true,
	["metalpanel"] = true,
	["metalvent"] = true,
	["metalvehicle"] = true,
	["popcan"] = true,
	["roller"] = true,
	["slipperymetal"] = true,
	["solidmetal"] = true,
	["strider"] = true,
	["weapon"] = true
}

local shards = {
	["ice"] = true,
	["glass"] = true,
	["glassbottle"] = true,
	["combine_glass"] = true,
	["tile"] = true
}

local liquid = {
	["alienflesh"] = true,
	["antlion"] = true,
	["bloodyflesh"] = true,
	["flesh"] = true,
	["watermelon"] = true,
	["zombieflesh"] = true
}

local rocks = {
	["baserock"] = true,
	["boulder"] = true,
	["brick"] = true,
	["concrete"] = true,
	["gravel"] = true,
	["rock"] = true
}

local bubbly = {
	["default"] = true,
	["default_silent"] = true,
	["ladder"] = true,
	["baserock"] = true,
	["boulder"] = true,
	["brick"] = true,
	["gravel"] = true,
	["rock"] = true,
	["chainlink"] = true,
	["floating_metal_barrel"] = true,
	["metal_barrel"] = true,
	["metalgrate"] = true,
	["metalvehicle"] = true,
	["roller"] = true,
	["strider"] = true,
	["wood"] = true,
	["wood_box"] = true,
	["wood_crate"] = true,
	["wood_furniture"] = true,
	["wood_lowdensity"] = true,
	["wood_plank"] = true,
	["wood_panel"] = true,
	["sand"] = true,
	["slime"] = true,
	["ice"] = true,
	["cardboard"] = true,
	["carpet"] = true,
	["computer"] = true
}

local paintcan = {
	["paintcan"] = true
}

local validEnts = {
	["prop_physics"] = true,
	["prop_dynamic"] = true
}

local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")
local eWaterLevel = ENTITY.WaterLevel
local eIsFlagSet = ENTITY.IsFlagSet
local pGetWalkSpeed, pGetRunSpeed = PLAYER.GetWalkSpeed, PLAYER.GetRunSpeed
local moveKeys = bit.bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT)

hook.Add("Move", "EnhancedWater.ToggleSwim", function(ply, mv)
	local waterLevel = eWaterLevel(ply)

	if waterLevel != 3 then
		return
	end
	
	local isJumping = mv:KeyDown(IN_JUMP)

	if isJumping then
		return
	end
	
	if !eIsFlagSet(ply, FL_ONGROUND) or !eIsFlagSet(ply, FL_INWATER) then
		return
	end
	
	local isMoving = mv:KeyDown(moveKeys)
	local isSprinting = mv:KeyDown(IN_SPEED)
	local vel = mv:GetVelocity()
	local walkSpeed = pGetWalkSpeed(ply)
	
	if isMoving then
		mv:SetVelocity(Vector(vel.x / walkSpeed, vel.y / walkSpeed, -50))
	else
		local runSpeed = pGetRunSpeed(ply)

		if isSprinting then
			mv:SetVelocity(Vector(vel.x / runSpeed, vel.y / runSpeed, 0))
		else
			mv:SetVelocity(Vector(vel.x / walkSpeed, vel.y / walkSpeed, 0))
		end
	end
end)

local enterSnds = {"enhancedwater/enterwater1.wav", "enhancedwater/enterwater2.wav", "enhancedwater/enterwater3.wav", "enhancedwater/enterwater4.wav"}
local enterLVSnds = {"enhancedwater/enterwater_lowvel0.wav", "enhancedwater/enterwater_lowvel1.wav"}
local enterHVSnds = {"enhancedwater/enterwater_highvel0.wav", "enhancedwater/enterwater_highvel1.wav"}
local exitSnds =  {"enhancedwater/exitwater1.wav", "enhancedwater/exitwater2.wav", "enhancedwater/exitwater3.wav", "enhancedwater/exitwater4.wav"}
local bubbleSnds = {"enhancedwater/ambient/bubbles0.wav", "enhancedwater/ambient/bubbles1.wav", "enhancedwater/ambient/bubbles2.wav", "enhancedwater/ambient/bubbles3.wav", "enhancedwater/ambient/bubbles4.wav"}

hook.Add("OnEntityWaterLevelChanged", "EnhancedWater.WaterImpactDetection", function( ent, old, new )
	local isPlayer = ent:IsPlayer()
	local effectCount = 90
	local doDripEffects = false

	if ent:IsPlayer() then
		local vel = ent:GetVelocity()
		local speed = math.abs((vel.x + vel.y + vel.z) / 3)
	
		if new < 3 and old >= 3 then
			ent:EmitSound(exitSnds[math.random(1, #exitSnds)], 75, math.random(98, 102))
			
			local ep = ent:EyePos()
			local splash = EffectData()
			splash:SetOrigin(ep)

			util.Effect("watersplash", splash)
			util.Effect("waterripple", splash)
		elseif new < 1 then
			doDripEffects = true
		elseif new == 3 then
			ent:EmitSound(enterSnds[math.random(1, #enterSnds)], 60, math.random(98, 102))
			ent:EmitSound(bubbleSnds[math.random(1, #bubbleSnds)], 60, math.random(95, 105))
			
			if speed > 100 then
				ent:EmitSound(enterHVSnds[math.random(1, #enterHVSnds)], 60, math.random(98, 102))
			elseif speed < 100 then
				ent:EmitSound(enterLVSnds[math.random(1, #enterLVSnds)], 50, math.random(98, 102))
			end
			
			local splish = EffectData()
			splish:SetOrigin(ent:GetPos())
			splish:SetEntity(ent)

			util.Effect("ew_splash", splish)
		end
	elseif validEnts[ent:GetClass()] then
		if new == 3 and old == 0 then
			local splish = EffectData()
			splish:SetOrigin(ent:GetPos())
			splish:SetEntity(ent)

			util.Effect("ew_splash", splish)
		elseif new < 1 and old == 0 and !isPlayer then
			local phys = ent:GetPhysicsObject()
			
			if phys:IsValid() then
				local mass = phys:GetMass()

				effectCount = math.Clamp(mass / 5, 5, 90)
			end

			doDripEffects = true
		end
	end

	if doDripEffects then
		local drips = EffectData()
		drips:SetOrigin(ent:GetPos())

		for i = 0, effectCount do
			timer.Simple(1 / 30 * i, function()
				if IsValid(ent) then
					util.Effect("ew_drip", drips)
				end
			end)
		end
	end
end)

local footsteps = CreateConVar("sv_ew_footsteps", 1, {FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_DEMO}, "Enables/Disables underwater footstep sounds for all players.", 0, 1)
local stepSnds = {
	"enhancedwater/step/walk0.wav",
	"enhancedwater/step/walk1.wav",
	"enhancedwater/step/walk2.wav",
	"enhancedwater/step/walk3.wav",
	"enhancedwater/step/walk4.wav",
	"enhancedwater/step/walk5.wav",
	"enhancedwater/step/walk6.wav",
	"enhancedwater/step/walk7.wav",
	"enhancedwater/step/walk8.wav",
	"enhancedwater/step/walk9.wav",
	"enhancedwater/step/walk10.wav",
	"enhancedwater/step/walk11.wav",
	"enhancedwater/step/walk12.wav",
	"enhancedwater/step/walk13.wav",
	"enhancedwater/step/walk14.wav",
	"enhancedwater/step/walk15.wav",
	"enhancedwater/step/walk16.wav",
	"enhancedwater/step/walk17.wav",
	"enhancedwater/step/walk18.wav"
}

local sprintSnds = {
	"enhancedwater/step/run0.wav",
	"enhancedwater/step/run1.wav",
	"enhancedwater/step/run2.wav",
	"enhancedwater/step/run3.wav",
	"enhancedwater/step/run4.wav",
	"enhancedwater/step/run5.wav",
	"enhancedwater/step/run6.wav",
	"enhancedwater/step/run7.wav",
	"enhancedwater/step/run8.wav",
	"enhancedwater/step/run9.wav",
	"enhancedwater/step/run10.wav",
	"enhancedwater/step/run11.wav",
	"enhancedwater/step/run12.wav",
	"enhancedwater/step/run13.wav",
	"enhancedwater/step/run14.wav"
}

hook.Add("PlayerFootstep", "EnhancedWater.Step", function(ply, pos, foot, sound, vol, filter)
	local waterLevel = ply:WaterLevel()

	if waterLevel != 3 or !ply:IsFlagSet(FL_ONGROUND) or !ply:IsFlagSet(FL_INWATER) then
		return
	end
	
	local footstep = EffectData()
	footstep:SetOrigin(ply:GetPos())
	footstep:SetEntity(ply)
	util.Effect("ew_uw_dust", footstep)

	local curTime = CurTime()
	
	if curTime > ply:GetNW2Float("EnhancedWater.LastStepTime", curTime) + ply:GetNW2Float("EnhancedWater.StepDelay", 0.35) then
		local isSprinting = ply:KeyDown(IN_SPEED)
		local isCrouching = ply:KeyDown(IN_DUCK)

		if !isSprinting and !isCrouching then
			if footsteps:GetBool() then
				ply:EmitSound(stepSnds[math.random(1, #stepSnds)], 40, math.random(99, 101))
			end

			ply:SetNW2Float("EnhancedWater.StepDelay", 0.65)
		elseif isSprinting then
			if footsteps:GetBool() then
				ply:EmitSound(sprintSnds[math.random(1, #sprintSnds)], 40, math.random(99, 101))
			end

			ply:SetNW2Float("EnhancedWater.StepDelay", 0.3)
		end

		ply:SetNW2Float("EnhancedWater.LastStepTime", curTime)
	end
		
	-- return false
end)

local liquidSnds = {
	"physics/flesh/flesh_squishy_impact_hard1.wav",
	"physics/flesh/flesh_squishy_impact_hard2.wav",
	"physics/flesh/flesh_squishy_impact_hard3.wav",
	"physics/flesh/flesh_squishy_impact_hard4.wav"
}

local function Physics(ent, data)			
	if !ent or !data.HitEntity:IsWorld() then
		return
	end

	local waterLevel = ent:WaterLevel()

	if waterLevel != 3 then
		return
	end

	local sname = string.lower(util.GetSurfacePropName(data.TheirSurfaceProps))
	local lsname = string.lower(util.GetSurfacePropName(data.OurSurfaceProps))
	local vel = ent:GetVelocity()
	local velmedian = math.Round(math.abs((vel.x + vel.y + vel.z) / 3))
	local phys = ent:GetPhysicsObject()
	local mass = phys:GetMass()
	
	local uwEffect = EffectData()
	uwEffect:SetOrigin(data.HitPos)
	uwEffect:SetEntity(ent)
	
	if dust[sname] or dust[lsname] then
		util.Effect("ew_uw_dust", uwEffect)
	elseif rocks[sname] or rocks[lsname] then
		if velmedian > mass / 2 then
			util.Effect("ew_uw_pebbles", uwEffect)
		end
	elseif shards[sname] or shards[lsname] then
		if velmedian > mass / 2 then
			util.Effect("ew_uw_shards", uwEffect)
		end
	elseif liquid[sname] or liquid[lsname] then
		if velmedian > mass / 2 then
			util.Effect("ew_uw_liquiddistortion", uwEffect)
			util.Effect("ew_uw_blood", uwEffect)
		end
	end

	local bubbleChance = math.random(0, 100)

	if bubbleChance > 97 then
		if bubbly[sname] then
			util.Effect("ew_uw_bubbles_world", uwEffect)

			ent:EmitSound(bubbleSnds[math.random(1, #bubbleSnds)], 60, math.random(95, 105))
		end

		if bubbly[lsname] then
			util.Effect("ew_uw_bubbles", uwEffect)

			ent:EmitSound(bubbleSnds[math.random(1, #bubbleSnds)], 60, math.random(95, 105))
		end

		if paintcan[lsname] then
			util.Effect("ew_uw_paint", uwEffect)

			ent:EmitSound(liquidSnds[math.random(1, #liquidSnds)], 50, math.random(95, 105))
		end
	end
end

hook.Add("OnEntityCreated", "EnhancedWater.Callbacks", function(ent)
	if validEnts[ent:GetClass()] or ent:IsScripted() then
		ent:AddCallback("PhysicsCollide", Physics)
	end
end)

hook.Add("EntityTakeDamage", "EnhancedWater.DamageEffectsUnderwater", function(ent, dmg)
	if !IsValid(ent) then
		return
	end

	local waterLevel = ent:WaterLevel()

	if waterLevel != 3 then
		return
	end
	
	local bloodColor = ent:GetBloodColor()

	if bloodColor == -1 then
		return
	end

	local uwEffect = EffectData()
	uwEffect:SetOrigin(dmg:GetDamagePosition())
	uwEffect:SetEntity(ent)

	local sname = ent:GetBoneSurfaceProp(0)
	local damageClamp = math.Clamp(dmg:GetDamage(), 1, 100) / 5
	
	if dust[sname] then
		util.Effect("ew_uw_dust", uwEffect)
	elseif rocks[sname] then
		for i = 0, damageClamp do
			util.Effect("ew_uw_pebbles", uwEffect)
		end
	elseif shards[sname] then
		for i = 0, damageClamp do
			util.Effect("ew_uw_shards", uwEffect)
		end
	elseif liquid[sname] then
		for i = 0, damageClamp do
			util.Effect("ew_uw_blood", uwEffect)
		end
	end
end)

local exitSndsH = {
    ["enhancedwater/exitwater1.wav"] = true,
    ["enhancedwater/exitwater2.wav"] = true,
    ["enhancedwater/exitwater3.wav"] = true,
    ["enhancedwater/exitwater4.wav"] = true
}

local stepSndsH = {
	["enhancedwater/step/walk0.wav"] = true,
	["enhancedwater/step/walk1.wav"] = true,
	["enhancedwater/step/walk2.wav"] = true,
	["enhancedwater/step/walk3.wav"] = true,
	["enhancedwater/step/walk4.wav"] = true,
	["enhancedwater/step/walk5.wav"] = true,
	["enhancedwater/step/walk6.wav"] = true,
	["enhancedwater/step/walk7.wav"] = true,
	["enhancedwater/step/walk8.wav"] = true,
	["enhancedwater/step/walk9.wav"] = true,
	["enhancedwater/step/walk10.wav"] = true,
	["enhancedwater/step/walk11.wav"] = true,
	["enhancedwater/step/walk12.wav"] = true,
	["enhancedwater/step/walk13.wav"] = true,
	["enhancedwater/step/walk14.wav"] = true,
	["enhancedwater/step/walk15.wav"] = true,
	["enhancedwater/step/walk16.wav"] = true,
	["enhancedwater/step/walk17.wav"] = true,
	["enhancedwater/step/walk18.wav"] = true
}

local sprintSndsH = {
	["enhancedwater/step/run0.wav"] = true,
	["enhancedwater/step/run1.wav"] = true,
	["enhancedwater/step/run2.wav"] = true,
	["enhancedwater/step/run3.wav"] = true,
	["enhancedwater/step/run4.wav"] = true,
	["enhancedwater/step/run5.wav"] = true,
	["enhancedwater/step/run6.wav"] = true,
	["enhancedwater/step/run7.wav"] = true,
	["enhancedwater/step/run8.wav"] = true,
	["enhancedwater/step/run9.wav"] = true,
	["enhancedwater/step/run10.wav"] = true,
	["enhancedwater/step/run11.wav"] = true,
	["enhancedwater/step/run12.wav"] = true,
	["enhancedwater/step/run13.wav"] = true,
	["enhancedwater/step/run14.wav"] = true
}

hook.Add("EntityEmitSound", "EnhancedWater.Occlusion", function(data)
	local ent = data.Entity

	if !IsValid(ent) then
		return
	end

	local waterLevel = ent:WaterLevel()
	local sn = data.OriginalSoundName
	
	if exitSndsH[sn] then
		return true
	elseif stepSndsH[sn] or sprintSndsH[sn] then
		data.DSP = 133

		return true
	elseif sn == "Player.Swim" and waterLevel == 3 then
		ent:EmitSound(bubbleSnds[math.random(1, #bubbleSnds)], 60, math.random(95, 105))

		local uwEffect = EffectData()
		uwEffect:SetOrigin(ent:GetPos())
		uwEffect:SetEntity(ent)

		util.Effect("ew_uw_bubbles_world", uwEffect)
		util.Effect("ew_uw_liquiddistortion", uwEffect)

		return true
	end 

	if waterLevel == 3 then
		if data.Channel == 1 then
			data.DSP = 16
		else
			data.DSP = 15
		end

		return true
	end
end)

hook.Add("AllowPlayerPickup", "EnhancedWaterInteractSound", function(ply, ent)
	if !IsValid(ply) or !IsValid(ent) then
		return
	end

	if ent:WaterLevel() != 3 then
		return
	end

	local phys = ent:GetPhysicsObject()

	if !phys or !phys:IsValid() or phys:GetMass() > 249 then
		return
	end
	
	ent:EmitSound("enhancedwater/pickup.wav", 80, math.random(98, 102))
	ent:EmitSound(bubbleSnds[math.random(1, #bubbleSnds)], 60, math.random(95, 105))
end)

if !CLIENT then return end

local screenEffects = CreateClientConVar("sv_ew_screeneffects", 1, true, false, "Enables/Disables additional underwater screen effects for all players.", 0, 1)
local LTT, lwl, nwl = 0, 69, 420
local underwaterAmbient = nil

hook.Add("RenderScreenspaceEffects", "EnhancedWater.UnderWaterDetection", function()
	local ply = LocalPlayer()
	local inWater = eWaterLevel(ply) == 3

	if !underwaterAmbient then
		underwaterAmbient = CreateSound(ply, "enhancedwater/uw_ambient.wav")
		underwaterAmbient:SetSoundLevel(80)
	end

	if inWater then
		underwaterAmbient:Play()
	else
		underwaterAmbient:Stop()
	end
	
	if !screenEffects:GetBool() then
		return
	end

	local sysTime = SysTime()

	if !inWater then
		UWP = 0

		if lwl != nwl then
			LTT = sysTime
			lwl = nwl
		end
	else
		if lwl == nwl then
			LTT = sysTime
			lwl = nwl
		end

		lwl = 0
		UWP = 1
	end
	
	local wllerp = Lerp((sysTime - LTT) / 0.5, 0, UWP or 0)
	local invwllerp = Lerp((sysTime - LTT) / 0.5, 1, UWP or 1)
	
	if inWater then
		DrawBloom(wllerp / 2, wllerp / 2, 5, 5, wllerp / 5, 1, 1, 1, 1)
		DrawToyTown(wllerp * 5, Lerp(wllerp, ScrH() / 2, ScrH() / 2))
		DrawSunbeams(0.5, wllerp / 50, 0.1, .5, .5)
	else
		DrawBloom(0, invwllerp, 3, 3, wllerp, 1, 1, 1, 1)
		DrawToyTown(invwllerp * 5, Lerp(wllerp, ScrH() / 2, ScrH()))
	end
end)