if (!isServer) exitWith {};

private _interval = 900; // 15 minutes
while {true} do {
    [] call front_fnc_persistenceSave;
    sleep _interval;
};
