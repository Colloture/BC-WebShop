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
        BCTrackOrder: Record "BCTrack Order";
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

        BCTrackOrder.Init();
        BCTrackOrder."Order No." := BCOrders."Order No.";
        BCTrackOrder."Item No." := BCOrders."Item No.";
        BCTrackOrder.Status := BCOrders.Status;
        BCTrackOrder."Status Changed Time" := BCOrders."Status Changed Time";
        BCTrackOrder.Insert();
    end;
}