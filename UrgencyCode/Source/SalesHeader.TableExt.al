tableextension 50000 "URG Sales Header" extends "Sales Header"
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