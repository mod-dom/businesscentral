enum 50000 "URG Urgency Code"
{
    Extensible = true;

    value(0; None) { }
    value(1; Normal)
    {
        Caption = 'Normal';
    }
    value(2; Speed)
    {
        Caption = 'Speed';
    }
    value(3; Panic)
    {
        Caption = 'Panic';
    }
}