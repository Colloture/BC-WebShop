codeunit 50105 "BCPost Customer"
{
    procedure GetCustomer()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        BCAuthorization: Codeunit BCAuthorization;
        ResponseText: Text;
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        BackEndGetUrlLbl: Label '%1/customersMM?$filter=name eq ''%2''', Comment = '%1 is Web Shop URL, %2 is name';
    begin
        BCWebShopSetup.Get();

        BCAuthorization.SetAuthorization(BCWebShopSetup, httpClient);

        httpClient.Get(StrSubstNo(BackEndGetUrlLbl, BCWebShopSetup."Backend Web Service URL", BCLoggedInUser.GetUser()), HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode() then
            Error('Something went wrong while logging in.');

        HttpResponseMessage.Content.ReadAs(ResponseText);

        JsonObject.ReadFrom(ResponseText);
        JsonObject.Get('value', JsonToken);
        JsonArray := JsonToken.AsArray();

        if JsonArray.Count = 0 then
            exit
        else
            foreach JsonToken in JsonArray do begin
                JsonObject := JsonToken.AsObject();
                ResponseText := GetFieldValue(JsonObject, 'no').AsCode();

                BCLoggedInUser.SetUserNo(ResponseText);
                Message('Successfully logged in.');
                exit;
            end;
    end;

    procedure PostNewCustomer()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        BCAuthorization: Codeunit BCAuthorization;
        ResponseText: Text;
        httpClient: httpClient;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        httpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndPostUrlLbl: Label '%1/customersMM', Comment = '%1 is Web Shop URL';
    begin
        BCWebShopSetup.Get();
        BCAuthorization.SetAuthorization(BCWebShopSetup, httpClient);

        httpContent.WriteFrom(CreateJsonObject(BCWebShopSetup));
        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Remove('Content-Type');
        httpHeaders.Add('Content-Type', 'application/json');

        httpRequestMessage.Content := httpContent;
        httpRequestMessage.SetRequestUri(StrSubstNo(BackEndPostUrlLbl, BCWebShopSetup."Backend Web Service URL"));
        httpRequestMessage.Method := 'POST';

        httpClient.Send(httpRequestMessage, HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            ParseResponse(ResponseText);

            BCLoggedInUser.SetUserNo(ResponseText);
            Message('Successfull register.')
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure CreateJsonObject(var BCWebShopSetup: Record "BCWeb Shop Setup"): Text
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        JsonObject: JsonObject;
        Text: Text;
    begin
        JsonObject.Add('name', BCLoggedInUser.GetUser());
        JsonObject.Add('genBusPostingGroup', BCWebShopSetup."Gen. Bus. Posting Group");
        JsonObject.Add('customerPostingGroup', BCWebShopSetup."Customer Posting Group");
        JsonObject.Add('paymentTermsCode', BCWebShopSetup."Payment Terms Code");
        JsonObject.WriteTo(Text);
        exit(Text);
    end;

    local procedure ParseResponse(var ResponseText: Text)
    var
        JsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(ResponseText);
        ResponseText := GetFieldValue(JsonObject, 'no').AsCode();
    end;

    local procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;
}