pageextension 50002 "URG Sales Order List" extends "Sales Order List"
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