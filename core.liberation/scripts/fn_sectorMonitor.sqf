if (!isServer) exitWith {};

while {true} do {
    private _sectors = [
        missionNamespace getVariable ["front_sectorCities", []],
        missionNamespace getVariable ["front_sectorMilitary", []],
        missionNamespace getVariable ["front_sectorFactories", []],
        missionNamespace getVariable ["front_sectorFuel", []],
        missionNamespace getVariable ["front_sectorRadio", []],
        missionNamespace getVariable ["front_sectorRoadblocks", []]
    ] call BIS_fnc_flatten;

    private _friendly = missionNamespace getVariable ["front_friendlySectors", []];
    private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
    private _enemySide = missionNamespace getVariable ["front_enemySide", east];

    {
        private _pos = _x select 0;
        private _name = if ((count _x) > 1) then {_x select 1} else {format ["Sector %1", _forEachIndex]};
        private _type = if ((count _x) > 2) then {_x select 2} else {"Roadblock"};
        private _marker = format ["front_sector_%1", _forEachIndex];

        private _friendlyPresence = allUnits select {side _x isEqualTo _friendlySide && alive _x && (_x distance2D _pos) < 175};
        private _enemyPresence = allUnits select {side _x isEqualTo _enemySide && alive _x && (_x distance2D _pos) < 175};

        private _isFriendly = _friendly findIf { (_x select 0) isEqualTo _pos } > -1;

        if (_isFriendly && {!(_enemyPresence isEqualTo []) && {_friendlyPresence isEqualTo []}}) then {
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

            private _ownedAir = missionNamespace getVariable ["front_ownedAirports", []];
            private _airIdx = _ownedAir findIf { (_x select 0) isEqualTo _pos };
            if (_airIdx > -1) then {
                _ownedAir deleteAt _airIdx;
                missionNamespace setVariable ["front_ownedAirports", _ownedAir];
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
                        missionNamespace setVariable ["front_ownedFactories", _owned + [[_pos, _name, 10]]];
                    };
                };
                case "FuelDepot": {
                    private _ownedFuel = missionNamespace getVariable ["front_ownedFuel", []];
                    if ((_ownedFuel findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedFuel", _ownedFuel + [[_pos, _name, 8]]];
                    };
                };
                case "Airport": {
                    private _airports = missionNamespace getVariable ["front_ownedAirports", []];
                    if ((_airports findIf { (_x select 0) isEqualTo _pos }) < 0) then {
                        missionNamespace setVariable ["front_ownedAirports", _airports + [[_pos, _name]]];
                    };
                };
            };
        };
    } forEach _sectors;

    publicVariable "front_friendlySectors";
    sleep 120;
};
