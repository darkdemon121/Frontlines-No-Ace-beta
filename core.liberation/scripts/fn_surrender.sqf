if (!isServer) exitWith {};

private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
private _enemySide = missionNamespace getVariable ["front_enemySide", east];

while {true} do {
    private _anger = ["get"] call front_fnc_enemyAnger;
    private _allGroups = allGroups select {
        private _side = side _x;
        (_side isEqualTo _friendlySide || {_side isEqualTo _enemySide}) &&
        {count (units _x) > 0} &&
        {((units _x) findIf {isPlayer _x}) == -1}
    };

    {
        private _grp = _x;
        private _units = units _grp select {alive _x};
        if (_units isEqualTo []) then {continue};

        private _initial = _grp getVariable ["front_surrenderInitial", count _units];
        _grp setVariable ["front_surrenderInitial", _initial];

        private _leader = leader _grp;
        private _enemyUnits = allUnits select {
            alive _x && {side _x != side _grp} && {_x distance _leader < 200} && {!(isPlayer _x)}
        };

        private _attrition = 1 - ((count _units) max 1) / (_initial max 1);
        private _outnumbered = if ((count _enemyUnits) > 0) then {(count _enemyUnits) / ((count _units) max 1)} else {0};
        private _wounded = {_x getHit "body" > 0.65 || {damage _x > 0.65}} count _units;

        private _chance = 0.01;
        _chance = _chance + (_attrition * 0.25);
        if (_outnumbered > 1) then { _chance = _chance + 0.08; };
        if (_wounded > 0) then { _chance = _chance + 0.05; };
        if (_attrition > 0.8) then { _chance = _chance + 0.07; };

        if (side _grp isEqualTo _enemySide) then {
            private _modifier = (1 - (_anger / 200)) max 0.35;
            _chance = _chance * _modifier;
        };

        _chance = _chance min 0.55;

        if (random 1 < _chance) then {
            {
                if (!(_x getVariable ["front_surrendered", false]) && {alive _x}) then {
                    _x setVariable ["front_surrendered", true, true];
                    _x setCaptive true;
                    _x disableAI "AUTOTARGET";
                    _x disableAI "TARGET";
                    _x disableAI "MOVE";
                    _x setUnitPos "DOWN";
                    removeAllWeapons _x;
                    [_x, "Acts_KneelTalk_DONOTUSE"] remoteExec ["switchMove", 0];
                };
            } forEach _units;
        };
    } forEach _allGroups;

    sleep 60 + random 30;
};
