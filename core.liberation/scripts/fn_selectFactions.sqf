if (!isServer) exitWith {};

private _loadFaction = {
    params ["_path"];
    private _result = call compile preprocessFileLineNumbers _path;
    if !(_result isEqualType []) exitWith {[]};
    if ((count _result) < 5) exitWith {[]};
    _result
};

private _filterExisting = {
    params ["_classes"];
    _classes select {isClass (configFile >> "CfgVehicles" >> _x)};
};

private _sanitize = {
    params ["_pool", "_fallback"];
    private _label = _pool param [0, _fallback select 0];
    private _side = _pool param [1, _fallback select 1];
    private _inf = _pool param [2, _fallback select 2];
    private _veh = _pool param [3, _fallback select 3];
    private _air = _pool param [4, _fallback select 4];
    private _statics = _pool param [5, []];

    _inf = [_inf] call _filterExisting;
    _veh = [_veh] call _filterExisting;
    _air = [_air] call _filterExisting;
    _statics = [_statics] call _filterExisting;

    if (_inf isEqualTo []) then {_inf = _fallback select 2;};
    if (_veh isEqualTo []) then {_veh = _fallback select 3;};
    if (_air isEqualTo []) then {_air = _fallback select 4;};

    [_label, _side, _inf, _veh, _air, _statics]
};

private _bluforPools = [
    "factions/blufor/nato_west.sqf",
    "factions/blufor/nato_pacific_west.sqf",
    "factions/blufor/ctrg_west.sqf",
    "factions/blufor/rhs_us_army_west.sqf",
    "factions/blufor/rhs_usmc_west.sqf",
    "factions/blufor/3cb_baf_west.sqf",
    "factions/blufor/cup_baf_west.sqf"
] apply _loadFaction;

private _enemyPools = [
    "factions/opfor/csat_east.sqf",
    "factions/opfor/csat_pacific_east.sqf",
    "factions/independent/aaf_independent.sqf",
    "factions/independent/syndikat_independent.sqf",
    "factions/opfor/rhs_vdv_east.sqf",
    "factions/opfor/rhs_msv_east.sqf",
    "factions/independent/rhs_cdf_independent.sqf",
    "factions/independent/rhs_chdkz_independent.sqf"
] apply _loadFaction;

private _friendlyIdx = "friendlyFaction" call BIS_fnc_getParamValue;
private _enemyIdx = "enemyFaction" call BIS_fnc_getParamValue;

private _friendlySelection = _bluforPools select (_friendlyIdx max 0 min ((count _bluforPools) - 1));
private _enemySelection = _enemyPools select (_enemyIdx max 0 min ((count _enemyPools) - 1));

private _defaultFriendly = [
    "NATO",
    west,
    ["B_Soldier_F", "B_soldier_AR_F", "B_soldier_LAT_F", "B_soldier_GL_F", "B_medic_F"],
    ["B_MRAP_01_hmg_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F"],
    ["B_Heli_Light_01_dynamicLoadout_F", "B_Heli_Attack_01_dynamicLoadout_F", "B_Plane_Fighter_01_F"],
    ["B_HMG_01_F", "B_static_AA_F"]
];

private _defaultEnemy = [
    "CSAT",
    east,
    ["O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_AR_F", "O_Soldier_GL_F", "O_medic_F"],
    ["O_MRAP_02_hmg_F", "O_APC_Wheeled_02_rcws_v2_F", "O_MBT_02_cannon_F"],
    ["O_Heli_Light_02_dynamicLoadout_F", "O_Heli_Attack_02_black_F", "O_Plane_Fighter_02_F"],
    ["O_HMG_01_F", "O_static_AA_F"]
];

_friendlySelection = [_friendlySelection, _defaultFriendly] call _sanitize;
_enemySelection = [_enemySelection, _defaultEnemy] call _sanitize;

{
    _x params ["_label", "_side", "_infantry", "_vehicles", "_air", "_statics"];
    if (_forEachIndex == 0) then {
        missionNamespace setVariable ["front_friendlyFaction", _label];
        missionNamespace setVariable ["front_friendlySide", _side];
        missionNamespace setVariable ["front_friendlyInfantry", _infantry];
        missionNamespace setVariable ["front_friendlyVehicles", _vehicles];
        missionNamespace setVariable ["front_friendlyAir", _air];
        missionNamespace setVariable ["front_friendlyStatics", _statics];
    } else {
        missionNamespace setVariable ["front_enemyFaction", _label];
        missionNamespace setVariable ["front_enemySide", _side];
        missionNamespace setVariable ["front_enemyInfantry", _infantry];
        missionNamespace setVariable ["front_enemyVehicles", _vehicles];
        missionNamespace setVariable ["front_enemyAir", _air];
        missionNamespace setVariable ["front_enemyStatics", _statics];
    };
} forEach [
    _friendlySelection select [0, 6],
    _enemySelection select [0, 6]
];

publicVariable "front_friendlyFaction";
publicVariable "front_friendlyInfantry";
publicVariable "front_friendlyVehicles";
publicVariable "front_friendlyAir";
publicVariable "front_friendlyStatics";
publicVariable "front_enemyFaction";
publicVariable "front_enemyInfantry";
publicVariable "front_enemyVehicles";
publicVariable "front_enemyAir";
publicVariable "front_enemyStatics";
publicVariable "front_enemySide";
publicVariable "front_friendlySide";
