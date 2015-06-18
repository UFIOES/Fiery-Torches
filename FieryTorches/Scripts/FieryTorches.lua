
-------------------------------------------------------------------------------
if FieryTorches == nil then
	FieryTorches = EternusEngine.ModScriptClass.Subclass("FieryTorches")
end

-------------------------------------------------------------------------------
function FieryTorches:Constructor(  )

end

 -------------------------------------------------------------------------------
 -- Called once from C++ at engine initialization time
function FieryTorches:Initialize()

end

------------------------------------------------------------------------------
-- Called from C++ when the current game enters
function FieryTorches:Enter()
end

-------------------------------------------------------------------------------
-- Called from C++ when the game leaves it current mode
function FieryTorches:Leave()
end


-------------------------------------------------------------------------------
-- Called from C++ every update tick
function FieryTorches:Process(dt)
end


EntityFramework:RegisterModScript(FieryTorches)
