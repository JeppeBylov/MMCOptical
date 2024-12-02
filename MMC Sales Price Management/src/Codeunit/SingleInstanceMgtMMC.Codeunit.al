codeunit 60002 "Single Instance Mgt. MMC"
{
    SingleInstance = true;

    procedure SetOldLastDirectCost(OldLastDirectCost: Decimal);
    begin
        GlobalOldLastDirectCost := OldLastDirectCost;
    end;

    procedure GetOldLastDirectCost(): Decimal
    begin
        exit(GlobalOldLastDirectCost);
    end;

    var
        GlobalOldLastDirectCost: Decimal;
}