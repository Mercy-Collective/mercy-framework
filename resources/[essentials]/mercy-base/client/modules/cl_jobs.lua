local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("JobManager", JobManagerModule)
    end
end)

JobManagerModule = {
    -- ToDo: Remove hardcoded jobs, and add functions to add jobs.
    GetJobs = function()
        return Shared.CivillianJobs
    end,
    -- AddJob = function(JobData)
    --     -- Code
    -- end,
    -- RemoveJob = function(JobData)
    --     -- Code
    -- end,
}