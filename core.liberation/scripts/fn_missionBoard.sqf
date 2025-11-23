params ["_mode", "_args"]; // UI event dispatcher

if (!hasInterface) exitWith {};

private _display = uiNamespace getVariable ["front_missionBoardDisplay", displayNull];

switch (_mode) do {
    case "onLoad": {
        _args params ["_disp"]; 
        uiNamespace setVariable ["front_missionBoardDisplay", _disp];
        disableSerialization;

        if ((count (missionNamespace getVariable ["front_missionDefinitions", []])) isEqualTo 0) then {
            [] remoteExecCall ["front_fnc_missionLibrary", 2];
        };

        private _categories = [] call front_fnc_getMissionCategories;
        private _catCtrl = _disp displayCtrl 9801;
        lbClear _catCtrl;
        {
            private _idx = _catCtrl lbAdd _x;
            _catCtrl lbSetData [_idx, _x];
        } forEach _categories;
        if ((count _categories) > 0) then { _catCtrl lbSetCurSel 0; };
    };
    case "onUnload": {
        uiNamespace setVariable ["front_missionBoardDisplay", displayNull];
    };
    case "categoryChanged": {
        if (isNull _display) exitWith {};
        disableSerialization;
        _args params ["_ctrl", "_index"];
        private _category = _ctrl lbData _index;
        private _missions = [_category] call front_fnc_getMissionsForCategory;
        private _missionCtrl = _display displayCtrl 9802;
        lbClear _missionCtrl;
        {
            private _idx = _missionCtrl lbAdd (_x get "title");
            _missionCtrl lbSetData [_idx, _x get "id"];
            private _state = [_x get "id"] call front_fnc_getMissionState;
            if (!(_state isEqualTo "")) then {
                _missionCtrl lbSetTextRight [_idx, _state];
            };
        } forEach _missions;
        if ((count _missions) > 0) then { _missionCtrl lbSetCurSel 0; };
    };
    case "missionChanged": {
        if (isNull _display) exitWith {};
        disableSerialization;
        _args params ["_ctrl", "_index"];
        private _id = _ctrl lbData _index;
        private _def = [_id] call front_fnc_getMissionDefinition;
        private _details = _display displayCtrl 9803;
        if (!isNil "_def") then {
            private _desc = _def getOrDefault ["description", ""];
            private _category = _def get "category";
            private _state = [_id] call front_fnc_getMissionState;
            private _anger = missionNamespace getVariable ["front_enemyAnger", 0];
            private _payout = _def getOrDefault ["payout", 0];
            _details ctrlSetStructuredText parseText format ["<t size='1.2'>%1</t><br/><t color='#8cd1ff'>%2</t><br/><br/>%3<br/><br/><t size='0.9'>Payout: $%4</t><br/><t size='0.9'>Enemy Anger: %5</t><br/><t size='0.8'>Impact: %6</t>",
                _def get "title", _category, _desc, _payout, _anger, if (_def getOrDefault ["sabotage", false]) then {"Lowers enemy alert"} else {"Raises enemy alert"}
            ];
        };
    };
    case "startMission": {
        if (isNull _display) exitWith {};
        disableSerialization;
        private _missionCtrl = _display displayCtrl 9802;
        private _sel = lbCurSel _missionCtrl;
        if (_sel < 0) exitWith {};
        private _id = _missionCtrl lbData _sel;
        [_id] remoteExecCall ["front_fnc_activateMission", 2];
    };
};
