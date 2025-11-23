if (!isServer) exitWith {
    _this remoteExecCall ["front_fnc_completeMission", 2];
};

params ["_id", ["_success", false]];

private _active = missionNamespace getVariable ["front_activeMissions", []];
private _idx = _active findIf { (_x get "id") isEqualTo _id };
if (_idx < 0) exitWith {};

private _mission = _active select _idx;
private _taskId = _mission get "taskId";
private _angerDelta = if (_mission getOrDefault ["sabotage", false]) then {-10} else {5};
private _marker = _mission getOrDefault ["marker", ""];

if (_success) then {
    [_taskId, "Succeeded"] call BIS_fnc_taskSetState;
    ["adjust", _angerDelta] call front_fnc_enemyAnger;
    _mission set ["state", "Completed"];
    private _payout = _mission getOrDefault ["payout", 0];
    if (_payout > 0) then {
        {
            if (!isNull _x) then {
                ["adjust", [_x, _payout]] call front_fnc_privateEconomy;
                [format ["Mission reward +$%1", _payout]] remoteExec ["hintSilent", _x];
            };
        } forEach allPlayers;
    };
    ["missionBonus", []] call front_fnc_privateEconomy;
} else {
    [_taskId, "Failed"] call BIS_fnc_taskSetState;
    ["adjust", 3] call front_fnc_enemyAnger;
    _mission set ["state", "Failed"];
};

if (!(_marker isEqualTo "")) then {
    deleteMarker _marker;
};

_active set [_idx, _mission];
missionNamespace setVariable ["front_activeMissions", _active];
publicVariable "front_activeMissions";
