if (!isServer) exitWith {};

private _defaults = [
    [west, "B_UAV_01_F", "B_UAV_06_F"],
    [east, "O_UAV_01_F", "O_UAV_06_F"],
    [resistance, "I_UAV_01_F", "I_UAV_06_F"]
];

private _resolveClass = {
    params ["_side", "_isBomblet"];
    private _map = missionNamespace getVariable ["front_droneDefaults", _defaults];
    private _entry = _map select { (_x select 0) isEqualTo _side };
    if (_entry isEqualTo []) then { _entry = _map select { (_x select 0) isEqualTo resistance }; };
    if (_entry isEqualTo []) exitWith {""};
    private _idx = if (_isBomblet) then {2} else {1};
    _entry select 0 select _idx
};

missionNamespace setVariable ["front_droneDefaults", _defaults];

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

private _spawnDrone = {
    params ["_side", "_targetSide", "_spawnPos", "_targetPos", "_isBomblet", "_poolKey"];

    private _existing = (missionNamespace getVariable [_poolKey, []]) select { alive _x };
    if ((count _existing) >= 6) exitWith { missionNamespace setVariable [_poolKey, _existing]; };

    private _class = [_side, _isBomblet] call _resolveClass;
    if (_class isEqualTo "") exitWith {};
    if (!(isClass (configFile >> "CfgVehicles" >> _class))) exitWith {};

    private _drone = createVehicle [_class, _spawnPos, [], 0, "FLY"];
    createVehicleCrew _drone;
    _drone setBehaviourStrong "COMBAT";
    _drone flyInHeight 80;
    _drone doMove _targetPos;

    _existing pushBack _drone;
    missionNamespace setVariable [_poolKey, _existing];

    [_drone, _targetSide, _targetPos, _isBomblet] spawn {
        params ["_drone", "_targetSide", "_targetPos", "_isBomblet"];
        private _lastDrop = time;
        while {alive _drone} do {
            private _enemy = _drone findNearestEnemy _drone;
            if (!isNull _enemy && {alive _enemy} && {side _enemy isEqualTo _targetSide}) then {
                private _dist = _drone distance _enemy;
                if (_isBomblet) then {
                    if ((_dist < 60) && {time - _lastDrop > 6}) then {
                        "G_40mm_HE" createVehicle (getPosATL _drone);
                        _lastDrop = time;
                    };
                    _drone doMove (getPos _enemy);
                } else {
                    if (_dist < 25) exitWith {
                        "Bo_GBU12_LGB" createVehicle (getPosATL _drone);
                        deleteVehicle _drone;
                    };
                    _drone doMove (getPos _enemy);
                };
            } else {
                if ((_drone distance2D _targetPos) < 120) then {
                    _targetPos = [_targetPos, 250 + random 150, random 360] call BIS_fnc_relPos;
                    _drone doMove _targetPos;
                };
            };
            sleep 2 + random 1;
        };
    };
};

while {true} do {
    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _enemySide = missionNamespace getVariable ["front_enemySide", east];

    private _sectors = [] call _collectSectors;
    private _friendlySectors = missionNamespace getVariable ["front_friendlySectors", []];
    private _friendlyPositions = _friendlySectors apply { _x select 0 };
    private _enemySectors = _sectors select { (_friendlyPositions find (_x select 0)) < 0 };

    if (!(_friendlySectors isEqualTo []) && !(_enemySectors isEqualTo [])) then {
        private _anchor = selectRandom _friendlySectors;
        private _target = selectRandom _enemySectors;
        private _spawnPos = [(_anchor select 0), 200 + random 150, random 360] call BIS_fnc_relPos;
        private _targetPos = _target select 0;
        [_friendlySide, _enemySide, _spawnPos, _targetPos, false, "front_friendlyDrones"] call _spawnDrone;
        [_friendlySide, _enemySide, _spawnPos, _targetPos, true, "front_friendlyDrones"] call _spawnDrone;
    };

    if (!(_enemySectors isEqualTo []) && !(_friendlySectors isEqualTo [])) then {
        private _anchor = selectRandom _enemySectors;
        private _target = selectRandom _friendlySectors;
        private _spawnPos = [(_anchor select 0), 200 + random 150, random 360] call BIS_fnc_relPos;
        private _targetPos = _target select 0;
        [_enemySide, _friendlySide, _spawnPos, _targetPos, false, "front_enemyDrones"] call _spawnDrone;
        [_enemySide, _friendlySide, _spawnPos, _targetPos, true, "front_enemyDrones"] call _spawnDrone;
    };

    sleep (210 + random 90);
};
