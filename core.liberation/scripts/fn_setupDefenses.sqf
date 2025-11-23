params ["_pos", "_type"];

if (!isServer) exitWith {};

private _enemySide = missionNamespace getVariable ["front_enemySide", east];
private _enemyFaction = missionNamespace getVariable ["front_enemyFaction", "CSAT"];
private _infPool = missionNamespace getVariable ["front_enemyInfantry", ["O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_AR_F"]];
private _vehPool = missionNamespace getVariable ["front_enemyVehicles", ["O_MRAP_02_hmg_F", "O_APC_Wheeled_02_rcws_v2_F"]];
private _airPool = missionNamespace getVariable ["front_enemyAir", ["O_Heli_Attack_02_black_F", "O_Heli_Light_02_dynamicLoadout_F"]];
private _staticPool = missionNamespace getVariable ["front_enemyStatics", ["O_HMG_01_F", "O_static_AA_F"]];

private _garrisonSize = switch (_type) do {
    case "Factory": {6 + floor (random 3)};
    case "FuelDepot": {6 + floor (random 3)};
    case "Radio": {4 + floor (random 2)};
    case "Roadblock": {3 + floor (random 2)};
    default {8 + floor (random 4)};
};

private _garrisonGrp = createGroup [_enemySide, true];

// Infantry garrison
for "_i" from 1 to _garrisonSize do {
    private _unitType = selectRandom _infPool;
    _garrisonGrp createUnit [_unitType, _pos getPos [random 50, random 360], [], 0, "NONE"];
};
[_garrisonGrp, _pos, "defend"] call front_fnc_aiTactics;

// Static defenses ringing the position
if !(_staticPool isEqualTo []) then {
    private _static = selectRandom _staticPool;
    private _dir = random 360;
    private _defPos = _pos getPos [40 + random 30, _dir];
    private _weapon = createVehicle [_static, _defPos, [], 0, "NONE"];
    private _crewGrp = createGroup [_enemySide, true];
    private _gunner = _crewGrp createUnit [selectRandom _infPool, _defPos, [], 0, "NONE"];
    _gunner moveInGunner _weapon;
    _crewGrp addVehicle _weapon;
};

// Vehicles guarding military style objectives
if (_type in ["NameCity", "NameCityCapital", "NameVillage", "NameLocal", "Strategic", "Factory", "FuelDepot"]) then {
    private _vehType = selectRandom _vehPool;
    private _veh = createVehicle [_vehType, _pos getPos [80, random 360], [], 0, "NONE"];
    createVehicleCrew _veh;
};

// Light air cover for prime objectives
if (_type in ["Airport", "Strategic"]) then {
    private _airType = selectRandom _airPool;
    private _spawnPos = _pos getPos [300, random 360];
    private _veh = createVehicle [_airType, _spawnPos, [], 0, "FLY"]; 
    createVehicleCrew _veh;
};
