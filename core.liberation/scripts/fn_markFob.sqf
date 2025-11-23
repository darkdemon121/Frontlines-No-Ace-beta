params ["_pos", ["_label", "FOB HQ"]];

if (!isServer) exitWith {};
if (_pos isEqualTo [0,0,0]) exitWith {};

private _mName = format ["front_fob_%1", diag_tickTime + random 1000];
_mName setMarkerShape "ICON";
_mName setMarkerType "b_hq";
_mName setMarkerColor "ColorBLUFOR";
_mName setMarkerText _label;
_mName setMarkerPos _pos;
