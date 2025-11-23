if (!isServer) exitWith {};

private _defaultGuns = [
    [west, ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F", "B_Mortar_01_F"]],
    [east, ["O_MBT_02_arty_F", "O_MBT_02_arty_F", "O_Mortar_01_F"]],
    [resistance, ["I_Truck_02_MRL_F", "I_Mortar_01_F"]]
];

missionNamespace setVariable ["front_artilleryDefaults", _defaultGuns];

private _announceIncoming = {
    params ["_kind", "_targetPos", ["_marker", ""]];
    private _text = switch (_kind) do {
        case "fobUnderMortar": { "Incoming mortars on a FOB!" };
        case "sectorUnderArtillery": { "Artillery strike inbound!" };
        case "industryUnderFire": { "Industry site under bombardment!" };
        case "fobBomber": { "Bomber inbound on a FOB!" };
        default { "Incoming fire detected!" };
    };
    private _grid = mapGridPosition _targetPos;
    [format ["%1 Grid %2", _text, _grid]] remoteExec ["hint", 0];

    if !(_marker isEqualTo "") then {
        private _name = format ["%1_%2", _marker, diag_tickTime];
        private _m = createMarker [_name, _targetPos];
        _m setMarkerShape "ELLIPSE";
        _m setMarkerSize [125, 125];
        _m setMarkerColor "ColorRed";
        _m setMarkerAlpha 0.65;
        [_name] spawn {
            params ["_marker"];
            sleep 30;
            deleteMarker _marker;
        };
    };
};

private _resolveGun = {
    params ["_side", ["_staticOnly", false]];
    private _map = missionNamespace getVariable ["front_artilleryDefaults", _defaultGuns];
    private _entry = _map select { (_x select 0) isEqualTo _side };
    if (_entry isEqualTo []) then { _entry = _map select { (_x select 0) isEqualTo resistance }; };
    if (_entry isEqualTo []) exitWith {""};
    private _candidates = _entry select 0 select 1;
    if (_staticOnly) then {
        _candidates = _candidates select { _x isKindOf "StaticWeapon" || {_x find "Mortar" > -1} };
        if (_candidates isEqualTo []) then { _candidates = _entry select 0 select 1; };
    };
    private _filtered = _candidates select { isClass (configFile >> "CfgVehicles" >> _x) };
    if (_filtered isEqualTo []) exitWith {""};
    selectRandom _filtered
};

private _collectSectors = {
    [
        missionNamespace getVariable ["front_sectorCities", []],
        missionNamespace getVariable ["front_sectorMilitary", []],
        missionNamespace getVariable ["front_sectorFactories", []],
        missionNamespace getVariable ["front_sectorFuel", []],
        missionNamespace getVariable ["front_sectorRadio", []],
        missionNamespace getVariable ["front_sectorRoadblocks", []],
        missionNamespace getVariable ["front_sectorPorts", []],
        missionNamespace getVariable ["front_sectorCarriers", []]
    ] call BIS_fnc_flatten
};

private _disableIndustry = {
    params ["_pool", "_pos"];
    private _idx = _pool findIf { (_x select 0) isEqualTo _pos };
    if (_idx > -1) then {
        private _entry = +(_pool select _idx);
        if ((count _entry) < 4) then { _entry set [3, false]; } else { _entry set [3, false]; };
        _pool set [_idx, _entry];
    };
    _pool
};

private _spawnBattery = {
    params ["_side", "_targetSide", "_targetPos", ["_static", false], ["_shots", 6], ["_announce", ""]];
    private _class = [_side, _static] call _resolveGun;
    if (_class isEqualTo "") exitWith {};

    private _range = if (_static) then {750} else {1600};
    private _spawnPos = [_targetPos, _range, _range * 1.5, 0, 0, 0.4, 0] call BIS_fnc_findSafePos;
    if (_spawnPos isEqualTo [0,0,0]) exitWith {};

    private _gun = createVehicle [_class, _spawnPos, [], 0, "NONE"];
    createVehicleCrew _gun;
    _gun setDir random 360;
    _gun setCombatMode "RED";

    private _ammo = getArtilleryAmmo _gun;
    if (_ammo isEqualTo []) exitWith { deleteVehicle _gun; };
    private _chosen = _ammo select 0;
    if (!(_gun inRangeOfArtillery [_targetPos, _chosen])) exitWith { deleteVehicle _gun; };

    if (!(_announce isEqualTo "")) then {
        [_announce, _targetPos, "front_incomingMarker"] call _announceIncoming;
    };

    [_gun, _chosen, _targetPos, _shots] spawn {
        params ["_gun", "_ammo", "_pos", "_shots"];
        private _rounds = 0;
        while {alive _gun && {_rounds < _shots}} do {
            _gun doArtilleryFire [_pos, _ammo, 1 + floor (random 2)];
            _rounds = _rounds + 1;
            sleep (8 + random 6);
        };
        sleep 180;
        deleteVehicleCrew _gun;
        deleteVehicle _gun;
    };
};

while {true} do {
    private _aiMult = missionNamespace getVariable ["front_aiMultiplier", 1];
    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _enemySide = missionNamespace getVariable ["front_enemySide", east];
    private _friendlySectors = missionNamespace getVariable ["front_friendlySectors", []];
    private _friendlyPositions = _friendlySectors apply { _x select 0 };
    private _sectors = [] call _collectSectors;
    private _enemySectors = _sectors select { (_friendlyPositions find (_x select 0)) == -1 };

    // General counter-battery vs sectors
    if (!(_friendlySectors isEqualTo []) && !(_enemySectors isEqualTo [])) then {
        private _strike = selectRandom _friendlySectors;
        private _shots = 4 + round (random 2) + round (_aiMult);
        [_enemySide, _friendlySide, _strike select 0, false, _shots, "sectorUnderArtillery"] call _spawnBattery;
    };

    if (!(_enemySectors isEqualTo []) && !(_friendlySectors isEqualTo [])) then {
        private _strike = selectRandom _enemySectors;
        private _shots = 4 + round (random 2) + round (_aiMult);
        [_friendlySide, _enemySide, _strike select 0, false, _shots, "sectorUnderArtillery"] call _spawnBattery;
    };

    // Industry harassment: disable factories/fuel until repaired
    {
        private _pool = missionNamespace getVariable [_x, []];
        if (!(_pool isEqualTo []) && {random 1 > 0.45}) then {
            private _entry = selectRandom _pool;
            private _pos = _entry select 0;
            [_enemySide, _friendlySide, _pos, true, 3 + round (_aiMult), "industryUnderFire"] call _spawnBattery;
            private _updated = [_pool, _pos] call _disableIndustry;
            missionNamespace setVariable [_x, _updated, true];
        };
    } forEach ["front_ownedFactories", "front_ownedFuel"];

    // Retaliation for recently lost sectors
    private _friendlyLost = missionNamespace getVariable ["front_friendlyLost", []];
    if (!(_friendlyLost isEqualTo [])) then {
        private _recent = _friendlyLost deleteAt 0;
        missionNamespace setVariable ["front_friendlyLost", _friendlyLost];
        [_enemySide, _friendlySide, _recent, false, 6 + round (_aiMult), "sectorUnderArtillery"] call _spawnBattery;
    };

    private _enemyLost = missionNamespace getVariable ["front_enemyLost", []];
    if (!(_enemyLost isEqualTo [])) then {
        private _recent = _enemyLost deleteAt 0;
        missionNamespace setVariable ["front_enemyLost", _enemyLost];
        [_friendlySide, _enemySide, _recent, false, 6 + round (_aiMult), "sectorUnderArtillery"] call _spawnBattery;
    };

    // Mortar harassment near FOBs
    private _fobs = missionNamespace getVariable ["front_friendlyFobs", []];
    if (!(_fobs isEqualTo []) && {random 1 > 0.5}) then {
        private _fob = selectRandom _fobs;
        private _mortarPos = [_fob, 400 + random 200, 600, 0, 0, 0.5, 0] call BIS_fnc_findSafePos;
        if !(_mortarPos isEqualTo [0,0,0]) then {
            private _shots = 3 + floor (random 3);
            [_enemySide, _friendlySide, _fob, true, _shots, "fobUnderMortar"] call _spawnBattery;
        };
    };

    // Bomber runs against FOBs
    private _enemyAir = missionNamespace getVariable ["front_enemyAir", []];
    if (!(_fobs isEqualTo []) && {!(_enemyAir isEqualTo [])} && {random 1 > 0.7}) then {
        private _fob = selectRandom _fobs;
        private _airType = selectRandom _enemyAir;
        private _spawnPos = _fob getPos [800 + random 400, random 360];
        private _air = createVehicle [_airType, _spawnPos, [], 0, "FLY"];
        createVehicleCrew _air;
        _air flyInHeight 250;
        [_air] spawn {
            params ["_plane"];
            sleep 15;
            if (alive _plane) then { _plane setDamage 1; };
        };

        [_air, _fob] spawn {
            params ["_plane", "_pos"];
            private _passes = 0;
            while {alive _plane && {_passes < 2}} do {
                _plane doMove _pos;
                sleep 6;
                "Bo_Mk82" createVehicle (_pos vectorAdd [0,0,150]);
                "Bo_Mk82" createVehicle (_pos getPos [30, random 360] vectorAdd [0,0,150]);
                _passes = _passes + 1;
                sleep 10;
            };
        };

        ["fobBomber", _fob, "front_incomingBomber"] call _announceIncoming;
    };

    sleep (240 + random 120);
};
