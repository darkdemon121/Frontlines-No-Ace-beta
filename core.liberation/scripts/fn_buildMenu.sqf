params ["_mode", "_args"];

if (!hasInterface) exitWith {};

private _display = uiNamespace getVariable ["front_buildDisplay", displayNull];

// Helper to refresh catalog from mission config
private _refreshCatalog = {
    private _cfg = missionConfigFile >> "Buildables";
    private _cats = [];
    {
        private _entries = getArray (_x >> "entries");
        private _requires = if (isArray (_x >> "requires")) then {getArray (_x >> "requires")} else {[]};
        _cats pushBack [configName _x, getText (_x >> "displayName"), _requires, _entries];
    } forEach ("true" configClasses _cfg);
    missionNamespace setVariable ["front_buildCatalog", _cats];
    _cats
};

switch (_mode) do {
    case "onLoad": {
        _args params ["_disp"];
        uiNamespace setVariable ["front_buildDisplay", _disp];
        disableSerialization;

        private _catalog = missionNamespace getVariable ["front_buildCatalog", []];
        if (_catalog isEqualTo []) then { _catalog = call _refreshCatalog; };

        // store the current FOB position context
        uiNamespace setVariable ["front_buildContext", [position player, getDir player]];

        private _catCtrl = _disp displayCtrl 9801;
        lbClear _catCtrl;
        {
            private _idx = _catCtrl lbAdd (_x select 1);
            _catCtrl lbSetData [_idx, _x select 0];
        } forEach _catalog;
        if ((count _catalog) > 0) then { _catCtrl lbSetCurSel 0; };
    };
    case "onUnload": {
        uiNamespace setVariable ["front_buildDisplay", displayNull];
    };
    case "categoryChanged": {
        if (isNull _display) exitWith {};
        disableSerialization;
        _args params ["_ctrl", "_index"];
        private _catalog = missionNamespace getVariable ["front_buildCatalog", call _refreshCatalog];
        private _catId = _ctrl lbData _index;
        private _cat = _catalog select {(_x select 0) isEqualTo _catId};
        if ((count _cat) isEqualTo 0) exitWith {};
        _cat = _cat select 0;
        private _items = _cat select 3;
        private _itemCtrl = _display displayCtrl 9802;
        lbClear _itemCtrl;
        {
            private _idx = _itemCtrl lbAdd (_x select 0);
            _itemCtrl lbSetData [_idx, str _x];
            private _res = _x param [2,0];
            private _fuel = _x param [3,0];
            private _man = _x param [4,0];
            _itemCtrl lbSetTextRight [_idx, format ["R:%1 F:%2 M:%3", _res, _fuel, _man]];
        } forEach _items;
        if ((count _items) > 0) then { _itemCtrl lbSetCurSel 0; };
    };
    case "itemChanged": {
        if (isNull _display) exitWith {};
        disableSerialization;
        _args params ["_ctrl", "_index"];
        private _data = _ctrl lbData _index;
        private _details = _display displayCtrl 9803;
        if (!isNil "_data") then {
            private _item = call compile _data;
            private _res = _item param [2,0];
            private _fuel = _item param [3,0];
            private _man = _item param [4,0];
            private _catCtrl = _display displayCtrl 9801;
            private _catId = _catCtrl lbData (lbCurSel _catCtrl);
            private _catalog = missionNamespace getVariable ["front_buildCatalog", call _refreshCatalog];
            private _cat = _catalog select {(_x select 0) isEqualTo _catId};
            private _reqs = if ((count _cat) > 0) then {_cat select 0 select 2} else {[]};
            _details ctrlSetStructuredText parseText format [
                "<t size='1.2'>%1</t><br/><br/>Resources: %2<br/>Fuel: %3<br/>Manpower: %4<br/><br/>Requires: %5",
                _item select 0,
                _res,
                _fuel,
                _man,
                if ((_reqs isEqualTo []) then {"None"} else {(_reqs joinString ", ")})
            ];
        };
    };
    case "build": {
        if (isNull _display) exitWith {};
        disableSerialization;
        private _catCtrl = _display displayCtrl 9801;
        private _itemCtrl = _display displayCtrl 9802;
        private _catId = _catCtrl lbData (lbCurSel _catCtrl);
        private _itemSel = lbCurSel _itemCtrl;
        if (_catId isEqualTo "" || {_itemSel < 0}) exitWith {};
        private _itemData = call compile (_itemCtrl lbData _itemSel);
        private _context = [position player, getDir player];
        uiNamespace setVariable ["front_buildContext", _context];

        if (_catId in ["Buildings", "Fortifications"]) then {
            // let the buyer pick an exact placement before spending resources
            uiNamespace setVariable ["front_buildPending", [_catId, _itemData, _context, player]];
            hint "Open the map and click where you want to place this structure.";
            openMap true;

            onMapSingleClick {
                params ["_pos"];
                onMapSingleClick "";
                openMap false;

                private _pending = uiNamespace getVariable ["front_buildPending", []];
                uiNamespace setVariable ["front_buildPending", nil];
                if (_pending isEqualTo []) exitWith {};

                _pending params ["_catId", "_itemData", "_context", "_buyer"];
                _context set [0, _pos];
                [_catId, _itemData, _context, _buyer] remoteExecCall ["front_fnc_buildPurchase", 2];
            };
        } else {
            [_catId, _itemData, _context, player] remoteExecCall ["front_fnc_buildPurchase", 2];
        };
    };
};
