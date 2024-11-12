@IsTest
public class TestDataFactory {
  public static Account createTestAccount() {
    Account acc = new Account(Name = 'Test Account');
    insert acc;
    return acc;
  }

  public static Opportunity createTestOpportunity(Id accountId) {
    Opportunity opp = new Opportunity(
      Name = 'Test Opportunity',
      StageName = 'Prospecting',
      CloseDate = System.today().addDays(30),
      Amount = 10000,
      AccountId = accountId
    );
    insert opp;
    return opp;
  }

  public static Case createTestCase(Id accountId, String subject) {
    Case testCase = new Case(
      Subject = subject,
      Status = 'New',
      Priority = 'Medium',
      AccountId = accountId
    );
    insert testCase;
    return testCase;
  }

  // Méthode pour créer un utilisateur de test
  public static User createTestUser(String profileName) {
    Profile profile = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
    User testUser = new User(
      FirstName = 'Test',
      LastName = 'User',
      Alias = 'tuser',
      Email = 'testuser@example.com',
      Username = 'testuser@example.com' + System.currentTimeMillis(),
      ProfileId = profile.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US'
    );
    insert testUser;
    return testUser;
  }

}
