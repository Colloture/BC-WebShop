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
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                    NotBlank = true;
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
                    if (Rec.Name = '') and (Rec."E-Mail" = '') then
                        exit;
                    BCPostCustomer.Run(Rec);
                    VisibleAction := false;
                    CurrPage.Close();
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
            Rec.Init();
            Rec.Name := BCWebShopSetup.LoggedInUsername;
            Rec."E-Mail" := BCWebShopSetup.LoggedInEmail;
            Rec.Insert();
            Message('You''re already logged in.');
            CurrPage.Close();
            exit;
        end;

        Rec.Init();
        Rec.Insert();
        VisibleAction := true;
    end;

    var
        VisibleAction: Boolean;
}