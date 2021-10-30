table 50102 "BCSports Equipment Cue"
{
    Caption = 'Sports Equipment Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "No. of Items"; Integer)
        {
            Caption = 'No. of All Items';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items");
        }
        field(3; "Total No. of Items"; Decimal)
        {
            Caption = 'No. of All Items in Inventory';
            FieldClass = FlowField;
            CalcFormula = sum("BCStore Items".Inventory);
        }
        field(4; Balls; Integer)
        {
            Caption = 'Balls';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('BALL')));
        }
        field(5; Rackets; Integer)
        {
            Caption = 'Rackets';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('RACKET')));
        }
        field(6; Glasses; Integer)
        {
            Caption = 'Glasses';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('GLASSES')));
        }
        field(7; Jerseys; Integer)
        {
            Caption = 'Jerseys';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('JERSEY')));
        }
        field(8; Shoes; Integer)
        {
            Caption = 'Shoes';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('SHOES')));
        }
        field(9; Bags; Integer)
        {
            Caption = 'Bags';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('BAG')));
        }
        field(10; Other; Integer)
        {
            Caption = 'Other';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('OTHER')));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}