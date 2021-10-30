page 50114 "BCPostingSalesOrder-MM"
{
    Caption = 'Posting Sales Order MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'postingSalesOrderMM';
    EntitySetName = 'postingSalesOrdersMM';
    SourceTable = "Sales Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentType; Rec."Document Type")
                {
                }
                field(no; Rec."No.")
                {
                }
                field(postedNo; PostedSalesInvoiceNo())
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Ship := true;
        Rec.Invoice := true;

        Codeunit.Run(Codeunit::"Sales-Post", Rec);
    end;

    local procedure PostedSalesInvoiceNo(): Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.SetRange("Order No.", Rec."No.");
        SalesInvoiceHeader.FindFirst();
        exit(SalesInvoiceHeader."No.");
    end;
}