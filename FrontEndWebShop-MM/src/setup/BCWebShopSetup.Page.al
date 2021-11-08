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

                field(BackendWebServiceURL; Rec."Backend Web Service URL")
                {
                    ToolTip = 'Specifies the value of the Backend Web Service URL field.';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Last Date Modified Items"; Rec."Last Date Modified Items")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Modified Items field.';
                }

                group(BackEndWebServiceCredentials)
                {
                    Caption = 'Credentials';

                    field(BackendUsername; Rec."Backend Username")
                    {
                        Caption = 'Username';
                        ToolTip = 'Specifies the value of the Backend Username field.';
                        ApplicationArea = All;
                    }
                    field(BackendPassword; Rec."Backend Password")
                    {
                        Caption = 'Password';
                        ToolTip = 'Specifies the value of the Backend Password field.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Customer)
            {
                Caption = 'Customer Settings';
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field(CustomerPostingGroup; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Posting Group field.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                }
            }
            group(SalesOrder)
            {
                Caption = 'Sales Order Settings';

                field(SalesOrderDocumentType; Rec."Sales Order Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Document Type field.';
                }
                field(SalesLineType; Rec."Sales Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Line Type field.';
                }
            }
            group(GenJournalLine)
            {
                Caption = 'Gen. Journal Line Settings';

                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Method Code field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(BalAccountType; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }
                field(BalAccountNo; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(AppliesToDocType; "Applies To Doc. Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applies To Doc. Type field.';
                }
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
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