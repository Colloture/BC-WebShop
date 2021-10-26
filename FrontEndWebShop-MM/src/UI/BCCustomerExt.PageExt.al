pageextension 50100 "BCCustomerExt" extends "Customer List"
{
    actions
    {
        addfirst(navigation)
        {
            action(BCGetWebServiceItemList)
            {
                ApplicationArea = All;
                Caption = 'Get Web Service Item List';
                ToolTip = 'Executes the Get Web Service Item List action.';
                Image = Web;
                Promoted = true;
                RunObject = codeunit "BCGet Items";
            }
        }
    }
}