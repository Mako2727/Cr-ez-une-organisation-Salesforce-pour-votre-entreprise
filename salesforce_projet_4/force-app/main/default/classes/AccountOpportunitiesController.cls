public with sharing class AccountOpportunitiesController {
  @AuraEnabled(Cacheable=true)
  public static List<OpportunityLineItem> getOpportunities(Id opportunityId) {
    try {
      return OpportunityLineItemSelector.getProductByOpportunityID(
        opportunityId
      );
    } catch (Exception e) {
      // Lance une exception gérée pour que le LWC puisse comprendre l'erreur
      throw new AuraHandledException(
        'Erreur lors de la recherche des cas: ' + e.getMessage()
      );
    }
  }

  @AuraEnabled
  public static void deleteOpportunity(Id opportunityId) {
    try {
      // Supprimer l'opportunité
      OpportunityLineItemSelector.delOpportunityID(opportunityId);
    } catch (Exception e) {
      throw new AuraHandledException(
        'Erreur lors de la suppression de l’opportunité : ' + e.getMessage()
      );
    }
  }
}
