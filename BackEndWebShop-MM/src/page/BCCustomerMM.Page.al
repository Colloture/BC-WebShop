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
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                }
                field(customerPostingGroup; Rec."Customer Posting Group")
                {
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                }
            }
        }
    }
}