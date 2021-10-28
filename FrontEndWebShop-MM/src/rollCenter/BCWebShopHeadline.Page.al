page 50106 "BCWeb Shop Headline"
{
    Caption = 'Web Shop Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = true;

                field(GreetingText1; Headline1Txt)
                {
                    ApplicationArea = All;
                    Caption = 'Greeting';
                    Editable = false;
                }
                field(GreetingText2; Headline2Txt)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        BCStoreItems: Page "BCStore Items";
                    begin
                        BCStoreItems.Run();
                    end;
                }
            }
        }
    }

    var
        Headline1Txt: Label 'Welcome to the Sports Equipment Web Shop';
        Headline2Txt: Label 'Explore Available Items';
}