if (!isServer) exitWith {};

// Skip if persistence already provided FOBs
if (missionNamespace getVariable ["front_persistenceLoaded", false]) exitWith {};
private _existing = missionNamespace getVariable ["front_friendlyFobs", []];
if (!(_existing isEqualTo [])) exitWith {};

private _enemySectors = [
    missionNamespace getVariable ["front_sectorCities", []],
    missionNamespace getVariable ["front_sectorMilitary", []],
    missionNamespace getVariable ["front_sectorFactories", []],
    missionNamespace getVariable ["front_sectorFuel", []],
    missionNamespace getVariable ["front_sectorRadio", []],
    missionNamespace getVariable ["front_sectorPorts", []],
    missionNamespace getVariable ["front_sectorCarriers", []]
] call BIS_fnc_flatten;

private _pos = [worldSize / 2, worldSize / 2, 0];
private _tries = 0;
while {_tries < 25} do {
    private _candidate = [_pos, 0, worldSize * 0.75, 5, 0, 0.5, 0] call BIS_fnc_findSafePos;
    if (!surfaceIsWater _candidate) then {
        private _nearby = _enemySectors findIf { _candidate distance2D (_x select 0) < 800 };
        if (_nearby == -1) exitWith { _pos = _candidate; };
    };
    _tries = _tries + 1;
};

private _truckClass = missionNamespace getVariable ["front_fobVehicleClass", "B_Truck_01_box_F"];
private _truck = createVehicle [_truckClass, _pos, [], 0, "NONE"];
_truck setDir random 360;

[_truck] call front_fnc_registerFobTruck;
[_truck, objNull] call front_fnc_deployFob;
