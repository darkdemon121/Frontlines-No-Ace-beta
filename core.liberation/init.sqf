// Entry point
[] call compile preprocessFileLineNumbers "scripts/fn_missionHelpers.sqf";
missionNamespace setVariable ["front_friendlyPrisonBuilding", "Land_Barracks_01_grey_F"];
missionNamespace setVariable ["front_powPrisonBuilding", "Land_i_Barracks_V1_F"];
// legacy alias for modules still reading the older single-prison key (use POW holding site)
missionNamespace setVariable ["front_prisonBuilding", "Land_i_Barracks_V1_F"];
if (isServer) then {
    private _center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
    private _respawnPos = [_center select 0, _center select 1, 0];

    [] call front_fnc_selectFactions;
    [] call front_fnc_persistenceLoad;
    ["init"] call front_fnc_enemyAnger;

    if (!(markerExists "respawn_west")) then {
        private _marker = createMarker ["respawn_west", _respawnPos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "hd_start";
        _marker setMarkerText "Deployment";
    };

    [] call front_fnc_initWorld;
    [] spawn front_fnc_generateSectors;
    [] call front_fnc_shops;
    ["start", []] call front_fnc_privateEconomy;
    [] spawn front_fnc_sectorMonitor;
    [] spawn front_fnc_economyLoop;
    [] spawn front_fnc_aiCommander;
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
};

if (isServer && (paramsArray select ("sideMissions" call BIS_fnc_getParamValue) > -1)) then {
    [] spawn front_fnc_sideMissions;
};
