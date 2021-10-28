pageextension 50100 "BCCustomerExt" extends "Customer List"
{
    actions
    {
        addfirst(navigation)
        {
            // TODO - izmestiti ove akcije na pravo mesto
            action(BCGetWebServiceItemList)
            {
                ApplicationArea = All;
                Caption = 'Get Web Service Item List';
                ToolTip = 'Executes the Get Web Service Item List action.';
                Image = Web;
                Promoted = true;
                RunObject = codeunit "BCGet Items";
            }
            action(BCTestPassword)
            {
                ApplicationArea = All;
                Caption = 'Test Password';
                Image = Pause;
                Promoted = true;
                RunObject = codeunit BCPasswordEncryption;
                ToolTip = 'Executes the Test Password action.';
            }
        }
    }
}