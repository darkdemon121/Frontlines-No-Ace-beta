params ["_logic"];

if (!isServer) exitWith {};

// Default faction pools (overridden by faction selection and persistence)
if (isNil {missionNamespace getVariable "front_enemySide"}) then { missionNamespace setVariable ["front_enemySide", east]; };
if (isNil {missionNamespace getVariable "front_enemyFaction"}) then { missionNamespace setVariable ["front_enemyFaction", "CSAT"]; };
if (isNil {missionNamespace getVariable "front_enemyInfantry"}) then { missionNamespace setVariable ["front_enemyInfantry", ["O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_GL_F", "O_Soldier_AR_F", "O_Soldier_AAR_F", "O_Soldier_TL_F", "O_Soldier_SL_F", "O_Soldier_M_F", "O_Soldier_A_F", "O_medic_F", "O_engineer_F", "O_soldier_exp_F", "O_Soldier_AT_F", "O_Soldier_AAT_F", "O_sniper_F", "O_spotter_F", "O_soldier_repair_F", "O_soldier_PG_F", "O_helipilot_F", "O_helicrew_F", "O_crew_F", "O_officer_F", "O_soldier_UAV_F"]]; };
if (isNil {missionNamespace getVariable "front_enemyVehicles"}) then { missionNamespace setVariable ["front_enemyVehicles", ["O_Quadbike_01_F", "O_MRAP_02_F", "O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F", "O_Truck_03_transport_F", "O_Truck_03_covered_F", "O_Truck_03_device_F", "O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_AA_F", "O_MBT_02_cannon_F", "O_MBT_02_arty_F"]]; };
if (isNil {missionNamespace getVariable "front_enemyAir"}) then { missionNamespace setVariable ["front_enemyAir", ["O_UAV_02_F", "O_UAV_02_CAS_F", "O_UAV_01_F", "O_UGV_01_F", "O_UGV_01_rcws_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_covered_F", "O_Plane_CAS_02_F"]]; };
if (isNil {missionNamespace getVariable "front_enemyNaval"}) then { missionNamespace setVariable ["front_enemyNaval", ["O_Boat_Armed_01_hmg_F", "O_Boat_Transport_01_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlySide"}) then { missionNamespace setVariable ["front_friendlySide", west]; };
if (isNil {missionNamespace getVariable "front_friendlyFaction"}) then { missionNamespace setVariable ["front_friendlyFaction", "NATO"]; };
if (isNil {missionNamespace getVariable "front_friendlyInfantry"}) then { missionNamespace setVariable ["front_friendlyInfantry", ["B_Soldier_F", "B_Soldier_LAT_F", "B_Soldier_GL_F", "B_Soldier_AR_F", "B_Soldier_AAR_F", "B_Soldier_TL_F", "B_Soldier_SL_F", "B_Soldier_M_F", "B_Soldier_A_F", "B_medic_F", "B_engineer_F", "B_soldier_exp_F", "B_Soldier_AT_F", "B_Soldier_AAT_F", "B_sniper_F", "B_spotter_F", "B_soldier_repair_F", "B_soldier_PG_F", "B_Helipilot_F", "B_helicrew_F", "B_crew_F", "B_officer_F", "B_soldier_UAV_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlyVehicles"}) then { missionNamespace setVariable ["front_friendlyVehicles", ["B_Quadbike_01_F", "B_MRAP_01_F", "B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F", "B_Truck_01_transport_F", "B_Truck_01_covered_F", "B_Truck_01_mover_F", "B_Truck_01_box_F", "B_Truck_01_medical_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F", "B_APC_Tracked_01_CRV_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_cannon_F", "B_MBT_01_TUSK_F", "B_MBT_01_arty_F", "B_MBT_01_mlrs_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlyAir"}) then { missionNamespace setVariable ["front_friendlyAir", ["B_UAV_02_F", "B_UAV_02_CAS_F", "B_UAV_01_F", "B_UGV_01_F", "B_UGV_01_rcws_F", "B_Heli_Light_01_F", "B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_Heli_Attack_01_F", "B_Plane_CAS_01_F"]]; };
if (isNil {missionNamespace getVariable "front_friendlyNaval"}) then { missionNamespace setVariable ["front_friendlyNaval", ["B_Boat_Armed_01_minigun_F", "B_Boat_Transport_01_F"]]; };
if (isNil {missionNamespace getVariable "front_builtStructures"}) then { missionNamespace setVariable ["front_builtStructures", []]; };
if (isNil {missionNamespace getVariable "front_builtPlacements"}) then { missionNamespace setVariable ["front_builtPlacements", []]; };
if (isNil {missionNamespace getVariable "front_ownedAirports"}) then { missionNamespace setVariable ["front_ownedAirports", []]; };
if (isNil {missionNamespace getVariable "front_ownedPorts"}) then { missionNamespace setVariable ["front_ownedPorts", []]; };
if (isNil {missionNamespace getVariable "front_hasNaval"}) then { missionNamespace setVariable ["front_hasNaval", false]; };
if (isNil {missionNamespace getVariable "front_sectorPorts"}) then { missionNamespace setVariable ["front_sectorPorts", []]; };
if (isNil {missionNamespace getVariable "front_sectorCarriers"}) then { missionNamespace setVariable ["front_sectorCarriers", []]; };
if (isNil {missionNamespace getVariable "front_civInfantry"}) then { missionNamespace setVariable ["front_civInfantry", ["C_Man_1", "C_Man_ConstructionWorker_01_Black_F", "C_Man_Paramedic_01_F", "C_Man_casual_1_F", "C_man_polo_1_F", "C_Man_casual_4_F", "C_Man_casual_6_F"]]; };
if (isNil {missionNamespace getVariable "front_civVehicles"}) then { missionNamespace setVariable ["front_civVehicles", ["C_Offroad_01_F", "C_Offroad_01_repair_F", "C_SUV_01_F", "C_Hatchback_01_F", "C_Hatchback_01_sport_F", "C_Van_01_transport_F", "C_Van_01_box_F", "C_Van_01_fuel_F", "C_Quadbike_01_F"]]; };

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
        "front_sectorRadio",
        "front_sectorPorts",
        "front_sectorCarriers",
        "front_hasNaval",
        "front_friendlyNaval",
        "front_enemyNaval"
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
missionNamespace setVariable ["front_sectorPorts", []];
missionNamespace setVariable ["front_sectorCarriers", []];

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

// Detect water access and seed naval sectors
private _waterSamples = [];
for "_s" from 0 to 20 do {
    _waterSamples pushBack (surfaceIsWater ([[0, 0, 0], 0, worldSize, 0, 2, 0.7, 0] call BIS_fnc_findSafePos));
};
private _hasNaval = (_waterSamples select { _x }) isNotEqualTo [];
missionNamespace setVariable ["front_hasNaval", _hasNaval];

if (_hasNaval) then {
    private _marineLocations = nearestLocations [[worldSize / 2, worldSize / 2, 0], ["NameMarine", "NameLocal", "NameVillage"], worldSize];
    {
        private _pos = locationPosition _x;
        if (surfaceIsWater (_pos getPos [40, random 360])) then {
            missionNamespace setVariable ["front_sectorPorts", (missionNamespace getVariable "front_sectorPorts") + [[_pos, text _x, "Port"]]];
        };
    } forEach _marineLocations;

    for "_c" from 0 to 1 do {
        private _carrierPos = [[0, 0, 0], worldSize * 0.25, worldSize, 0, 2, 0.4, 0] call BIS_fnc_findSafePos;
        if (surfaceIsWater _carrierPos) then {
            missionNamespace setVariable ["front_sectorCarriers", (missionNamespace getVariable "front_sectorCarriers") + [[_carrierPos, format ["Carrier Group %1", _c + 1], "Carrier"]]];
        };
    };
};

publicVariable "front_sectorCities";
publicVariable "front_sectorMilitary";
publicVariable "front_sectorRoadblocks";
publicVariable "front_sectorFactories";
publicVariable "front_sectorFuel";
publicVariable "front_sectorRadio";
publicVariable "front_sectorPorts";
publicVariable "front_sectorCarriers";
publicVariable "front_hasNaval";
publicVariable "front_friendlyNaval";
publicVariable "front_enemyNaval";
