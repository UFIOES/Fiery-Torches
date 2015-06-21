-------------------------------------------------------------------------------
Fiery = EternusEngine.Mixin.Subclass("Fiery")

function Fiery:Constructor( args )

end

-------------------------------------------------------------------------------
function Fiery:OnContactStart( collision )
	if not collision.gameobject then return end
	--collision.raiseStopEvents = true
	--collision.raiseStayEvents = true

	local instance = collision.gameobject:NKGetInstance()
	if instance then

		self:Burn(collision, instance)

	end
end
-------------------------------------------------------------------------------
function Fiery:Burn( collision, instance )

	if collision.contact then
		local normalL = self:NKGetTransform():NKWorldToLocalDirection(collision.contact.normal)
		if normalL:x() >= 0.75 then

			local targetObj = collision.gameobject:NKGetInstance()

			if targetObj then

				if targetObj:InstanceOf(BaseCharacter) then

					local newBuff = EternusEngine.BuffManager:CreateBuff("FireDebuff", {duration = 0.0, damage = 1.5, ticksPerSecond = 2.0})
					targetObj:ApplyBuff(newBuff)

				end

			end

		end
	end

end
-------------------------------------------------------------------------------
function Fiery:OnContactStop( collision )
	if not collision.gameobject then return end

	local targetObj = collision.gameobject:NKGetInstance()

	if targetObj then

		if targetObj:InstanceOf(BaseCharacter) then

			targetObj:RemoveBuff("FireDebuff")

			local newBuff = EternusEngine.BuffManager:CreateBuff("FireDebuff", {duration = 1.5, damage = 1.5, ticksPerSecond = 2.0})
			targetObj:ApplyBuff(newBuff)

		end

	end

end
-------------------------------------------------------------------------------
function Fiery:Spawn()
	self:NKGetPhysics():NKSetContactEventsEnabled(true)
end

-------------------------------------------------------------------------------
function Fiery:Despawn()
	self:NKGetPhysics():NKSetContactEventsEnabled(false)
end
