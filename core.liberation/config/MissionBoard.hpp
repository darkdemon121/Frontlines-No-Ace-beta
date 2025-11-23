class RscDisplayMissionBoard
{
    idd = 9800;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "['onLoad', _this] call front_fnc_missionBoard";
    onUnload = "['onUnload', _this] call front_fnc_missionBoard";

    class controlsBackground
    {
        class Background: RscText
        {
            idc = -1;
            x = 0.14;
            y = 0.14;
            w = 0.72;
            h = 0.72;
            colorBackground[] = {0,0,0,0.8};
        };
        class Header: RscText
        {
            idc = -1;
            text = "Mission Board";
            x = 0.14;
            y = 0.12;
            w = 0.72;
            h = 0.04;
            colorBackground[] = {0,0.6,1,0.8};
        };
    };

    class controls
    {
        class CategoryList: RscListbox
        {
            idc = 9801;
            x = 0.16;
            y = 0.18;
            w = 0.2;
            h = 0.66;
            onLBSelChanged = "['categoryChanged', _this] call front_fnc_missionBoard";
        };
        class MissionList: RscListbox
        {
            idc = 9802;
            x = 0.38;
            y = 0.18;
            w = 0.24;
            h = 0.66;
            onLBSelChanged = "['missionChanged', _this] call front_fnc_missionBoard";
        };
        class MissionDetails: RscStructuredText
        {
            idc = 9803;
            x = 0.64;
            y = 0.18;
            w = 0.2;
            h = 0.48;
            colorBackground[] = {0,0,0,0.4};
        };
        class StartButton: RscButton
        {
            idc = 9804;
            text = "Start Mission";
            x = 0.64;
            y = 0.68;
            w = 0.2;
            h = 0.06;
            action = "['startMission'] call front_fnc_missionBoard";
        };
        class CloseButton: RscButton
        {
            idc = 9805;
            text = "Close";
            x = 0.64;
            y = 0.76;
            w = 0.2;
            h = 0.06;
            action = "closeDialog 0";
        };
    };
};
