page 50111 "BCCustomerMM"
{
    Caption = 'Customer MM';
    PageType = API;
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityName = 'customerMM';
    EntitySetName = 'customersMM';
    SourceTable = Customer;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(name; Rec.Name)
                {
                }
                field(email; Rec."E-Mail")
                {
                }
                field(address; Rec.Address)
                {
                }
                field(phone; Rec."Phone No.")
                {
                }
            }
        }
    }
}