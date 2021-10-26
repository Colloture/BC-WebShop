page 50110 "BCItem-MM"
{
    Caption = 'Item MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'itemMM';
    EntitySetName = 'itemsMM';
    SourceTable = Item;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(number; Rec."No.")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(unitPrice; Rec."Unit Price")
                {
                }
                field(inventory; Rec.Inventory)
                {
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                }
                field(intern; Rec.BCIntern)
                {
                }
                field(picture; Rec.Picture)
                {
                }
            }
        }
    }
}