codeunit 50114 "BCPostSalesOrder"
{
    procedure CreateOrder(var BCWebShopSetup: Record "BCWeb Shop Setup"; var BCCart: Record BCCart; httpClient: httpClient; var SalesHeaderNo: Code[20]; var SalesHeaderDocumentType: Text; var PostedSalesHeaderNo: Code[20])
    var
        SalesLineNo: Integer;
    begin
        PostSalesHeader(BCWebShopSetup, SalesHeaderNo, SalesHeaderDocumentType, httpClient);

        SalesLineNo := 10000;
        repeat
            PostSalesLine(BCWebShopSetup, SalesHeaderNo, SalesHeaderDocumentType, SalesLineNo, BCCart, httpClient);
            SalesLineNo += 10000;
        until BCCart.Next() = 0;

        PostOrder(BCWebShopSetup, SalesHeaderNo, SalesHeaderDocumentType, PostedSalesHeaderNo, httpClient);
    end;

    local procedure PostSalesHeader(var BCWebShopSetup: Record "BCWeb Shop Setup"; var SalesHeaderNo: Code[20]; var SalesHeaderDocumentType: Text; httpClient: httpClient)
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        Text: Text;
        Response: Text;
        JsonObject: JsonObject;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndPostUrlLbl: Label '%1/salesHeadersMM', Comment = '%1 is Web Shop URL';
    begin
        JsonObject.Add('documentType', BCWebShopSetup."Sales Order Document Type");
        JsonObject.Add('sellToCustomerNo', BCLoggedInUser.GetUserNo());
        JsonObject.WriteTo(Text);

        httpContent.WriteFrom(Text);
        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Remove('Content-Type');
        httpHeaders.Add('Content-Type', 'application/json');

        httpRequestMessage.Content := httpContent;
        httpRequestMessage.SetRequestUri(StrSubstNo(BackEndPostUrlLbl, BCWebShopSetup."Backend Web Service URL"));
        httpRequestMessage.Method := 'POST';

        httpClient.Send(httpRequestMessage, HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(Response);
            ParseResponseSalesHeader(Response, SalesHeaderNo, SalesHeaderDocumentType);
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseResponseSalesHeader(ResponseText: Text; var SalesHeaderNo: Code[20]; var SalesHeaderDocumentType: Text)
    var
        JsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(ResponseText);
        SalesHeaderNo := CopyStr(GetFieldValue(JsonObject, 'no').AsCode(), 1, MaxStrLen(SalesHeaderNo));
        SalesHeaderDocumentType := GetFieldValue(JsonObject, 'documentType').AsText();
    end;

    local procedure PostSalesLine(var BCWebShopSetup: Record "BCWeb Shop Setup"; SalesHeaderNo: Code[20]; SalesHeaderDocumentType: Text; LineNo: Integer; var BCCart: Record BCCart; httpClient: httpClient)
    var
        Text: Text;
        JsonObject: JsonObject;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndPostUrlLbl: Label '%1/salesLinesMM', Comment = '%1 is Web Shop URL';
    begin
        JsonObject.Add('documentType', SalesHeaderDocumentType);
        JsonObject.Add('documentNo', SalesHeaderNo);
        JsonObject.Add('lineNo', LineNo);
        JsonObject.Add('type', BCWebShopSetup."Sales Line Type");
        JsonObject.Add('itemNo', BCCart."Item No.");
        JsonObject.Add('quantity', BCCart.Quantity);
        JsonObject.Add('quantityToShip', BCCart.Quantity);
        JsonObject.Add('unitPrice', BCCart."Unit Price");
        JsonObject.WriteTo(Text);

        httpContent.WriteFrom(Text);
        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Remove('Content-Type');
        httpHeaders.Add('Content-Type', 'application/json');

        httpRequestMessage.Content := httpContent;
        httpRequestMessage.SetRequestUri(StrSubstNo(BackEndPostUrlLbl, BCWebShopSetup."Backend Web Service URL"));
        httpRequestMessage.Method := 'POST';

        httpClient.Send(httpRequestMessage, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode() then
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure PostOrder(var BCWebShopSetup: Record "BCWeb Shop Setup"; SalesHeaderNo: Code[20]; SalesHeaderDocumentType: Text; var PostedSalesHeaderNo: Code[20]; httpClient: HttpClient)
    var
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        JsonObject: JsonObject;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndWebShopUrlLbl: Label '%1/postingSalesOrdersMM?$filter=documentType eq ''%2'' and no eq ''%3''', Comment = '%1 is Web Shop URL, %2 is document type, %3 is document no.';
    begin

        httpClient.Get(StrSubstNo(BackEndWebShopUrlLbl, BCWebShopSetup."Backend Web Service URL", SalesHeaderDocumentType, SalesHeaderNo), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            JsonObject.ReadFrom(ResponseText);
            ParseJson(ResponseText, PostedSalesHeaderNo);
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseJson(ResponseText: Text; var PostedSalesHeaderNo: Code[20]): Boolean
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
            foreach JsonToken in JsonArray do begin
                JsonObject := JsonToken.AsObject();
                PostedSalesHeaderNo := CopyStr(GetFieldValue(JsonObject, 'postedNo').AsCode(), 1, MaxStrLen(PostedSalesHeaderNo));
                exit(true);
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