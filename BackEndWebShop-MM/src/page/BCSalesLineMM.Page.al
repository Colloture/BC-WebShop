page 50113 "BCSalesLine-MM"
{
    Caption = 'Sales Line MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'salesLineMM';
    EntitySetName = 'salesLinesMM';
    SourceTable = "Sales Line";
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
                field(documentNo; Rec."Document No.")
                {
                }
                field(lineNo; Rec."Line No.")
                {
                }
                field(type; Rec.Type)
                {
                }
                field(itemNo; Rec."No.")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(quantityToShip; Rec."Qty. to Ship")
                {
                }
                field(unitPrice; Rec."Unit Price")
                {
                }
            }
        }
    }
}