pageextension 60000 "Item Card MMC" extends "Item Card"
{
    actions
    {
        // Add changes to page actions here
        addafter("Co&mments")
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Item Track Change', comment = '="Test af itemtracking Change"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = AbsenceCalendar;

                trigger OnAction()
                var
                    Options: Text[30];
                    Selected: Integer;
                    Text000: Label 'Ingen,Lotnummer,Serienummer';
                    Text001: Label 'You selected option %1.';
                    Text002: Label 'Ændrer varesporing på varen til  - (HUSK at nedjustere antallet til nul inden ændring af varesporingskode!!)';
                begin
                    // Message('Test');
                    Options := Text000;
                    Selected := Dialog.StrMenu(Options, 1, Text002);
                    if confirm('Ændrer varesporing på varen til  - HUSK at nedjustere antallet til nul inden ændring af varesporingskode!!') then
                        ChangeItemTracking(format(Rec."No."), Selected);
                end;
            }
        }
    }

    procedure ChangeItemTracking(ItemNumber: Text; NewType: Integer)
    var
        myInt: Integer;
        NewTypetxt: Text;
        MyItem: Record Item;
    begin
        case NewType of
            1:
                NewTypetxt := '';
            2:
                NewTypetxt := 'LOTALL';
            3:
                NewTypetxt := 'SERIEALL'
        end;
        MyItem.setfilter("No.", ItemNumber);
        if myitem.findset then begin
            myitem."Item Tracking Code" := NewTypetxt;
            MyItem."Lot Nos." := '';
            Myitem.Modify();
        end;
    end;
}
