table 50113 "BCTrack Order"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(4; Status; Enum "BCOrder Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(5; "Status Changed Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Status Change Time';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Order No.", "Item No.")
        {
        }
    }
}