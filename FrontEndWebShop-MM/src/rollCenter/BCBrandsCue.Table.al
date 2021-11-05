table 50110 "BCBrands Cue"
{
    Caption = 'Brands Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; Nike; Integer)
        {
            Caption = 'Nike';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Nike')));
        }
        field(3; Adidas; Integer)
        {
            Caption = 'Adidas';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Adidas')));
        }
        field(4; Lonsdale; Integer)
        {
            Caption = 'Lonsdale';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Lonsdale')));
        }
        field(5; Umbro; Integer)
        {
            Caption = 'Umbro';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Umbro')));
        }
        field(6; Mikasa; Integer)
        {
            Caption = 'Mikasa';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Mikasa')));
        }
        field(7; Ellesse; Integer)
        {
            Caption = 'Ellesse';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Ellesse')));
        }
        field(8; Spalding; Integer)
        {
            Caption = 'Spalding';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Spalding')));
        }
        field(9; Asics; Integer)
        {
            Caption = 'Asics';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Asics')));
        }
        field(10; Head; Integer)
        {
            Caption = 'Head';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Head')));
        }
        field(11; Speedo; Integer)
        {
            Caption = 'Speedo';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Speedo')));
        }
        field(12; Butterfly; Integer)
        {
            Caption = 'Butterfly';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Brand = const('Butterfly')));
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