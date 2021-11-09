codeunit 50117 "BCChange Order Status"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        BCOrders: Record BCOrders;
        BCTrackOrder: Record "BCTrack Order";
        NotFirst: Boolean;
    begin
        if not BCOrders.FindSet() then
            exit;

        repeat
            if BCOrders.Status <> BCOrders.Status::Arrived then begin
                BCOrders.Status := Enum::"BCOrder Status".FromInteger(BCOrders.Status.AsInteger() + 1);
                BCOrders."Status Changed Time" := CurrentDateTime;
                BCOrders.Modify();

                BCTrackOrder.Init();
                if NotFirst then
                    BCTrackOrder."No." += 1;

                NotFirst := true;
                BCTrackOrder."Order No." := BCOrders."Order No.";
                BCTrackOrder."Item No." := BCOrders."Item No.";
                BCTrackOrder.Status := BCOrders.Status;
                BCTrackOrder."Status Changed Time" := BCOrders."Status Changed Time";
                BCTrackOrder.Insert();
            end;
        until BCOrders.Next() = 0;
    end;
}