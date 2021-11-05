codeunit 50101 "BCGet Items"
{
    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCStoreItems: Record "BCStore Items";
        BCAuthorization: Codeunit BCAuthorization;
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndWebShopUrAllItemslLbl: Label '%1/itemsMM?$filter=intern eq ''MM''', Comment = '%1 is Web Shop URL';
        BackEndWebShopUrNewItemslLbl: Label '%1/itemsMM?$filter=intern eq ''MM'' and lastModifiedDateTime gt %2', Comment = '%1 is Web Shop URL, %2 is last date modified items';
    begin
        BCWebShopSetup.Get();

        BCAuthorization.SetAuthorization(BCWebShopSetup, httpClient);

        if BCWebShopSetup."Last Date Modified Items" = '' then
            httpClient.Get(StrSubstNo(BackEndWebShopUrAllItemslLbl, BCWebShopSetup."Backend Web Service URL"), HttpResponseMessage)
        else
            httpClient.Get(StrSubstNo(BackEndWebShopUrNewItemslLbl, BCWebShopSetup."Backend Web Service URL", BCWebShopSetup."Last Date Modified Items"), HttpResponseMessage);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            ParseJson(ResponseText, BCStoreItems);

            BCWebShopSetup."Last Date Modified Items" := Format(CurrentDateTime, 0, 9);
            BCWebShopSetup.Modify();
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseJson(ResponseText: Text; var BCStoreItems: Record "BCStore Items")
    var
        ItemNo: Code[20];
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ItemJsonToken: JsonToken;
        ItemJsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(ResponseText);
        JsonObject.Get('value', JsonToken);
        JsonArray := JsonToken.AsArray();
        if JsonArray.Count = 0 then
            exit;

        foreach ItemJsonToken in JsonArray do begin
            ItemJsonObject := ItemJsonToken.AsObject();

            ItemNo := CopyStr(GetFieldValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(BCStoreItems."No."));
            if BCStoreItems.Get(ItemNo) then
                BCStoreItems.Delete();

            BCStoreItems.Init();
            BCStoreItems."No." := CopyStr(GetFieldValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(BCStoreItems."No."));
            BCStoreItems.Description := CopyStr(GetFieldValue(ItemJsonObject, 'description').AsText(), 1, MaxStrLen(BCStoreItems.Description));
            BCStoreItems."Unit Price" := GetFieldValue(ItemJsonObject, 'unitPrice').AsDecimal();
            BCStoreItems.Inventory := GetFieldValue(ItemJsonObject, 'inventory').AsDecimal();
            BCStoreItems."Base Unit of Measure" := CopyStr(GetFieldValue(ItemJsonObject, 'baseUnitOfMeasure').AsCode(), 1, MaxStrLen(BCStoreItems."Base Unit of Measure"));
            BCStoreItems."Item Category" := CopyStr(GetFieldValue(ItemJsonObject, 'itemCategoryCode').AsCode(), 1, MaxStrLen(BCStoreItems."Item Category"));
            BCStoreItems."Last Date Modified" := GetFieldValue(ItemJsonObject, 'lastModifiedDateTime').AsDateTime();
            BCStoreItems.Sport := CopyStr(GetFieldValue(ItemJsonObject, 'sport').AsText(), 1, MaxStrLen(BCStoreItems.Sport));
            BCStoreItems.Brand := CopyStr(GetFieldValue(ItemJsonObject, 'brand').AsText(), 1, MaxStrLen(BCStoreItems.Brand));
            GetItemImage(BCStoreItems, ItemJsonObject);

            BCStoreItems.Insert();
        end;
    end;

    local procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;

    local procedure GetItemImage(var BCStoreItems: Record "BCStore Items"; ItemJsonObject: JsonObject)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        ImageDataBase64: Text;
        Mime: Text;
        InStream: InStream;
        OutStream: OutStream;
    begin
        TempBlob.CreateOutStream(OutStream);
        ImageDataBase64 := GetFieldValue(ItemJsonObject, 'image').AsText();
        if ImageDataBase64 = '' then
            exit;

        Base64Convert.FromBase64(ImageDataBase64, OutStream);
        TempBlob.CreateInStream(InStream);
        Mime := GetFieldValue(ItemJsonObject, 'mime').AsText();

        BCStoreItems.Image.ImportStream(InStream, 'pictureName.jpg', mime);
    end;
}