codeunit 50108 "BCItemFunctions"
{
    procedure AddNewItemToCart(var BCStoreItems: Record "BCStore Items")
    var
        BCCart: Record BCCart;
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCUserInformationCue: Record "BCUser Information Cue";
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername = '') and (BCWebShopSetup.LoggedInEmail = '') then
            Error('Please Log In in order to Add Items to Cart.');

        if BCStoreItems.Inventory = 0 then
            Error('This item isn''t available at the moment.');

        BCCart.SetRange(Username, BCWebShopSetup.LoggedInUsername);
        BCCart.SetRange(Email, BCWebShopSetup.LoggedInEmail);
        BCCart.SetRange("Item No.", BCStoreItems."No.");

        if not BCCart.IsEmpty then begin
            BCCart.FindFirst();
            BCCart.Quantity += 1;
            BCCart.Amount += BCStoreItems."Unit Price";
            BCCart.Modify();
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
            BCCart.Amount := BCStoreItems."Unit Price";
            BCCart.Insert();
        end;

        Message('New Item added to the Cart.');

        BCUserInformationCue.SetRange(Username, BCCart.Username);
        BCUserInformationCue.SetRange(Email, BCCart.Email);
        BCUserInformationCue.FindFirst();
        BCUserInformationCue.Cart += 1;
        BCUserInformationCue.CartValue := BCCart.TotalAmount;
        BCUserInformationCue.Modify();
    end;

    procedure OpenYourCart()
    var
        BCCart: Record BCCart;
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        BCWebShopSetup.Get();

        BCCart.SetRange(Username, BCWebShopSetup.LoggedInUsername);
        BCCart.SetRange(Email, BCWebShopSetup.LoggedInEmail);

        Page.Run(50110, BCCart);
    end;

    procedure AddNewItemToFavorites(var BCStoreItems: Record "BCStore Items")
    var
        BCFavorites: Record BCFavorites;
        BCWebShopSetup: Record "BCWeb Shop Setup";
        BCUserInformationCue: Record "BCUser Information Cue";
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername = '') and (BCWebShopSetup.LoggedInEmail = '') then
            Error('Please Log In in order to Add Items to Favorites.');

        BCFavorites.SetRange(Username, BCWebShopSetup.LoggedInUsername);
        BCFavorites.SetRange(Email, BCWebShopSetup.LoggedInEmail);
        BCFavorites.SetRange("Item No.", BCStoreItems."No.");

        if not BCFavorites.IsEmpty then
            Message('Item is already in Favorites.')
        else begin
            BCFavorites.Init();
            BCFavorites.Username := BCWebShopSetup.LoggedInUsername;
            BCFavorites.Email := BCWebShopSetup.LoggedInEmail;
            BCFavorites."Item No." := BCStoreItems."No.";
            BCFavorites.Description := BCStoreItems.Description;
            BCFavorites."Item Category" := BCStoreItems."Item Category";
            BCFavorites."Unit Price" := BCStoreItems."Unit Price";
            BCFavorites."Base Unit of Measure" := BCStoreItems."Base Unit of Measure";
            BCFavorites.Inventory := BCStoreItems.Inventory;
            BCFavorites.Insert();

            Message('New Item added to the Favorites.');

            BCUserInformationCue.SetRange(Username, BCFavorites.Username);
            BCUserInformationCue.SetRange(Email, BCFavorites.Email);
            BCUserInformationCue.FindFirst();
            BCUserInformationCue.Favorites += 1;
            BCUserInformationCue.Modify();
        end;
    end;

    procedure OpenYourFavorites()
    var
        BCFavorites: Record BCFavorites;
        BCWebShopSetup: Record "BCWeb Shop Setup";
    begin
        BCWebShopSetup.Get();

        BCFavorites.SetRange(Username, BCWebShopSetup.LoggedInUsername);
        BCFavorites.SetRange(Email, BCWebShopSetup.LoggedInEmail);

        Page.Run(50111, BCFavorites);
    end;
}