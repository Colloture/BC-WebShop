codeunit 50106 "BCLogOut"
{
    trigger OnRun()
    begin
        BCWebShopSetup.Get();
        if (BCWebShopSetup.LoggedInUsername = '') and (BCWebShopSetup.LoggedInEmail = '') then
            exit;
        BCWebShopSetup.LoggedInUsername := '';
        BCWebShopSetup.LoggedInEmail := '';
        BCWebShopSetup.Modify();
        Message('Successfull logout.');
    end;

    var
        BCWebShopSetup: Record "BCWeb Shop Setup";

    procedure IsLoggedIn(): Boolean
    begin
        if (BCWebShopSetup.LoggedInUsername <> '') and (BCWebShopSetup.LoggedInEmail <> '') then
            exit(true)
        else
            exit(false);
    end;
}