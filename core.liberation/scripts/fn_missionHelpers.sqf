// Helper functions for mission browsing and spawning

front_fnc_getMissionCategories = {
    private _defs = missionNamespace getVariable ["front_missionDefinitions", []];
    private _categories = [];
    {
        private _cat = _x get "category";
        if (!(_cat in _categories)) then { _categories pushBack _cat; };
    } forEach _defs;
    _categories sort true;
    _categories
};

front_fnc_getMissionsForCategory = {
    params ["_category"];
    private _defs = missionNamespace getVariable ["front_missionDefinitions", []];
    _defs select { (_x get "category") isEqualTo _category };
};

front_fnc_getMissionDefinition = {
    params ["_id"];
    private _defs = missionNamespace getVariable ["front_missionDefinitions", []];
    private _idx = _defs findIf { (_x get "id") isEqualTo _id };
    if (_idx > -1) then { _defs select _idx } else { objNull };
};

front_fnc_getMissionState = {
    params ["_id"];
    private _active = missionNamespace getVariable ["front_activeMissions", []];
    private _idx = _active findIf { (_x get "id") isEqualTo _id };
    if (_idx > -1) then {
        private _state = (_active select _idx) getOrDefault ["state", "running"];
        if (_state isEqualTo "running") then {"Active"} else {_state};
    } else {
        ""
    };
};

front_fnc_findMissionPos = {
    params ["_def"];

    private _cities     = missionNamespace getVariable ["front_sectorCities", []];
    private _military   = missionNamespace getVariable ["front_sectorMilitary", []];
    private _factories  = missionNamespace getVariable ["front_sectorFactories", []];
    private _fuel       = missionNamespace getVariable ["front_sectorFuel", []];
    private _radio      = missionNamespace getVariable ["front_sectorRadio", []];
    private _roadblocks = missionNamespace getVariable ["front_sectorRoadblocks", []];
    private _ports      = missionNamespace getVariable ["front_sectorPorts", []];
    private _carriers   = missionNamespace getVariable ["front_sectorCarriers", []];

    private _allSectors = [_cities, _military, _factories, _fuel, _radio, _roadblocks, _ports, _carriers] call BIS_fnc_flatten;
    private _friendly   = missionNamespace getVariable ["front_friendlySectors", []];
    private _friendlyPos = _friendly apply { _x select 0 };
    private _frontLine = missionNamespace getVariable ["front_noMansLand", []];

    private _enemySectors = _allSectors select { !((_x select 0) in _friendlyPos) };

    private _pick = {
        params ["_pool", ["_preferEnemy", false]];
        private _candidates = if (_preferEnemy) then { _pool select { !((_x select 0) in _friendlyPos) } } else { _pool };
        if ((count _candidates) > 0) then { ((_candidates call BIS_fnc_selectRandom) select 0) } else { [] };
    };

    private _category = toLower (_def getOrDefault ["category", ""]);
    private _type = toLower (_def getOrDefault ["type", "destroy"]);
    private _pickOrder = [];

    switch (true) do {
        case (_type isEqualTo "defend"): {
            _pickOrder = [_friendly, _cities, _military];
        };
        case (_category find "sabotage" > -1): {
            _pickOrder = [_factories, _fuel, _radio, _ports, _military, _cities];
        };
        case (_category find "intel" > -1): {
            _pickOrder = [_radio, _cities, _military, _ports];
        };
        case (_category find "rescue" > -1): {
            _pickOrder = [_cities, _military, _ports];
        };
        case (_category find "logistics" > -1): {
            _pickOrder = [_roadblocks, _factories, _fuel, _ports, _cities];
        };
        case (_category find "reconnaissance" > -1): {
            _pickOrder = [_frontLine, _military, _cities, _roadblocks, _ports];
        };
        case (_category find "minefield" > -1): {
            _pickOrder = [_roadblocks, _cities, _ports];
        };
        case (_category find "enemy movement" > -1): {
            _pickOrder = [_frontLine, _roadblocks, _military, _ports];
        };
        case (_category find "urban" > -1): {
            _pickOrder = [_cities];
        };
        case (_category find "defensive" > -1): {
            _pickOrder = [_friendly, _cities, _military];
        };
        case (_category find "air" > -1): {
            _pickOrder = [_military, _radio, _carriers];
        };
        case (_category find "covert" > -1): {
            _pickOrder = [_frontLine, _cities, _military, _ports];
        };
        case (_category find "heavy combat" > -1): {
            _pickOrder = [_military, _cities, _ports];
        };
        case (_category find "gameplay" > -1): {
            _pickOrder = [_enemySectors, _cities, _military, _ports];
        };
        case (_category find "chaos" > -1): {
            _pickOrder = [_frontLine, _enemySectors, _military, _cities, _carriers];
        };
        default {
            _pickOrder = [_enemySectors, _allSectors];
        };
    };

    private _chosen = [];
    {
        if (!isNil "_x" && {count _x > 0}) then {
            _chosen = [_x, true] call _pick;
        };
        if (!(_chosen isEqualTo [])) exitWith {};
    } forEach _pickOrder;

    if (_chosen isEqualTo []) then { _chosen = [_allSectors, true] call _pick; };

    if (_chosen isEqualTo []) then { [[0,0,0], 0, worldSize, 5, 0, 20, 0] call BIS_fnc_findSafePos } else { _chosen };
};

front_fnc_spawnGuardGroup = {
    params ["_pos", ["_weight", 6]];
    private _side = missionNamespace getVariable ["front_enemySide", east];
    private _inf = missionNamespace getVariable ["front_enemyInfantry", ["O_Soldier_F"]];
    private _aiMult = missionNamespace getVariable ["front_aiMultiplier", 1];
    private _grp = createGroup _side;
    private _count = round (_weight * _aiMult);
    for "_i" from 1 to _count do {
        private _u = _grp createUnit [selectRandom _inf, _pos getPos [random 30, random 360], [], 0, "NONE"];
        _u setSkill (0.4 + random 0.3);
    };
    _grp
};

front_fnc_makeTask = {
    params ["_id", "_title", "_desc", "_pos"];
    private _task = [west, [_id], [format ["%1", _desc], _title, _title], _pos, true] call BIS_fnc_taskCreate;
    _task
};

front_fnc_attachDestroyHandler = {
    params ["_objects", "_missionData"];
    private _counter = _objects select {alive _x};
    {
        _x addEventHandler ["Killed", {
            params ["_obj"]; 
            private _data = _obj getVariable ["front_missionData", objNull];
            if (isNil "_data") exitWith {};
            private _all = _data get "targets";
            private _remaining = _all select {alive _x};
            if ((count _remaining) isEqualTo 0) then {
                [_data get "id", true] call front_fnc_completeMission;
            };
        }];
        _x setVariable ["front_missionData", _missionData];
    } forEach _counter;
};

front_fnc_attachIntelHandler = {
    params ["_object", "_missionData", ["_label", "Collect Intel"]];
    _object addAction [_label, {
        params ["_target", "_caller", "_actionId", "_args"];
        _target removeAction _actionId;
        [_args get "id", true] call front_fnc_completeMission;
    }, _missionData, 1.5, true, true, "", "true", 5];
};

front_fnc_attachEscortHandler = {
    params ["_unit", "_missionData", ["_label", "Escort to FOB"]];
    _unit addAction [_label, {
        params ["_target", "_caller", "_actionId", "_args"];
        private _fobs = missionNamespace getVariable ["front_friendlyFobs", []];
        private _pos = if ((count _fobs) > 0) then { _fobs select 0 } else { markerPos "respawn_west" };
        if ((_caller distance2D _pos) < 50) then {
            _target removeAction _actionId;
            [_args get "id", true] call front_fnc_completeMission;
        } else {
            hint "Bring the VIP to a FOB to complete the task.";
        };
    }, _missionData, 1.5, true, true, "", "true", 5];
    _unit setCaptive false;
    _unit allowFleeing 0;
    _unit setBehaviour "AWARE";
};
