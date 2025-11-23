if (!isServer) exitWith { objNull };

params ["_def"];

private _pos = [_def] call front_fnc_findMissionPos;
private _taskId = format ["front_task_%1", _def get "id"];
private _taskDesc = _def getOrDefault ["description", _def get "title"];
[_taskId, _def get "title", _taskDesc, _pos] call front_fnc_makeTask;

private _missionData = createHashMapFromArray [
    ["id", _def get "id"],
    ["taskId", _taskId],
    ["state", "running"],
    ["sabotage", _def getOrDefault ["sabotage", false]],
    ["payout", _def getOrDefault ["payout", 0]],
    ["category", _def get "category"],
    ["title", _def get "title"],
    ["targets", []],
    ["pos", _pos],
    ["marker", ""]
];

private _type = _def getOrDefault ["type", "destroy"];

switch (_type) do {
    case "destroy": {
        private _targets = [];
        {
            private _cfg = configFile >> "CfgVehicles" >> _x;
            if ((getNumber (_cfg >> "isMan")) == 1) then {
                private _grp = createGroup (missionNamespace getVariable ["front_enemySide", east]);
                private _man = _grp createUnit [_x, _pos getPos [random 20, random 360], [], 0, "NONE"];
                _targets pushBack _man;
            } else {
                private _obj = createVehicle [_x, _pos getPos [random 20, random 360], [], 0, "NONE"];
                _targets pushBack _obj;
            };
        } forEach (_def getOrDefault ["objects", ["Land_Cargo_Tower_V1_No1_F"]]);
        _missionData set ["targets", _targets];
        [_targets, _missionData] call front_fnc_attachDestroyHandler;
        [_pos, (_def getOrDefault ["guards", 8])] call front_fnc_spawnGuardGroup;
    };
    case "intel": {
        private _class = (_def getOrDefault ["objects", ["Land_Laptop_device_F"]]) select 0;
        private _obj = createVehicle [_class, _pos, [], 0, "NONE"];
        _missionData set ["targets", [_obj]];
        [_obj, _missionData, "Collect Intel"] call front_fnc_attachIntelHandler;
        [_pos, (_def getOrDefault ["guards", 6])] call front_fnc_spawnGuardGroup;
    };
    case "escort": {
        private _class = (_def getOrDefault ["objects", ["C_man_1"]]) select 0;
        private _grp = createGroup west;
        private _unit = _grp createUnit [_class, _pos, [], 0, "NONE"];
        _missionData set ["targets", [_unit]];
        [_unit, _missionData, "Escort to FOB"] call front_fnc_attachEscortHandler;
        [_pos, (_def getOrDefault ["guards", 4])] call front_fnc_spawnGuardGroup;
    };
    case "defend": {
        private _class = (_def getOrDefault ["objects", ["Land_HelipadSquare_F"]]) select 0;
        private _anchor = createVehicle [_class, _pos, [], 0, "NONE"];
        _missionData set ["targets", [_anchor]];
        [_pos, (_def getOrDefault ["guards", 10])] call front_fnc_spawnGuardGroup;
        [_anchor, _missionData] spawn {
            params ["_target", "_data"];
            sleep (_data getOrDefault ["duration", 600]);
            if (alive _target) then { [_data get "id", true] call front_fnc_completeMission; };
        };
    };
    case "patrol": {
        private _grp = [_pos, (_def getOrDefault ["guards", 8])] call front_fnc_spawnGuardGroup;
        _missionData set ["targets", units _grp];
        [_grp, _missionData] spawn {
            params ["_group", "_data"];
            while {({alive _x} count (units _group)) > 0} do { sleep 10; };
            [_data get "id", true] call front_fnc_completeMission;
        };
    };
};

// Global mission marker for map and intel boards
private _marker = format ["front_mission_%1", _def get "id"];
deleteMarker _marker;
_marker = createMarker [_marker, _pos];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_objective";
_marker setMarkerText (_def get "title");
_marker setMarkerColor "ColorBLUFOR";
_missionData set ["marker", _marker];

missionNamespace setVariable ["front_activeMissionPos", _pos];

_missionData
