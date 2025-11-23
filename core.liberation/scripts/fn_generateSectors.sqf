if (!isServer) exitWith {};

// Combine discovered sector types
private _sectors = [
    missionNamespace getVariable ["front_sectorCities", []],
    missionNamespace getVariable ["front_sectorMilitary", []],
    missionNamespace getVariable ["front_sectorFactories", []],
    missionNamespace getVariable ["front_sectorFuel", []],
    missionNamespace getVariable ["front_sectorRadio", []],
    missionNamespace getVariable ["front_sectorRoadblocks", []]
] call BIS_fnc_flatten;

{
    private _pos = _x select 0;
    private _name = _x select 1;
    private _type = _x select 2;
    private _markerName = format ["front_sector_%1", _forEachIndex];
    _markerName setMarkerShape "ELLIPSE";
    _markerName setMarkerSize [200, 200];
    _markerName setMarkerColor "ColorRed";
    _markerName setMarkerText _name;
    _markerName setMarkerPos _pos;

    // Initial defenders
    [_pos, _type] spawn front_fnc_setupDefenses;
} forEach _sectors;
