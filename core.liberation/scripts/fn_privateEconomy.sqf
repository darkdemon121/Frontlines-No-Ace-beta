params ["_mode", ["_data", []]];

if (!isServer) exitWith {
    [_mode, _data] remoteExecCall ["front_fnc_privateEconomy", 2];
};

private _funds = missionNamespace getVariable ["front_playerFunds", createHashMap];
private _income = missionNamespace getVariable ["front_playerIncome", createHashMap];
private _baseIncome = missionNamespace getVariable ["front_baseIncome", 100];
private _missionBonus = missionNamespace getVariable ["front_missionIncomeBonus", 5];
private _sectorBonus = missionNamespace getVariable ["front_sectorIncomeBonus", 3];
private _startingFunds = missionNamespace getVariable ["front_startingFunds", 500];

switch (_mode) do {
    case "start": {
        if (missionNamespace getVariable ["front_privateLoopStarted", false]) exitWith {};
        missionNamespace setVariable ["front_privateLoopStarted", true];
        missionNamespace setVariable ["front_playerFunds", _funds];
        missionNamespace setVariable ["front_playerIncome", _income];
        [] spawn {
            while {true} do {
                ["payout", []] call front_fnc_privateEconomy;
                sleep 3600;
            };
        };
    };
    case "register": {
        _data params ["_unit"];
        if (isNull _unit) exitWith {};
        private _uid = getPlayerUID _unit;
        if (_uid isEqualTo "") exitWith {};

        if ((_funds getOrDefault [_uid, objNull]) isEqualTo objNull) then {
            _funds set [_uid, _startingFunds];
        };
        if ((_income getOrDefault [_uid, objNull]) isEqualTo objNull) then {
            _income set [_uid, 0];
        };

        missionNamespace setVariable ["front_playerFunds", _funds];
        missionNamespace setVariable ["front_playerIncome", _income];
        _unit setVariable ["front_privateFunds", _funds get _uid, true];
        _unit setVariable ["front_privateIncome", _income get _uid, true];
    };
    case "adjust": {
        _data params ["_unit", ["_delta", 0]];
        if (isNull _unit) exitWith {};
        private _uid = getPlayerUID _unit;
        if (_uid isEqualTo "") exitWith {};
        if ((_funds getOrDefault [_uid, objNull]) isEqualTo objNull) then { _funds set [_uid, _startingFunds]; };
        private _current = _funds get _uid;
        private _new = (_current + _delta) max 0;
        _funds set [_uid, _new];
        missionNamespace setVariable ["front_playerFunds", _funds];
        _unit setVariable ["front_privateFunds", _new, true];
    };
    case "adjustIncome": {
        _data params ["_unit", ["_deltaPercent", 0]];
        if (isNull _unit) exitWith {};
        private _uid = getPlayerUID _unit;
        if (_uid isEqualTo "") exitWith {};
        if ((_income getOrDefault [_uid, objNull]) isEqualTo objNull) then { _income set [_uid, 0]; };
        _income set [_uid, (_income get _uid) + _deltaPercent];
        missionNamespace setVariable ["front_playerIncome", _income];
        _unit setVariable ["front_privateIncome", _income get _uid, true];
    };
    case "missionBonus": {
        {
            ["adjustIncome", [_x, _missionBonus]] call front_fnc_privateEconomy;
        } forEach allPlayers;
    };
    case "sectorBonus": {
        {
            ["adjustIncome", [_x, _sectorBonus]] call front_fnc_privateEconomy;
        } forEach allPlayers;
    };
    case "payout": {
        {
            if (!isNull _x) then {
                ["register", [_x]] call front_fnc_privateEconomy;
                private _uid = getPlayerUID _x;
                private _percent = _income getOrDefault [_uid, 0];
                private _payout = round (_baseIncome * (1 + (_percent / 100)));
                ["adjust", [_x, _payout]] call front_fnc_privateEconomy;
                [format ["Hourly income +$%1 (bonus %2%%)", _payout, _percent]] remoteExec ["hintSilent", _x];
            };
        } forEach allPlayers;
    };
};
