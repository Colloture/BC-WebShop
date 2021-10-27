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
                field(image; GetItemImage(Rec))
                {
                }
            }
        }
    }

    local procedure GetItemImage(var Item: Record Item): Text
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        MediaInStream: InStream;
        MediaJsonObject: JsonObject;
        MediaJsonToken: JsonToken;
    begin
        if Item.Picture.Count = 0 then
            exit('');

        TenantMedia.Get(Item.Picture.Item(1)); // zelimo samo prvu sliku 
        TenantMedia.CalcFields(Content); // stvarno preuzimanje slike iz baze

        if not TenantMedia.Content.HasValue then
            exit('');

        TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);
        MediaJsonObject.Add('image', Base64Convert.ToBase64(MediaInStream)); // "cudna slova" prilagodjava json-u
        MediaJsonObject.SelectToken('image', MediaJsonToken); // uzimamo vrednost 

        // TODO na frontend-u idemo OutStream ili kako smo do sada radili

        exit(MediaJsonToken.AsValue().AsText());
    end;
}