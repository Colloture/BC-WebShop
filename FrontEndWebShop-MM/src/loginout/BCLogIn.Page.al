page 50108 "BCLogIn"
{
    Caption = 'Log In';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = BCLogIn;

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
                    NotBlank = true;
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
                    NotBlank = true;
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
        area(Navigation)
        {
            action(LogIn)
            {
                ApplicationArea = All;
                Caption = 'Log In';
                ToolTip = 'Executes the Log In action.';
                Image = Log;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = VisibleAction;

                trigger OnAction()
                var
                    BCPostCustomer: Codeunit "BCPost Customer";
                begin
                    BCPostCustomer.Run(Rec);
                    VisibleAction := false;
                    Page.Run(50102);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername <> '') and (BCWebShopSetup.LoggedInEmail <> '') then begin
            Message('You''re already logged in.');
            exit;
        end;
        VisibleAction := true;
    end;

    var
        VisibleAction: Boolean;
}