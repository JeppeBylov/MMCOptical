codeunit 60000 "Events Subscribers MMC"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnRunOnAfterPostPurchLine, '', false, false)]
    local procedure "Purch.-Post_OnRunOnAfterPostPurchLine"(var TempPurchLineGlobal: Record "Purchase Line" temporary; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var ReturnShipmentHeader: Record "Return Shipment Header")
    var
        MMCSalesPriceManagement: Codeunit "MMC Sales Price Management";
    begin
        if PurchInvHeader."No." = '' then
            exit;

        if TempPurchLineGlobal.Type = TempPurchLineGlobal.Type::Item then
            MMCSalesPriceManagement.CreateNewSalesPrice(TempPurchLineGlobal);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostPurchLine, '', false, false)]
    local procedure "Purch.-Post_OnBeforePostPurchLine"(var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        Item: Record Item;
        SingleInstanceMgt: Codeunit "Single Instance Mgt. MMC";
    begin
        if PurchLine.Type = PurchLine.Type::Item then begin
            Item.Get(PurchLine."No.");
            SingleInstanceMgt.SetOldLastDirectCost(Item."Last Direct Cost");
        end;
    end;
}