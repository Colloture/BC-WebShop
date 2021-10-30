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
                field(itemCategoryCode; Rec."Item Category Code")
                {
                }
                field(image; Image)
                {
                }
                field(mime; Mime)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetItemImage(Rec);
    end;

    var
        Mime: Text;
        Image: Text;

    local procedure GetItemImage(var Item: Record Item)
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        MediaInStream: InStream;
    begin
        if Item.Picture.Count = 0 then begin
            Mime := '';
            Image := '';
            exit;
        end;

        TenantMedia.Get(Item.Picture.Item(1));
        TenantMedia.CalcFields(Content);

        if TenantMedia.Content.HasValue() then begin
            TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);
            Image := Base64Convert.ToBase64(MediaInStream);
            Mime := TenantMedia."Mime Type";
        end;
    end;
}