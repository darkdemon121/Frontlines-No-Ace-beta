// War crime / ROE enforcement and random atrocities for both factions

if (isServer) then {
    missionNamespace setVariable ["front_warCrimeEvents", [], true];
    missionNamespace setVariable ["front_friendlyDetainees", [], true];
    missionNamespace setVariable ["front_playerOffenders", [], true];

    private _notify = {
        params ["_msg"];
        [_msg] remoteExec ["hint", 0];
    };

    private _spawnEvent = {
        params ["_sideLabel"];
        private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
        private _enemySide = missionNamespace getVariable ["front_enemySide", east];
        private _side = if (_sideLabel isEqualTo "friendly") then {_friendlySide} else {_enemySide};
        private _infPool = missionNamespace getVariable [if (_sideLabel isEqualTo "friendly") then {"front_friendlyInfantry"} else {"front_enemyInfantry"}, []];

        private _pool = if (_sideLabel isEqualTo "friendly") then {
            missionNamespace getVariable ["front_friendlySectors", []]
        } else {
            private _sectors = missionNamespace getVariable ["front_sectorCities", []];
            _sectors select {
                private _sectorSide = if ((count _x) > 3) then {_x select 3} else {_enemySide};
                _sectorSide isEqualTo _enemySide
            };
        };

        if (_pool isEqualTo [] || {_infPool isEqualTo []}) exitWith {};

        private _sector = selectRandom _pool;
        private _pos = _sector select 0;
        private _grp = createGroup [_side, true];
        private _count = 4 + floor (random 4);
        for "_i" from 1 to _count do {
            _grp createUnit [selectRandom _infPool, _pos getPos [20 + random 25, random 360], [], 0, "NONE"];
        };

        private _marker = createMarker [format ["front_warcrime_%1_%2", _sideLabel, diag_tickTime], _pos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType (if (_sideLabel isEqualTo "friendly") then {"mil_unknown"} else {"o_installation"});
        _marker setMarkerColor (if (_sideLabel isEqualTo "friendly") then {"ColorBLUFOR"} else {"ColorOPFOR"});
        _marker setMarkerText (if (_sideLabel isEqualTo "friendly") then {"Friendly War Crime"} else {"Enemy War Crime"});

        private _data = createHashMapFromArray [
            ["pos", _pos],
            ["marker", _marker],
            ["side", _sideLabel],
            ["units", units _grp],
            ["resolved", false]
        ];

        { _x setVariable ["front_requiresTribunal", (_sideLabel isEqualTo "friendly"), true];
          _x setVariable ["front_enemyWarCrime", (_sideLabel isEqualTo "enemy"), true];
        } forEach (units _grp);

        missionNamespace setVariable ["front_warCrimeEvents", (missionNamespace getVariable ["front_warCrimeEvents", []]) + [_data], true];
        [format ["%1 atrocity reported. Marked on maps.", if (_sideLabel isEqualTo "friendly") then {"Friendly"} else {"Enemy"}]] call _notify;

        [_grp, _pos, "defend"] call front_fnc_aiTactics;
    };

    addMissionEventHandler ["EntityKilled", {
        params ["_killed", "_killer"];
        if (isNull _killer) exitWith {};
        if (!isPlayer _killer) exitWith {};
        private _isProtected = (side _killed isEqualTo civilian) || (_killed getVariable ["front_isPrisoner", false]);
        if (_isProtected) then {
            private _list = missionNamespace getVariable ["front_playerOffenders", []];
            _list pushBackUnique _killer;
            missionNamespace setVariable ["front_playerOffenders", _list, true];
            _killer setVariable ["front_playerOffender", true, true];

            private _marker = createMarker [format ["front_playerCrime_%1", getPlayerUID _killer], getPos _killer];
            _marker setMarkerShape "ICON";
            _marker setMarkerType "mil_warning";
            _marker setMarkerColor "ColorRed";
            _marker setMarkerText format ["%1 committed war crime", name _killer];
            _killer setVariable ["front_playerCrimeMarker", _marker, true];

            [format ["%1 violated ROE! Detain at a friendly prison.", name _killer]] remoteExec ["hint", 0];

            {
                if (side _x isEqualTo (missionNamespace getVariable ["front_friendlySide", west]) && {_x distance2D _killer < 150}) then {
                    _x doTarget _killer;
                    _x doFire _killer;
                };
            } forEach allUnits;
        };
    }];

    [] spawn {
        while {true} do {
            sleep (360 + random 120);
            if (random 1 > 0.65) then { ["friendly"] call _spawnEvent; };
            if (random 1 > 0.6) then { ["enemy"] call _spawnEvent; };
        };
    };

    [] spawn {
        while {true} do {
            private _events = missionNamespace getVariable ["front_warCrimeEvents", []];
            {
                private _units = _x getOrDefault ["units", []];
                private _alive = _units select {alive _x};
                private _allDetained = (_alive findIf { !(_x getVariable ["front_isDetained", false]) } == -1);
                if (_alive isEqualTo [] || {_allDetained}) then {
                    private _marker = _x getOrDefault ["marker", ""];
                    if (_marker != "" && {markerExists _marker}) then { deleteMarker _marker; };
                    _x set ["resolved", true];
                } else {
                    _x set ["units", _alive];
                };
            } forEach _events;
            missionNamespace setVariable ["front_warCrimeEvents", _events, true];
            sleep 30;
        };
    };
};

if (hasInterface) then {
    // Detain actions for flagged offenders and war criminals
    [] spawn {
        while {true} do {
            private _target = cursorTarget;
            if (!isNull _target && {_target isKindOf "Man"}) then {
                if ((_target getVariable ["front_requiresTribunal", false]) && {!(_target getVariable ["front_isDetained", false])}) then {
                    if ((_target getVariable ["front_detainAction", -1]) < 0) then {
                        private _id = _target addAction [
                            "Detain Offending Squad",
                            {
                                params ["_unit", "_caller"];
                                private _grp = group _unit;
                                {
                                    _x setCaptive true;
                                    _x disableAI "MOVE";
                                    _x setVariable ["front_isDetained", true, true];
                                    _x addAction ["Deliver to Friendly Prison", {
                                        params ["_u", "_c"];
                                        private _prisonClass = missionNamespace getVariable ["front_friendlyPrisonBuilding", "Land_Barracks_01_grey_F"];
                                        private _near = nearestObjects [_c, [_prisonClass], 35];
                                        if (!(_near isEqualTo [])) then {
                                            _u setPosATL (getPosATL (_near select 0));
                                            private _list = missionNamespace getVariable ["front_friendlyDetainees", []];
                                            _list pushBackUnique _u;
                                            missionNamespace setVariable ["front_friendlyDetainees", _list, true];
                                            _u removeAllActions;
                                            ["Detained squad delivered. Use prison menu to release after paying resources."] remoteExec ["hint", owner _c];
                                        } else {
                                        hint "Build a Friendly Prison and bring detainees there.";
                                        };
                                    }, [], 1.5, true, true, "", "true", 5];
                                } forEach (units _grp);
                            },
                            [], 1.5, true, true, "", "true", 5
                        ];
                        _target setVariable ["front_detainAction", _id];
                    };
                };

                if ((_target getVariable ["front_enemyWarCrime", false]) && {!(_target getVariable ["front_isPrisoner", false])}) then {
                    if ((_target getVariable ["front_captureCrime", -1]) < 0) then {
                        private _id = _target addAction [
                            "Capture War Criminal",
                            {
                                params ["_unit", "_caller"];
                                _unit setCaptive true;
                                [_unit] joinSilent (group _caller);
                                _unit setVariable ["front_isPrisoner", true, true];
                                _unit addAction ["Deliver to Prison", {
                                    params ["_prisoner", "_caller"];
                                    private _prisonClass = missionNamespace getVariable ["front_powPrisonBuilding", "Land_i_Barracks_V1_F"];
                                    private _near = nearestObjects [_caller, [_prisonClass], 35];
                                    if (!(_near isEqualTo [])) then {
                                        _prisoner setPosATL (getPosATL (_near select 0));
                                        _prisoner disableAI "MOVE";
                                        _prisoner setVariable ["front_isDetained", true, true];
                                        _prisoner removeAllActions;
                                    } else {
                                        hint "Need a POW Prison at a FOB to hold enemy captives.";
                                    };
                                }, [], 1.5, true, true, "", "true", 5];
                            },
                            [], 1.5, true, true, "", "true", 5
                        ];
                        _target setVariable ["front_captureCrime", _id];
                    };
                };

                if ((_target getVariable ["front_playerOffender", false]) || {(_target getVariable ["front_playerCrimeMarker", ""]) != ""}) then {
                    if ((_target getVariable ["front_detainPlayer", -1]) < 0) then {
                        private _id = _target addAction [
                            "Detain War Criminal (Player)",
                            {
                                params ["_unit", "_caller"];
                                _unit setCaptive true;
                                _unit disableUserInput true;
                                _unit setVariable ["front_isDetained", true, true];
                                _unit addAction ["Escort to Friendly Prison", {
                                    params ["_p", "_c"];
                                    private _prisonClass = missionNamespace getVariable ["front_friendlyPrisonBuilding", "Land_Barracks_01_grey_F"];
                                    private _near = nearestObjects [_c, [_prisonClass], 35];
                                    if (!(_near isEqualTo [])) then {
                                        _p setPosATL (getPosATL (_near select 0));
                                        private _list = missionNamespace getVariable ["front_playerOffenders", []];
                                        _list pushBackUnique _p;
                                        missionNamespace setVariable ["front_playerOffenders", _list, true];
                                        _p disableUserInput false;
                                        _p removeAllActions;
                                    } else {
                                        hint "Bring detained player to a Friendly Prison building.";
                                    };
                                }, [], 1.5, true, true, "", "true", 5];
                            },
                            [], 1.5, true, true, "", "side _caller == side _unit", 5
                        ];
                        _target setVariable ["front_detainPlayer", _id];
                    };
                };
            };
            sleep 2;
        };
    };

    // Friendly Prison menu for releasing detained squads or players
    [] spawn {
        private _action = -1;
        while {true} do {
            private _prisonClass = missionNamespace getVariable ["front_friendlyPrisonBuilding", "Land_Barracks_01_grey_F"];
            private _near = nearestObjects [player, [_prisonClass], 20];
            if (!(_near isEqualTo [])) then {
                if (_action < 0) then {
                    _action = player addAction [
                        "Friendly Prison Release Menu",
                        {
                            [player] remoteExec ["front_fnc_releaseDetainees", 2];
                        }, [], 1.5, true, true, "", "true", 3
                    ];
                };
            } else {
                if (_action >= 0) then {
                    player removeAction _action;
                    _action = -1;
                };
            };
            sleep 3;
        };
    };
};
