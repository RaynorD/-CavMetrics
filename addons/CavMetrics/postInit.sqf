
// functions adapted from YAINA by MartinCo at http://yaina.eu

if !(isServer || !hasInterface) exitWith {};
_cba = (isClass(configFile >> "CfgPatches" >> "cba_a3"));

diag_log text format ["[CavMetrics] instance name: %1", profileName];

_fnc_send = {
    params ["_metric", "_value", ["_global", false]];
    _profileName = profileName;
    private _metricPath = [format["%1.%2.%3", _profileName, "hosts", profileName], format["%1.%2", _profileName, "global"]] select _global;
    if(missionNamespace getVariable ["CavMetrics_debug",false]) then {
        diag_log text format ["[CavMetrics] Sending a3Graphite data: %1",[format["%1.%2", _metricPath, _metric], _value]];
    };
    "a3graphite" callExtension format["%1|%2", format["%1.%2", _metricPath, _metric], _value];
};

diag_log text "[CavMetrics] Initializing";

[_cba, _fnc_send] spawn {
    params ["_cba","_fnc_send"];
    CavMetrics_run = true;
    while{true} do {
        if(missionNamespace getVariable ["CavMetrics_run",false]) then {
            // Number of local units
            ["count.units", { local _x } count allUnits] call _fnc_send;
            ["count.groups", { local _x } count allGroups] call _fnc_send;
            ["count.vehicles", { local _x} count vehicles] call _fnc_send;
            
            // Server Stats
            ["stats.fps", round diag_fps] call _fnc_send;
            ["stats.fpsMin", round diag_fpsMin] call _fnc_send;
            ["stats.uptime", round diag_tickTime] call _fnc_send;
            ["stats.missionTime", round time] call _fnc_send;
            
            // Scripts
            private _activeScripts = diag_activeScripts;
            ["scripts.spawn", _activeScripts select 0] call _fnc_send;
            ["scripts.execVM", _activeScripts select 1] call _fnc_send;
            ["scripts.exec", _activeScripts select 2] call _fnc_send;
            ["scripts.execFSM", _activeScripts select 3] call _fnc_send;
            
            _pfhCount = if(_cba) then {count CBA_perFrameHandlerArray} else {0};
            ["scripts.pfh", _pfhCount] call _fnc_send;
            
            // Globals if server
            if (isServer) then {
                // Number of local units
                ["count.units", count allUnits, true] call _fnc_send;
                ["count.groups", count allGroups, true] call _fnc_send;
                ["count.vehicles", count vehicles, true] call _fnc_send;
                ["count.players", count allPlayers, true] call _fnc_send;
            };
            
        };
            
        sleep 10;
    };
};
