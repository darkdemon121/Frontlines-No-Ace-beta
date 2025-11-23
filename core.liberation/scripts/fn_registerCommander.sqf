if (!isServer) exitWith {};

params ["_unit", ["_state", false]];
if (isNull _unit) exitWith {};

private _commanders = missionNamespace getVariable ["front_commanderUnits", []];
_commanders = _commanders select {!isNull _x};

if (_state) then {
    if (!(_unit in _commanders)) then { _commanders pushBack _unit; };
} else {
    _commanders = _commanders - [_unit];
};

missionNamespace setVariable ["front_commanderUnits", _commanders];
publicVariable "front_commanderUnits";

// Provide existing ambient HC groups to newly registered commanders
if (_state) then {
    private _hcGroups = allGroups select { (_x getVariable ["front_highCommand", false]) && {side _x isEqualTo (missionNamespace getVariable ["front_friendlySide", west])} };
    { [_x] remoteExecCall ["front_fnc_addHCGroup", _unit]; } forEach _hcGroups;
} else {
    [_unit] remoteExecCall [{ params ["_commander"]; if (local _commander) then { hcRemoveAllGroups _commander; }; }, _unit];
};
