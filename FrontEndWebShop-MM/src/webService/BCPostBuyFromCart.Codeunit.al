codeunit 50107 "BCPostBuyFromCart"
{
    TableNo = BCCart;

    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        httpClient: httpClient;
        SalesHeaderNo: Code[20];
        SalesHeaderDocumentType: Text;
        PostedSalesHeaderNo: Code[20];
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername = '') and (BCWebShopSetup.LoggedInEmail = '') then
            Error('Please Log In in order to Buy Items.');

        if Rec.Count = 0 then
            Error('Your Cart is empty.');

        SetAuthorization(BCWebShopSetup, httpClient);

        CreateOrder(BCWebShopSetup, Rec, httpClient, SalesHeaderNo, SalesHeaderDocumentType);
        GetPostOrder(BCWebShopSetup, SalesHeaderNo, SalesHeaderDocumentType, PostedSalesHeaderNo, httpClient);
        PostCreatePayment(BCWebShopSetup, httpClient, SalesHeaderNo);

        Rec.DeleteAll();
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

    local procedure CreateOrder(var BCWebShopSetup: Record "BCWeb Shop Setup"; var BCCart: Record BCCart; httpClient: httpClient; var SalesHeaderNo: Code[20]; var SalesHeaderDocumentType: Text)
    var
        SalesLineNo: Integer;
    begin
        PostSalesHeader(BCWebShopSetup, SalesHeaderNo, SalesHeaderDocumentType, httpClient);

        SalesLineNo := 10000;
        repeat
            PostSalesLine(BCWebShopSetup, SalesHeaderNo, SalesHeaderDocumentType, SalesLineNo, BCCart, httpClient);
            SalesLineNo += 10000;
        until BCCart.Next() = 0;
    end;

    local procedure PostSalesHeader(var BCWebShopSetup: Record "BCWeb Shop Setup"; var SalesHeaderNo: Code[20]; var SalesHeaderDocumentType: Text; httpClient: httpClient)
    var
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
        JsonObject.Add('documentType', 'Order');
        JsonObject.Add('sellToCustomerNo', BCWebShopSetup.UserNo);
        JsonObject.WriteTo(Text);

        httpContent.WriteFrom(Text);
        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Clear();
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
        JsonObject.Add('type', 'Item');
        JsonObject.Add('itemNo', BCCart."Item No.");
        JsonObject.Add('quantity', BCCart.Quantity);
        JsonObject.Add('quantityToShip', BCCart.Quantity);
        JsonObject.Add('unitPrice', BCCart."Unit Price");
        JsonObject.WriteTo(Text);

        httpContent.WriteFrom(Text);
        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Clear();
        httpHeaders.Add('Content-Type', 'application/json');
        httpRequestMessage.Content := httpContent;
        httpRequestMessage.SetRequestUri(StrSubstNo(BackEndPostUrlLbl, BCWebShopSetup."Backend Web Service URL"));
        httpRequestMessage.Method := 'POST';

        httpClient.Send(httpRequestMessage, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode() then
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure GetPostOrder(var BCWebShopSetup: Record "BCWeb Shop Setup"; SalesHeaderNo: Code[20]; SalesHeaderDocumentType: Text; var PostedSalesHeaderNo: Code[20]; httpClient: HttpClient)
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

    local procedure PostCreatePayment(var BCWebShopSetup: Record "BCWeb Shop Setup"; httpClient: httpClient; SalesHeaderNo: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
        TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
        Text: Text;
        LineNo: Integer;
        JsonObject: JsonObject;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        WebErrorMsg: Label 'Error occurred: %1 - %2', Comment = '%1 is HTTP Status Code, %2 is message';
        BackEndPostUrlLbl: Label '%1/genJournalLinesMM', Comment = '%1 is Web Shop URL';
    begin
        if GetPostedSalesInvoice(BCWebShopSetup, TempSalesInvoiceHeader, httpClient, SalesHeaderNo) then begin

            TempSalesInvoiceHeader.CalcFields("Amount Including VAT");

            JsonObject.Add('postingDate', '2023-01-26');
            JsonObject.Add('documentType', BCWebShopSetup."Document Type");
            JsonObject.Add('documentNo', CopyStr('PAY-' + TempSalesInvoiceHeader."No.", 1, MaxStrLen(GenJournalLine."Document No.")));
            JsonObject.Add('accountType', BCWebShopSetup."Account Type");
            JsonObject.Add('accountNo', BCWebShopSetup.UserNo);
            JsonObject.Add('currencyCode', TempSalesInvoiceHeader."Currency Code");
            JsonObject.Add('paymentMethodCode', BCWebShopSetup."Payment Method Code");
            JsonObject.Add('creditAmount', TempSalesInvoiceHeader."Amount Including VAT");
            JsonObject.Add('appliesToDocType', BCWebShopSetup."Applies To Doc. Type");
            JsonObject.Add('appliesToDocNo', TempSalesInvoiceHeader."No.");
            JsonObject.Add('balAccountType', BCWebShopSetup."Bal. Account Type");
            JsonObject.Add('balAccountNo', BCWebShopSetup."Bal. Account No.");
            JsonObject.Add('journalTemplateName', BCWebShopSetup."Journal Template Name");
            JsonObject.Add('journalBatchName', BCWebShopSetup."Journal Batch Name");
            if GetLastGenJournalLine(BCWebShopSetup, httpClient, LineNo) then
                LineNo += 1;
            JsonObject.Add('lineNo', LineNo);
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
                Message('Thank you for shopping with us.')
            else begin
                HttpResponseMessage.Content().ReadAs(Text);
                Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode(), Text);
            end;
        end;
    end;

    local procedure GetPostedSalesInvoice(var BCWebShopSetup: Record "BCWeb Shop Setup"; var TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary; httpClient: HttpClient; SalesHeaderNo: Code[20]): Boolean
    var
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        JsonObject: JsonObject;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndWebShopUrlLbl: Label '%1/postedSalesInvoicesMM?$filter=customerNo eq ''%2'' and orderNo eq ''%3''', Comment = '%1 is Web Shop URL, %2 is customer no., %3 is order no., %4 is posting date';
    begin
        httpClient.Get(StrSubstNo(BackEndWebShopUrlLbl, BCWebShopSetup."Backend Web Service URL", BCWebShopSetup.UserNo, SalesHeaderNo), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            JsonObject.ReadFrom(ResponseText);
            exit(ParseJsonSalesInvoiceHeader(ResponseText, TempSalesInvoiceHeader));
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseJsonSalesInvoiceHeader(ResponseText: Text; var TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary): Boolean
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

                TempSalesInvoiceHeader.Init();
                TempSalesInvoiceHeader."No." := CopyStr(GetFieldValue(JsonObject, 'postedNo').AsCode(), 1, MaxStrLen(TempSalesInvoiceHeader."No."));
                TempSalesInvoiceHeader."Amount Including VAT" := GetFieldValue(JsonObject, 'amountIncludingVAT').AsDecimal();
                TempSalesInvoiceHeader."Currency Code" := CopyStr(GetFieldValue(JsonObject, 'currencyCode').AsCode(), 1, MaxStrLen(TempSalesInvoiceHeader."Currency Code"));
                TempSalesInvoiceHeader.Insert();

                exit(true);
            end;
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

    local procedure GetLastGenJournalLine(var BCWebShopSetup: Record "BCWeb Shop Setup"; httpClient: HttpClient; var LineNo: Integer): Boolean
    var
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        JsonObject: JsonObject;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndWebShopUrlLbl: Label '%1/allGenJournalLinesMM?$filter=journalTemplateName eq ''%2'' and journalBatchName eq ''%3''', Comment = '%1 is Web Shop URL, %2 is template name, %3 is batch name';
    begin
        httpClient.Get(StrSubstNo(BackEndWebShopUrlLbl, BCWebShopSetup."Backend Web Service URL", BCWebShopSetup."Journal Template Name", BCWebShopSetup."Journal Batch Name"), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            JsonObject.ReadFrom(ResponseText);
            exit(ParseJsonGenJournalLine(ResponseText, LineNo));
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseJsonGenJournalLine(ResponseText: Text; var LineNo: Integer): Boolean
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
                LineNo := GetFieldValue(JsonObject, 'lineNo').AsInteger();
            end;
        exit(true);
    end;
}