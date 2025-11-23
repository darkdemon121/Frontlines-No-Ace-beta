if (!isServer) exitWith {
    _this params ["_itemData", "_ctx"];
    [_itemData, _ctx, player] remoteExecCall ["front_fnc_shopPurchase", 2];
};

params ["_itemData", "_ctx", "_buyer"];
_ctx params ["_pos", "_shop"];
if (isNil "_pos") then { _pos = position _buyer; };
if (isNull _buyer) exitWith {};

["register", [_buyer]] call front_fnc_privateEconomy;

private _uid = getPlayerUID _buyer;
private _fundsMap = missionNamespace getVariable ["front_playerFunds", createHashMap];
private _balance = _fundsMap getOrDefault [_uid, missionNamespace getVariable ["front_startingFunds", 500]];
private _cost = _itemData select 2;

if (_balance < _cost) exitWith {
    ["Insufficient private funds"] remoteExec ["hint", _buyer];
};

["adjust", [_buyer, -_cost]] call front_fnc_privateEconomy;

private _spawnPos = _pos getPos [4, random 360];
private _type = _itemData select 3;
private _class = _itemData select 1;

switch (_type) do {
    case "weapon": {
        private _holder = createVehicle ["GroundWeaponHolder_Scripted", _spawnPos, [], 0, "CAN_COLLIDE"];
        _holder addWeaponCargoGlobal [_class, 1];
    };
    case "magazine": {
        private _holder = createVehicle ["GroundWeaponHolder_Scripted", _spawnPos, [], 0, "CAN_COLLIDE"];
        _holder addMagazineCargoGlobal [_class, 3];
    };
    case "item": {
        private _holder = createVehicle ["GroundWeaponHolder_Scripted", _spawnPos, [], 0, "CAN_COLLIDE"];
        _holder addItemCargoGlobal [_class, 1];
    };
    case "vehicle": {
        private _veh = createVehicle [_class, _spawnPos, [], 0, "NONE"];
        _veh setDir random 360;
    };
};

[format ["Purchased %1 for $%2", _itemData select 0, _cost]] remoteExec ["hint", _buyer];
