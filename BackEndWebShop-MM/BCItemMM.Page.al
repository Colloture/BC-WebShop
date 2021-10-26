page 50110 "BCItem-MM"
{
    Caption = 'Item MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'itemMM';
    EntitySetName = 'itemsMM';
    UsageCategory = Administration;
    SourceTable = Item;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(number; Rec."No.")
                {
                }
                field(displayName; Rec.Description)
                {
                }
            }
        }
    }
}