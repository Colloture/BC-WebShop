pageextension 50100 "BCCustomerExt" extends "Customer List"
{
    actions
    {
        addfirst(navigation)
        {
            // TODO - izmestiti ove akcije na pravo mesto
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