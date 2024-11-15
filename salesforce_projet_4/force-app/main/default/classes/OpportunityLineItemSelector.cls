public with sharing class OpportunityLineItemSelector {
  public static List<OpportunityLineItem> getProductByOpportunityID(
    Id OpportunityId
  ) {
    try {
      return [
        SELECT
          Id,
          Product2.Name,
          UnitPrice,
          TotalPrice,
          Quantity,
          Product2.QuantityInStock__c
        FROM OpportunityLineItem
        WHERE OpportunityId = :OpportunityId
      ];
    } catch (Exception e) {
      throw new AuraHandledException(
        'Erreur lors de la recuperation de l’OpportunityLineItem : ' +
        e.getMessage()
      );
    }
  }

  public static void delOpportunityID(Id lineItemId) {
    try {
      // Rechercher l'OpportunityLineItem spécifique
      OpportunityLineItem lineItem = [
        SELECT Id
        FROM OpportunityLineItem
        WHERE Id = :lineItemId
        LIMIT 1
      ];

      // Supprimer l'OpportunityLineItem
      delete lineItem;
    } catch (Exception e) {
      throw new AuraHandledException(
        'Erreur lors de la suppression de l’OpportunityLineItem : ' +
        e.getMessage()
      );
    }
  }
}
