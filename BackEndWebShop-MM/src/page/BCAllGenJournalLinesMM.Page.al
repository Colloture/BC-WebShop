page 50137 "BCAllGenJournalLines-MM"
{
    Caption = 'All Gen. Journal Lines MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'allGenJournalLineMM';
    EntitySetName = 'allGenJournalLinesMM';
    SourceTable = "Gen. Journal Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
}