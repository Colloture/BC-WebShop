codeunit 50116 "BCFillInOrders"
{
    procedure InsertOrders(PostedSalesHeaderNo: Code[20]; var BCCart: Record BCCart)
    begin
        repeat
            InsertOrder(PostedSalesHeaderNo, BCCart);
        until BCCart.Next() = 0;
    end;

    local procedure InsertOrder(PostedSalesHeaderNo: Code[20]; var BCCart: Record BCCart)
    var
        BCOrders: Record BCOrders;
        BCLoggedInUser: Codeunit "BCLoggedIn User";
    begin
        BCOrders.Init();
        BCOrders.Username := BCLoggedInUser.GetUser();
        BCOrders."Order No." := PostedSalesHeaderNo;
        BCOrders."Item No." := BCCart."Item No.";
        BCOrders.Description := BCCart.Description;
        BCOrders.Amount := BCCart.Amount;
        BCOrders.Status := BCOrders.Status::Received;
        BCOrders."Status Changed Time" := CurrentDateTime;
        BCOrders.Insert();
    end;
}