local ModuleHandler = {
    CleanupTasks = {}
}

-- Adds a task to be executed when the module stops
function ModuleHandler:RegisterTask(moduleName, task)
    if not self.CleanupTasks[moduleName] then
        self.CleanupTasks[moduleName] = {}
    end
    table.insert(self.CleanupTasks[moduleName], task)
end

-- Stops a specific module and cleans up all related tasks
function ModuleHandler:StopModule(moduleName)
    print("[K. Cheat] Stopping module: " .. moduleName)
    if self.CleanupTasks[moduleName] then
        for _, task in ipairs(self.CleanupTasks[moduleName]) do
            pcall(function()
                if typeof(task) == "function" then
                    task()
                elseif typeof(task) == "RBXScriptConnection" then
                    task:Disconnect()
                elseif typeof(task) == "Instance" then
                    task:Destroy()
                end
            end)
        end
        self.CleanupTasks[moduleName] = nil
    end
end

-- Shutdown all modules (called when GUI closes)
function ModuleHandler:Shutdown()
    print("[K. Cheat] Global shutdown triggered.")
    for moduleName, _ in pairs(self.CleanupTasks) do
        self:StopModule(moduleName)
    end
end

return ModuleHandler
