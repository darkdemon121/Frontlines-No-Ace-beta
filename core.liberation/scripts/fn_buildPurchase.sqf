if (!isServer) exitWith {
    params ["_catId", "_itemData", "_ctx", "_buyer"];
    [_catId, _itemData, _ctx, _buyer] remoteExecCall ["front_fnc_buildPurchase", 2];
};

params ["_catId", "_itemData", ["_ctx", [position player, getDir player]], "_buyer"];
_ctx params ["_pos", ["_dir", getDir _buyer]];
if (isNil "_pos") then { _pos = position _buyer; };
if (isNull _buyer) exitWith {};

private _resources = missionNamespace getVariable ["front_resources", 0];
private _fuel = missionNamespace getVariable ["front_fuel", 0];
private _manpower = missionNamespace getVariable ["front_manpower", 0];
private _built = missionNamespace getVariable ["front_builtStructures", []];
private _airports = missionNamespace getVariable ["front_ownedAirports", []];

_itemData params ["_name", "_class", ["_resCost",0], ["_fuelCost",0], ["_manCost",0]];

private _catalog = missionNamespace getVariable ["front_buildCatalog", []];
private _cat = _catalog select {(_x select 0) isEqualTo _catId};
private _requires = if ((count _cat) > 0) then {_cat select 0 select 2} else {[]};

// requirement checks
private _hasRequirement = {
    params ["_req", "_built", "_airports"];
    switch (_req) do {
        case "Airport": { (count _airports) > 0 };
        default { (_built findIf { _x isEqualTo _req }) > -1 };
    };
};

private _requirementsMet = true;
scopeName "reqCheck";
{
    if (!([_x, _built, _airports] call _hasRequirement)) exitWith {
        [format ["Missing requirement: %1", _x]] remoteExec ["hint", _buyer];
        _requirementsMet = false;
        breakOut "reqCheck";
    };
} forEach _requires;

if (!_requirementsMet) exitWith {};

if (_resources < _resCost) exitWith { ["Insufficient faction resources"] remoteExec ["hint", _buyer]; };
if (_fuel < _fuelCost) exitWith { ["Insufficient faction fuel"] remoteExec ["hint", _buyer]; };
if (_manpower < _manCost) exitWith { ["Insufficient manpower"] remoteExec ["hint", _buyer]; };

// deduct costs
missionNamespace setVariable ["front_resources", _resources - _resCost, true];
missionNamespace setVariable ["front_fuel", _fuel - _fuelCost, true];
missionNamespace setVariable ["front_manpower", _manpower - _manCost, true];

private _spawnPos = _pos getPos [6, random 360];

switch (_catId) do {
    case "Buildings": {
        private _obj = createVehicle [_class, _spawnPos, [], 0, "NONE"];
        _obj setDir _dir;
        private _fobVehicle = missionNamespace getVariable ["front_fobVehicleClass", "B_Truck_01_box_F"];
        if (_class isEqualTo _fobVehicle) then {
            [_obj] call front_fnc_registerFobTruck;
        };
        private _placements = missionNamespace getVariable ["front_builtPlacements", []];
        _placements pushBack [_name, _class, getPosATL _obj, getDir _obj];
        missionNamespace setVariable ["front_builtPlacements", _placements, true];
        if ((_built findIf {_x isEqualTo _name}) < 0) then {
            _built pushBack _name;
            missionNamespace setVariable ["front_builtStructures", _built, true];
        };
    };
    case "Fortifications": {
        private _obj = createVehicle [_class, _spawnPos, [], 0, "NONE"];
        _obj setDir _dir;
        private _placements = missionNamespace getVariable ["front_builtPlacements", []];
        _placements pushBack [_name, _class, getPosATL _obj, getDir _obj];
        missionNamespace setVariable ["front_builtPlacements", _placements, true];
    };
    case "Infantry": {
        [_class, _buyer, _pos] call front_fnc_spawnPersonalInfantry;
    };
    case "Vehicles": {
        private _veh = createVehicle [_class, _spawnPos, [], 0, "NONE"];
        _veh setDir random 360;
    };
    case "Helicopters": {
        private _veh = createVehicle [_class, _spawnPos vectorAdd [0,0,1], [], 0, "FLY"];
        createVehicleCrew _veh;
    };
    case "Planes": {
        private _veh = createVehicle [_class, _spawnPos vectorAdd [0,0,5], [], 0, "FLY"];
        createVehicleCrew _veh;
    };
    case "Defenses": {
        private _weapon = createVehicle [_class, _spawnPos, [], 0, "NONE"];
        _weapon setDir random 360;
    };
};

[format ["Built %1 (-%2 res, -%3 fuel, -%4 manpower)", _name, _resCost, _fuelCost, _manCost]] remoteExec ["hint", _buyer];
