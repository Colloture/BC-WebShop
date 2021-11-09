page 50108 "BCLogIn"
{
    Caption = 'Log In';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Username; Username)
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                    ToolTip = 'Specifies the value of the Username field.';
                    NotBlank = true;
                }
                field(Password; Password)
                {
                    ApplicationArea = All;
                    Caption = 'Password';
                    ToolTip = 'Specifies the value of the Password field.';
                    ExtendedDatatype = Masked;
                    NotBlank = true;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Register)
            {
                ApplicationArea = All;
                Caption = 'Register';
                ToolTip = 'Executes the Register action.';
                Image = LogSetup;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = VisibleAction;

                trigger OnAction()
                var
                    BCPostCustomer: Codeunit "BCPost Customer";
                    BCLoggedInUser: codeunit "BCLoggedIn User";
                begin
                    if (Username = '') or (Password = '') then
                        Error('You must fill in both Username and Password fields.');

                    BCLoggedInUser.SetUser(Username);
                    BCLoggedInUser.Register(Password);

                    BCPostCustomer.PostNewCustomer();
                    VisibleAction := false;
                    CurrPage.Close();
                    Page.Run(50102);
                end;
            }
            action(Login)
            {
                ApplicationArea = All;
                Caption = 'Log In';
                ToolTip = 'Executes the Login action.';
                Image = Log;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = VisibleAction;

                trigger OnAction()
                var
                    BCPostCustomer: Codeunit "BCPost Customer";
                    BCLoggedInUser: Codeunit "BCLoggedIn User";
                begin
                    if (Username = '') or (Password = '') then
                        Error('You must fill in both Username and Password fields.');

                    BCLoggedInUser.SetUser(Username);
                    BCLoggedInUser.ValidatePassword(Password);

                    BCPostCustomer.GetCustomer();
                    VisibleAction := false;
                    CurrPage.Close();
                    Page.Run(50102);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
    begin
        if BCLoggedInUser.GetUser() <> '' then begin
            Message('You''re already logged in.');
            exit;
        end;

        VisibleAction := true;
    end;

    var
        VisibleAction: Boolean;
        Username: Text[250];
        Password: Text[250];
}