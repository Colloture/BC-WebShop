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
        field(5; UserNo; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Logged In User No.';
        }
        field(6; LoggedInUsername; Text[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Logged In Username';
        }
        field(7; LoggedInEmail; Text[80])
        {
            DataClassification = SystemMetadata;
            Caption = 'Logged In Email';
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