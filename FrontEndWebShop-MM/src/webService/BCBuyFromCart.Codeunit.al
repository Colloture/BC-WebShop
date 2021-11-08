codeunit 50107 "BCBuyFromCart"
{
    TableNo = BCCart;

    trigger OnRun()
    var
        BCCartCopy: Record BCCart;
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCLoggedInUser: Codeunit "BCLoggedIn User";
        BCAuthorization: Codeunit BCAuthorization;
        BCPostSalesOrder: Codeunit BCPostSalesOrder;
        BCPostPayment: Codeunit BCPostPayment;
        BCFillInOrders: Codeunit BCFillInOrders;
        httpClient: httpClient;
        SalesHeaderNo: Code[20];
        PostedSalesHeaderNo: Code[20];
        SalesHeaderDocumentType: Text;
        ConfirmBuyingLbl: Label 'Are you sure you want to proceed with this purchase?';
    begin
        if BCLoggedInUser.GetUser() = '' then
            Error('Please Log In in order to Buy Items.');

        if Rec.Count = 0 then
            Error('Your Cart is empty.');

        if not Confirm(ConfirmBuyingLbl) then
            exit;

        BCWebShopSetup.Get();
        BCAuthorization.SetAuthorization(BCWebShopSetup, httpClient);

        BCCartCopy.Copy(Rec);
        BCPostSalesOrder.CreateOrder(BCWebShopSetup, BCCartCopy, httpClient, SalesHeaderNo, SalesHeaderDocumentType, PostedSalesHeaderNo);
        BCPostPayment.CreatePayment(BCWebShopSetup, httpClient, SalesHeaderNo);
        BCCartCopy.Copy(Rec);
        ChangeInventoryOnFront(BCCartCopy);
        BCCartCopy.Copy(Rec);
        BCFillInOrders.InsertOrders(PostedSalesHeaderNo, BCCartCopy);

        Message('Thank you for shopping with us. Your order number is ' + PostedSalesHeaderNo + '.');

        Rec.DeleteAll();
    end;

    local procedure ChangeInventoryOnFront(var BCCart: Record BCCart)
    var
        BCStoreItems: Record "BCStore Items";
    begin
        repeat
            BCStoreItems.Get(BCCart."Item No.");
            BCStoreItems.Inventory -= BCCart.Quantity;
            BCStoreItems.Modify();
        until BCCart.Next() = 0;
    end;
}