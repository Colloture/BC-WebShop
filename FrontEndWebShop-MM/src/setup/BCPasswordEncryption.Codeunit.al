codeunit 50103 "BCPasswordEncryption"
{
    // TODO - gde pozvati?
    SingleInstance = true;

    trigger OnRun()
    begin
        StorePassword('admin', 'Pa$$w0rd!'); // iz setup-a?
        if UserExists('admin') then
            Message('%1', GetPassword('admin'))
        else
            Message('User with this username doesnt''t exists.');
    end;

    local procedure UserExists(User: Text): Boolean
    var
        Pwd: Text;
    begin
        exit(IsolatedStorage.Get(User, Pwd));
    end;

    local procedure StorePassword(User: Text; Pwd: Text): Boolean
    begin
        if EncryptionEnabled() then
            exit(IsolatedStorage.SetEncrypted(User, Pwd, DataScope::Module))
        else
            exit(IsolatedStorage.Set(User, Pwd, DataScope::Module));
    end;

    local procedure GetPassword(User: Text) PWd: Text
    begin
        IsolatedStorage.Get(User, Pwd);
        exit(Pwd);
    end;
}