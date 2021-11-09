page 50115 "BCOrder"
{
    Caption = 'My Orders';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BCOrders;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order No. field.';
                    Style = Strong;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(StatusChangedTime; Rec."Status Changed Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Change Time field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TrackOrderHistory)
            {
                ApplicationArea = All;
                Caption = 'Track Order History';
                ToolTip = 'Executes the Track Order History action.';
                Image = Track;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BCTrackOrder: Record "BCTrack Order";
                begin
                    BCTrackOrder.SetRange("Order No.", Rec."Order No.");
                    BCTrackOrder.SetRange("Item No.", Rec."Item No.");
                    Page.Run(50118, BCTrackOrder);
                end;
            }
        }
    }
}