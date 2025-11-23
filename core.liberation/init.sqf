// Entry point
[] call compile preprocessFileLineNumbers "scripts/fn_missionHelpers.sqf";
missionNamespace setVariable ["front_friendlyPrisonBuilding", "Land_Barracks_01_grey_F"];
missionNamespace setVariable ["front_powPrisonBuilding", "Land_i_Barracks_V1_F"];
// legacy alias for modules still reading the older single-prison key (use POW holding site)
missionNamespace setVariable ["front_prisonBuilding", "Land_i_Barracks_V1_F"];
missionNamespace setVariable ["front_fobStructureClass", "Land_Cargo_HQ_V1_F"];
missionNamespace setVariable ["front_fobVehicleClass", "B_Truck_01_box_F"];
missionNamespace setVariable ["front_fobAnchors", ["Land_Cargo_HQ_V1_F", "B_Truck_01_box_F"]];
private _existingFobs = missionNamespace getVariable ["front_friendlyFobs", []];
missionNamespace setVariable ["front_friendlyFobs", _existingFobs, true];
if (isServer) then {
    private _center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
    private _respawnPos = [_center select 0, _center select 1, 0];

    [] call front_fnc_selectFactions;
    private _enemyCapture = "enemyCaptureTime" call BIS_fnc_getParamValue;
    missionNamespace setVariable ["front_enemyCaptureDuration", _enemyCapture max 120];
    private _aiScaleRaw = "aiPopulationScale" call BIS_fnc_getParamValue;
    private _aiScale = (_aiScaleRaw max 50) min 500; // clamp to 50%–500% so we never drop below half strength or go negative
    missionNamespace setVariable ["front_aiMultiplier", _aiScale / 100];
    publicVariable "front_aiMultiplier";
    publicVariable "front_enemyCaptureDuration";
    if (isNil {missionNamespace getVariable "front_friendlyLost"}) then { missionNamespace setVariable ["front_friendlyLost", []]; };
    if (isNil {missionNamespace getVariable "front_enemyLost"}) then { missionNamespace setVariable ["front_enemyLost", []]; };
    [] call front_fnc_persistenceLoad;
    ["init"] call front_fnc_enemyAnger;

    if (!(markerExists "respawn_west")) then {
        private _marker = createMarker ["respawn_west", _respawnPos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "hd_start";
        _marker setMarkerText "Deployment";
    };

    [] call front_fnc_initWorld;
    [] call front_fnc_seedFob;
    [] spawn front_fnc_generateSectors;
    [] call front_fnc_shops;
    ["start", []] call front_fnc_privateEconomy;
    [] spawn front_fnc_sectorMonitor;
    [] spawn front_fnc_economyLoop;
    [] spawn front_fnc_aiCommander;
    [] spawn front_fnc_surrender;
    [] spawn front_fnc_drones;
    [] spawn front_fnc_navalOps;
    [] spawn front_fnc_artilleryOps;
    [] spawn front_fnc_warCrimes;
    [] spawn front_fnc_persistenceAutoSave;
    [] spawn front_fnc_battleOverlay;
};

if (hasInterface) then {
    ["register", [player]] call front_fnc_privateEconomy;
    [] spawn front_fnc_spawnLogisticsMenu;
    [] spawn front_fnc_prisoners;
    [] spawn front_fnc_playerFundsActions;
    [] spawn front_fnc_warCrimes;
    [] spawn front_fnc_battleOverlay;
    [] spawn front_fnc_commandAccess;
    [] spawn front_fnc_sectorPresenceClient;
    [] spawn front_fnc_structureRepairs;
};

if (isServer && (paramsArray select ("sideMissions" call BIS_fnc_getParamValue) > -1)) then {
    [] spawn front_fnc_sideMissions;
};
