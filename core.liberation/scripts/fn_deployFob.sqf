if (!isServer) exitWith {
    params ["_truck", ["_caller", objNull]];
    [_truck, _caller] remoteExecCall ["front_fnc_deployFob", 2];
};

params ["_truck", ["_caller", objNull]];
if (isNull _truck) exitWith {};

private _structureClass = missionNamespace getVariable ["front_fobStructureClass", "Land_Cargo_HQ_V1_F"];
private _vehicleClass = missionNamespace getVariable ["front_fobVehicleClass", "B_Truck_01_box_F"];

if (!(_truck isKindOf _vehicleClass)) exitWith {};
if (_truck getVariable ["front_fobDeployed", false]) exitWith {};

private _pos = getPosATL _truck;
private _dir = getDir _truck;

private _placements = missionNamespace getVariable ["front_builtPlacements", []];
_placements = _placements select { !((_x select 1) isEqualTo _vehicleClass && {_pos distance (_x select 2) < 10}) };

private _hq = createVehicle [_structureClass, _pos, [], 0, "NONE"];
_hq setDir _dir;
_hq setPosATL _pos;

_placements pushBack ["FOB HQ", _structureClass, getPosATL _hq, getDir _hq];
missionNamespace setVariable ["front_builtPlacements", _placements, true];

private _fobs = missionNamespace getVariable ["front_friendlyFobs", []];
_fobs pushBackUnique getPosATL _hq;
missionNamespace setVariable ["front_friendlyFobs", _fobs, true];
publicVariable "front_friendlyFobs";

[getPosATL _hq, "FOB HQ"] call front_fnc_markFob;

_truck setVariable ["front_fobDeployed", true, true];
[_truck] spawn {
    params ["_veh"];
    if (!isNull _veh) then { deleteVehicle _veh; };
};
