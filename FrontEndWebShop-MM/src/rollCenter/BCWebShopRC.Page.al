page 50103 "BCWeb Shop RC"
{
    Caption = 'Web Shop RC';
    PageType = RoleCenter;
    RefreshOnActivate = true;
    SourceTable = "BCSports Equipment Cue";

    layout
    {
        area(RoleCenter)
        {
            part(HeadlineTxt; "BCWeb Shop Headline")
            {
                ApplicationArea = All;
            }

            group(General)
            {
                part(SportsEquipmentQueue; "BCSports Equipment Queue")
                {
                    ApplicationArea = All;
                }
                part(UserInformationQueue; "BCUser Information Queue")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                part(SportsQueue; "BCSports Queue")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                part(BrandsQueue; "BCBrands Queue")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(LogIn)
            {
                ApplicationArea = All;
                Caption = 'Log In';
                ToolTip = 'Executes the Log In action.';
                RunObject = page BCLogIn;
            }
            action(LogOut)
            {
                ApplicationArea = All;
                Caption = 'Log Out';
                ToolTip = 'Executes the Log Out action.';
                RunObject = codeunit BCLogOut;
            }
        }
        area(Processing)
        {
            action(AllStoreItems)
            {
                ApplicationArea = All;
                Caption = 'All Store Items';
                ToolTip = 'Executes the All Store Items action.';
                RunObject = page "BCStore Items";
            }
        }
    }
}