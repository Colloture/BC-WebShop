page 50113 "BCSports Queue"
{
    Caption = 'Sports Queue';
    PageType = CardPart;
    SourceTable = "BCSports Cue";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'Sports';

                field(Football; Rec.Football)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Football field.';
                }
                field(Volleyball; Rec.Volleyball)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Volleyball field.';
                }
                field(Basketball; Rec.Basketball)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Basketball field.';
                }
                field(Fitness; Rec.Fitness)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Fitness field.';
                }
                field(Swimming; Rec.Swimming)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Swimming field.';
                }
                field(Skiing; Rec.Skiing)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Skiing field.';
                }
                field(Tennis; Rec.Tennis)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Tennis field.';
                }
                field("Table Tennis"; Rec."Table Tennis")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Table Tennis field.';
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