codeunit 50101 "BCGet Items"
{
    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCStoreItems: Record "BCStore Items";
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndWebShopUrlLbl: Label '%1/itemsMM?$filter=intern eq ''MM''', Comment = '%1 is Web Shop URL';
    begin
        BCWebShopSetup.Get();

        SetAuthorization(BCWebShopSetup, httpClient);

        httpClient.Get(StrSubstNo(BackEndWebShopUrlLbl, BCWebShopSetup."Backend Web Service URL"), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            ParseJson(ResponseText, BCStoreItems);
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure SetAuthorization(var BCWebShopSetup: Record "BCWeb Shop Setup"; var httpClient: httpClient)
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthString: Text;
        AuthLbl: Label 'Basic %1', Comment = '%1 is Auth String';
        UserPwdTok: Label '%1:%2', Comment = '%1 is Username, %2 is Password';
    begin
        AuthString := StrSubstNo(UserPwdTok, BCWebShopSetup."Backend Username", BCWebShopSetup."Backend Password");
        AuthString := Base64Convert.ToBase64(AuthString);
        httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(AuthLbl, AuthString));
    end;

    local procedure ParseJson(ResponseText: Text; var BCStoreItems: Record "BCStore Items")
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ItemJsonToken: JsonToken;
        ItemJsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(ResponseText);
        JsonObject.Get('value', JsonToken);
        JsonArray := JsonToken.AsArray();

        foreach ItemJsonToken in JsonArray do begin
            ItemJsonObject := ItemJsonToken.AsObject();

            BCStoreItems.Init();
            BCStoreItems."No." := CopyStr(GetFieldValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(BCStoreItems."No."));
            BCStoreItems.Description := CopyStr(GetFieldValue(ItemJsonObject, 'description').AsText(), 1, MaxStrLen(BCStoreItems.Description));
            BCStoreItems."Unit Price" := GetFieldValue(ItemJsonObject, 'unitPrice').AsDecimal();
            BCStoreItems.Inventory := GetFieldValue(ItemJsonObject, 'inventory').AsDecimal();
            BCStoreItems."Base Unit of Measure" := CopyStr(GetFieldValue(ItemJsonObject, 'baseUnitOfMeasure').AsCode(), 1, MaxStrLen(BCStoreItems."Base Unit of Measure"));
            BCStoreItems."Item Category" := CopyStr(GetFieldValue(ItemJsonObject, 'itemCategoryCode').AsCode(), 1, MaxStrLen(BCStoreItems."Item Category"));
            // TODO - add picture
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
}