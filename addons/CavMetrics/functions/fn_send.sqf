params ["_metric", "_value", ["_global", false]];

private _profileName = profileName;

private _metricPath = [format["%1.%2.%3", _profileName, "hosts", profileName], format["%1.%2", _profileName, "global"]] select _global;

private _extSend = format["%1|%2", format["%1.%2", _metricPath, _metric], _value];

if(missionNamespace getVariable ["CavMetrics_debug",false]) then {
    [format ["[CavMetrics] INFO: Sending a3Graphite data: %1", _extSend]] call CavMetrics_fnc_log;
};

private _return = "a3graphite" callExtension _extSend;

if(isNil "_return") exitWith {
    [format ["[CavMetrics] ERROR: return was nil (%1)", _extSend]] call CavMetrics_fnc_log;
    false
};

if(_return in ["invalid metric value","malformed, could not find separator"] ) exitWith {
    [format ["[CavMetrics] ERROR: %1 (%2)", _return, _extSend]] call CavMetrics_fnc_log;
    false
};

if(missionNamespace getVariable ["CavMetrics_debug",false]) then {
    _returnArgs = _return splitString (toString [10,32]);
    [format ["[CavMetrics] INFO: a3Graphite return data: %1",_returnArgs]] call CavMetrics_fnc_log;
};

true

//"Raynor.global.count.unitTest 5 1540003701
//"
