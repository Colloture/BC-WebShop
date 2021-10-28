table 50101 "BCStore Items"
{
    DataClassification = CustomerContent;
    // DrillDownPageId = ; TODO - add page for single item
    // TODO - probati bez ove tabele nekako
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
        }
        field(4; Inventory; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory';
        }
        field(5; "Base Unit of Measure"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Base Unit of Measure';
        }
        field(6; "Item Category"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Category';
        }
        // TODO - Add photo
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
}