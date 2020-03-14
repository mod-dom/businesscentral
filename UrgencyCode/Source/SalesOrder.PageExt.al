pageextension 50000 "URG Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(URGUrgencyCode; "URG Urgency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies priority for order handling';
            }
        }
    }
}