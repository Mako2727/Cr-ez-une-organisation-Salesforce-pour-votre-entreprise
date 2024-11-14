@IsTest
public class TestDataFactory {
    
  public static Account createTestAccount() {
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
    return testAccount;
}

public static Product2 createTestProduct() {
    Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
    insert testProduct;
    return testProduct;
}

public static Pricebook2 standardPriceBook(){
  Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

return standardPriceBook;
}

public static PricebookEntry createStandardPricebookEntry(Id productId) {
    // Récupère le catalogue de prix standard
    //Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
   ID standardPriceBook = Test.getStandardPricebookId();
    // Crée l'entrée de catalogue de prix standard
    PricebookEntry standardPriceEntry = new PricebookEntry(
        Pricebook2Id = standardPriceBook,
        Product2Id = productId,
        UnitPrice = 100.00,
        IsActive = true
    );
    insert standardPriceEntry;
    return standardPriceEntry;
}

public static Pricebook2 createTestPricebook2() {
    // Crée un catalogue de prix personnalisé
    Pricebook2 customPriceBook = new Pricebook2(Name = 'Test Pricebook', IsActive = true);
    insert customPriceBook;
    return customPriceBook;
}

public static Opportunity createTestOpportunity(Id accountId, Id pricebookId) {
    Opportunity testOpportunity = new Opportunity(
        Name = 'Test Opportunity',
        StageName = 'Prospecting',
        CloseDate = Date.today(),
        AccountId = accountId,
        Pricebook2Id = pricebookId
    );
    insert testOpportunity;
    return testOpportunity;
}

public static OpportunityLineItem createTestOpportunityLineItem(Id opportunityId, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
    OpportunityLineItem testOppLineItem = new OpportunityLineItem(
        OpportunityId = opportunityId,
        PricebookEntryId = pricebookEntryId,
        Quantity = quantity,
        UnitPrice = unitPrice
    );
    insert testOppLineItem;
    System.debug('Inserted opp: ' + testOppLineItem);
    return testOppLineItem;
}
}