PrefabFiles = {"baby_koalefant", "koalefantherd"}

STRINGS = GLOBAL.STRINGS
if not STRINGS.CHARACTERS.WATHGRITHR then STRINGS.CHARACTERS.WATHGRITHR = {DESCRIBE = {}} end
if not STRINGS.CHARACTERS.WEBBER then STRINGS.CHARACTERS.WEBBER = {DESCRIBE = {}} end

STRINGS.NAMES.BABY_KOALEFANT_SUMMER = "Baby Koalefant"
STRINGS.NAMES.BABY_KOALEFANT_WINTER = "Baby Koalefant"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BABY_KOALEFANT_SUMMER		= "Aww. So adorable!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BABY_KOALEFANT_SUMMER 		= "My new little friend!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BABY_KOALEFANT_SUMMER 		= " He's young, but it doesn't matter. Death will find him anyway."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BABY_KOALEFANT_SUMMER 		= "Baby nose meat!"
STRINGS.CHARACTERS.WX78.DESCRIBE.BABY_KOALEFANT_SUMMER 			= "A TINY BEAST LOCATED."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BABY_KOALEFANT_SUMMER 	= "A young Koalefanta Proboscidea."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BABY_KOALEFANT_SUMMER 		= "It is so cute that I want to eat it."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BABY_KOALEFANT_SUMMER 		= "It's a bit surprising that they were able to reproduce."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BABY_KOALEFANT_SUMMER 	= "I must wait until the meat's ripe."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BABY_KOALEFANT_SUMMER 		= "We should become good friends."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BABY_KOALEFANT_WINTER		= "Aww. So adorable!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BABY_KOALEFANT_WINTER 		= "My new little friend!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BABY_KOALEFANT_WINTER 		= "He's young, but it doesn't matter. Death will find him anyway."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BABY_KOALEFANT_WINTER 		= "Baby nose meat!"
STRINGS.CHARACTERS.WX78.DESCRIBE.BABY_KOALEFANT_WINTER 			= "A TINY BEAST LOCATED."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BABY_KOALEFANT_WINTER 	= "A young Koalefanta Proboscidea."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BABY_KOALEFANT_WINTER 		= "It is so cute that I want to eat it."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BABY_KOALEFANT_WINTER 		= "It's a bit surprising that they were able to reproduce."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BABY_KOALEFANT_WINTER 	= "I must wait until the meat's ripe."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BABY_KOALEFANT_WINTER 		= "We should become good friends."

local koalefants = {"koalefant_summer", "koalefant_winter"}

function OnAttackedMod(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,function(dude)
        return dude:HasTag("koalefant") and dude:HasTag("baby") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function OnEnterMood(inst)
	--If you ever wanted to you can do something special for when they enter "heat"
	print("entering heat")
end

local function OnLeaveMood(inst)
	--for when they leave "heat"
	print("exiting heat")
end

function KoalefantPostInit(inst)
	inst:AddComponent("leader")
    inst:AddComponent("herdmember")
	inst.components.herdmember:SetHerdPrefab("koalefantherd")
    inst:ListenForEvent("entermood", OnEnterMood)
    inst:ListenForEvent("leavemood", OnLeaveMood)
	inst:ListenForEvent("attacked", function(inst, data) OnAttackedMod(inst, data) end)
end

for k,v in pairs(koalefants) do AddPrefabPostInit(v, KoalefantPostInit) end