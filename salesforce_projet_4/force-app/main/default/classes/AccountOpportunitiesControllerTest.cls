@IsTest
private class AccountOpportunitiesControllerTest {
  @TestSetup
  static void setup() {
    // Création d'un compte de test
    Account testAccount = TestDataFactory.createTestAccount();

    // Récupération du Pricebook standard
    Id standardPriceBook = Test.getStandardPricebookId();
    // Création des données de test
    System.debug('standardPriceBook =' + standardPriceBook);
    Opportunity testOpportunity = TestDataFactory.createTestOpportunity(
      testAccount.Id,
      standardPriceBook
    );
    System.debug('testOpportunity =' + testOpportunity);
    Product2 testProduct = TestDataFactory.createTestProduct();
    System.debug('testProduct =' + testProduct);
    PricebookEntry standardPrice = TestDataFactory.createStandardPricebookEntry(
      testProduct.Id
    );
    System.debug('standardPrice =' + standardPrice);

    // Création d'un OpportunityLineItem de test
    OpportunityLineItem opp = TestDataFactory.createTestOpportunityLineItem(
      testOpportunity.Id,
      standardPrice.Id,
      2,
      50.00
    );
    System.debug('opp =' + opp);
    System.debug('opp.OpportunityId =' + opp.OpportunityId);
  }

  @IsTest
  static void testgetOpportunities() {
    OpportunityLineItem opp = [
      SELECT OpportunityId
      FROM OpportunityLineItem
      LIMIT 1
    ];
    // Vérification de l'existence de l'enregistrement avant d'appeler la méthode
    System.assertNotEquals(
      null,
      opp,
      'No OpportunityLineItem was found in the test data'
    );
    Test.startTest();
    // Appel de la méthode testée
    System.debug('opp.OpportunityId =' + opp.OpportunityId);
    List<OpportunityLineItem> results = AccountOpportunitiesController.getOpportunities(
      opp.OpportunityId
    );
    Test.stopTest();

    // Validation des résultats
    System.assertEquals(
      1,
      results.size(),
      'Should return one opportunity line item'
    );
  }

  @IsTest
  static void testdeleteOpportunity() {
    // Récupérer une opportunité insérée pour la suppression
    OpportunityLineItem testOpportunityLineItem = [
      SELECT Id
      FROM OpportunityLineItem
      LIMIT 1
    ];
    // Assurez-vous que l'opportunité existe avant de procéder à la suppression
    System.assertNotEquals(
      null,
      testOpportunityLineItem,
      'Opportunity should exist'
    );
    System.debug('testOpportunityLineItem =' + testOpportunityLineItem.Id);
    Test.startTest();
    OpportunityLineItemSelector.delOpportunityID(testOpportunityLineItem.Id);
    Test.stopTest();
    List<OpportunityLineItem> deletedOppLineItems = [
      SELECT Id
      FROM OpportunityLineItem
      WHERE Id = :testOpportunityLineItem.Id
    ];
    System.assertEquals(
      0,
      deletedOppLineItems.size(),
      'OpportunityLineItems should be deleted'
    );
  }
}
