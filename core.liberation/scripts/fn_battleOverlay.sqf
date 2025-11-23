// Live battle-line overlay for map and FOB intel boards
// Server calculates hotspots; clients render local markers

if (isServer && {!(missionNamespace getVariable ["front_battleOverlayServerRunning", false])}) then {
    missionNamespace setVariable ["front_battleOverlayServerRunning", true];
    [] spawn {
        private _interval = ["battleOverlayInterval", 30] call BIS_fnc_getParamValue;
        if (_interval < 5) then { _interval = 5; };

        while {true} do {
            private _enemySide = missionNamespace getVariable ["front_enemySide", east];
            private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
            private _allSectors = [
                missionNamespace getVariable ["front_sectorCities", []],
                missionNamespace getVariable ["front_sectorMilitary", []],
                missionNamespace getVariable ["front_sectorRoadblocks", []],
                missionNamespace getVariable ["front_sectorFactories", []],
                missionNamespace getVariable ["front_sectorFuel", []],
                missionNamespace getVariable ["front_sectorRadio", []],
                missionNamespace getVariable ["front_sectorPorts", []],
                missionNamespace getVariable ["front_sectorCarriers", []]
            ] call BIS_fnc_flatten;

            // Track ownership markers for BLUFOR / OPFOR fronts
            private _friendlySectors = missionNamespace getVariable ["front_friendlySectors", []];
            private _friendlyFronts = (missionNamespace getVariable ["front_friendlyFobs", []]) + (_friendlySectors apply { _x select 0 });
            private _enemyFronts = _allSectors select { !(_x in _friendlySectors) } apply { _x select 0 };

            private _pairs = [];
            private _buffer = [];
            {
                private _anchor = _x;
                if (!(_enemyFronts isEqualTo [])) then {
                    private _nearest = selectRandom _enemyFronts;
                    private _nearestDist = 999999;
                    {
                        private _d = _x distance2D _anchor;
                        if (_d < _nearestDist) then { _nearestDist = _d; _nearest = _x; };
                    } forEach _enemyFronts;
                    private _mid = [((_anchor select 0) + (_nearest select 0)) / 2, ((_anchor select 1) + (_nearest select 1)) / 2, 0];
                    _pairs pushBack [_anchor, _nearest, _mid];
                    _buffer pushBack _mid;
                };
            } forEach _friendlyFronts;

            missionNamespace setVariable ["front_noMansLand", _buffer, true];
            missionNamespace setVariable ["front_frontPairs", _pairs, true];

            private _zones = [];
            {
                private _pos = _x select 0;
                private _label = _x select 1;
                private _radius = 350;
                private _nearEnemies = allUnits select { alive _x && {side _x == _enemySide} && {_x distance2D _pos < _radius} };
                private _nearFriendlies = allUnits select { alive _x && {side _x == _friendlySide} && {_x distance2D _pos < _radius} };

                private _status = "quiet";
                if ((count _nearEnemies) > 0 && ((count _nearFriendlies) > 0 || {count _nearEnemies > 5})) then {
                    _status = "heavy";
                } else {
                    if ((count _nearEnemies) > 0) then { _status = "contact"; };
                };

                _zones pushBack createHashMapFromArray [
                    ["pos", _pos],
                    ["label", _label],
                    ["status", _status],
                    ["friendly", count _nearFriendlies],
                    ["enemy", count _nearEnemies]
                ];
            } forEach _allSectors;

            missionNamespace setVariable ["front_battleOverlayData", createHashMapFromArray [
                ["zones", _zones],
                ["friendlyFronts", _friendlyFronts],
                ["enemyFronts", _enemyFronts],
                ["buffer", _buffer],
                ["pairs", _pairs]
            ]];
            publicVariable "front_battleOverlayData";

            sleep _interval;
        };
    };
};

if (hasInterface && {!(missionNamespace getVariable ["front_battleOverlayClientRunning", false])}) then {
    missionNamespace setVariable ["front_battleOverlayClientRunning", true];
    [] spawn {
        private _zoneMarkers = [];
        private _friendlyMarkers = [];
        private _enemyMarkers = [];
        private _bufferMarkers = [];
        private _lineMarkers = [];
        while {true} do {
            private _data = missionNamespace getVariable ["front_battleOverlayData", createHashMap];
            private _zones = _data getOrDefault ["zones", []];
            private _friendlyFronts = _data getOrDefault ["friendlyFronts", []];
            private _enemyFronts = _data getOrDefault ["enemyFronts", []];
            private _buffer = _data getOrDefault ["buffer", []];
            private _pairs = _data getOrDefault ["pairs", []];

            { deleteMarkerLocal _x; } forEach _zoneMarkers; _zoneMarkers = [];
            {
                private _pos = _x get "pos";
                private _status = _x get "status";
                private _markerName = format ["front_zone_%1", _forEachIndex];
                deleteMarkerLocal _markerName;
                _markerName = createMarkerLocal [_markerName, _pos];
                _markerName setMarkerShape "ELLIPSE";
                _markerName setMarkerSize [250, 250];
                _markerName setMarkerAlpha 0.6;
                _markerName setMarkerColor (switch (_status) do {
                    case "heavy": {"ColorRed"};
                    case "contact": {"ColorYellow"};
                    default {"ColorGreen"};
                });
                _markerName setMarkerText format ["%1", _x getOrDefault ["label", ""]];
                _zoneMarkers pushBack _markerName;
            } forEach _zones;

            { deleteMarkerLocal _x; } forEach _friendlyMarkers; _friendlyMarkers = [];
            {
                private _m = format ["front_friendlyFront_%1", _forEachIndex];
                deleteMarkerLocal _m;
                _m = createMarkerLocal [_m, _x];
                _m setMarkerShape "ICON";
                _m setMarkerType "b_inf";
                _m setMarkerColor "ColorBLUFOR";
                _m setMarkerText "BLUFOR";
                _friendlyMarkers pushBack _m;
            } forEach _friendlyFronts;

            { deleteMarkerLocal _x; } forEach _enemyMarkers; _enemyMarkers = [];
            {
                private _m = format ["front_enemyFront_%1", _forEachIndex];
                deleteMarkerLocal _m;
                _m = createMarkerLocal [_m, _x];
                _m setMarkerShape "ICON";
                _m setMarkerType "o_inf";
                _m setMarkerColor "ColorOPFOR";
                _m setMarkerText "OPFOR";
                _enemyMarkers pushBack _m;
            } forEach _enemyFronts;

            { deleteMarkerLocal _x; } forEach _bufferMarkers; _bufferMarkers = [];
            {
                private _m = format ["front_buffer_%1", _forEachIndex];
                deleteMarkerLocal _m;
                _m = createMarkerLocal [_m, _x];
                _m setMarkerShape "ELLIPSE";
                _m setMarkerSize [200, 200];
                _m setMarkerAlpha 0.25;
                _m setMarkerColor "ColorUNKNOWN";
                _bufferMarkers pushBack _m;
            } forEach _buffer;

            { deleteMarkerLocal _x; } forEach _lineMarkers; _lineMarkers = [];
            {
                _x params ["_friendly", "_enemy", "_mid"];
                private _dirF = _friendly getDir _mid;
                private _dirE = _enemy getDir _mid;
                private _lenF = (_friendly distance2D _mid) max 1;
                private _lenE = (_enemy distance2D _mid) max 1;

                private _mf = format ["front_line_friend_%1", _forEachIndex];
                deleteMarkerLocal _mf;
                _mf = createMarkerLocal [_mf, _friendly getPos [_lenF/2, _dirF]];
                _mf setMarkerShape "RECTANGLE";
                _mf setMarkerSize [_lenF/2, 40];
                _mf setMarkerDir _dirF;
                _mf setMarkerColor "ColorBLUFOR";
                _mf setMarkerAlpha 0.35;
                _lineMarkers pushBack _mf;

                private _me = format ["front_line_enemy_%1", _forEachIndex];
                deleteMarkerLocal _me;
                _me = createMarkerLocal [_me, _enemy getPos [_lenE/2, _dirE]];
                _me setMarkerShape "RECTANGLE";
                _me setMarkerSize [_lenE/2, 40];
                _me setMarkerDir _dirE;
                _me setMarkerColor "ColorOPFOR";
                _me setMarkerAlpha 0.35;
                _lineMarkers pushBack _me;
            } forEach _pairs;

            sleep 5;
        };
    };
};
