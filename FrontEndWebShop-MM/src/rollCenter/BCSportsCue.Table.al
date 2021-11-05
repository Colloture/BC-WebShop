table 50109 "BCSports Cue"
{
    Caption = 'Sports Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; Football; Integer)
        {
            Caption = 'Football';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Football')));
        }
        field(3; Volleyball; Integer)
        {
            Caption = 'Volleyball';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Volleyball')));
        }
        field(4; Basketball; Integer)
        {
            Caption = 'Basketball';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Basketball')));
        }
        field(5; Fitness; Integer)
        {
            Caption = 'Fitness';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Fitness')));
        }
        field(6; Swimming; Integer)
        {
            Caption = 'Swimming';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Swimming')));
        }
        field(7; Skiing; Integer)
        {
            Caption = 'Skiing';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Skiing')));
        }
        field(8; Tennis; Integer)
        {
            Caption = 'Tennis';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Tennis')));
        }
        field(9; "Table Tennis"; Integer)
        {
            Caption = 'Table Tennis';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items" where(Sport = const('Table Tennis')));
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