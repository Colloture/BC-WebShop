codeunit 50106 "BCLogOut"
{
    trigger OnRun()
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
    begin
        if BCLoggedInUser.GetUser() = '' then
            exit;

        BCLoggedInUser.SetUser('');

        Message('Successfull logout.');
    end;
}