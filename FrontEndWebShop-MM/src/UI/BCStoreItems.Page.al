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
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory field.';
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
                // TODO - add photo 
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
                Image = NewItem;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AddNewItemToCart(Rec);
                end;
            }
            action(Cart)
            {
                ApplicationArea = All;
                Caption = 'Open Your Cart';
                ToolTip = 'Executes the Open Your Cart action.';
                Image = Open;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OpenYourCart();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        BCStoreItems: Record "BCStore Items";
        BCGetItems: Codeunit "BCGet Items";
    begin
        // BCStoreItems.DeleteAll(); // kada dodajem novi atribut tabeli
        if BCStoreItems.IsEmpty then
            BCGetItems.Run();
    end;

    local procedure AddNewItemToCart(var BCStoreItems: Record "BCStore Items")
    var
        BCCart: Record BCCart;
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        if BCStoreItems.Inventory = 0 then
            Error('This item isn''t available at the moment.');

        BCWebShopSetup.Get();

        BCCart.SetRange(Username, BCWebShopSetup.LoggedInUsername);
        BCCart.SetRange(Email, BCWebShopSetup.LoggedInEmail);
        BCCart.SetRange("Item No.", BCStoreItems."No.");

        // TODO - do this on backend
        if not BCCart.IsEmpty then begin
            // todo - check is BCStoreItems has something in inventory
            BCCart.FindFirst();
            BCCart.Quantity += 1;
            BCCart.TotalAmount += BCStoreItems."Unit Price";
            BCCart.Modify();

            BCStoreItems.Inventory -= 1;
            BCStoreItems.Modify();
        end
        else begin
            BCCart.Init();
            BCCart.Username := BCWebShopSetup.LoggedInUsername;
            BCCart.Email := BCWebShopSetup.LoggedInEmail;
            BCCart."Item No." := BCStoreItems."No.";
            BCCart.Description := BCStoreItems.Description;
            BCCart."Item Category" := BCStoreItems."Item Category";
            BCCart."Unit Price" := BCStoreItems."Unit Price";
            BCCart.Quantity := 1;
            BCCart."Base Unit of Measure" := BCStoreItems."Base Unit of Measure";
            BCCart.TotalAmount := BCStoreItems."Unit Price";
            BCCart.Insert();

            BCStoreItems.Inventory -= 1;
            BCStoreItems.Modify();
        end;

        Message('New Item added to the Cart.');
    end;

    local procedure OpenYourCart()
    var
        BCCart: Record BCCart;
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        BCWebShopSetup.Get();

        // todo - on backend
        BCCart.SetRange(Username, BCWebShopSetup.LoggedInUsername);
        BCCart.SetRange(Email, BCWebShopSetup.LoggedInEmail);

        Page.Run(50110, BCCart);
    end;
}