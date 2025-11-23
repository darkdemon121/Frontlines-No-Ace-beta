// Initializes town shops, shopkeepers, and catalog
if (isServer) then {
    // Build catalog from config so clients can consume the same structure
    private _catalog = [];
    private _categories = "true" configClasses (configFile >> "ShopCatalog" >> "Categories");
    {
        private _items = [];
        private _itemArr = getArray (_x >> "items");
        {
            _items pushBack [
                _x select 0, // label
                _x select 1, // class
                _x select 2, // cost
                _x select 3  // type
            ];
        } forEach _itemArr;
        _catalog pushBack [configName _x, getText (_x >> "displayName"), _items];
    } forEach _categories;

    missionNamespace setVariable ["front_shopCatalog", _catalog];
    missionNamespace setVariable ["front_baseIncome", getNumber (configFile >> "ShopCatalog" >> "baseIncome")];
    missionNamespace setVariable ["front_missionIncomeBonus", getNumber (configFile >> "ShopCatalog" >> "missionBonusPercent")];
    missionNamespace setVariable ["front_sectorIncomeBonus", getNumber (configFile >> "ShopCatalog" >> "sectorBonusPercent")];
    missionNamespace setVariable ["front_startingFunds", getNumber (configFile >> "ShopCatalog" >> "startingFunds") max 0];

    publicVariable "front_shopCatalog";
    publicVariable "front_baseIncome";
    publicVariable "front_missionIncomeBonus";
    publicVariable "front_sectorIncomeBonus";
    publicVariable "front_startingFunds";

    // Spawn shopkeepers at civilian centers
    private _shops = [];
    private _cityTypes = ["NameCity", "NameCityCapital", "NameVillage", "NameLocal"];
    {
        private _pos = _x select 0;
        private _name = _x select 1;
        private _type = _x select 2;
        if (_type in _cityTypes) then {
            private _mark = format ["front_shop_%1", _forEachIndex];
            private _marker = createMarker [_mark, _pos];
            _marker setMarkerShape "ICON";
            _marker setMarkerType "hd_dot";
            _marker setMarkerColor "ColorCIV";
            _marker setMarkerText format ["%1 Market", _name];
            _marker setMarkerPos _pos;

            private _shopPos = _pos getPos [8 + random 15, random 360];
            private _civGrp = createGroup civilian;
            private _shopkeeper = _civGrp createUnit ["C_Man_1", _shopPos, [], 0, "NONE"];
            _shopkeeper disableAI "PATH";
            _shopkeeper setDir random 360;
            _shopkeeper addAction ["Open Market", {
                params ["_target", "_caller", "_actionId", "_args"];
                [_target, _caller] call front_fnc_openShop;
            }, [], 1.5, true, true, "", "true", 5];

            _shops pushBack [_shopkeeper, _mark];
        };
    } forEach (missionNamespace getVariable ["front_sectorCities", []]);

    missionNamespace setVariable ["front_shopLocations", _shops];
    publicVariable "front_shopLocations";
};
