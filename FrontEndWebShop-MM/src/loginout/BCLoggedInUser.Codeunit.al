codeunit 50119 "BCLoggedIn User"
{
    SingleInstance = true;

    procedure GetUser(): Text[250]
    begin
        exit(Username);
    end;

    procedure SetUser(Name: Text[250])
    begin
        Username := Name;
    end;

    procedure GetUserNo(): Code[20]
    begin
        exit(UserNo);
    end;

    procedure SetUserNo(No: Code[20])
    begin
        UserNo := No;
    end;

    procedure Register(Password: Text[250])
    begin
        if not IsolatedStorage.Contains(Username) then
            IsolatedStorage.Set(Username, Password)
        else
            Error('Customer with this Username already exists.');
    end;

    procedure ValidatePassword(Password: Text[250])
    var
        PasswordFromStorage: Text;
    begin
        if not IsolatedStorage.Get(Username, PasswordFromStorage) then
            Error('Customer with this Username doesn''t exist.');

        if PasswordFromStorage <> Password then
            Error('Wrong password.');
    end;

    var
        Username: Text[250];
        UserNo: Code[20];
}