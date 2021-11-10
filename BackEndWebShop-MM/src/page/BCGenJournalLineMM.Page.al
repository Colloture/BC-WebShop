page 50139 "BCGenJournalLine-MM"
{
    Caption = 'Gen. Journal Line MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'genJournalLineMM';
    EntitySetName = 'genJournalLinesMM';
    SourceTable = "Gen. Journal Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(postingDate; Rec."Posting Date")
                {
                }
                field(documentType; Rec."Document Type")
                {
                }
                field(documentNo; Rec."Document No.")
                {
                }
                field(accountType; Rec."Account Type")
                {
                }
                field(accountNo; Rec."Account No.")
                {
                }
                field(currencyCode; Rec."Currency Code")
                {
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                }
                field(amount; Rec.Amount)
                {
                }
                field(appliesToDocType; Rec."Applies-to Doc. Type")
                {
                }
                field(appliesToDocNo; Rec."Applies-to Doc. No.")
                {
                }
                field(balAccountType; Rec."Bal. Account Type")
                {
                }
                field(balAccountNo; Rec."Bal. Account No.")
                {
                }
                field(journalTemplateName; Rec."Journal Template Name")
                {
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                }
                field(lineNo; Rec."Line No.")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Codeunit.Run(CODEUNIT::"Gen. Jnl.-Post Line", Rec);
    end;
}