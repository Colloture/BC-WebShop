table 50106 "BCLogIn"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(3; "E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'E-Mail';
        }
    }

    keys
    {
        key(Key1; Name, "E-Mail")
        {
            Clustered = true;
        }
    }
}