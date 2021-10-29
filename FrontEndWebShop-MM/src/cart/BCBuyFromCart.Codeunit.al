codeunit 50107 "BCBuyFromCart"
{
    TableNo = BCCart;

    // TODO - sve ovo na backend jer na frontu ne radi (Customer i Items su na backend-u)
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername = '') and (BCWebShopSetup.LoggedInEmail = '') then
            Error('Please Log In in order to Buy Items.');

        if Rec.Count = 0 then
            Error('Your Cart is empty.');

        CreateOrder(SalesHeader, BCWebShopSetup.UserNo, Rec);
        PostOrder(SalesHeader);
        CreatePayment(SalesHeader);
        OpenPostedSalesInvoice(SalesHeader);

        Rec.DeleteAll();
    end;

    local procedure CreateOrder(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20]; var BCCart: Record BCCart)
    var
        SalesLineNo: Integer;
    begin
        CreateSalesHeader(SalesHeader, CustomerNo);

        SalesLineNo := 10000;
        repeat
            CreateSalesLine(SalesHeader, SalesLineNo, BCCart."Item No.", BCCart.Quantity, BCCart."Unit Price");
            SalesLineNo += 10000;
        until BCCart.Next() = 0;
    end;

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    begin
        SalesHeader.Init();
        SalesHeader."No." := '';
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Insert(true);

        SalesHeader.Validate("Posting Date", Today());
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; LineNo: Integer; ItemNo: Code[20]; Quantity: Integer; UnitPrice: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := LineNo;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate(Quantity, Quantity);
        SalesLine.Validate("Qty. to Ship", Quantity);
        SalesLine.Validate("Unit Price", UnitPrice);
        SalesLine.Modify(true);
    end;

    local procedure PostOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Invoice := true;
        SalesHeader.Ship := true;
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
    end;

    local procedure CreatePayment(var SalesHeader: Record "Sales Header")
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        GenJournalLine: Record "Gen. Journal Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then begin

            SalesInvoiceHeader.CalcFields("Amount Including VAT");

            GenJournalLine.Init();
            GenJournalLine.Validate("Posting Date", Today());
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.Validate("Document No.", CopyStr('PAY-' + SalesInvoiceHeader."No.", 1, MaxStrLen(GenJournalLine."Document No.")));
            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
            GenJournalLine.Validate("Account No.", SalesHeader."Sell-to Customer No.");
            GenJournalLine.Validate("Currency Code", SalesInvoiceHeader."Currency Code");
            GenJournalLine.Validate("Payment Method Code", BCWebShopSetup."Payment Method Code");
            GenJournalLine.Validate("Credit Amount", SalesInvoiceHeader."Amount Including VAT");
            GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
            GenJournalLine.Validate("Applies-to Doc. No.", SalesInvoiceHeader."No.");
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
            GenJournalLine.Validate("Bal. Account No.", BCWebShopSetup."Bal. Account No.");

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GenJournalLine);
        end;
    end;

    local procedure OpenPostedSalesInvoice(var SalesHeader: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then
            Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
    end;

    local procedure FindPostedSalesInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    begin
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
        SalesInvoiceHeader.SetRange("Posting Date", SalesHeader."Posting Date");
        exit(SalesInvoiceHeader.FindFirst());
    end;
}