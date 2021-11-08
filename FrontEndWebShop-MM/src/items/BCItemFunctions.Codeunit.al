codeunit 50108 "BCItemFunctions"
{
    procedure AddNewItemToCart(var BCStoreItems: Record "BCStore Items")
    var
        BCCart: Record BCCart;
    begin
        if BCLoggedInUser.GetUser() = '' then
            Error('Please Log In in order to Add Items to Cart.');

        if BCStoreItems.Inventory = 0 then
            Error('This item isn''t available at the moment.');

        BCCart.SetRange(Username, BCLoggedInUser.GetUser());
        BCCart.SetRange("Item No.", BCStoreItems."No.");

        if not BCCart.IsEmpty then begin
            BCCart.FindFirst();
            BCCart.Quantity += 1;
            BCCart.Amount += BCStoreItems."Unit Price";
            BCCart.Modify();
        end
        else begin
            BCCart.Init();
            BCCart.Username := BCLoggedInUser.GetUser();
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
    end;

    procedure OpenYourCart()
    var
        BCCart: Record BCCart;
    begin
        if BCLoggedInUser.GetUser() = '' then
            Error('Please Log In in order to see your Cart.');

        BCCart.SetRange(Username, BCLoggedInUser.GetUser());

        Page.Run(50110, BCCart);
    end;

    procedure AddNewItemToFavorites(var BCStoreItems: Record "BCStore Items")
    var
        BCFavorites: Record BCFavorites;
    begin
        if BCLoggedInUser.GetUser() = '' then
            Error('Please Log In in order to Add Items to Favorites.');

        BCFavorites.SetRange(Username, BCLoggedInUser.GetUser());
        BCFavorites.SetRange("Item No.", BCStoreItems."No.");

        if not BCFavorites.IsEmpty then
            Message('Item is already in Favorites.')
        else begin
            BCFavorites.Init();
            BCFavorites.Username := BCLoggedInUser.GetUser();
            BCFavorites."Item No." := BCStoreItems."No.";
            BCFavorites.Description := BCStoreItems.Description;
            BCFavorites."Item Category" := BCStoreItems."Item Category";
            BCFavorites."Unit Price" := BCStoreItems."Unit Price";
            BCFavorites."Base Unit of Measure" := BCStoreItems."Base Unit of Measure";
            BCFavorites.Inventory := BCStoreItems.Inventory;
            BCFavorites.Sport := BCStoreItems.Sport;
            BCFavorites.Brand := BCStoreItems.Brand;
            BCFavorites.Insert();

            Message('New Item added to the Favorites.');
        end;
    end;

    procedure OpenYourFavorites()
    var
        BCFavorites: Record BCFavorites;
    begin
        if BCLoggedInUser.GetUser() = '' then
            Error('Please Log In in order to see your Favorites.');

        BCFavorites.SetRange(Username, BCLoggedInUser.GetUser());

        Page.Run(50111, BCFavorites);
    end;

    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
}