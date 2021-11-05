pageextension 50111 "BCItemCardExtension" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field(BCSport; Rec.BCSport)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sport field.';
            }
            field(BCBrand; Rec.BCBrand)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Brand field.';
            }
        }
    }
}