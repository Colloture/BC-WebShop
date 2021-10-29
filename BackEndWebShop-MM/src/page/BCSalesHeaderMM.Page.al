page 50112 "BCSalesHeader-MM"
{
    Caption = 'Sales Header MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'salesHeaderMM';
    EntitySetName = 'salesHeadersMM';
    SourceTable = "Sales Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentType; Rec."Document Type")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                }
            }
        }
    }
}