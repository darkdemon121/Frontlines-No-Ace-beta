params ["_pos", "_type"];

if (!isServer) exitWith {};

private _enemySide = missionNamespace getVariable ["front_enemySide", east];
private _enemyFaction = missionNamespace getVariable ["front_enemyFaction", "CSAT"];
private _infPool = missionNamespace getVariable ["front_enemyInfantry", ["O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_AR_F"]];
private _vehPool = missionNamespace getVariable ["front_enemyVehicles", ["O_MRAP_02_hmg_F", "O_APC_Wheeled_02_rcws_v2_F"]];
private _airPool = missionNamespace getVariable ["front_enemyAir", ["O_Heli_Attack_02_black_F", "O_Heli_Light_02_dynamicLoadout_F"]];
private _staticPool = missionNamespace getVariable ["front_enemyStatics", ["O_HMG_01_F", "O_static_AA_F"]];
private _navalPool = missionNamespace getVariable ["front_enemyNaval", ["O_Boat_Armed_01_hmg_F", "O_Boat_Transport_01_F"]];
private _aiMult = missionNamespace getVariable ["front_aiMultiplier", 1];

private _baseGarrison = switch (_type) do {
    case "Factory": {6 + floor (random 3)};
    case "FuelDepot": {6 + floor (random 3)};
    case "Radio": {4 + floor (random 2)};
    case "Roadblock": {3 + floor (random 2)};
    default {8 + floor (random 4)};
};
private _garrisonSize = 1 max round (_baseGarrison * _aiMult);

private _garrisonGrp = createGroup [_enemySide, true];

// Infantry garrison
for "_i" from 1 to _garrisonSize do {
    private _unitType = selectRandom _infPool;
    _garrisonGrp createUnit [_unitType, _pos getPos [random 50, random 360], [], 0, "NONE"];
};
[_garrisonGrp, _pos, "defend"] call front_fnc_aiTactics;

// Static defenses ringing the position
if !(_staticPool isEqualTo []) then {
    private _staticCount = 1 max round (_aiMult);
    for "_s" from 1 to _staticCount do {
        private _static = selectRandom _staticPool;
        private _dir = random 360;
        private _defPos = _pos getPos [40 + random 30, _dir];
        private _weapon = createVehicle [_static, _defPos, [], 0, "NONE"];
        private _crewGrp = createGroup [_enemySide, true];
        private _gunner = _crewGrp createUnit [selectRandom _infPool, _defPos, [], 0, "NONE"];
        _gunner moveInGunner _weapon;
        _crewGrp addVehicle _weapon;
    };
};

// Vehicles guarding military style objectives
if (_type in ["NameCity", "NameCityCapital", "NameVillage", "NameLocal", "Strategic", "Factory", "FuelDepot"]) then {
    private _vehCount = 1 max round (_aiMult);
    for "_v" from 1 to _vehCount do {
        private _vehType = selectRandom _vehPool;
        private _veh = createVehicle [_vehType, _pos getPos [80 + random 40, random 360], [], 0, "NONE"];
        createVehicleCrew _veh;
    };
};

// Light air cover for prime objectives
if (_type in ["Airport", "Strategic"]) then {
    private _airCount = 1 max round (_aiMult - 0.5);
    for "_a" from 1 to _airCount do {
        private _airType = selectRandom _airPool;
        private _spawnPos = _pos getPos [300 + random 150, random 360];
        private _veh = createVehicle [_airType, _spawnPos, [], 0, "FLY"];
        createVehicleCrew _veh;
    };
};

// Naval defenses for coastline objectives
if (_type in ["Port", "Carrier"]) then {
    private _boatCount = 1 max round (_aiMult);
    for "_b" from 1 to _boatCount do {
        private _boatType = selectRandom _navalPool;
        private _spawnPos = _pos getPos [150 + random 100, random 360];
        if (surfaceIsWater _spawnPos) then {
            private _boat = createVehicle [_boatType, _spawnPos, [], 0, "NONE"];
            createVehicleCrew _boat;
            _boat setDir random 360;
            [_boat] spawn {
                params ["_veh"];
                private _wpGrp = group driver _veh;
                private _wp = _wpGrp addWaypoint [getPos _veh, 0];
                _wp setWaypointType "PATROL";
            };
        };
    };

    if (_type isEqualTo "Carrier") then {
        // static hull acting as open-water base
        private _carrier = createVehicle ["Land_Carrier_01_base_F", _pos, [], 0, "NONE"];
        _carrier setDir random 360;

        private _carrierAir = 1 max round (_aiMult - 0.25);
        for "_ca" from 1 to _carrierAir do {
            private _airType = selectRandom _airPool;
            private _spawnPos = _pos getPos [35 + random 20, random 360];
            private _air = createVehicle [_airType, _spawnPos, [], 0, "NONE"];
            createVehicleCrew _air;
        };
    };
};
