codeunit 50007 "URG Test Sales Post Urgency"
{
    // [FEATURE] [Sales Order Urgency] 

    Subtype = Test;
    TestPermissions = NonRestrictive;

    var
        isInitialized: Boolean;
        Assert: Codeunit Assert;
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        LibrarySales: Codeunit "Library - Sales";
        LibraryRandom: Codeunit "Library - Random";
        LibraryInventory: Codeunit "Library - Inventory";

    local procedure Initialize()
    begin
        LibraryTestInitialize.OnTestInitialize(CODEUNIT::"URG Test Sales Post Urgency");
        LibrarySetupStorage.Restore;
        IF IsInitialized THEN
            EXIT;
        LibraryTestInitialize.OnBeforeTestSuiteInitialize(CODEUNIT::"URG Test Sales Post Urgency");
        IsInitialized := TRUE;

        LibrarySetupStorage.Save(DATABASE::"Sales & Receivables Setup");
        LibrarySetupStorage.Save(DATABASE::"Inventory Setup");
        LibrarySetupStorage.Save(DATABASE::"General Ledger Setup");
        LibraryTestInitialize.OnAfterTestSuiteInitialize(CODEUNIT::"URG Test Sales Post Urgency");
    end;

    [Test]
    procedure AssignUrgencyToSalesOrder()
    var
        SalesHeader: Record "Sales Header";
        SalesOrderCard: TestPage "Sales Order";
        UrgencyCode: Enum "URG Urgency Code";
    begin
        // [SCENARIO] Assign Sales Order Urgency level
        // [Given] Setup
        Initialize();

        // [Given] Create Sales Order        
        CreateSalesOrder(SalesHeader, UrgencyCode);

        // [When] Open Sales Order
        OpenSalesOrder(SalesOrderCard, SalesHeader);

        // [Then] Assign urgency level
        UrgencyCode := LibraryRandom.RandIntInRange(1, 3);
        SalesOrderCard.URGUrgencyCode.SetValue(UrgencyCode);
    end;

    [Test]
    procedure AssignUnknownUrgencyLevelToSalesOrder()
    var
        SalesHeader: Record "Sales Header";
        SalesOrderCard: TestPage "Sales Order";
        UrgencyCode: Enum "URG Urgency Code";
    begin
        // [SCENARIO] Assign Sales Order Urgency level
        // [Given] Setup
        Initialize();

        // [Given] Create Sales Order        
        CreateSalesOrder(SalesHeader, UrgencyCode);

        // [When] Open Sales Order
        OpenSalesOrder(SalesOrderCard, SalesHeader);

        // [Then] Assign urgency level
        UrgencyCode := LibraryRandom.RandIntInRange(4, 10);
        asserterror SalesOrderCard.URGUrgencyCode.SetValue(UrgencyCode);
    end;

    [Test]
    procedure PostSalesShipmentWithUrgency()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Location: Record Location;
        ItemNo: Code[10];
        PostedSalesShipment: TestPage "Posted Sales Shipment";
        UrgencyCode: Enum "URG Urgency Code";
    begin
        // [SCENARIO] Set urgency on sales order and post shipment
        // [Given] Setup
        Initialize();

        // [Given] Create Location, Create and/or update Inventory Posting Setup
        CreateLocation(Location);
        LibraryInventory.UpdateInventoryPostingSetup(Location);

        // [Given] Create and Purchase Item
        ItemNo := CreateItem();
        PurchaseItem(ItemNo, Location.Code, LibraryRandom.RandDecInRange(10, 20, 2));

        // [Given] Create Sales Order, Ship
        UrgencyCode := LibraryRandom.RandIntInRange(1, 3);
        CreateSalesOrder(SalesHeader, UrgencyCode);
        CreateSalesOrderLine(SalesLine, SalesHeader, ItemNo, Location.Code);
        ShipSalesOrder(SalesHeader);

        // [When] Open Posted Sales Shipment Card
        OpenPostedSalesShipment(PostedSalesShipment, SalesHeader);

        // [Then] Urgency Code exist on Posted Sales Shipment
        Assert.AreEqual(UrgencyCode, PostedSalesShipment.URGUrgencyCode.AsInteger(), 'Shipment not posted with correct urgency');
    end;

    [Test]
    procedure IsWebServiceRegistered()
    var
        UrgencyWebService: Codeunit "URG Urgency - Web Service";
        TenantWebService: Record "Tenant Web Service";
        TempTenantWebService: Record "Tenant Web Service" temporary;
        WebServices: TestPage "Web Services";
    begin
        // [SCENARIO] Web service is published
        // [Given]
        Initialize();

        // [Given] Object Type, Object ID, Service Name
        UrgencyWebService.PrepareWebService(TempTenantWebService);

        // [When] Open Web Service page
        OpenWebServices(WebServices, TempTenantWebService."Service Name");

        // [Then] Find web service
        Assert.AreEqual(TempTenantWebService."Service Name", WebServices."Service Name".Value(), 'Web service is not published');
    end;

    [Test]
    procedure PostSalesShipmentsWithDifferentUrgency()
    var
        SalesHeader1: Record "Sales Header";
        SalesLine1: Record "Sales Line";
        SalesHeader2: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        Location1: Record Location;
        Location2: Record Location;
        ItemNo1: Code[10];
        ItemNo2: Code[10];
        UrgencyCode1: Enum "URG Urgency Code";
        UrgencyCode2: Enum "URG Urgency Code";
        ShipmentUrgencyEntries: Query "URG Shipment Urgency Entries";
        CountQueryRows: Integer;
    begin
        // [SCENARIO] Post multiple shipments with different urgency level
        // [Given] Setup
        Initialize();

        // [Given] Create Locations, Create and/or update Inventory Posting Setup
        CreateLocation(Location1);
        LibraryInventory.UpdateInventoryPostingSetup(Location1);

        CreateLocation(Location2);
        LibraryInventory.UpdateInventoryPostingSetup(Location2);

        // [Given] Create and Purchase Items on different locations
        ItemNo1 := CreateItem();
        PurchaseItem(ItemNo1, Location1.Code, LibraryRandom.RandDecInRange(10, 20, 2));
        ItemNo2 := CreateItem();
        PurchaseItem(ItemNo2, Location2.Code, LibraryRandom.RandDecInRange(10, 20, 2));

        // [Given] Create Sales Orders, Ship orders
        UrgencyCode1 := LibraryRandom.RandIntInRange(0, 1);
        CreateSalesOrder(SalesHeader1, UrgencyCode1);
        CreateSalesOrderLine(SalesLine1, SalesHeader1, ItemNo1, Location1.Code);
        CreateSalesOrderLine(SalesLine2, SalesHeader1, ItemNo2, Location2.Code);
        ShipSalesOrder(SalesHeader1);

        UrgencyCode2 := LibraryRandom.RandIntInRange(2, 3);
        CreateSalesOrder(SalesHeader2, UrgencyCode2);
        CreateSalesOrderLine(SalesLine1, SalesHeader2, ItemNo1, Location1.Code);
        ShipSalesOrder(SalesHeader2);

        // [When] Run Query published as web service
        ShipmentUrgencyEntries.Open();
        while ShipmentUrgencyEntries.Read() do
            CountQueryRows += 1;
        ShipmentUrgencyEntries.Close();

        // [Then] Check shipment entries with urgency level set
        Assert.AreEqual(3, CountQueryRows, 'Urgency Shipment Entries not equal');
    end;

    local procedure ShipSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        LibrarySales.PostSalesDocument(SalesHeader, TRUE, false);
    end;

    local procedure OpenPostedSalesShipment(var PostedSalesShipment: TestPage "Posted Sales Shipment"; SalesHeader: Record "Sales Header")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        SalesShipmentHeader.SETRANGE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesShipmentHeader.FINDFIRST();

        PostedSalesShipment.OPENEDIT;
        PostedSalesShipment.FILTER.SETFILTER("No.", SalesShipmentHeader."No.");
    end;

    local procedure OpenSalesOrder(var SalesOrder: TestPage "Sales Order"; SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetRecFilter();
        SalesOrder.OPENEDIT();
        SalesOrder.FILTER.SETFILTER("No.", SalesHeader."No.");
    end;

    local procedure CreateSalesOrder(var SalesHeader: Record "Sales Header"; UrgencyCode: Enum "URG Urgency Code")
    begin
        LibrarySales.CreateSalesHeader(
                            SalesHeader,
                            SalesHeader."Document Type"::Order,
                            LibrarySales.CreateCustomerNo());
        SalesHeader."URG Urgency Code" := UrgencyCode;
        SalesHeader.Modify();
    end;

    local procedure CreateSalesOrderLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; ItemNo: Code[20]; LocationCode: Code[10])
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, ItemNo, LibraryRandom.RandIntInRange(5, 10));
    end;

    local procedure CreateItem(): Code[20]
    var
        Item: Record Item;
    begin
        LibraryInventory.CreateItem(Item);
        exit(Item."No.");
    end;

    local procedure CreateLocation(var Location: Record Location): Code[10]
    var
        LibraryWarehouse: Codeunit "Library - Warehouse";
    begin
        LibraryWarehouse.CreateLocation(Location);
    end;

    local procedure PurchaseItem(ItemNo: Code[20]; LocationCode: Code[10]; Quantity: Decimal)
    var
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
    begin
        SelectItemJournalBatch(ItemJournalBatch);
        LibraryInventory.CreateItemJournalLine(
                                ItemJournalLine, ItemJournalBatch."Journal Template Name", ItemJournalBatch.Name,
                                ItemJournalLine."Entry Type"::Purchase, ItemNo, Quantity);
        ItemJournalLine.VALIDATE("Unit Amount", LibraryRandom.RandDecInRange(10, 100, 2));
        ItemJournalLine.MODIFY(TRUE);
        LibraryInventory.PostItemJournalLine(ItemJournalBatch."Journal Template Name", ItemJournalBatch.Name);
    end;

    local procedure SelectItemJournalBatch(var ItemJournalBatch: Record "Item Journal Batch")
    var
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        LibraryInventory.SelectItemJournalTemplateName(ItemJournalTemplate, ItemJournalTemplate.Type::Item);
        LibraryInventory.SelectItemJournalBatchName(ItemJournalBatch, ItemJournalTemplate.Type::Item, ItemJournalTemplate.Name);
        LibraryInventory.ClearItemJournal(ItemJournalTemplate, ItemJournalBatch);
    end;

    local procedure OpenWebServices(var WebServices: TestPage "Web Services"; ServiceName: Text)
    begin
        WebServices.OpenView();
        WebServices.FILTER.SETFILTER("Service Name", ServiceName);
    end;
}