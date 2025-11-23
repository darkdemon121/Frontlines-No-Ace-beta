if (!isServer) exitWith {};

// Initialize anger tracking and mission catalog
["init"] call front_fnc_enemyAnger;
private _definitions = call front_fnc_missionLibrary;
missionNamespace setVariable ["front_activeMissions", []];
publicVariable "front_activeMissions";

// Auto-seed a few missions to keep the world busy
while {true} do {
    private _active = missionNamespace getVariable ["front_activeMissions", []];
    _active = _active select { (_x getOrDefault ["state", "running"]) in ["running", "Active"] };
    missionNamespace setVariable ["front_activeMissions", _active];
    publicVariable "front_activeMissions";

    if ((count _active) < 6) then {
        private _available = _definitions select {
            private _candidateId = _x get "id";
            (_active findIf { (_x get "id") isEqualTo _candidateId }) < 0
        };
        if ((count _available) > 0) then {
            private _pick = selectRandom _available;
            [_pick get "id"] call front_fnc_activateMission;
        };
    };
    sleep 600;
};
