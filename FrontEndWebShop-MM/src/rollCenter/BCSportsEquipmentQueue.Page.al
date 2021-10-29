page 50104 "BCSports Equipment Queue"
{
    Caption = 'Sports Equipment Queue';
    PageType = CardPart;
    SourceTable = "BCSports Equipment Cue";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'Sports Equipment';
                field("No. of Items"; Rec."No. of Items")
                {
                    ToolTip = 'Specifies No. of Items.';
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                }
                field(Balls; Rec.Balls)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies number of Balls.';
                }
                field(Rackets; Rec.Rackets)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies number of Rackets.';
                }
                field(Glasses; Rec.Glasses)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies number of Glasses.';
                }
                field(Other; Rec.Other)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies number of Other items.';
                }
                field("Total No. of Items"; Rec."Total No. of Items")
                {
                    ToolTip = 'Specifies Total No. of Items in Inventory.';
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}