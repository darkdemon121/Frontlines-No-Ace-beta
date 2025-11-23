params ["_truck"];
if (isNull _truck) exitWith {};

// Run on server to propagate deploy action to all clients
if (!isServer) exitWith { [_truck] remoteExecCall ["front_fnc_registerFobTruck", 2]; };

_truck setVariable ["front_isFobTruck", true, true];

[{
    params ["_t"];
    if (isNull _t) exitWith {};
    if (!hasInterface) exitWith {};
    if (_t getVariable ["front_hasDeploy", false]) exitWith {};
    private _id = _t addAction ["Deploy FOB HQ", {
        params ["_target", "_caller"];
        [_target, _caller] remoteExecCall ["front_fnc_deployFob", 2];
    }, [], 1.5, true, true, "", "alive _target"];
    _t setVariable ["front_hasDeploy", true];
    _t setVariable ["front_deployActionId", _id];
}, [_truck]] remoteExec ["spawn", 0, _truck];
