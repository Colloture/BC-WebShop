codeunit 50117 "BCChange Order Status"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        BCOrders: Record BCOrders;
    begin
        if not BCOrders.FindSet() then
            exit;

        repeat
            if BCOrders.Status <> BCOrders.Status::Arrived then begin
                BCOrders.Status += 1;
                BCOrders.Modify();
            end;
        until BCOrders.Next() = 0;
    end;
}