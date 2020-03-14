local BabyKoalefantSpawner = Class(function(self, inst)
	self.inst = inst
	self.basetime = 11 --do not go below 11
	self.variancetime = 15
	self.prefab = "baby_koalefant_summer"
	self.canspawn = nil
	self.whichpref = nil
	self.onspawn = nil
	self.SpawnTask = false
	self.timebeforespawn = 0
	self.spawnretries = 0
	self:Task()
end)

function BabyKoalefantSpawner:SetRandomTimes(basetime, variancetime)
	self.basetime = basetime
	self.variancetime = variancetime
end

function BabyKoalefantSpawner:SetSpawnTest(fn)
	self.canspawn = fn
end

function BabyKoalefantSpawner:SetPrefabTest(fn)
	self.whichpref = fn --always return a prefab name
end

function BabyKoalefantSpawner:SetOnSpawn(fn)
	self.onspawn = fn
end

function BabyKoalefantSpawner:Start()
	if self.timebeforespawn == 0 then self.timebeforespawn = math.random(self.basetime, self.variancetime) end
	self.SpawnTask = true
end

function BabyKoalefantSpawner:Stop()
	self.timebeforespawn = 0
	self.SpawnTask = false
end

function BabyKoalefantSpawner:CanSpawn()
	--print("testing")
	
	--[[local pos = Vector3(self.inst.Transform:GetWorldPosition())
    local players = TheSim:FindEntities(pos.x,pos.y,pos.z, 40, {"player"}) --the number is distance the player has to be otherwise it'll cancel the spawn
	if #players > 0 then return false end]]
	if self.inst:IsAsleep() then return false end
	if self.canspawn then
		if self.canspawn(self.inst)then return true else return false end
	end
	return true
end

function BabyKoalefantSpawner:Task()
	self.inst:DoTaskInTime(1, function()
		self.taskisgoing = true
		if self.SpawnTask == true then
			if self.timebeforespawn == 0 then
				self:Spawn()
				self.timebeforespawn = math.random(self.basetime, self.variancetime)
			else
				self.timebeforespawn = self.timebeforespawn - 1
			end
		end
		self:Task()
	end)
end

function BabyKoalefantSpawner:Spawn()
	print("attempting spawn")
	if self:CanSpawn() then
		if self.whichpref then self.prefab = self.whichpref(self.inst) end
		local pref = SpawnPrefab(self.prefab)
		pref.Transform:SetPosition(self.inst:GetPosition():Get())
		if self.onspawn then self.onspawn(self.inst, pref) end
	else
		self.inst:DoTaskInTime(1, function()
			if self.spawnretries < 10 then --this is how many times it will retry the spawn before giving up
				self.spawnretries = self.spawnretries + 1
				self:Spawn()
			else
				self.spawnretries = 0
			end
		end)
	end
end

function BabyKoalefantSpawner:OnSave()
	return {timebeforespawn = self.timebeforespawn, spawnretries = self.spawnretries}
end

function BabyKoalefantSpawner:OnLoad(data)
	if data then
		if data.timebeforespawn then self.timebeforespawn = data.timebeforespawn end
		if data.spawnretries then self.spawnretries = data.spawnretries end
	end
	if self.spawnretries >= 1 then self:Spawn() end
	if not self.taskisgoing then self:Task() end --make sure it's ALWAYS going
end

return BabyKoalefantSpawner