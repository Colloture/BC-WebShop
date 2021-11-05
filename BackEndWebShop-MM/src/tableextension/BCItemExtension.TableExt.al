tableextension 50110 "BCItemExtension" extends Item
{
    fields
    {
        field(50110; BCSport; Enum BCSport)
        {
            DataClassification = CustomerContent;
            Caption = 'Sport';
        }
        field(50111; BCBrand; Enum BCBrand)
        {
            DataClassification = CustomerContent;
            Caption = 'Sport Brand';
        }
    }
}