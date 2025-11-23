if (!hasInterface) exitWith {};

params ["_grp"];
if (isNull _grp || {!(_grp isEqualType grpNull)}) exitWith {};
if (!(player getVariable ["front_isCommander", false])) exitWith {};

player hcSetGroup _grp;
player setVariable ["front_hasHighCommand", true];
