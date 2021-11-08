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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
            group(Totals)
            {
                field(Total; TotalAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(IncQuantity)
            {
                ApplicationArea = All;
                Caption = 'Increase Quantity';
                ToolTip = 'Executes the Increase Quantity action.';
                Image = Add;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IncreaseQuantity();
                end;
            }
            action(DecQuantity)
            {
                ApplicationArea = All;
                Caption = 'Decrease Quantity';
                ToolTip = 'Executes the Decrease Quantity action.';
                Image = AdjustEntries;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DecreaseQuantity();
                end;
            }
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

    local procedure IncreaseQuantity()
    var
        BCStoreItems: Record "BCStore Items";
        BCUserInformationCue: Record "BCUser Information Cue";
    begin
        if Rec."Item No." = '' then
            exit;

        BCStoreItems.Get(Rec."Item No.");
        if Rec.Quantity = BCStoreItems.Inventory then begin
            Message('You reached maximum amount for this Item.');
            exit;
        end;

        Rec.Quantity += 1;
        Rec.Amount += Rec."Unit Price";
        Rec.TotalAmount += Rec."Unit Price";
        Rec.Modify();

        BCUserInformationCue.SetRange(Username, Rec.Username);
        BCUserInformationCue.FindFirst();
        BCUserInformationCue.CartValue := Rec.TotalAmount;
        BCUserInformationCue.Modify();
    end;

    local procedure DecreaseQuantity()
    var
        BCUserInformationCue: Record "BCUser Information Cue";
    begin
        if Rec."Item No." = '' then
            exit;

        if Rec.Quantity = 1 then begin
            Rec.Delete();
            exit;
        end;

        Rec.Quantity -= 1;
        Rec.Amount -= Rec."Unit Price";
        Rec.TotalAmount -= Rec."Unit Price";
        Rec.Modify();

        BCUserInformationCue.SetRange(Username, Rec.Username);
        BCUserInformationCue.FindFirst();
        BCUserInformationCue.CartValue := Rec.TotalAmount;
        BCUserInformationCue.Modify();
    end;
}