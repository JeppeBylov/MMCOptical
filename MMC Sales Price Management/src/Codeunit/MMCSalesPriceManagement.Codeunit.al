codeunit 60001 "MMC Sales Price Management"
{
    procedure CreateNewSalesPrice(var TempPurchLine: Record "Purchase Line" temporary)
    var
        Item: Record Item;
        SalesPrice: Record "Sales Price";
        NewSalesPrice: Record "Sales Price";
        SingleInstanceMgt: Codeunit "Single Instance Mgt. MMC";
        OldLastDirectCost: Decimal;
        UnitPrice: Decimal;
    begin
        UnitPrice := 0;

        Item.Get(TempPurchLine."No.");
        OldLastDirectCost := SingleInstanceMgt.GetOldLastDirectCost();

        if OldLastDirectCost < TempPurchLine."Direct Unit Cost" then begin
            SalesPrice.SetRange("Item No.", TempPurchLine."No.");
            SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"All Customers");
            if SalesPrice.IsEmpty then
                if Item."Unit Price" <> 0 then
                    UnitPrice := Item."Unit Price" + Round(Item."Unit Price" * Item."Profit %" / 100);

            SalesPrice.SetFilter("Starting Date", '<=%1', Today());
            SalesPrice.SetRange("Currency Code", TempPurchLine."Currency Code");
            SalesPrice.SetRange("Variant Code", TempPurchLine."Variant Code");
            SalesPrice.SetRange("Unit of Measure Code", TempPurchLine."Unit of Measure Code");
            SalesPrice.SetFilter("Ending Date", '>= %1|%2', Today(), 0D);
            if SalesPrice.FindLast() then
                UnitPrice := SalesPrice."Unit Price" + Round(SalesPrice."Unit Price" * Item."Profit %" / 100);

            if UnitPrice <> 0 then begin
                NewSalesPrice.Init();
                NewSalesPrice."Item No." := TempPurchLine."No.";
                NewSalesPrice."Sales Type" := NewSalesPrice."Sales Type"::"All Customers";
                NewSalesPrice."Starting Date" := Today();
                NewSalesPrice."Currency Code" := TempPurchLine."Currency Code";
                NewSalesPrice."Variant Code" := TempPurchLine."Variant Code";
                NewSalesPrice."Unit of Measure Code" := TempPurchLine."Unit of Measure Code";
                NewSalesPrice."Unit Price" := UnitPrice;
                if not NewSalesPrice.Insert() then
                    NewSalesPrice.Modify();

                Item.Validate("Unit Price", UnitPrice);
                Item.Modify();
            end;
        end;
    end;
}