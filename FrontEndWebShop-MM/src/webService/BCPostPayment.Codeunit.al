codeunit 50115 "BCPostPayment"
{
    procedure CreatePayment(var BCWebShopSetup: Record "BCWeb Shop Setup"; httpClient: httpClient; SalesHeaderNo: Code[20])
    var
        TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
        Text: Text;
        Amount: Decimal;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        WebErrorMsg: Label 'Error occurred: %1 - %2', Comment = '%1 is HTTP Status Code, %2 is message';
        BackEndPostUrlLbl: Label '%1/genJournalLinesMM', Comment = '%1 is Web Shop URL';
    begin
        if GetPostedSalesInvoice(BCWebShopSetup, TempSalesInvoiceHeader, httpClient, SalesHeaderNo, Amount) then begin

            TempSalesInvoiceHeader.CalcFields("Amount Including VAT");

            httpContent.WriteFrom(CreateGenJournalLine(BCWebShopSetup, httpClient, TempSalesInvoiceHeader, Amount));
            httpContent.GetHeaders(httpHeaders);
            httpHeaders.Remove('Content-Type');
            httpHeaders.Add('Content-Type', 'application/json');

            httpRequestMessage.Content := httpContent;
            httpRequestMessage.SetRequestUri(StrSubstNo(BackEndPostUrlLbl, BCWebShopSetup."Backend Web Service URL"));
            httpRequestMessage.Method := 'POST';

            httpClient.Send(httpRequestMessage, HttpResponseMessage);
            if not HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content().ReadAs(Text);
                Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode(), Text);
            end;
        end;
    end;

    local procedure GetPostedSalesInvoice(var BCWebShopSetup: Record "BCWeb Shop Setup"; var TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary; httpClient: HttpClient; SalesHeaderNo: Code[20]; var Amount: Decimal): Boolean
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        JsonObject: JsonObject;
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is HTTP Status Code';
        BackEndWebShopUrlLbl: Label '%1/postedSalesInvoicesMM?$filter=customerNo eq ''%2'' and orderNo eq ''%3''', Comment = '%1 is Web Shop URL, %2 is customer no., %3 is order no., %4 is posting date';
    begin
        httpClient.Get(StrSubstNo(BackEndWebShopUrlLbl, BCWebShopSetup."Backend Web Service URL", BCLoggedInUser.GetUserNo(), SalesHeaderNo), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            JsonObject.ReadFrom(ResponseText);
            exit(ParseJsonSalesInvoiceHeader(ResponseText, TempSalesInvoiceHeader, Amount));
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseJsonSalesInvoiceHeader(ResponseText: Text; var TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary; var Amount: Decimal): Boolean
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
                Amount := GetFieldValue(JsonObject, 'amountIncludingVAT').AsDecimal();
                TempSalesInvoiceHeader."Amount Including VAT" := GetFieldValue(JsonObject, 'amountIncludingVAT').AsDecimal();
                TempSalesInvoiceHeader."Currency Code" := CopyStr(GetFieldValue(JsonObject, 'currencyCode').AsCode(), 1, MaxStrLen(TempSalesInvoiceHeader."Currency Code"));
                TempSalesInvoiceHeader.Insert();

                exit(true);
            end;
    end;

    local procedure CreateGenJournalLine(var BCWebShopSetup: Record "BCWeb Shop Setup"; var httpClient: httpClient; var TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary; Amount: Decimal): Text
    var
        GenJournalLine: Record "Gen. Journal Line";
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        Text: Text;
        LineNo: Integer;
        JsonObject: JsonObject;
    begin
        JsonObject.Add('postingDate', '2023-01-26');
        JsonObject.Add('documentType', BCWebShopSetup."Document Type");
        JsonObject.Add('documentNo', CopyStr('PAY-' + TempSalesInvoiceHeader."No.", 1, MaxStrLen(GenJournalLine."Document No.")));
        JsonObject.Add('accountType', BCWebShopSetup."Account Type");
        JsonObject.Add('accountNo', BCLoggedInUser.GetUserNo());
        JsonObject.Add('currencyCode', TempSalesInvoiceHeader."Currency Code");
        JsonObject.Add('paymentMethodCode', BCWebShopSetup."Payment Method Code");
        JsonObject.Add('amount', -Amount);
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
        exit(Text);
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

    local procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;
}