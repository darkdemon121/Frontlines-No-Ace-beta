if (!hasInterface) exitWith {};

[] spawn {
    private _privateAction = -1;
    private _factionAction = -1;
    while {true} do {
        private _private = player getVariable ["front_privateFunds", 0];
        private _income = player getVariable ["front_privateIncome", 0];
        private _factionRes = missionNamespace getVariable ["front_resources", 0];
        private _factionFuel = missionNamespace getVariable ["front_fuel", 0];
        private _factionMan = missionNamespace getVariable ["front_manpower", 0];

        if (_privateAction < 0) then {
            _privateAction = player addAction [
                format ["Private Funds ($%1)", _private],
                {
                    private _bal = player getVariable ["front_privateFunds", 0];
                    private _inc = player getVariable ["front_privateIncome", 0];
                    hint format ["Private Balance: $%1\nHourly Income Bonus: %2%%", _bal, _inc];
                },
                [], 1.5, true, true, "", "true", 2
            ];
        } else {
            player setUserActionText [_privateAction, format ["Private Funds ($%1)", _private]];
        };

        if (_factionAction < 0) then {
            _factionAction = player addAction [
                "Faction Funds",
                {
                    private _res = missionNamespace getVariable ["front_resources", 0];
                    private _fuel = missionNamespace getVariable ["front_fuel", 0];
                    private _man = missionNamespace getVariable ["front_manpower", 0];
                    hint format ["Faction Resources: %1\nFaction Fuel: %2\nManpower: %3", _res, _fuel, _man];
                },
                [], 1.5, true, true, "", "true", 2
            ];
        } else {
            player setUserActionText [_factionAction, format ["Faction Funds (Res %1 / Fuel %2)", _factionRes, _factionFuel]];
        };

        sleep 10;
    };
};
