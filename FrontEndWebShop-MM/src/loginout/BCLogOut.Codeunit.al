codeunit 50106 "BCLogOut"
{
    trigger OnRun()
    var
        BCLoggedInUser: Codeunit "BCLoggedIn User";
    begin
        if BCLoggedInUser.GetUser() = '' then
            Error('No one is logged in.');

        BCLoggedInUser.SetUser('');

        Message('Successfull logout.');
    end;
}