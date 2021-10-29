page 50105 "BCUser Information Queue"
{
    Caption = 'User Information Queue';
    PageType = CardPart;
    SourceTable = "BCUser Information Cue";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'User Information';
                field(Favorites; Rec.Favorites)
                {
                    ToolTip = 'Specifies No. of Favorite Items.';
                    ApplicationArea = All;
                    DrillDownPageId = "BCStore Items"; // TODO - Favorites table
                }
                field(Cart; Rec.Cart)
                {
                    ApplicationArea = All;
                    DrillDownPageId = BCCart;
                    ToolTip = 'Specifies No. of Items in Cart.';
                }
                field(CartValue; Rec.CartValue)
                {
                    ApplicationArea = All;
                    DrillDownPageId = BCCart;
                    ToolTip = 'Specifies Value of Items in Cart.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        BCWebShopSetup.Get();
        Rec.Username := BCWebShopSetup.LoggedInUsername;
        Rec.Email := BCWebShopSetup.LoggedInEmail;
        Rec.Modify();
    end;
}