if (!isServer) exitWith {};

params ["_grp"];
if (isNull _grp) exitWith {};

_grp setVariable ["front_highCommand", true, true];

private _commanders = missionNamespace getVariable ["front_commanderUnits", []];
_commanders = _commanders select {!isNull _x};
{
    [_grp] remoteExecCall ["front_fnc_addHCGroup", _x];
} forEach _commanders;
