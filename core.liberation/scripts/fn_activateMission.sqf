params ["_id"];

if (!isServer) exitWith {
    [_id] remoteExecCall ["front_fnc_activateMission", 2];
};

private _defs = missionNamespace getVariable ["front_missionDefinitions", []];
private _idx = _defs findIf { (_x get "id") isEqualTo _id };
if (_idx < 0) exitWith {};

private _active = missionNamespace getVariable ["front_activeMissions", []];
if ((_active findIf { (_x get "id") isEqualTo _id && {(_x get "state") in ["running", "Active"]} }) > -1) exitWith {};

private _def = _defs select _idx;
private _mission = [_def] call front_fnc_spawnMission;
if (!isNil "_mission") then {
    _active pushBack _mission;
    missionNamespace setVariable ["front_activeMissions", _active];
    publicVariable "front_activeMissions";

    [format ["Mission started: %1 (%2) - Reward $%3", _def get "title", _def get "category", _def getOrDefault ["payout", 0]]] remoteExec ["systemChat", 0];
    ["TaskAssigned", [_mission get "taskId", true]] remoteExec ["BIS_fnc_showNotification", 0];
};
