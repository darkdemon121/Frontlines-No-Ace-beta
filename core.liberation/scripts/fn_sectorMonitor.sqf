if (!isServer) exitWith {};

private _captureTimers = missionNamespace getVariable ["front_enemyCaptureTimers", []];

while {true} do {
    private _captureDuration = missionNamespace getVariable ["front_enemyCaptureDuration", 600];
    _captureTimers = missionNamespace getVariable ["front_enemyCaptureTimers", _captureTimers];
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

    private _friendly = missionNamespace getVariable ["front_friendlySectors", []];
    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _enemySide = missionNamespace getVariable ["front_enemySide", east];

    {
        private _pos = _x select 0;
        private _name = if ((count _x) > 1) then {_x select 1} else {format ["Sector %1", _forEachIndex]};
        private _type = if ((count _x) > 2) then {_x select 2} else {"Roadblock"};
        private _marker = format ["front_sector_%1", _forEachIndex];

        private _friendlyPresence = allUnits select {
            side _x isEqualTo _friendlySide && alive _x && {(_x getVariable ["front_surrendered", false]) isEqualTo false} && (_x distance2D _pos) < 175
        };
        private _enemyPresence = allUnits select {
            side _x isEqualTo _enemySide && alive _x && {(_x getVariable ["front_surrendered", false]) isEqualTo false} && (_x distance2D _pos) < 175
        };

        private _isFriendly = _friendly findIf { (_x select 0) isEqualTo _pos } > -1;

        if (_isFriendly) then {
            private _timerIdx = _captureTimers findIf { (_x select 0) isEqualTo _pos };
            if (!(_enemyPresence isEqualTo []) && {_friendlyPresence isEqualTo []}) then {
                private _start = if (_timerIdx > -1) then { (_captureTimers select _timerIdx) select 1 } else { diag_tickTime };
                if (_timerIdx < 0) then { _captureTimers pushBack [_pos, _start]; };
                if ((diag_tickTime - _start) > _captureDuration) then {
                    if (_timerIdx > -1) then { _captureTimers deleteAt _timerIdx; };
                    // lost
                    private _idx = _friendly findIf { (_x select 0) isEqualTo _pos };
                    if (_idx > -1) then { _friendly deleteAt _idx; };
                    missionNamespace setVariable ["front_friendlySectors", _friendly];
                    if (markerExists _marker) then { _marker setMarkerColor "ColorRed"; };
                    ["sectorLost", [_name]] remoteExec ["BIS_fnc_showNotification", 0];

                    private _ownedFactories = missionNamespace getVariable ["front_ownedFactories", []];
                    private _factoryIdx = _ownedFactories findIf { (_x select 0) isEqualTo _pos };
                    if (_factoryIdx > -1) then {
                        _ownedFactories deleteAt _factoryIdx;
                        missionNamespace setVariable ["front_ownedFactories", _ownedFactories];
                    };

                    private _ownedFuel = missionNamespace getVariable ["front_ownedFuel", []];
                    private _fuelIdx = _ownedFuel findIf { (_x select 0) isEqualTo _pos };
                    if (_fuelIdx > -1) then {
                        _ownedFuel deleteAt _fuelIdx;
                        missionNamespace setVariable ["front_ownedFuel", _ownedFuel];
                    };

                    private _friendlyLost = missionNamespace getVariable ["front_friendlyLost", []];
                    _friendlyLost pushBack _pos;
                    missionNamespace setVariable ["front_friendlyLost", _friendlyLost];

                    private _ownedPorts = missionNamespace getVariable ["front_ownedPorts", []];
                    private _portIdx = _ownedPorts findIf { (_x select 0) isEqualTo _pos };
                    if (_portIdx > -1) then {
                        _ownedPorts deleteAt _portIdx;
                        missionNamespace setVariable ["front_ownedPorts", _ownedPorts];
                    };

                    private _ownedAir = missionNamespace getVariable ["front_ownedAirports", []];
                    private _airIdx = _ownedAir findIf { (_x select 0) isEqualTo _pos };
                    if (_airIdx > -1) then {
                        _ownedAir deleteAt _airIdx;
                        missionNamespace setVariable ["front_ownedAirports", _ownedAir];
                    };
                };
            } else {
                if (_timerIdx > -1) then { _captureTimers deleteAt _timerIdx; };
            };
        };

        if (!_isFriendly && {_enemyPresence isEqualTo []} && {!(_friendlyPresence isEqualTo [])}) then {
            _friendly pushBack _x;
            missionNamespace setVariable ["front_friendlySectors", _friendly];
            if (markerExists _marker) then { _marker setMarkerColor "ColorBLUFOR"; };
            ["sectorCaptured", [_name]] remoteExec ["BIS_fnc_showNotification", 0];
            ["sectorBonus", []] call front_fnc_privateEconomy;

            switch (_type) do {
                case "Factory": {
                    private _owned = missionNamespace getVariable ["front_ownedFactories", []];
                    if ((_owned findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedFactories", _owned + [[_pos, _name, 10, true]]];
                    };
                };
                case "FuelDepot": {
                    private _ownedFuel = missionNamespace getVariable ["front_ownedFuel", []];
                    if ((_ownedFuel findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedFuel", _ownedFuel + [[_pos, _name, 8, true]]];
                    };
                };
                case "Airport": {
                    private _airports = missionNamespace getVariable ["front_ownedAirports", []];
                    if ((_airports findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedAirports", _airports + [[_pos, _name]]];
                    };
                };
                case "Carrier": {
                    private _airports = missionNamespace getVariable ["front_ownedAirports", []];
                    if ((_airports findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedAirports", _airports + [[_pos, _name]]];
                    };
                };
                case "Port": {
                    private _ports = missionNamespace getVariable ["front_ownedPorts", []];
                    if (isNil {missionNamespace getVariable "front_ownedPorts"}) then { missionNamespace setVariable ["front_ownedPorts", []]; _ports = []; };
                    if ((_ports findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedPorts", _ports + [[_pos, _name]]];
                    };
                };
            };

            private _enemyLost = missionNamespace getVariable ["front_enemyLost", []];
            _enemyLost pushBack _pos;
            missionNamespace setVariable ["front_enemyLost", _enemyLost];
        };
    } forEach _sectors;

    publicVariable "front_friendlySectors";
    missionNamespace setVariable ["front_enemyCaptureTimers", _captureTimers];

    private _allCount = count _sectors;
    private _friendlyCount = count (missionNamespace getVariable ["front_friendlySectors", []]);
    private _fobsAlive = missionNamespace getVariable ["front_friendlyFobs", []];
    private _missionEnded = missionNamespace getVariable ["front_endTriggered", false];

    if (!(_missionEnded) && {_allCount > 0} && {_friendlyCount >= _allCount}) then {
        missionNamespace setVariable ["front_endTriggered", true, true];
        ["END1", true] remoteExec ["BIS_fnc_endMission", 0];
    };

    if (!(_missionEnded) && {_allCount > 0} && {_fobsAlive isEqualTo []}) then {
        missionNamespace setVariable ["front_endTriggered", true, true];
        ["LOSER", true] remoteExec ["BIS_fnc_endMission", 0];
    };

    sleep 30;
};
