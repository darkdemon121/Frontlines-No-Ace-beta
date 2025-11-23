class RscDisplayInvasionIntelMap
{
    idd = 9900;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "['onLoad', _this] call front_fnc_intelMap";
    onUnload = "['onUnload', _this] call front_fnc_intelMap";

    class controlsBackground
    {
        class Background: RscText
        {
            idc = -1;
            x = 0.08; y = 0.08; w = 0.84; h = 0.84;
            colorBackground[] = {0,0,0,0.7};
        };
        class Header: RscText
        {
            idc = -1;
            text = "Tactical Map";
            x = 0.08; y = 0.06; w = 0.84; h = 0.04;
            colorBackground[] = {0,0.6,1,0.8};
        };
    };

    class controls
    {
        class Map: RscMapControl
        {
            idc = 9901;
            x = 0.1; y = 0.12; w = 0.8; h = 0.74;
        };
        class CloseButton: RscButton
        {
            idc = 9902;
            text = "Close";
            x = 0.72; y = 0.88; w = 0.18; h = 0.06;
            action = "closeDialog 0";
        };
    };
};
