table 50107 "BCCart"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Username; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Username';
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(5; "Item Category"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Category';
        }
        field(6; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
        }
        field(7; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Base Unit of Measure';
        }
        field(9; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(10; TotalAmount; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum(BCCart.Amount where(Username = field(Username)));
        }
    }

    keys
    {
        key(Key1; Username, "Item No.")
        {
            Clustered = true;
        }
        key(Key2; Username)
        {
            SumIndexFields = Amount;
        }
    }
}