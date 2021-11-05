codeunit 50116 "BCFillInOrders"
{
    procedure InsertOrders(BCWebShopSetup: Record "BCWeb Shop Setup"; PostedSalesHeaderNo: Code[20]; var BCCart: Record BCCart)
    begin
        repeat
            InsertOrder(BCWebShopSetup, PostedSalesHeaderNo, BCCart);
        until BCCart.Next() = 0;
    end;

    local procedure InsertOrder(BCWebShopSetup: Record "BCWeb Shop Setup"; PostedSalesHeaderNo: Code[20]; var BCCart: Record BCCart)
    var
        BCOrders: Record BCOrders;
    begin
        BCOrders.Init();
        BCOrders.Username := BCWebShopSetup.LoggedInUsername;
        BCOrders.Email := BCWebShopSetup.LoggedInEmail;
        BCOrders."Order No." := PostedSalesHeaderNo;
        BCOrders."Item No." := BCCart."Item No.";
        BCOrders.Description := BCCart.Description;
        BCOrders.Amount := BCCart.Amount;
        BCOrders.Status := BCOrders.Status::Received;
        BCOrders.Insert();
    end;
}