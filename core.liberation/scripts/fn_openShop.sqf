params ["_shop", "_caller"];

if (!hasInterface) exitWith {};
uiNamespace setVariable ["front_shopContext", [position _shop, _shop]];
createDialog "RscDisplayFrontShop";
