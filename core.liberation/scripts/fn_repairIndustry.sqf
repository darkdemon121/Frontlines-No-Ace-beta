if (!isServer) exitWith {
    params ["_pos", "_name", ["_caller", player]];
    [_pos, _name, _caller] remoteExecCall ["front_fnc_repairIndustry", 2];
};

params ["_pos", ["_name", "Facility"], ["_caller", objNull]];

private _resources = missionNamespace getVariable ["front_resources", 0];
private _fuel = missionNamespace getVariable ["front_fuel", 0];
private _resCost = 200;
private _fuelCost = 50;

if (_resources < _resCost) exitWith { ["Insufficient resources to repair"] remoteExec ["hint", _caller]; };
if (_fuel < _fuelCost) exitWith { ["Insufficient fuel to repair"] remoteExec ["hint", _caller]; };

private _fixEntry = {
    params ["_key", "_pos"];
    private _pool = missionNamespace getVariable [_key, []];
    private _idx = _pool findIf { (_x select 0) isEqualTo _pos };
    if (_idx < 0) exitWith {false};
    private _entry = +(_pool select _idx);
    if ((count _entry) < 4) then { _entry set [3, true]; } else { _entry set [3, true]; };
    _pool set [_idx, _entry];
    missionNamespace setVariable [_key, _pool, true];
    true
};

private _patched = (["front_ownedFactories", _pos] call _fixEntry) || (["front_ownedFuel", _pos] call _fixEntry);
if (!_patched) exitWith { ["No damaged industry found here"] remoteExec ["hint", _caller]; };

missionNamespace setVariable ["front_resources", _resources - _resCost, true];
missionNamespace setVariable ["front_fuel", _fuel - _fuelCost, true];

[format ["%1 repaired (-%2 res / -%3 fuel)", _name, _resCost, _fuelCost]] remoteExec ["hint", _caller];
