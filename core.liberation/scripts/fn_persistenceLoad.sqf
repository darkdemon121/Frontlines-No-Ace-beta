if (!isServer) exitWith {};

private _saveKey = format ["front_persist_%1", worldName];
private _state = serverProfileNamespace getVariable [_saveKey, objNull];

if (!isNil "_state" && {!(_state isEqualTo objNull)}) then {
    private _getValue = {
        params ["_store", "_key", "_default"];
        if (_store isEqualType createHashMap) then {
            _store getOrDefault [_key, _default]
        } else {
            _default
        }
    };

    private _parseSide = {
        params ["_value", "_default"];
        if (_value isEqualType sideUnknown) exitWith {_value};
        if (_value isEqualType "") exitWith {
            private _parsed = call compile _value;
            if (_parsed isEqualType sideUnknown) then { _parsed } else { _default };
        };
        _default
    };

    missionNamespace setVariable ["front_friendlyFaction", [_state, "friendlyFaction", missionNamespace getVariable ["front_friendlyFaction", "NATO"]] call _getValue];
    missionNamespace setVariable ["front_enemyFaction", [_state, "enemyFaction", missionNamespace getVariable ["front_enemyFaction", "CSAT"]] call _getValue];
    missionNamespace setVariable ["front_friendlySide", [[_state, "friendlySide", str (missionNamespace getVariable ["front_friendlySide", west])] call _getValue, missionNamespace getVariable ["front_friendlySide", west]] call _parseSide];
    missionNamespace setVariable ["front_enemySide", [[_state, "enemySide", str (missionNamespace getVariable ["front_enemySide", east])] call _getValue, missionNamespace getVariable ["front_enemySide", east]] call _parseSide];
    missionNamespace setVariable ["front_friendlyInfantry", [_state, "friendlyInfantry", missionNamespace getVariable ["front_friendlyInfantry", []]] call _getValue];
    missionNamespace setVariable ["front_friendlyVehicles", [_state, "friendlyVehicles", missionNamespace getVariable ["front_friendlyVehicles", []]] call _getValue];
    missionNamespace setVariable ["front_friendlyAir", [_state, "friendlyAir", missionNamespace getVariable ["front_friendlyAir", []]] call _getValue];
    missionNamespace setVariable ["front_enemyInfantry", [_state, "enemyInfantry", missionNamespace getVariable ["front_enemyInfantry", []]] call _getValue];
    missionNamespace setVariable ["front_enemyVehicles", [_state, "enemyVehicles", missionNamespace getVariable ["front_enemyVehicles", []]] call _getValue];
    missionNamespace setVariable ["front_enemyAir", [_state, "enemyAir", missionNamespace getVariable ["front_enemyAir", []]] call _getValue];

    missionNamespace setVariable ["front_sectorCities", [_state, "sectorCities", []] call _getValue];
    missionNamespace setVariable ["front_sectorMilitary", [_state, "sectorMilitary", []] call _getValue];
    missionNamespace setVariable ["front_sectorRoadblocks", [_state, "sectorRoadblocks", []] call _getValue];
    missionNamespace setVariable ["front_sectorFactories", [_state, "sectorFactories", []] call _getValue];
    missionNamespace setVariable ["front_sectorFuel", [_state, "sectorFuel", []] call _getValue];
    missionNamespace setVariable ["front_sectorRadio", [_state, "sectorRadio", []] call _getValue];
    missionNamespace setVariable ["front_ownedFactories", [_state, "ownedFactories", []] call _getValue];
    missionNamespace setVariable ["front_ownedFuel", [_state, "ownedFuel", []] call _getValue];
    missionNamespace setVariable ["front_ownedAirports", [_state, "ownedAirports", []] call _getValue];
    missionNamespace setVariable ["front_builtStructures", [_state, "builtStructures", []] call _getValue];
    missionNamespace setVariable ["front_resources", [_state, "resources", 1000] call _getValue];
    missionNamespace setVariable ["front_fuel", [_state, "fuel", 250] call _getValue];
    missionNamespace setVariable ["front_manpower", [_state, "manpower", 20] call _getValue];
    missionNamespace setVariable ["front_civilians", [_state, "civilians", []] call _getValue];
    missionNamespace setVariable ["front_friendlyFobs", [_state, "friendlyFobs", []] call _getValue];
    missionNamespace setVariable ["front_friendlySectors", [_state, "friendlySectors", []] call _getValue];
    missionNamespace setVariable ["front_enemyAnger", [_state, "enemyAnger", 25] call _getValue];
    private _fundsArr = [_state, "playerFunds", []] call _getValue;
    private _incomeArr = [_state, "playerIncome", []] call _getValue;
    private _funds = createHashMap;
    private _income = createHashMap;
    { _funds set [_x select 0, _x select 1]; } forEach _fundsArr;
    { _income set [_x select 0, _x select 1]; } forEach _incomeArr;
    missionNamespace setVariable ["front_playerFunds", _funds];
    missionNamespace setVariable ["front_playerIncome", _income];
    missionNamespace setVariable ["front_persistenceLoaded", true];

    {
        publicVariable _x;
    } forEach [
        "front_sectorCities",
        "front_sectorMilitary",
        "front_sectorRoadblocks",
        "front_sectorFactories",
        "front_sectorFuel",
        "front_sectorRadio",
        "front_friendlyFaction",
        "front_friendlyInfantry",
        "front_friendlyVehicles",
        "front_friendlyAir",
        "front_friendlySide",
        "front_enemyFaction",
        "front_enemyInfantry",
        "front_enemyVehicles",
        "front_enemyAir",
        "front_enemySide",
        "front_ownedFactories",
        "front_ownedFuel",
        "front_ownedAirports",
        "front_resources",
        "front_fuel",
        "front_manpower",
        "front_builtStructures",
        "front_civilians",
        "front_friendlyFobs",
        "front_friendlySectors",
        "front_enemyAnger"
    ];

    diag_log format ["Frontlines persistence: restored save '%1'", _saveKey];
} else {
    missionNamespace setVariable ["front_persistenceLoaded", false];
    diag_log format ["Frontlines persistence: no save found for '%1'", _saveKey];
};
