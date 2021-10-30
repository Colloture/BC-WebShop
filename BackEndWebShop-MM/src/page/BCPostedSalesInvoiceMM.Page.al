page 50138 "BCPostedSalesInvoice-MM"
{
    Caption = 'Posted Sales Invoice MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'postedSalesInvoiceMM';
    EntitySetName = 'postedSalesInvoicesMM';
    SourceTable = "Sales Invoice Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(customerNo; Rec."Sell-to Customer No.")
                {
                }
                field(orderNo; Rec."Order No.")
                {
                }
                field(postingDate; Rec."Posting Date")
                {
                }
                field(postedNo; Rec."No.")
                {
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                }
                field(currencyCode; Rec."Currency Code")
                {
                }
            }
        }
    }
}