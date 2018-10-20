
// function adapted from YAINA by MartinCo at http://yaina.eu

if !(isServer || !hasInterface) exitWith {};
_cba = (isClass(configFile >> "CfgPatches" >> "cba_a3"));

[format ["[CavMetrics] instance name: %1", profileName]] call CavMetrics_fnc_log;

["[CavMetrics] Initializing v1.1"] call CavMetrics_fnc_log;

[_cba] spawn {
    params ["_cba"];
    CavMetrics_run = true;
    
    while{true} do {
        if(missionNamespace getVariable ["CavMetrics_run",false]) then {
            // Number of local units
            ["count.units", { local _x } count allUnits] call CavMetrics_fnc_send;
            ["count.groups", { local _x } count allGroups] call CavMetrics_fnc_send;
            ["count.vehicles", { local _x} count vehicles] call CavMetrics_fnc_send;
            
            // Server Stats
            ["stats.fps", round diag_fps] call CavMetrics_fnc_send;
            ["stats.fpsMin", round diag_fpsMin] call CavMetrics_fnc_send;
            ["stats.uptime", round diag_tickTime] call CavMetrics_fnc_send;
            ["stats.missionTime", round time] call CavMetrics_fnc_send;
            
            // Scripts
            private _activeScripts = diag_activeScripts;
            ["scripts.spawn", _activeScripts select 0] call CavMetrics_fnc_send;
            ["scripts.execVM", _activeScripts select 1] call CavMetrics_fnc_send;
            ["scripts.exec", _activeScripts select 2] call CavMetrics_fnc_send;
            ["scripts.execFSM", _activeScripts select 3] call CavMetrics_fnc_send;
            
            _pfhCount = if(_cba) then {count CBA_perFrameHandlerArray} else {0};
            ["scripts.pfh", _pfhCount] call CavMetrics_fnc_send;
            
            // Globals if server
            if (isServer) then {
                // Number of local units
                ["count.units", count allUnits, true] call CavMetrics_fnc_send;
                ["count.groups", count allGroups, true] call CavMetrics_fnc_send;
                ["count.vehicles", count vehicles, true] call CavMetrics_fnc_send;
                ["count.players", count allPlayers, true] call CavMetrics_fnc_send;
            };
            if(missionNamespace getVariable ["CavMetrics_debug",false]) then {
                missionNamespace setVariable ["CavMetrics_debug",false];
            };
        };
            
        sleep 10;
    };
};
