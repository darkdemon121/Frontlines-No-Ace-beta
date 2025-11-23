params ["_mode", ["_value", 0]];

switch (_mode) do {
    case "init": {
        private _config = [] call {
            private _path = "enemy_anger/scalars.sqf";
            if (fileExists _path) then { call compile preprocessFileLineNumbers _path } else {[25,0,100]};
        };
        _config params ["_base", "_min", "_max"];
        missionNamespace setVariable ["front_enemyAnger", missionNamespace getVariable ["front_enemyAnger", _base]];
        missionNamespace setVariable ["front_enemyAngerBounds", [_min, _max]];
    };
    case "adjust": {
        private _bounds = missionNamespace getVariable ["front_enemyAngerBounds", [0,100]];
        private _anger = missionNamespace getVariable ["front_enemyAnger", 25];
        private _new = (_anger + _value) max (_bounds select 0) min (_bounds select 1);
        missionNamespace setVariable ["front_enemyAnger", _new];
        publicVariable "front_enemyAnger";
    };
    case "get": {
        missionNamespace getVariable ["front_enemyAnger", 25];
    };
};
