page 50108 "BCLogIn"
{
    Caption = 'Log In';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = BCLogIn;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
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
                Image = Log;
                Promoted = true;
                PromotedOnly = true;
                Visible = VisibleAction;

                trigger OnAction()
                var
                    BCPostCustomer: Codeunit "BCPost Customer";
                begin
                    if (Rec.Name = '') or (Rec."E-Mail" = '') then
                        Error('Name and E-Mail must be filled in.');

                    BCPostCustomer.Run(Rec);

                    VisibleAction := false;
                    Page.Run(50102);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        VisibleAction := true;
    end;

    var
        VisibleAction: Boolean;
}