codeunit 50000 "URG Urgency - Web Service"
{
    trigger OnRun()
    begin

    end;

    var
        WebServiceMgt: Codeunit "Web Service Management";

    procedure CreateWebService()
    var
        TempTenantWebService: Record "Tenant Web Service" temporary;
    begin
        OnBeforeCreateWeService(TempTenantWebService);
        if TempTenantWebService."Service Name" <> '' then
            exit;
        PrepareWebService(TempTenantWebService);
        WebServiceMgt.CreateTenantWebService(
                            TempTenantWebService."Object Type",
                            TempTenantWebService."Object ID",
                            TempTenantWebService."Service Name",
                            true);
    end;

    procedure PrepareWebService(var TenantWebService: Record "Tenant Web Service")
    begin
        TenantWebService."Object Type" := TenantWebService."Object Type"::Query;
        TenantWebService."Object ID" := 50000;
        TenantWebService."Service Name" := 'URG Shipment Urgency Entries';
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateWeService(var TenantWebService: Record "Tenant Web Service")
    begin
    end;
}