class RscDisplayFrontlinesBuild
{
    idd = 9800;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "['onLoad', _this] call front_fnc_buildMenu";
    onUnload = "['onUnload', _this] call front_fnc_buildMenu";

    class controlsBackground
    {
        class Background: RscText
        {
            idc = -1;
            x = 0.12; y = 0.12; w = 0.76; h = 0.76;
            colorBackground[] = {0,0,0,0.8};
        };
        class Header: RscText
        {
            idc = -1;
            text = "FOB Logistics";
            x = 0.12; y = 0.08; w = 0.76; h = 0.04;
            colorBackground[] = {0.1,0.4,0.8,0.9};
        };
    };

    class controls
    {
        class CategoryList: RscListbox
        {
            idc = 9801;
            x = 0.14; y = 0.16; w = 0.2; h = 0.66;
            onLBSelChanged = "['categoryChanged', _this] call front_fnc_buildMenu";
        };
        class ItemList: RscListbox
        {
            idc = 9802;
            x = 0.36; y = 0.16; w = 0.24; h = 0.66;
            onLBSelChanged = "['itemChanged', _this] call front_fnc_buildMenu";
        };
        class ItemDetails: RscStructuredText
        {
            idc = 9803;
            x = 0.62; y = 0.16; w = 0.24; h = 0.52;
            colorBackground[] = {0,0,0,0.4};
        };
        class BuildButton: RscButton
        {
            idc = 9804;
            text = "Build";
            x = 0.62; y = 0.70; w = 0.24; h = 0.06;
            action = "['build'] call front_fnc_buildMenu";
        };
        class CloseButton: RscButton
        {
            idc = 9805;
            text = "Close";
            x = 0.62; y = 0.78; w = 0.24; h = 0.06;
            action = "closeDialog 0";
        };
    };
};
