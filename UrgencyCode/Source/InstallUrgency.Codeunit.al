codeunit 50006 "URG Install Urgency"
{
    Subtype = Install;

    trigger OnRun()
    begin

    end;

    trigger OnInstallAppPerDatabase();
    var
        myAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo);

        if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then
            HandleFreshInstall();
    end;

    local procedure HandleFreshInstall();
    var
        UrgencyWebService: Codeunit "URG Urgency - Web Service";
    begin
        UrgencyWebService.CreateWebService();
    end;
}