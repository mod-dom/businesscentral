tableextension 50001 "URG Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "URG Urgency Code"; Enum "URG Urgency Code")
        {
            Caption = 'Urgency Code';
            DataClassification = CustomerContent;
            Description = 'Prioritize Order Handling';
        }

    }

}