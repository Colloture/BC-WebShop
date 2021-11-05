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
        field(8; "Payment Method Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Payment Method Code';
        }
        field(9; "Bal. Account No."; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Bal. Account No.';
        }
        field(10; "Document Type"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Document Type';
        }
        field(11; "Account Type"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Account Type';
        }
        field(12; "Applies To Doc. Type"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Applies To Doc. Type';
        }
        field(13; "Bal. Account Type"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Bal. Account Type';
        }
        field(14; "Journal Template Name"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Journal Template Name';
        }
        field(15; "Journal Batch Name"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Journal Batch Name';
        }
        field(16; "Gen. Bus. Posting Group"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Gen. Bus. Posting Group';
        }
        field(17; "Customer Posting Group"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Customer Posting Group';
        }
        field(18; "Payment Terms Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Payment Terms Code';
        }
        field(19; "Sales Order Document Type"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Sales Order Document Type';
        }
        field(20; "Sales Line Type"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Sales Line Type';
        }
        field(21; "Last Date Modified Items"; Text[30])
        {
            DataClassification = SystemMetadata;
            Caption = 'Last Date Modified Items';
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