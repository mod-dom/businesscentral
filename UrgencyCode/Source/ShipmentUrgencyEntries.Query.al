query 50000 "URG Shipment Urgency Entries"
{
    QueryType = Normal;
    elements
    {
        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            DataItemTableFilter = Type = filter(Item);
            column(No_; "No.")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            dataitem(SalesShipmentHeader; "Sales Shipment Header")
            {
                DataItemLink = "No." = SalesShipmentLine."Document No.";
                DataItemTableFilter = "URG Urgency Code" = filter(> 0);
                SqlJoinType = InnerJoin;
                column(Urgency_Code; "URG Urgency Code")
                {

                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}