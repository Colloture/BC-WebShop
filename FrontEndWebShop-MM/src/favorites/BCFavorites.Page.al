page 50111 "BCFavorites"
{
    Caption = 'Favorites';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BCFavorites;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Item Category"; Rec."Item Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AddToCart)
            {
                ApplicationArea = All;
                Caption = 'Add to Cart';
                ToolTip = 'Executes the Add to Cart action.';
                Image = Add;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BCStoreItems: Record "BCStore Items";
                begin
                    BCStoreItems.Get(Rec."Item No.");
                    BCItemFunctions.AddNewItemToCart(BCStoreItems);
                end;
            }
            action(OpenCart)
            {
                ApplicationArea = All;
                Caption = 'Your Cart';
                ToolTip = 'Executes the Open Your Cart action.';
                Image = Open;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BCItemFunctions.OpenYourCart();
                end;
            }
        }
    }

    var
        BCItemFunctions: Codeunit BCItemFunctions;
}