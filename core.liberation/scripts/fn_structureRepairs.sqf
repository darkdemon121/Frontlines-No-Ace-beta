if (!hasInterface) exitWith {};

private _actions = createHashMap;

while {true} do {
    private _pools = [
        missionNamespace getVariable ["front_ownedFactories", []],
        missionNamespace getVariable ["front_ownedFuel", []]
    ];

    {
        private _entry = _x;
        _entry params ["_pos", ["_name", "Site"], ["_rate", 0], ["_operational", true]];
        private _key = str _pos;
        private _actionId = _actions getOrDefault [_key, -1];

        if (!_operational && {(player distance2D _pos) < 15}) then {
            if (_actionId == -1) then {
                private _id = player addAction [
                    format ["Repair %1 (-200 res / -50 fuel)", _name],
                    {
                        params ["_target", "_caller", "_actionId", "_args"];
                        _args params ["_pos", "_name"];
                        [_pos, _name, _caller] call front_fnc_repairIndustry;
                    },
                    [_pos, _name],
                    1.5,
                    true,
                    true,
                    "",
                    "true",
                    5
                ];
                _actions set [_key, _id];
            };
        } else {
            if (_actionId > -1) then {
                player removeAction _actionId;
                _actions deleteAt _key;
            };
        };
    } forEach (_pools call BIS_fnc_flatten);

    sleep 5;
};
