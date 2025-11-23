params ["_mode", "_args"];

if (!hasInterface) exitWith {};

private _display = uiNamespace getVariable ["front_shopDisplay", displayNull];

switch (_mode) do {
    case "onLoad": {
        _args params ["_disp"];
        uiNamespace setVariable ["front_shopDisplay", _disp];
        disableSerialization;

        // ensure catalog is present
        if ((count (missionNamespace getVariable ["front_shopCatalog", []])) isEqualTo 0) then {
            [] remoteExecCall ["front_fnc_shops", 2];
        };

        private _categories = missionNamespace getVariable ["front_shopCatalog", []];
        private _catCtrl = _disp displayCtrl 9901;
        lbClear _catCtrl;
        {
            private _idx = _catCtrl lbAdd (_x select 1);
            _catCtrl lbSetData [_idx, _x select 0];
        } forEach _categories;
        if ((count _categories) > 0) then { _catCtrl lbSetCurSel 0; };
    };
    case "onUnload": {
        uiNamespace setVariable ["front_shopDisplay", displayNull];
    };
    case "categoryChanged": {
        if (isNull _display) exitWith {};
        disableSerialization;
        _args params ["_ctrl", "_index"];
        private _categories = missionNamespace getVariable ["front_shopCatalog", []];
        private _categoryId = _ctrl lbData _index;
        private _cat = _categories select {(_x select 0) isEqualTo _categoryId};
        if ((count _cat) isEqualTo 0) exitWith {};
        _cat = _cat select 0;
        private _items = _cat select 2;
        private _itemCtrl = _display displayCtrl 9902;
        lbClear _itemCtrl;
        {
            private _idx = _itemCtrl lbAdd (_x select 0);
            _itemCtrl lbSetData [_idx, str _x];
            _itemCtrl lbSetTextRight [_idx, format ["$%1", _x select 2]];
        } forEach _items;
        if ((count _items) > 0) then { _itemCtrl lbSetCurSel 0; };
    };
    case "itemChanged": {
        if (isNull _display) exitWith {};
        disableSerialization;
        _args params ["_ctrl", "_index"];
        private _data = _ctrl lbData _index;
        private _details = _display displayCtrl 9903;
        if (!isNil "_data") then {
            private _item = call compile _data;
            private _type = _item select 3;
            private _cost = _item select 2;
            _details ctrlSetStructuredText parseText format ["<t size='1.2'>%1</t><br/><br/>Cost: $%2<br/>Type: %3<br/><br/>Purchased items spawn beside the shopkeeper.", _item select 0, _cost, toUpper _type];
        };
    };
    case "purchase": {
        if (isNull _display) exitWith {};
        disableSerialization;
        private _itemCtrl = _display displayCtrl 9902;
        private _sel = lbCurSel _itemCtrl;
        if (_sel < 0) exitWith {};
        private _itemData = call compile (_itemCtrl lbData _sel);
        private _ctx = uiNamespace getVariable ["front_shopContext", [position player, objNull]];
        [_itemData, _ctx] call front_fnc_shopPurchase;
    };
};
