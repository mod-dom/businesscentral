pageextension 50001 "URG Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(URGUrgencyCode; "URG Urgency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies priority for order handling';
                Editable = false;
            }
        }
    }
}