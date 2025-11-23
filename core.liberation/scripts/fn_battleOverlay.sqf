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
                missionNamespace getVariable ["front_sectorRadio", []]
            ] call BIS_fnc_flatten;

            // Track ownership markers for BLUFOR / OPFOR fronts
            private _friendlySectors = missionNamespace getVariable ["front_friendlySectors", []];
            private _friendlyFronts = (missionNamespace getVariable ["front_friendlyFobs", []]) + (_friendlySectors apply { _x select 0 });
            private _enemyFronts = _allSectors select { !(_x in _friendlySectors) } apply { _x select 0 };

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
                ["enemyFronts", _enemyFronts]
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
        while {true} do {
            private _data = missionNamespace getVariable ["front_battleOverlayData", createHashMap];
            private _zones = _data getOrDefault ["zones", []];
            private _friendlyFronts = _data getOrDefault ["friendlyFronts", []];
            private _enemyFronts = _data getOrDefault ["enemyFronts", []];

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

            sleep 5;
        };
    };
};
