page 50114 "BCBrands Queue"
{
    Caption = 'Brands Queue';
    PageType = CardPart;
    SourceTable = "BCBrands Cue";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'Brands';

                field(Nike; Rec.Nike)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Nike field.';
                }
                field(Adidas; Rec.Adidas)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Adidas field.';
                }
                field(Lonsdale; Rec.Lonsdale)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Lonsdale field.';
                }
                field(Umbro; Rec.Umbro)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Umbro field.';
                }
                field(Mikasa; Rec.Mikasa)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Mikasa field.';
                }
                field(Asics; Rec.Asics)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Asics field.';
                }
                field(Butterfly; Rec.Butterfly)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Butterfly field.';
                }
                field(Ellesse; Rec.Ellesse)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Ellesse field.';
                }
                field(Head; Rec.Head)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Head field.';
                }
                field(Spalding; Rec.Spalding)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Spalding field.';
                }
                field(Speedo; Rec.Speedo)
                {
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items";
                    ToolTip = 'Specifies the value of the Speedo field.';
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