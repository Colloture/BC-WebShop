table 50111 "BCOrders"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'No.';
        }
        field(2; Username; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Username';
        }
        field(4; "Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
        }
        field(5; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(6; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(7; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(8; Status; Enum "BCOrder Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
    }

    keys
    {
        key(Key1; "No.", Username)
        {
            Clustered = true;
        }
    }
}