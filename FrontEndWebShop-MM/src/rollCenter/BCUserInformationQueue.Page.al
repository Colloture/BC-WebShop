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
                    DrillDownPageId = BCFavorites;
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
                field(Orders; Rec.Orders)
                {
                    ApplicationArea = All;
                    DrillDownPageId = BCOrder;
                    ToolTip = 'Specifies the value of the Orders field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.Username := BCLoggedInUser.GetUser();
        Rec.Modify();
    end;
}