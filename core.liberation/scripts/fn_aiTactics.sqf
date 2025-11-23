params ["_grp", ["_objectivePos", [0,0,0]], ["_role", "attack"]];

if (!isServer) exitWith {};
if (isNull _grp) exitWith {};

_grp setVariable ["front_initialCount", count units _grp];
private _roleLower = toLower _role;
if (_roleLower isEqualTo "ambush") then {
    _grp setBehaviourStrong "STEALTH";
    _grp setCombatMode "RED";
    _grp setSpeedMode "LIMITED";
} else {
    _grp setBehaviourStrong "COMBAT";
    _grp setCombatMode "YELLOW";
};
_grp enableAttack true;

private _flank = {
    params ["_leader", "_enemyPos"];
    private _dir = _leader getDir _enemyPos;
    private _offset = selectRandom [-1, 1] * (60 + random 40);
    _enemyPos getPos [_offset, _dir + (selectRandom [-75, 75])]
};

[_grp, _objectivePos, _role, _flank] spawn {
    params ["_grp", "_objectivePos", "_role", "_flank"];
    private _initial = _grp getVariable ["front_initialCount", count units _grp];
    while {alive leader _grp && {(count units _grp) > 0}} do {
        private _leader = leader _grp;
        private _enemy = _leader findNearestEnemy _leader;
        private _hasEnemy = !(isNull _enemy) && {alive _enemy};
        private _enemyPos = if (_hasEnemy) then {getPos _enemy} else {_objectivePos};

        if (_hasEnemy) then {
            // Combined-arms style: use suppression and occasional flanks
            if (random 1 > 0.55) then {
                private _shooter = selectRandom (units _grp);
                if (alive _shooter) then { _shooter doSuppressiveFire _enemy; };
            };

            if (random 1 > 0.65) then {
                private _pos = [_leader, _enemyPos] call _flank;
                _grp move _pos;
            };
        };

        // Garrison nearby buildings if heavily attrited
        private _remaining = count units _grp;
        if ((_remaining max 1) < (_initial * 0.5) && {_roleLower in ["attack", "raid", "ambush"]}) then {
            private _houses = nearestObjects [_leader, ["House"], 120];
            if (!(_houses isEqualTo [])) then {
                private _house = selectRandom _houses;
                private _positions = [_house] call BIS_fnc_buildingPositions;
                if (!(_positions isEqualTo [])) then {
                    {
                        if (_forEachIndex < (count _positions)) then {
                            _x doMove (_positions select _forEachIndex);
                            _x setUnitPos "MIDDLE";
                        };
                    } forEach (units _grp);
                };
            };
        };

        // Defensive posture if ordered to hold
        if (_roleLower isEqualTo "defend") then {
            _grp setBehaviourStrong "AWARE";
            _grp setCombatMode "RED";
            _grp move _objectivePos;
        } else {
            if (_roleLower isEqualTo "ambush") then {
                _grp setBehaviourStrong "STEALTH";
                _grp setCombatMode "RED";
            };
        };

        sleep 20 + random 10;
    };
};
