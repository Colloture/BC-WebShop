codeunit 50110 "BCAuthorization"
{
    procedure SetAuthorization(var BCWebShopSetup: Record "BCWeb Shop Setup"; var httpClient: httpClient)
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthString: Text;
        AuthLbl: Label 'Basic %1', Comment = '%1 is Auth String';
        UserPwdTok: Label '%1:%2', Comment = '%1 is Username, %2 is Password';
    begin
        AuthString := StrSubstNo(UserPwdTok, BCWebShopSetup."Backend Username", BCWebShopSetup."Backend Password");
        AuthString := Base64Convert.ToBase64(AuthString);
        httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(AuthLbl, AuthString));
    end;
}