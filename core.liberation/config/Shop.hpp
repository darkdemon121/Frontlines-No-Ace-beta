class RscDisplayFrontShop
{
    idd = 9900;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "['onLoad', _this] call front_fnc_shopMenu";
    onUnload = "['onUnload', _this] call front_fnc_shopMenu";

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
            text = "Town Market";
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
            idc = 9901;
            x = 0.16;
            y = 0.18;
            w = 0.22;
            h = 0.66;
            onLBSelChanged = "['categoryChanged', _this] call front_fnc_shopMenu";
        };
        class ItemList: RscListbox
        {
            idc = 9902;
            x = 0.40;
            y = 0.18;
            w = 0.26;
            h = 0.66;
            onLBSelChanged = "['itemChanged', _this] call front_fnc_shopMenu";
        };
        class ItemDetails: RscStructuredText
        {
            idc = 9903;
            x = 0.68;
            y = 0.18;
            w = 0.2;
            h = 0.48;
            colorBackground[] = {0,0,0,0.4};
        };
        class PurchaseButton: RscButton
        {
            idc = 9904;
            text = "Purchase";
            x = 0.68;
            y = 0.68;
            w = 0.2;
            h = 0.06;
            action = "['purchase'] call front_fnc_shopMenu";
        };
        class CloseButton: RscButton
        {
            idc = 9905;
            text = "Close";
            x = 0.68;
            y = 0.76;
            w = 0.2;
            h = 0.06;
            action = "closeDialog 0";
        };
    };
};
