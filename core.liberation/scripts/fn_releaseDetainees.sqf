params ["_caller"];

if (!isServer) exitWith {};

private _prisonPos = getPos _caller;
private _friendlySide = missionNamespace getVariable ["front_friendlySide", west];
private _friendlyDetainees = missionNamespace getVariable ["front_friendlyDetainees", []];
private _playerOffenders = missionNamespace getVariable ["front_playerOffenders", []];

_friendlyDetainees = _friendlyDetainees select {alive _x && {_x distance2D _prisonPos < 40}};
_playerOffenders = _playerOffenders select {alive _x && {_x distance2D _prisonPos < 40}};

if ((_friendlyDetainees isEqualTo []) && (_playerOffenders isEqualTo [])) exitWith {
    ["No detainees nearby to process."] remoteExec ["hint", owner _caller];
};

private _resources = missionNamespace getVariable ["front_resources", 0];
private _friendlyCost = (max [1, count _friendlyDetainees]) * 150;
private _playerCost = (max [1, count _playerOffenders]) * 500;
private _total = _friendlyCost + _playerCost;

if (_resources < _total) exitWith {
    [format ["Not enough faction resources (%1 needed).", _total]] remoteExec ["hint", owner _caller];
};

missionNamespace setVariable ["front_resources", _resources - _total, true];

if (!(_friendlyDetainees isEqualTo [])) then {
    private _grp = createGroup [_friendlySide, true];
    {
        _x setCaptive false;
        _x enableAI "MOVE";
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        [_x] joinSilent _grp;
        _x setVariable ["front_isDetained", false, true];
    } forEach _friendlyDetainees;
};

if (!(_playerOffenders isEqualTo [])) then {
    {
        _x setCaptive false;
        _x disableUserInput false;
        _x setVariable ["front_isDetained", false, true];
        private _marker = format ["front_playerCrime_%1", getPlayerUID _x];
        if (markerExists _marker) then { deleteMarker _marker; };
    } forEach _playerOffenders;
};

missionNamespace setVariable ["front_friendlyDetainees", (missionNamespace getVariable ["front_friendlyDetainees", []]) - _friendlyDetainees, true];
missionNamespace setVariable ["front_playerOffenders", (missionNamespace getVariable ["front_playerOffenders", []]) - _playerOffenders, true];

[format ["Detainees released. Cost paid: %1 resources.", _total]] remoteExec ["hint", owner _caller];
