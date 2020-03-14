pageextension 50003 "URG Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field(URGUrgencyCode; "URG Urgency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies priority for order handling';
            }

        }
    }
}