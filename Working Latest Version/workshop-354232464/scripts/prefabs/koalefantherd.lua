local assets = { Asset("ANIM", "anim/log.zip"), }

local prefabs = {"baby_koalefant_summer", "baby_koalefant_winter"}

local function InMood(inst)
    inst.components.babykoalefantspawner:Start()
    if inst.components.herd then
        for k,v in pairs(inst.components.herd.members) do
            k:PushEvent("entermood")
        end
    end
end

local function LeaveMood(inst)
    inst.components.babykoalefantspawner:Stop()
    if inst.components.herd then
        for k,v in pairs(inst.components.herd.members) do
            k:PushEvent("leavemood")
        end
    end
end

local function AddMember(inst, member)
    if inst.components.mood then
        if inst.components.mood:IsInMood() then
            member:PushEvent("entermood")
        else
            member:PushEvent("leavemood")
        end
    end
end

local function CanSpawn(inst)
	print("ATTEMPTING TO POOP A BABY")
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, inst.components.herd.gatherrange, inst.components.herd.membertag and {inst.components.herd.membertag} or nil )
    return (#ents < TUNING.BEEFALOHERD_MAX_IN_RANGE) and inst.components.herd and not inst.components.herd:IsFull() and inst.components.mood:IsInMood()
end

local function OnSpawned(inst, newent)
    if inst.components.herd then
        inst.components.herd:AddMember(newent)
    end
end

local function TestPrefab(inst)
	if GetSeasonManager():IsWinter() then
		return "baby_koalefant_winter"
	else
		return "baby_koalefant_summer"
	end
end

local function OnEmpty(inst)
    inst:Remove()
end

local function OnFull(inst)
    --TODO: mark some beefalo for death --wtf Klei?! O_O
end
   
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    inst:AddTag("herd")
    
    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("koalefant")
    inst.components.herd:SetGatherRange(TUNING.BEEFALOHERD_RANGE)
    inst.components.herd:SetUpdateRange(20)
	inst.components.herd:SetMaxSize(3) --1 herd or "family" will stop growing at this size
    inst.components.herd:SetOnEmptyFn(OnEmpty)
    inst.components.herd:SetOnFullFn(OnFull)
    inst.components.herd:SetAddMemberFn(AddMember)
    
    inst:AddComponent("mood")
    inst.components.mood:SetMoodTimeInDays(4, 10) --how many days the season lasts, how many days you wait between seasons
    inst.components.mood:SetInMoodFn(InMood)
    inst.components.mood:SetLeaveMoodFn(LeaveMood)
    inst.components.mood:CheckForMoodChange()
	inst:ListenForEvent("daycomplete", function() --idk why in the hell I had to do this... but for some damn reason mood WILL NOT respond to the "daycomplete" event!
		print("WOWZA! "..inst.components.mood.daystomoodchange)
		if inst.components.mood.daystomoodchange and inst.components.mood.daystomoodchange > 0 then
            inst.components.mood.daystomoodchange = inst.components.mood.daystomoodchange - 1
            inst.components.mood:CheckForMoodChange()
        end
	end, GetWorld())
	
	inst:AddComponent("babykoalefantspawner") --because periodicspawner is broken to all hell :L
	inst.components.babykoalefantspawner:SetRandomTimes(TUNING.BEEFALO_MATING_SEASON_BABYDELAY, TUNING.BEEFALO_MATING_SEASON_BABYDELAY*1.5)
	inst.components.babykoalefantspawner:SetSpawnTest(CanSpawn)
	inst.components.babykoalefantspawner:SetPrefabTest(TestPrefab)
	inst.components.babykoalefantspawner:SetOnSpawn(OnSpawned)

    return inst
end

return Prefab( "forest/animals/koalefantherd", fn, assets, prefabs) 
