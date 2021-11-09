page 50118 "BCTrack Order"
{
    Caption = 'Track Order History';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCTrack Order";
    Editable = false;

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
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Status Changed Time"; Rec."Status Changed Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Change Time field.';
                }
            }
        }
    }
}