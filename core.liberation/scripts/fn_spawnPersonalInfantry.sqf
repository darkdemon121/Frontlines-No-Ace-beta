params ["_class", "_buyer", ["_pos", objNull]];

if (!isServer) exitWith {
    [_class, _buyer, _pos] remoteExecCall ["front_fnc_spawnPersonalInfantry", 2];
};

if (isNull _buyer) exitWith {};
if (isNil "_pos" || {isNull _pos}) then { _pos = position _buyer; };

private _grp = group _buyer;
if (isNull _grp) then { _grp = createGroup [side _buyer, true]; [_buyer] joinSilent _grp; };

private _spawnPos = _pos getPos [4 + random 2, random 360];
private _unit = _grp createUnit [_class, _spawnPos, [], 0, "NONE"];
[_unit] joinSilent _grp;
_unit setSkill (0.4 + random 0.2);

["Personal squad member ready"] remoteExec ["hint", _buyer];
