include("Scripts/Objects/Equipable.lua")
include("Scripts/Mixins/Fiery.lua")

-------------------------------------------------------------------------------
Torch = Equipable.Subclass("Torch")

-- Static Variables
Torch.TorchSound = "SoftTorch"

Torch.RegisterScriptEvent("ClientEvent_PlayObjectSound",
	{
		soundName = "string",
		loop = "bool",
		offset = "vec3",
		minDist = "float",
		maxDist = "float"
	}
)

-------------------------------------------------------------------------------
function Torch:Constructor(args)

	self:Mixin(Fiery)

end

-------------------------------------------------------------------------------
function Torch:PostLoad( args )

	Torch.__super.PostLoad(self)
	if not self.m_restored then
		if self:NKGetEquipable() then
			self:SetMaxHitPoints(self:NKGetEquipable():NKGetCurrentDurability())
			self:SetHitPoints(self:NKGetEquipable():NKGetCurrentDurability())
		end
	end

	self:NKGetSound():NKPlay3DSound(self.TorchSound, true, vec3.new(0, 0, 0), 10.0, 15.0)
end


-------------------------------------------------------------------------------
function Torch:OnDestroy()

	-- If hit points is less than or equal to zero
	if self:GetHitPoints() <= 0 then

		-- Destroy object and remove it from player
		Torch.__super.OnDestroy(self)
	end
end

-------------------------------------------------------------------------------
function Torch:Save( outData )

	Torch.__super.Save(self, outData)

	outData.maxDurability = self:GetMaxHitPoints()
	outData.currentDurability = self:GetHitPoints()
end

-------------------------------------------------------------------------------
function Torch:Restore( inData, version )

	Torch.__super.Restore(self, inData)

	self:SetMaxHitPoints(inData.maxDurability)
	self:SetHitPoints(inData.currentDurability)
	self.m_restored = true
end

-------------------------------------------------------------------------------
function Torch:PrimaryAction( args )

	if args.targetObj then

		local targetObj = args.targetObj:NKGetInstance()

		if targetObj:InstanceOf(BaseCharacter) then

			local newBuff = EternusEngine.BuffManager:CreateBuff("FireDebuff", {duration = 3.0, damage = 1.5, ticksPerSecond = 2.0})
			targetObj:ApplyBuff(newBuff)

		end

	end

end

-------------------------------------------------------------------------------
function Torch:SecondaryAction( args )
	local player = args.player
	local target = args.targetObj

	if target == nil or target == player then
		return false
	end

	if target ~= nil then
		local targetScript = target:NKGetInstance()
		if targetScript ~= nil then
			-- Check to see if the crafting station should be lit or not
			if targetScript.m_activeCrafter then
				return true
			elseif not targetScript.m_activeCrafter then
				if targetScript:InstanceOf(StoneFurnace) or targetScript:InstanceOf(FirePit) then
					-- Reduce the number of available uses for the object
					self:ModifyHitPoints(-1)
					return false
				end
			end
		end
	end

	return false
end

-------------------------------------------------------------------------------
function Torch:Spawn()

	if (Eternus.IsServer and self.m_restored) then
		local torchName = self:NKGetName()
		local newTorch = Eternus.GameObjectSystem:NKCreateGameObject(torchName, true)
		local newChildren = newTorch:NKGetChildren()
		local oldChildren = self:NKGetChildren()

		for key, value in pairs(oldChildren) do
			value:NKSetParent(nil)
			value:NKDeleteMe()
		end

		for key, value in pairs(newChildren) do
			local localPos = value:NKGetPosition()
			value:NKSetParent(self.object)
			value:NKSetPosition(localPos)
		end

		newTorch:NKDeleteMe()

		self:NKSetEmitterActive(true)
	end
	self.m_CHILDCOUNT = self:NKGetNumChildren()
end

-------------------------------------------------------------------------------
EntityFramework:RegisterGameObject(Torch)
