if (!isServer) exitWith {};

// Ambient offensive / defensive AI scheduling
while {true} do {
    private _friendlySectors = missionNamespace getVariable ["front_friendlySectors", []];
    private _enemySectors = missionNamespace getVariable ["front_sectorCities", []] select {(_x getOrDefault ["side", east]) isEqualTo (missionNamespace getVariable ["front_enemySide", east])};
    private _anger = ["get"] call front_fnc_enemyAnger;

    // Enemy counterattacks toward recently captured objectives
    if (!(_friendlySectors isEqualTo [])) then {
        private _target = selectRandom _friendlySectors;
        [_target] spawn {
            params ["_sector"];
            private _pos = _sector select 0;
            private _enemySide = missionNamespace getVariable ["front_enemySide", east];
            private _infPool = missionNamespace getVariable ["front_enemyInfantry", []];
            private _vehPool = missionNamespace getVariable ["front_enemyVehicles", []];
            private _airPool = missionNamespace getVariable ["front_enemyAir", []];
            private _anger = ["get"] call front_fnc_enemyAnger;
            private _mult = 1 + (_anger / 40);

            private _vehChance = 0.4 + (random 0.25) + (_anger / 200);
            private _airChance = 0.25 + (random 0.2) + (_anger / 220);

            if (!(_vehPool isEqualTo []) && {random 1 < _vehChance}) then {
                private _vehType = selectRandom _vehPool;
                private _veh = createVehicle [_vehType, _pos getPos [200, random 360], [], 0, "NONE"];
                createVehicleCrew _veh;
                _veh setCombatMode "RED";
                _veh setDir random 360;
                _veh doMove _pos;
            };

            if (!(_airPool isEqualTo []) && {random 1 < _airChance}) then {
                private _airType = selectRandom _airPool;
                private _spawnPos = _pos getPos [400, random 360];
                private _air = createVehicle [_airType, _spawnPos, [], 0, "FLY"];
                createVehicleCrew _air;
                _air flyInHeight 120;
                _air doMove _pos;
            };

            private _grp = createGroup [_enemySide, true];
            private _count = 6 + floor (random 6 * _mult);
            for "_i" from 1 to _count do { _grp createUnit [selectRandom _infPool, _pos getPos [120, random 360], [], 0, "FORM"]; };
            [_grp, _pos, "attack"] call front_fnc_aiTactics;
        };
    };

    // Friendly offensive patrols
    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _friendlyInf = missionNamespace getVariable ["front_friendlyInfantry", ["B_Soldier_F", "B_soldier_AR_F", "B_soldier_LAT_F"]];
    private _friendlyOrigin = missionNamespace getVariable ["front_friendlyFobs", []];
    if (!(_friendlyOrigin isEqualTo []) && !(_enemySectors isEqualTo [])) then {
        private _origin = selectRandom _friendlyOrigin;
        private _target = selectRandom _enemySectors;
        [_origin, _target] spawn {
            params ["_start", "_dest"];
            private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
            private _infPool = missionNamespace getVariable ["front_friendlyInfantry", []];
            private _vehPool = missionNamespace getVariable ["front_friendlyVehicles", []];
            private _airPool = missionNamespace getVariable ["front_friendlyAir", []];
            private _destPos = _dest select 0;
            private _anger = ["get"] call front_fnc_enemyAnger;
            private _weight = 6 + floor (random 4) + round (_anger / 50);

            if (!(_vehPool isEqualTo []) && {random 1 > 0.45}) then {
                private _vehType = selectRandom _vehPool;
                private _veh = createVehicle [_vehType, _start, [], 0, "NONE"];
                createVehicleCrew _veh;
                _veh setDir random 360;
                _veh doMove _destPos;
            };

            if (!(_airPool isEqualTo []) && {random 1 > 0.65}) then {
                private _airType = selectRandom _airPool;
                private _air = createVehicle [_airType, _start, [], 0, "FLY"];
                createVehicleCrew _air;
                _air flyInHeight 120;
                _air doMove _destPos;
            };

            private _grp = createGroup [_friendlySide, true];
            for "_i" from 1 to _weight do { _grp createUnit [selectRandom _infPool, _start getPos [random 20, random 360], [], 0, "NONE"]; };
            [_grp] call front_fnc_flagHighCommandGroup;
            [_grp, _destPos, "attack"] call front_fnc_aiTactics;
        };
    };

    sleep (480 max (180 + random 120));
};
