if (!hasInterface) exitWith {};

private _enemySide = missionNamespace getVariable ["front_enemySide", east];
private _prisonClass = missionNamespace getVariable ["front_powPrisonBuilding", "Land_i_Barracks_V1_F"];
private _medFacilities = ["Land_MedicalTent_01_white_generic_open_F", "Land_Medevac_house_V1_F", "Land_Medevac_HQ_V1_F"];

[] spawn {
    while {true} do {
        private _target = cursorTarget;
        private _isEnemy = side _target == (missionNamespace getVariable ["front_enemySide", east]);
        private _isSurrendered = _target getVariable ["front_surrendered", false];
        if (!isNull _target && {alive _target} && {_isEnemy} && {(damage _target) > 0.7 || {_isSurrendered}}) then {
            if ((_target getVariable ["front_hasCaptureAction", false]) isEqualTo false) then {
                private _id = _target addAction ["Take Prisoner", {
                    params ["_unit", "_caller", "_idAction", "_args"];
                    _unit setCaptive true;
                    _unit disableAI "AUTOTARGET";
                    _unit disableAI "TARGET";
                    [_unit] joinSilent (group _caller);
                    _unit setVariable ["front_isPrisoner", true, true];
                    _unit setVariable ["front_captureAction", _idAction];
                    _unit addAction ["Deliver to Prison", {
                        params ["_prisoner", "_caller"];
                        private _prisonClass = missionNamespace getVariable ["front_powPrisonBuilding", "Land_i_Barracks_V1_F"];
                        private _near = nearestObjects [_prisoner, [_prisonClass], 30];
                        if ((count _near) > 0) then {
                            private _cell = _near select 0;
                            _prisoner removeAction (_prisoner getVariable ["front_captureAction", -1]);
                            _prisoner setPosATL (getPosATL _cell);
                            _prisoner disableAI "MOVE";
                            _prisoner setVariable ["front_isDetained", true, true];
                            [_prisoner, true] remoteExecCall ["setCaptive", 0, true];
                        } else {
                            hint "You need a POW Prison building at a FOB to hold captured enemies.";
                        };
                    }, nil, 1.5, true, true, "", "_target getVariable ['front_isPrisoner', false]", 5];
                }, nil, 1.5, true, true, "", "!(_target getVariable ['front_isPrisoner', false])", 3];
                _target setVariable ["front_hasCaptureAction", true];
            };
        };

        if (!isNull _target && {alive _target} && {_isEnemy} && {(damage _target) > 0.65} && {(_target getVariable ["front_isPrisoner", false]) isEqualTo false}) then {
            private _nearMed = nearestObjects [_target, _medFacilities, 25];
            if (!(_nearMed isEqualTo [])) then {
                if ((_target getVariable ["front_hasTreatAction", false]) isEqualTo false) then {
                    private _aid = _target addAction ["Stabilize Wounded Enemy", {
                        params ["_unit", "_caller", "_idAction"];
                        _unit setDamage 0.6;
                        _unit setCaptive true;
                        _unit disableAI "AUTOTARGET";
                        _unit disableAI "TARGET";
                        _unit setVariable ["front_hasTreatAction", true, true];
                        hint "Enemy stabilized. Move them to the POW prison.";
                    }, nil, 1.5, true, true, "", "alive _target && {(damage _target) > 0.65}" , 3];
                    _target setVariable ["front_hasTreatAction", true];
                };
            };
        };
        sleep 1.5;
    };
};
