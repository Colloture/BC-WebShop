codeunit 50101 "BCGet Items"
{
    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        TempItem: Record Item temporary;
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
            ParseJson(ResponseText, TempItem);
            Page.Run(0, TempItem);
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

    local procedure ParseJson(AuthString: Text; var TempItem: Record Item temporary)
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ItemJsonToken: JsonToken;
        ItemJsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(AuthString);
        JsonObject.Get('value', JsonToken);
        JsonArray := JsonToken.AsArray();

        foreach ItemJsonToken in JsonArray do begin
            ItemJsonObject := ItemJsonToken.AsObject();

            TempItem.Init();
            TempItem."No." := CopyStr(GetFieldValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(TempItem."No."));
            TempItem.Description := CopyStr(GetFieldValue(ItemJsonObject, 'description').AsText(), 1, MaxStrLen(TempItem.Description));
            TempItem."Unit Price" := GetFieldValue(ItemJsonObject, 'unitPrice').AsDecimal();
            TempItem.Inventory := GetFieldValue(ItemJsonObject, 'inventory').AsDecimal();
            TempItem."Base Unit of Measure" := CopyStr(GetFieldValue(ItemJsonObject, 'baseUnitOfMeasure').AsCode(), 1, MaxStrLen(TempItem."Base Unit of Measure"));
            // TODO - add picture
            TempItem.Insert();
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