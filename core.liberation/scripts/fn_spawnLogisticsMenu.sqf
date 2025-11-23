if (!hasInterface) exitWith {};

// Simple addAction-based build menu, only available at FOBs
[] spawn {
    while {true} do {
        private _nearFob = nearestObject [player, "Land_Cargo_HQ_V1_F"];
        if (!isNull _nearFob && {player distance _nearFob < 15}) then {
            if ((player getVariable ["front_hasBuildAction", false]) isEqualTo false) then {
                private _id = player addAction ["Open Logistics", {
                    [] call front_fnc_openBuildMenu;
                }];
                player setVariable ["front_hasBuildAction", true];
                player setVariable ["front_buildActionId", _id];
            };
            if ((player getVariable ["front_hasMissionBoard", false]) isEqualTo false) then {
                private _mid = player addAction ["Open Mission Board", {
                    [] call front_fnc_openMissionBoard;
                }];
                player setVariable ["front_hasMissionBoard", true];
                player setVariable ["front_missionBoardId", _mid];
            };

            private _nearMap = nearestObject [player, "Land_MapBoard_01_Wall_F"];
            if (!isNull _nearMap && {player distance _nearMap < 8} && {(player getVariable ["front_hasIntelMap", false]) isEqualTo false}) then {
                private _iid = player addAction ["View Tactical Map", {
                    [] call front_fnc_openIntelMap;
                }];
                player setVariable ["front_hasIntelMap", true];
                player setVariable ["front_intelMapId", _iid];
            };
        } else {
            private _id = player getVariable ["front_buildActionId", -1];
            if (_id >= 0) then { player removeAction _id; };
            player setVariable ["front_hasBuildAction", false];
            player setVariable ["front_buildActionId", -1];

            private _mid = player getVariable ["front_missionBoardId", -1];
            if (_mid >= 0) then { player removeAction _mid; };
            player setVariable ["front_hasMissionBoard", false];
            player setVariable ["front_missionBoardId", -1];

            private _iid = player getVariable ["front_intelMapId", -1];
            if (_iid >= 0) then { player removeAction _iid; };
            player setVariable ["front_hasIntelMap", false];
            player setVariable ["front_intelMapId", -1];
        };
        sleep 5;
    };
};

front_fnc_openBuildMenu = {
    createDialog "RscDisplayFrontlinesBuild";
};
