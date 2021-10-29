page 50110 "BCCart"
{
    Caption = 'Cart';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCCart";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Username; Rec.Username)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Username field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Item Category"; Rec."Item Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.';
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TotalAmount field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Buy)
            {
                ApplicationArea = All;
                Caption = 'Buy';
                ToolTip = 'Executes the Buy action.';
                Image = Sales;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                RunObject = codeunit BCBuyFromCart;
            }
        }
    }

}