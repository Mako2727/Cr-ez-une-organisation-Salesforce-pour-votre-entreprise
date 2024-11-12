@IsTest
private class AccountOpportunitiesControllerTest {
  @TestSetup
  static void setup() {
  }

  @IsTest
  static void testGetOpportunities() {
    Account testAccount = [SELECT Id FROM Account LIMIT 1];
    System.assertNotEquals(null, testAccount.Id, 'Le compte de test devrait exister.');

    Test.startTest();
    List<OpportunityLineItem> results = AccountOpportunitiesController.getOpportunities(testAccount.Id);
    Test.stopTest();
    
    // Validation du résultat
    System.assertEquals(1, results.size(), 'Devrait retourner une ligne d’opportunité');
  }
}