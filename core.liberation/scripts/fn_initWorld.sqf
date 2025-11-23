params ["_logic"];

if (!isServer) exitWith {};

// Default faction pools (overridden by faction selection and persistence)
if (isNil {missionNamespace getVariable "front_enemySide"}) then { missionNamespace setVariable ["front_enemySide", east]; };
if (isNil {missionNamespace getVariable "front_enemyFaction"}) then { missionNamespace setVariable ["front_enemyFaction", "CSAT"]; };
if (isNil {missionNamespace getVariable "front_enemyInfantry"}) then { missionNamespace setVariable ["front_enemyInfantry", ["O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_AR_F", "O_medic_F"]]; };
if (isNil {missionNamespace getVariable "front_enemyVehicles"}) then { missionNamespace setVariable ["front_enemyVehicles", ["O_MRAP_02_hmg_F", "O_APC_Wheeled_02_rcws_v2_F"]]; };
if (isNil {missionNamespace getVariable "front_enemyAir"}) then { missionNamespace setVariable ["front_enemyAir", ["O_Heli_Attack_02_black_F", "O_Heli_Light_02_dynamicLoadout_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlySide"}) then { missionNamespace setVariable ["front_friendlySide", west]; };
if (isNil {missionNamespace getVariable "front_friendlyFaction"}) then { missionNamespace setVariable ["front_friendlyFaction", "NATO"]; };
if (isNil {missionNamespace getVariable "front_friendlyInfantry"}) then { missionNamespace setVariable ["front_friendlyInfantry", ["B_Soldier_F", "B_soldier_AR_F", "B_soldier_LAT_F", "B_medic_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlyVehicles"}) then { missionNamespace setVariable ["front_friendlyVehicles", ["B_MRAP_01_hmg_F", "B_APC_Wheeled_01_cannon_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlyAir"}) then { missionNamespace setVariable ["front_friendlyAir", ["B_Heli_Transport_03_F", "B_Heli_Attack_01_dynamicLoadout_F"]]; };
if (isNil {missionNamespace getVariable "front_builtStructures"}) then { missionNamespace setVariable ["front_builtStructures", []]; };
if (isNil {missionNamespace getVariable "front_ownedAirports"}) then { missionNamespace setVariable ["front_ownedAirports", []]; };

// Skip discovery if persistence restored a previous scan
if (missionNamespace getVariable ["front_persistenceLoaded", false]) exitWith {
    {
        publicVariable _x;
    } forEach [
        "front_sectorCities",
        "front_sectorMilitary",
        "front_sectorRoadblocks",
        "front_sectorFactories",
        "front_sectorFuel",
        "front_sectorRadio"
    ];
};

// Identify usable locations on current terrain
private _cityTypes = ["NameCity", "NameCityCapital", "NameVillage", "NameLocal"];
private _milTypes = ["Hill", "Airport", "Strategic", "NameMarine"];

missionNamespace setVariable ["front_sectorCities", []];
missionNamespace setVariable ["front_sectorMilitary", []];
missionNamespace setVariable ["front_sectorRoadblocks", []];
missionNamespace setVariable ["front_sectorFactories", []];
missionNamespace setVariable ["front_sectorFuel", []];
missionNamespace setVariable ["front_sectorRadio", []];

{
    private _locs = nearestLocations [[worldSize / 2, worldSize / 2, 0], [_x], worldSize];
    {
        private _entry = [locationPosition _x, text _x, type _x];
        switch (true) do {
            case (_x in _locs && {(type _x) in _cityTypes}): { missionNamespace setVariable ["front_sectorCities", (missionNamespace getVariable "front_sectorCities") + [_entry]]; };
            case ((type _x) in _milTypes): { missionNamespace setVariable ["front_sectorMilitary", (missionNamespace getVariable "front_sectorMilitary") + [_entry]]; };
        };
    } forEach _locs;
} forEach (_cityTypes + _milTypes);

// Sprinkle additional random objectives along the road network
private _roadSegments = roadsConnectedTo (player nearRoads 1);
private _randomRoads = (roadsConnectedTo ((position player) nearestRoad)) select [0, 50 min count _roadSegments];
missionNamespace setVariable ["front_sectorRoadblocks", _randomRoads apply { [getPosATL _x, "Roadblock"] }];

// Seed strategic industry points in remote areas
for "_i" from 0 to 5 do {
    private _pos = [[0, 0, 0], 0, worldSize, 5, 0, 20, 0] call BIS_fnc_findSafePos;
    if (_i < 3) then {
        missionNamespace setVariable ["front_sectorFactories", (missionNamespace getVariable "front_sectorFactories") + [[_pos, format ["Factory %1", _i + 1], "Factory"]]];
    } else {
        missionNamespace setVariable ["front_sectorFuel", (missionNamespace getVariable "front_sectorFuel") + [[_pos, format ["Fuel Depot %1", _i - 2], "FuelDepot"]]];
    };
};

// Place radio towers as communication objectives
for "_i" from 0 to 3 do {
    private _pos = [[0, 0, 0], 0, worldSize, 5, 0, 0.5, 0] call BIS_fnc_findSafePos;
    missionNamespace setVariable ["front_sectorRadio", (missionNamespace getVariable "front_sectorRadio") + [[_pos, format ["Radio Tower %1", _i + 1], "Radio"]]];
};

publicVariable "front_sectorCities";
publicVariable "front_sectorMilitary";
publicVariable "front_sectorRoadblocks";
publicVariable "front_sectorFactories";
publicVariable "front_sectorFuel";
publicVariable "front_sectorRadio";
