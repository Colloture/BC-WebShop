codeunit 50107 "BCPostBuyFromCart"
{
    TableNo = BCCart;

    // TODO - sve ovo na backend jer na frontu ne radi (Customer i Items su na backend-u)
    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        httpClient: httpClient;
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername = '') and (BCWebShopSetup.LoggedInEmail = '') then
            Error('Please Log In in order to Buy Items.');

        if Rec.Count = 0 then
            Error('Your Cart is empty.');

        SetAuthorization(BCWebShopSetup, httpClient);

        CreateOrder(BCWebShopSetup, Rec, httpClient);

        // PostOrder(SalesHeader); -> GET ili POST zahtev za novi PAGE koji ce uraditi POST
        // CreatePayment(SalesHeader);
        // OpenPostedSalesInvoice(SalesHeader);

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

    local procedure CreateOrder(var BCWebShopSetup: Record "BCWeb Shop Setup"; var BCCart: Record BCCart; httpClient: httpClient)
    var
        SalesLineNo: Integer;
        SalesHeaderNo: Code[20];
        SalesHeaderDocumentType: Text;
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
            Message('Successfull creation of Sales Header.')
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
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
        if HttpResponseMessage.IsSuccessStatusCode() then
            Message('Successfull creation of Sales Line.')
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    // local procedure PostOrder(var SalesHeader: Record "Sales Header")
    // begin
    //     // GET salesHeader
    //     SalesHeader.Invoice := true;
    //     SalesHeader.Ship := true;
    //     Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
    // end;

    // local procedure CreatePayment(var SalesHeader: Record "Sales Header")
    // var
    //     BCWebShopSetup: Record "BCWeb Shop Setup";
    //     GenJournalLine: Record "Gen. Journal Line";
    //     SalesInvoiceHeader: Record "Sales Invoice Header";
    // begin
    //     if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then begin

    //         SalesInvoiceHeader.CalcFields("Amount Including VAT");
    //         // POST GenJournalLine
    //         GenJournalLine.Init();
    //         GenJournalLine.Validate("Posting Date", Today());
    //         GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
    //         GenJournalLine.Validate("Document No.", CopyStr('PAY-' + SalesInvoiceHeader."No.", 1, MaxStrLen(GenJournalLine."Document No.")));
    //         GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
    //         GenJournalLine.Validate("Account No.", SalesHeader."Sell-to Customer No.");
    //         GenJournalLine.Validate("Currency Code", SalesInvoiceHeader."Currency Code");
    //         GenJournalLine.Validate("Payment Method Code", BCWebShopSetup."Payment Method Code");
    //         GenJournalLine.Validate("Credit Amount", SalesInvoiceHeader."Amount Including VAT");
    //         GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
    //         GenJournalLine.Validate("Applies-to Doc. No.", SalesInvoiceHeader."No.");
    //         GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
    //         GenJournalLine.Validate("Bal. Account No.", BCWebShopSetup."Bal. Account No.");

    //         CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GenJournalLine);
    //     end;
    // end;

    // local procedure OpenPostedSalesInvoice(var SalesHeader: Record "Sales Header")
    // var
    //     SalesInvoiceHeader: Record "Sales Invoice Header";
    // begin
    //     if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then
    //         Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
    // end;

    // local procedure FindPostedSalesInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    // begin
    //     // GET SalesInvoiceHeader
    //     SalesInvoiceHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
    //     SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
    //     SalesInvoiceHeader.SetRange("Posting Date", SalesHeader."Posting Date");
    //     exit(SalesInvoiceHeader.FindFirst());
    // end;

    local procedure ParseResponseSalesHeader(ResponseText: Text; var SalesHeaderNo: Code[20]; var SalesHeaderDocumentType: Text)
    var
        JsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(ResponseText);
        SalesHeaderNo := CopyStr(GetFieldValue(JsonObject, 'no').AsCode(), 1, MaxStrLen(SalesHeaderNo));
        SalesHeaderDocumentType := GetFieldValue(JsonObject, 'documentType').AsText();
    end;

    local procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;
}