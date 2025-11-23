if (!isServer) exitWith {};

// Simple economy manager tracking resources and fuel
if (isNil {missionNamespace getVariable "front_resources"}) then { missionNamespace setVariable ["front_resources", param [0, 1000]]; };
if (isNil {missionNamespace getVariable "front_fuel"}) then { missionNamespace setVariable ["front_fuel", param [1, 250]]; };
if (isNil {missionNamespace getVariable "front_manpower"}) then { missionNamespace setVariable ["front_manpower", 20]; };
if (isNil {missionNamespace getVariable "front_civilians"}) then { missionNamespace setVariable ["front_civilians", []]; };

while {true} do {
    private _factories = missionNamespace getVariable ["front_ownedFactories", []];
    private _depots = missionNamespace getVariable ["front_ownedFuel", []];
    {
        missionNamespace setVariable ["front_resources", (missionNamespace getVariable "front_resources") + (_x select 2)];
    } forEach _factories;
    {
        missionNamespace setVariable ["front_fuel", (missionNamespace getVariable "front_fuel") + (_x select 2)];
    } forEach _depots;

    // manpower growth tied to housed civilians
    missionNamespace setVariable ["front_manpower", (missionNamespace getVariable "front_manpower") + (count (missionNamespace getVariable "front_civilians")) max 0];
    sleep 300;
};
