if (!isServer) exitWith {};

private _saveKey = format ["front_persist_%1", worldName];
private _state = createHashMapFromArray [
    ["friendlyFaction", missionNamespace getVariable ["front_friendlyFaction", "NATO"]],
    ["friendlySide", str (missionNamespace getVariable ["front_friendlySide", west])],
    ["friendlyInfantry", missionNamespace getVariable ["front_friendlyInfantry", []]],
    ["friendlyVehicles", missionNamespace getVariable ["front_friendlyVehicles", []]],
    ["friendlyAir", missionNamespace getVariable ["front_friendlyAir", []]],
    ["enemyFaction", missionNamespace getVariable ["front_enemyFaction", "CSAT"]],
    ["enemySide", str (missionNamespace getVariable ["front_enemySide", east])],
    ["enemyInfantry", missionNamespace getVariable ["front_enemyInfantry", []]],
    ["enemyVehicles", missionNamespace getVariable ["front_enemyVehicles", []]],
    ["enemyAir", missionNamespace getVariable ["front_enemyAir", []]],
    ["sectorCities", missionNamespace getVariable ["front_sectorCities", []]],
    ["sectorMilitary", missionNamespace getVariable ["front_sectorMilitary", []]],
    ["sectorRoadblocks", missionNamespace getVariable ["front_sectorRoadblocks", []]],
    ["sectorFactories", missionNamespace getVariable ["front_sectorFactories", []]],
    ["sectorFuel", missionNamespace getVariable ["front_sectorFuel", []]],
    ["sectorRadio", missionNamespace getVariable ["front_sectorRadio", []]],
    ["ownedFactories", missionNamespace getVariable ["front_ownedFactories", []]],
    ["ownedFuel", missionNamespace getVariable ["front_ownedFuel", []]],
    ["ownedAirports", missionNamespace getVariable ["front_ownedAirports", []]],
    ["builtStructures", missionNamespace getVariable ["front_builtStructures", []]],
    ["resources", missionNamespace getVariable ["front_resources", 0]],
    ["fuel", missionNamespace getVariable ["front_fuel", 0]],
    ["manpower", missionNamespace getVariable ["front_manpower", 0]],
    ["civilians", missionNamespace getVariable ["front_civilians", []]],
    ["friendlyFobs", missionNamespace getVariable ["front_friendlyFobs", []]],
    ["friendlySectors", missionNamespace getVariable ["front_friendlySectors", []]],
    ["enemyAnger", missionNamespace getVariable ["front_enemyAnger", 25]],
    ["playerFunds", keys (missionNamespace getVariable ["front_playerFunds", createHashMap]) apply {[_x, (missionNamespace getVariable ["front_playerFunds", createHashMap]) get _x]}],
    ["playerIncome", keys (missionNamespace getVariable ["front_playerIncome", createHashMap]) apply {[_x, (missionNamespace getVariable ["front_playerIncome", createHashMap]) get _x]}],
    ["timestamp", diag_tickTime]
];

serverProfileNamespace setVariable [_saveKey, _state];
saveProfileNamespace;
missionNamespace setVariable ["front_lastSave", serverTime];
diag_log format ["Frontlines persistence: autosaved state '%1'", _saveKey];
