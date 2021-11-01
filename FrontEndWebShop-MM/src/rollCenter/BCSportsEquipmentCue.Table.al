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
        field(3; Balls; Integer)
        {
            Caption = 'Balls';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('BALL')));
        }
        field(4; Rackets; Integer)
        {
            Caption = 'Rackets';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('RACKET')));
        }
        field(5; Glasses; Integer)
        {
            Caption = 'Glasses';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('GLASSES')));
        }
        field(6; Jerseys; Integer)
        {
            Caption = 'Jerseys';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('JERSEY')));
        }
        field(7; Shoes; Integer)
        {
            Caption = 'Shoes';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('SHOES')));
        }
        field(8; Bags; Integer)
        {
            Caption = 'Bags';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where("Item Category" = const('BAG')));
        }
        field(9; Other; Integer)
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