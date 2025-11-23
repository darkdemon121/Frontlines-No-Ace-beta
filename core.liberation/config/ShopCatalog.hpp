class ShopCatalog
{
    baseIncome = 100; // baseline hourly income used with percentage bonuses
    missionBonusPercent = 5;
    sectorBonusPercent = 3;
    startingFunds = 500;
    class Categories
    {
        class Weapons
        {
            displayName = "Weapons";
            items[] = {
                {"MX 6.5mm", "arifle_MX_F", 200, "weapon"},
                {"MXC 6.5mm", "arifle_MXC_F", 180, "weapon"},
                {"Katiba 6.5mm", "arifle_Katiba_F", 190, "weapon"},
                {"MK200 LMG", "LMG_Mk200_F", 320, "weapon"},
                {"Rahim DMR", "srifle_DMR_01_F", 280, "weapon"}
            };
        };
        class Gear
        {
            displayName = "Gear";
            items[] = {
                {"Combat Fatigues", "U_B_CombatUniform_mcam", 80, "item"},
                {"Plate Carrier", "V_PlateCarrier1_rgr", 90, "item"},
                {"Fast Helmet", "H_HelmetSpecB", 70, "item"},
                {"Backpack", "B_AssaultPack_mcamo", 60, "item"},
                {"NV Goggles", "NVGoggles", 120, "item"}
            };
        };
        class Vehicles
        {
            displayName = "Vehicles";
            items[] = {
                {"Quad Bike", "B_Quadbike_01_F", 150, "vehicle"},
                {"Offroad", "C_Offroad_01_F", 220, "vehicle"},
                {"Transport Truck", "B_Truck_01_transport_F", 380, "vehicle"},
                {"APC (Unarmed)", "B_APC_Wheeled_01_cannon_F", 900, "vehicle"}
            };
        };
        class Supplies
        {
            displayName = "Supplies";
            items[] = {
                {"5.56mm Mag", "30Rnd_556x45_Stanag", 20, "magazine"},
                {"6.5mm Mag", "30Rnd_65x39_caseless_mag", 24, "magazine"},
                {"9mm Mag", "16Rnd_9x21_Mag", 12, "magazine"},
                {"Explosive Charge", "DemoCharge_Remote_Mag", 90, "magazine"},
                {"Medikit", "Medikit", 140, "item"}
            };
        };
    };
};
