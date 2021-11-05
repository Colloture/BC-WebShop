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
        field(2; Username; Text[100])
        {
            Caption = 'Username';
            DataClassification = SystemMetadata;
        }
        field(3; Email; Text[80])
        {
            Caption = 'Email';
            DataClassification = SystemMetadata;
        }
        field(4; Favorites; Integer)
        {
            Caption = 'Favorites';
            FieldClass = FlowField;
            CalcFormula = count(BCFavorites where(Username = field(Username), Email = field(Email)));
        }
        field(5; Cart; Integer)
        {
            Caption = 'Cart';
            FieldClass = FlowField;
            CalcFormula = count(BCCart where(Username = field(Username), Email = field(Email)));
        }
        field(6; CartValue; Decimal)
        {
            Caption = 'Value of Items in Cart';
            FieldClass = FlowField;
            CalcFormula = sum(BCCart.Amount where(Username = field(Username), Email = field(Email)));
        }
        field(7; Orders; Integer)
        {
            Caption = 'Orders';
            FieldClass = FlowField;
            CalcFormula = count(BCOrders where(Username = field(Username), Email = field(Email)));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
        key(Key2; Username, Email)
        {
        }
    }
}