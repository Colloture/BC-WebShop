codeunit 50105 "BCPost Customer"
{
    TableNo = BCLogIn;

    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        BackEndGetUrlLbl: Label '%1/customersMM?$filter=name eq ''%2'' and email eq ''%3''', Comment = '%1 is Web Shop URL, %2 is name, %3 is email';
        ResponseText: Text;
    begin
        BCWebShopSetup.Get();

        SetAuthorization(BCWebShopSetup, httpClient);

        httpClient.Get(StrSubstNo(BackEndGetUrlLbl, BCWebShopSetup."Backend Web Service URL", Rec.Name, Rec."E-Mail"), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            if CustomerExists(ResponseText) then
                Message('Welcome back.')
            else
                PostNewCustomer(Rec, HttpResponseMessage, BCWebShopSetup, httpClient);
        end;
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

    local procedure CustomerExists(ResponseText: Text): Boolean
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
    begin
        JsonObject.ReadFrom(ResponseText);
        JsonObject.Get('value', JsonToken);
        JsonArray := JsonToken.AsArray();
        if JsonArray.Count = 0 then
            exit(false)
        else
            exit(true);
    end;

    local procedure PostNewCustomer(var BCLogIn: Record BCLogIn; HttpResponseMessage: HttpResponseMessage; var BCWebShopSetup: Record "BCWeb Shop Setup"; httpClient: httpClient)
    var
        Text: Text;
        JsonObject: JsonObject;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        httpRequestMessage: HttpRequestMessage;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndPostUrlLbl: Label '%1/customersMM', Comment = '%1 is Web Shop URL';
    begin
        JsonObject.Add('name', BCLogIn.Name);
        JsonObject.Add('email', BCLogIn."E-Mail");
        JsonObject.Add('address', BCLogIn.Address);
        JsonObject.Add('phone', BCLogIn."Phone No.");
        JsonObject.WriteTo(Text);

        httpContent.WriteFrom(Text);
        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Clear();
        httpHeaders.Add('Content-Type', 'application/json');
        httpRequestMessage.Content := httpContent;
        httpRequestMessage.SetRequestUri(StrSubstNo(BackEndPostUrlLbl, BCWebShopSetup."Backend Web Service URL"));
        httpRequestMessage.Method := 'POST';

        httpClient.Send(httpRequestMessage, HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then
            Message('Successfull login.')
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;
}