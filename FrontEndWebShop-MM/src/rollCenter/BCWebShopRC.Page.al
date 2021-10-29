page 50103 "BCWeb Shop RC"
{
    Caption = 'Web Shop RC';
    PageType = RoleCenter;
    SourceTable = "BCSports Equipment Cue";

    layout
    {
        area(RoleCenter)
        {
            // TODO - add part with photo
            part(HeadlineTxt; "BCWeb Shop Headline")
            {
                ApplicationArea = All;
            }

            group(General)
            {
                part(RetailQueue; "BCSports Equipment Queue")
                {
                    ApplicationArea = All;
                }
                part(UserInformationQueue; "BCUser Information Queue")
                {
                    ApplicationArea = All;
                    Visible = true; // TODO - visible if user is logged in
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
            // TODO - visible only when logged in
            action(AllStoreItems)
            {
                ApplicationArea = All;
                Caption = 'All Store Items';
                ToolTip = 'Executes the All Store Items action.';
                RunObject = page "BCStore Items";
            }
            action(RequestNew)
            {
                ApplicationArea = All;
                Caption = 'Request New Item';
                ToolTip = 'Executes the Request New Item action.';
                RunObject = page "BCStore Items"; // TODO - link ka Request new-u stranici
            }
        }
    }
}