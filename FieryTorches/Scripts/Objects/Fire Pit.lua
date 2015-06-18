include("Scripts/Interactable.lua")
include("Scripts/Objects/CraftingStation.lua")

-------------------------------------------------------------------------------
FirePit = CraftingStation.Subclass("FirePit")

FirePit.EventRange = 5.0

-------------------------------------------------------------------------------
function FirePit:Spawn()
	self:NKGetPhysics():NKSetContactEventsEnabled(true)
	FirePit.__super.Spawn(self)
end
-------------------------------------------------------------------------------
 function FirePit:Despawn()
	self:NKGetPhysics():NKSetContactEventsEnabled(false)
 end
 -------------------------------------------------------------------------------
function FirePit:OnContactStart( collision )
	if not collision.gameobject then return end
	--collision.raiseStopEvents = true
	--collision.raiseStayEvents = true

	local instance = collision.gameobject:NKGetInstance()
	if instance and self.m_activeCrafter then

		self:Burn(collision, instance)

	end
end
-------------------------------------------------------------------------------
function FirePit:Burn( collision, instance )

	if collision.contact then
		local normalL = self:NKGetTransform():NKWorldToLocalDirection(collision.contact.normal)
		if normalL:y() >= 0.25 then

			local targetObj = collision.gameobject:NKGetInstance()

			if targetObj then

				if targetObj:InstanceOf(BaseCharacter) then

					local newBuff = EternusEngine.BuffManager:CreateBuff("FireDebuff", {duration = 0.0, damage = 2.0, ticksPerSecond = 2.0})
					targetObj:ApplyBuff(newBuff)

				end

			end

		end
	end

end
-------------------------------------------------------------------------------
function FirePit:OnContactStop( collision )
	if not collision.gameobject then return end

	local targetObj = collision.gameobject:NKGetInstance()

	if targetObj then

		if targetObj:InstanceOf(BaseCharacter) then

			targetObj:RemoveBuff("FireDebuff")

		end

	end

end
-------------------------------------------------------------------------------
function FirePit:OnDeactivate()
	FirePit.__super.OnDeactivate(self)

	Eternus.EventSystem:NKBroadcastEventInRadius("Event_HeatIsOff", self:NKGetPosition(), self.EventRange, self)
end

-------------------------------------------------------------------------------
function FirePit:OnActivate()
	FirePit.__super.OnActivate(self)
end

-------------------------------------------------------------------------------
function FirePit:OnRemoveFromWorld( freeMemory )
	Eternus.EventSystem:NKBroadcastEventInRadius("Event_HeatIsOff", self:NKGetPosition(), self.EventRange, self)
end

-------------------------------------------------------------------------------
function FirePit:Event_SeekingHeat(obj)
	if self.m_activeCrafter and obj and obj.Event_HeatIsOn then
		obj:Event_HeatIsOn(self)
	end
end


-------------------------------------------------------------------------------
EntityFramework:RegisterGameObject(FirePit)
