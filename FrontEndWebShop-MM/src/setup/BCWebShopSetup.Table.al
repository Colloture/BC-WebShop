table 50100 "BCWeb Shop Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
        }
        field(2; "Backend Web Service URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Backend Web Service URL';
        }
        field(3; "Backend Username"; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Backend Username';
        }
        field(4; "Backend Password"; Text[100])
        {
            // TODO
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
            Caption = 'Backend Password';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}