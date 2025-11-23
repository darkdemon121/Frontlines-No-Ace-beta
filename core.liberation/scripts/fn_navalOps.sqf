if (!isServer) exitWith {};

if (!(missionNamespace getVariable ["front_hasNaval", false])) exitWith {};

while {missionNamespace getVariable ["front_hasNaval", false]} do {
    private _aiMult = missionNamespace getVariable ["front_aiMultiplier", 1];
    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _enemySide = missionNamespace getVariable ["front_enemySide", east];
    private _friendlySectors = missionNamespace getVariable ["front_friendlySectors", []];
    private _navalSectors = [
        missionNamespace getVariable ["front_sectorPorts", []],
        missionNamespace getVariable ["front_sectorCarriers", []]
    ] call BIS_fnc_flatten;

    {
        _x params ["_pos", "", "_type"];
        private _isFriendly = (_friendlySectors findIf { (_x select 0) isEqualTo _pos }) > -1;
        private _navalPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyNaval"} else {"front_enemyNaval"}, []];
        private _side = if (_isFriendly) then {_friendlySide} else {_enemySide};

        if (!(_navalPool isEqualTo []) && {random 1 < (0.32 * _aiMult)}) then {
            private _boat = createVehicle [selectRandom _navalPool, _pos getPos [160 + random 120, random 360], [], 0, "NONE"];
            createVehicleCrew _boat;
            _boat setDir random 360;
            private _grp = group driver _boat;
            private _wp = _grp addWaypoint [_pos getPos [200, random 360], 0];
            _wp setWaypointType "CYCLE";
            _grp setCombatMode "RED";
        };

        if (!(_type isEqualTo "Carrier") && {!(_navalPool isEqualTo [])} && {random 1 < (0.18 * _aiMult)}) then {
            private _infPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyInfantry"} else {"front_enemyInfantry"}, []];
            private _boatType = selectRandom _navalPool;
            private _spawnPos = _pos getPos [140 + random 80, random 360];
            if (surfaceIsWater _spawnPos && { !(_infPool isEqualTo []) }) then {
                private _boat = createVehicle [_boatType, _spawnPos, [], 0, "NONE"];
                createVehicleCrew _boat;
                private _grp = createGroup [_side, true];
                private _count = 1 max round ((6 + floor (random 3)) * _aiMult);
                for "_i" from 1 to _count do {
                    private _unit = _grp createUnit [selectRandom _infPool, _spawnPos, [], 0, "NONE"];
                    _unit moveInCargo _boat;
                };
                [_boat, _grp, _pos] spawn {
                    params ["_veh", "_grp", "_dest"];
                    _veh setVariable ["front_assaultGroup", _grp];
                    _veh doMove _dest;
                    waitUntil {sleep 3; !alive _veh || {_veh distance2D _dest < 80}};
                    {unassignVehicle _x; doGetOut _x;} forEach units _grp;
                    [_grp, _dest, "attack"] call front_fnc_aiTactics;
                };
            };
        };
    } forEach _navalSectors;

    private _friendlyNavBases = _navalSectors select {
        private _pos = _x select 0;
        (_friendlySectors findIf { (_x select 0) isEqualTo _pos }) > -1
    };
    private _enemyNavBases = _navalSectors select {
        private _pos = _x select 0;
        (_friendlySectors findIf { (_x select 0) isEqualTo _pos }) == -1
    };

    if (!(_friendlyNavBases isEqualTo []) && !(_enemyNavBases isEqualTo [])) then {
        private _origin = selectRandom _friendlyNavBases;
        private _target = selectRandom _enemyNavBases;
        [_origin, _target, _friendlySide, true] spawn {
            params ["_start", "_dest", "_side", "_isFriendly"];
            private _destPos = _dest select 0;
            private _boatPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyNaval"} else {"front_enemyNaval"}, []];
            private _infPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyInfantry"} else {"front_enemyInfantry"}, []];
            private _vehPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyVehicles"} else {"front_enemyVehicles"}, []];
            private _aiMult = missionNamespace getVariable ["front_aiMultiplier", 1];
            private _amphib = _vehPool select { getNumber (configFile >> "CfgVehicles" >> _x >> "canFloat") > 0 };
            private _boatType = if (!(_boatPool isEqualTo [])) then {selectRandom _boatPool} else {if (!(_amphib isEqualTo [])) then {selectRandom _amphib} else {""}};
            if (_boatType isEqualTo "") exitWith {};
            private _spawnPos = (_start select 0) getPos [200 + random 120, random 360];
            if (!(surfaceIsWater _spawnPos) && {(_amphib isEqualTo [])}) exitWith {};

            private _boat = createVehicle [_boatType, _spawnPos, [], 0, "NONE"];
            createVehicleCrew _boat;
            private _grp = createGroup [_side, true];
            private _count = 1 max round ((8 + floor (random 4)) * _aiMult);
            for "_i" from 1 to _count do {
                private _unit = _grp createUnit [selectRandom _infPool, _spawnPos, [], 0, "NONE"];
                _unit moveInCargo _boat;
            };
            [_boat, _grp, _destPos] spawn {
                params ["_veh", "_grp", "_dest"];
                _veh doMove _dest;
                waitUntil {sleep 3; !alive _veh || {_veh distance2D _dest < 100}};
                {unassignVehicle _x; doGetOut _x;} forEach units _grp;
                [_grp, _dest, "attack"] call front_fnc_aiTactics;
            };
        };
    };

    if (!(_enemyNavBases isEqualTo []) && !(_friendlyNavBases isEqualTo [])) then {
        private _origin = selectRandom _enemyNavBases;
        private _target = selectRandom _friendlyNavBases;
        [_origin, _target, _enemySide, false] spawn {
            params ["_start", "_dest", "_side", "_isFriendly"];
            private _destPos = _target select 0;
            private _boatPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyNaval"} else {"front_enemyNaval"}, []];
            private _infPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyInfantry"} else {"front_enemyInfantry"}, []];
            private _vehPool = missionNamespace getVariable [if (_isFriendly) then {"front_friendlyVehicles"} else {"front_enemyVehicles"}, []];
            private _aiMult = missionNamespace getVariable ["front_aiMultiplier", 1];
            private _amphib = _vehPool select { getNumber (configFile >> "CfgVehicles" >> _x >> "canFloat") > 0 };
            private _boatType = if (!(_boatPool isEqualTo [])) then {selectRandom _boatPool} else {if (!(_amphib isEqualTo [])) then {selectRandom _amphib} else {""}};
            if (_boatType isEqualTo "") exitWith {};
            private _spawnPos = (_start select 0) getPos [200 + random 120, random 360];
            if (!(surfaceIsWater _spawnPos) && {(_amphib isEqualTo [])}) exitWith {};

            private _boat = createVehicle [_boatType, _spawnPos, [], 0, "NONE"];
            createVehicleCrew _boat;
            private _grp = createGroup [_side, true];
            private _count = 1 max round ((8 + floor (random 4)) * _aiMult);
            for "_i" from 1 to _count do {
                private _unit = _grp createUnit [selectRandom _infPool, _spawnPos, [], 0, "NONE"];
                _unit moveInCargo _boat;
            };
            [_boat, _grp, _destPos] spawn {
                params ["_veh", "_grp", "_dest"];
                _veh doMove _dest;
                waitUntil {sleep 3; !alive _veh || {_veh distance2D _dest < 100}};
                {unassignVehicle _x; doGetOut _x;} forEach units _grp;
                [_grp, _dest, "attack"] call front_fnc_aiTactics;
            };
        };
    };

    sleep (420 max (240 + random 120));
};
