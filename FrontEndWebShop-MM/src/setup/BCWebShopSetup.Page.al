page 50101 "BCWeb Shop Setup"
{
    Caption = 'Web Shop Setup';
    PageType = Card;
    SourceTable = "BCWeb Shop Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(BackEndWebService)
            {
                Caption = 'BackEnd Web Service';

                field("Backend Web Service URL"; Rec."Backend Web Service URL")
                {
                    ToolTip = 'Specifies the value of the Backend Web Service URL field.';
                    ApplicationArea = All;
                    MultiLine = true;
                }

                group(BackEndWebServiceCredentials)
                {
                    Caption = 'Credentials';

                    field("Backend Username"; Rec."Backend Username")
                    {
                        Caption = 'Username';
                        ToolTip = 'Specifies the value of the Backend Username field.';
                        ApplicationArea = All;
                    }
                    field("Backend Password"; Rec."Backend Password")
                    {
                        Caption = 'Password';
                        ToolTip = 'Specifies the value of the Backend Password field.';
                        ApplicationArea = All;
                    }
                }
                group("Logged In")
                {
                    field(LoggedInUsername; Rec.LoggedInUsername)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Username of logged in user.';
                    }
                    field(LoggedInEmail; Rec.LoggedInEmail)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Email of logged in user.';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Backend Web Service URL" := 'https://<servername>/<service>/api/1.0';
            Rec.Insert();
        end;
    end;
}