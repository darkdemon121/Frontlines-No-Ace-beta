params ["_mode", "_args"];

if (!hasInterface) exitWith {};

private _display = uiNamespace getVariable ["front_intelMapDisplay", displayNull];

switch (_mode) do {
    case "onLoad": {
        _args params ["_disp"];
        uiNamespace setVariable ["front_intelMapDisplay", _disp];
        uiNamespace setVariable ["front_intelMapHandles", []];

        // Center map on player position when opened
        disableSerialization;
        private _mapCtrl = _disp displayCtrl 9901;
        _mapCtrl ctrlMapAnimAdd [0, 0.35, getPos player];
        ctrlMapAnimCommit _mapCtrl;

        private _loop = [_disp] spawn {
            params ["_disp"];
            while {!isNull _disp} do {
                ["refresh", [_disp]] call front_fnc_intelMap;
                sleep 5;
            };
        };
        uiNamespace setVariable ["front_intelMapLoop", _loop];
    };
    case "onUnload": {
        private _loop = uiNamespace getVariable ["front_intelMapLoop", scriptNull];
        if (!isNull _loop) then { terminate _loop; };

        disableSerialization;
        private _mapCtrl = _display displayCtrl 9901;
        { _mapCtrl ctrlMapDelete _x; } forEach (uiNamespace getVariable ["front_intelMapHandles", []]);
        uiNamespace setVariable ["front_intelMapHandles", []];
        uiNamespace setVariable ["front_intelMapDisplay", displayNull];
    };
    case "refresh": {
        _args params ["_disp"];
        if (isNull _disp) exitWith {};
        disableSerialization;

        private _mapCtrl = _disp displayCtrl 9901;
        private _handles = uiNamespace getVariable ["front_intelMapHandles", []];
        { _mapCtrl ctrlMapDelete _x; } forEach _handles;
        _handles = [];

        private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
        private _enemySide = missionNamespace getVariable ["front_enemySide", east];
        private _data = missionNamespace getVariable ["front_battleOverlayData", createHashMap];
        private _zones = _data getOrDefault ["zones", []];
        private _fobs = missionNamespace getVariable ["front_friendlyFobs", []];

        {
            private _pos = _x get "pos";
            private _status = _x get "status";
            private _color = switch (_status) do {
                case "heavy": {[1,0,0,0.6]};
                case "contact": {[1,0.8,0,0.6]};
                default {[0,1,0,0.4]};
            };
            private _id = _mapCtrl ctrlMapAddCircle [_pos, 300, _color, _color];
            _handles pushBack _id;
        } forEach _zones;

        {
            private _id = _mapCtrl ctrlMapAddIcon ["b_hq", [0,0.6,1,1], _x, 22, 22, 0, "FOB HQ", 1];
            _handles pushBack _id;
        } forEach _fobs;

        // Friendly groups
        private _friendlyGroups = allGroups select { side _x == _friendlySide };
        {
            private _leader = leader _x;
            if (alive _leader) then {
                private _id = _mapCtrl ctrlMapAddIcon ["A3\\ui_f\\data\\map\\markers\\nato\\b_inf.paa", [0,0.6,1,1], getPos _leader, 16, 16, getDir _leader, groupId _x, 0];
                _handles pushBack _id;
            };
        } forEach (_friendlyGroups select [0, 25 min (count _friendlyGroups)]);

        // Spotted enemies: anything near friendlies
        private _enemyUnits = [];
        {
            private _near = _x nearEntities ["Man", 800];
            { if (side _x == _enemySide && {alive _x}) then { _enemyUnits pushBackUnique _x; }; } forEach _near;
        } forEach (allUnits select { side _x == _friendlySide && alive _x });

        {
            private _id = _mapCtrl ctrlMapAddIcon ["A3\\ui_f\\data\\map\\markers\\nato\\o_inf.paa", [1,0,0,1], getPos _x, 14, 14, getDir _x, "Spotted", 0];
            _handles pushBack _id;
        } forEach (_enemyUnits select [0, 30 min (count _enemyUnits)]);

        // Active missions
        private _missions = missionNamespace getVariable ["front_activeMissions", []];
        {
            private _pos = _x getOrDefault ["pos", markerPos (_x getOrDefault ["marker", ""])];
            private _label = format ["%1 ($%2)", _x getOrDefault ["title", "Mission"], _x getOrDefault ["payout", 0]];
            if (!(_pos isEqualTo [0,0,0])) then {
                private _id = _mapCtrl ctrlMapAddIcon ["mil_objective", [0,0.7,1,0.9], _pos, 18, 18, 0, _label, 1];
                _handles pushBack _id;
            };
        } forEach _missions;

        // War crime incidents
        private _crimes = missionNamespace getVariable ["front_warCrimeEvents", []];
        {
            if (!(_x getOrDefault ["resolved", false])) then {
                private _pos = _x getOrDefault ["pos", [0,0,0]];
                private _side = _x getOrDefault ["side", "enemy"];
                private _color = if (_side isEqualTo "friendly") then {[0,0.6,1,0.9]} else {[1,0,0,0.9]};
                private _text = if (_side isEqualTo "friendly") then {"Friendly ROE Violation"} else {"Enemy Atrocity"};
                private _id = _mapCtrl ctrlMapAddIcon ["mil_warning", _color, _pos, 18, 18, 0, _text, 1];
                _handles pushBack _id;
            };
        } forEach _crimes;

        uiNamespace setVariable ["front_intelMapHandles", _handles];
    };
};
