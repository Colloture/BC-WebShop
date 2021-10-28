table 50103 "BCUser Information Cue"
{
    Caption = 'User Information Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; Favorites; Integer)
        {
            Caption = 'No. of Favorite Items';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items"); // TODO - Favorites table
        }
        field(3; Cart; Integer)
        {
            Caption = 'No. of Items in Cart';
            FieldClass = FlowField;
            CalcFormula = count("BCStore Items"); // TODO - Cart table
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