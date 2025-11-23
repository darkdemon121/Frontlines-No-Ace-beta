if (!hasInterface) exitWith {};

[] spawn {
    private _keywords = ["commander", "command", "platoon", "jtac"];
    private _lastState = false;
    while {true} do {
        private _desc = toLower (roleDescription player);
        private _isCommander = (_keywords findIf {_desc find _x > -1}) > -1;
        player setVariable ["front_isCommander", _isCommander];

        if (_isCommander != _lastState) then {
            // keep only commanders controlling HC; non-commanders drop any inherited control
            if (!_isCommander) then { hcRemoveAllGroups player; };
            [player, _isCommander] remoteExecCall ["front_fnc_registerCommander", 2];
        };

        _lastState = _isCommander;
        sleep 8;
    };
};
