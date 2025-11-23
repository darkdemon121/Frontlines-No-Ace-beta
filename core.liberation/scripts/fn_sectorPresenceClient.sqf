if (!hasInterface) exitWith {};

private _lastSector = [];
private _lastCounts = [];

while {true} do {
    private _sectors = [
        missionNamespace getVariable ["front_sectorCities", []],
        missionNamespace getVariable ["front_sectorMilitary", []],
        missionNamespace getVariable ["front_sectorFactories", []],
        missionNamespace getVariable ["front_sectorFuel", []],
        missionNamespace getVariable ["front_sectorRadio", []],
        missionNamespace getVariable ["front_sectorRoadblocks", []],
        missionNamespace getVariable ["front_sectorPorts", []],
        missionNamespace getVariable ["front_sectorCarriers", []]
    ] call BIS_fnc_flatten;

    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _enemySide = missionNamespace getVariable ["front_enemySide", east];

    private _nearestIdx = _sectors findIf { player distance2D (_x select 0) < 175 };
    if (_nearestIdx > -1) then {
        private _sector = _sectors select _nearestIdx;
        private _pos = _sector select 0;
        private _name = if ((count _sector) > 1) then { _sector select 1 } else {"Sector"};

        private _friendlies = allUnits select {
            side _x isEqualTo _friendlySide && alive _x && {(_x getVariable ["front_surrendered", false]) isEqualTo false} && (_x distance2D _pos) < 175
        };
        private _enemies = allUnits select {
            side _x isEqualTo _enemySide && alive _x && {(_x getVariable ["front_surrendered", false]) isEqualTo false} && (_x distance2D _pos) < 175
        };

        private _counts = [count _friendlies, count _enemies];
        if (!(_pos isEqualTo _lastSector) || {!(_counts isEqualTo _lastCounts)}) then {
            hintSilent format ["%1\nFriendlies: %2 | Enemies: %3", _name, _counts select 0, _counts select 1];
            _lastSector = _pos;
            _lastCounts = _counts;
        };
        sleep 5;
    } else {
        _lastSector = [];
        _lastCounts = [];
        sleep 10;
    };
};
