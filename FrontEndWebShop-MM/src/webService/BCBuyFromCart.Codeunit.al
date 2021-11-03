codeunit 50107 "BCBuyFromCart"
{
    TableNo = BCCart;

    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCAuthorization: Codeunit BCAuthorization;
        BCPostSalesOrder: Codeunit BCPostSalesOrder;
        BCPostPayment: Codeunit BCPostPayment;
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

        BCAuthorization.SetAuthorization(BCWebShopSetup, httpClient);

        BCPostSalesOrder.CreateOrder(BCWebShopSetup, Rec, httpClient, SalesHeaderNo, SalesHeaderDocumentType, PostedSalesHeaderNo);
        BCPostPayment.CreatePayment(BCWebShopSetup, httpClient, SalesHeaderNo);

        Rec.DeleteAll();
    end;
}