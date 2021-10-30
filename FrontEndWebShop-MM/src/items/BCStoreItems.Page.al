page 50102 "BCStore Items"
{
    Caption = 'Store Items';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCStore Items";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.';
                }
                field("Item Category"; Rec."Item Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category field.';
                }
                field(Image; Rec.Image)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Image field.';
                }
            }
        }
    }

    actions
    {
        area(Creation)
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
                begin
                    BCItemFunctions.AddNewItemToCart(Rec);
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
            action(AddToFavorites)
            {
                ApplicationArea = All;
                Caption = 'Add to Favorites';
                ToolTip = 'Executes the Add to Favorites action.';
                Image = AddAction;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BCItemFunctions.AddNewItemToFavorites(Rec);
                end;
            }
            action(OpenFavorites)
            {
                ApplicationArea = All;
                Caption = 'Your Favorites';
                ToolTip = 'Executes the Open Your Favorites action.';
                Image = OpenJournal;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BCItemFunctions.OpenYourFavorites();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        BCStoreItems: Record "BCStore Items";
        BCGetItems: Codeunit "BCGet Items";
    begin
        BCStoreItems.DeleteAll();
        BCGetItems.Run();
    end;

    var
        BCItemFunctions: Codeunit BCItemFunctions;
}