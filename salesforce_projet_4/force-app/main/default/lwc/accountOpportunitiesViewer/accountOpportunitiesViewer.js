import { LightningElement, api, wire, track } from "lwc";
import getOpportunities from "@salesforce/apex/AccountOpportunitiesController.getOpportunities";
import deleteOpportunity from "@salesforce/apex/AccountOpportunitiesController.deleteOpportunity";
import { getRecord } from "lightning/uiRecordApi";
import Id from "@salesforce/user/Id";
import PROFILE_NAME_FIELD from "@salesforce/schema/User.Profile.Name";
import { RefreshEvent } from "lightning/refresh";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AccountOpportunitiesViewer extends LightningElement {
  @api recordId;
  @track opportunitiesListItem ;
  @track error = {};
  wiredOpportunitiesResult;
  wiredProfileResult;
  @track isStockBelowZero = false;
  @track userProfileName;
  userId = Id;
  draftValues = [];

  @wire(getRecord, { recordId: "$userId", fields: [PROFILE_NAME_FIELD] })
  wiredUserRecord({ error, data }) {
   
    if (data) {
      this.userProfileName = data.fields.Profile.value.fields.Name.value;
      console.log("this.userProfileName :", this.userProfileName);
    } else if (error) {
      console.error(
        "Erreur lors de la récupération du profil utilisateur :",
        error
      );
    }
  }

  get columns() {
    // Définir les colonnes en fonction du profil
    console.log("this.userProfileName = "+ this.userProfileName);
    if (this.userProfileName === "System Administrator") {
      AccountOpportunitiesViewer.columns= [
        { label: "Nom Produit", fieldName: "ProductName", type: "Text" },
        {
          label: "Quantité",
          fieldName: "Quantity",
          type: "Number",
          cellAttributes: {
            class: { fieldName: "StockAfterOrderStyle" } // Applique une classe conditionnelle
          }
        },
        { label: "Prix unitaire", fieldName: "UnitPrice", type: "Currency" },
        { label: "Prix Total", fieldName: "TotalPrice", type: "Currency" },
        {
          label: "Quantité en stock",
          fieldName: "ProductQuantityInStock",
          type: "Number",
          StyleSheet: ""
        },

        {
          type: "button-icon",
          label: "Supprimer", // Nom du bouton pour supprimer
          typeAttributes: {
            name: "delete", // Nom de l'action
            title: "Cliquez pour supprimer",
            disabled: false,
            value: "delete",
            iconPosition: "left",
            iconName: "utility:delete"
          }
        },
        {
          type: "button",
          label: "Voir Produit", // Nom du bouton pour voir le produit
          typeAttributes: {
            label: "Voir Produit",
            name: "view", // Nom de l'action
            title: "Voir Produit",
            disabled: false,
            value: "view",
            iconPosition: "left",
            iconName: "utility:preview",
            variant: "brand"
          }
        }
      ];
    } else {
      AccountOpportunitiesViewer.columns= [
        { label: "Nom Produit", fieldName: "ProductName", type: "Text" },
        {
          label: "Quantité",
          fieldName: "Quantity",
          type: "Number",
          cellAttributes: {
            class: { fieldName: "StockAfterOrderStyle" } // Applique une classe conditionnelle
          }
        },
        { label: "Prix unitaire", fieldName: "UnitPrice", type: "Currency" },
        { label: "Prix Total", fieldName: "TotalPrice", type: "Currency" },
        {
          label: "Quantité en stock",
          fieldName: "ProductQuantityInStock",
          type: "Number",
          StyleSheet: ""
        },

        {
          type: "button-icon",
          label: "Supprimer", // Nom du bouton pour supprimer
          typeAttributes: {
            name: "delete", // Nom de l'action
            title: "Cliquez pour supprimer",
            disabled: false,
            value: "delete",
            iconPosition: "left",
            iconName: "utility:delete"
          }
        }
      ];
    }
    console.log("columns opportunity=" , AccountOpportunitiesViewer.columns);
    return AccountOpportunitiesViewer.columns;
  }

  @wire(getOpportunities, { opportunityId: "$recordId" })
  wiredOpportunities(result) {
    console.log("OpportunityId=" + this.recordId);
    this.wiredOpportunitiesResult = result; // Stocke le résultat

    const { data, error } = result;
    this.isLoading = true; // Indicateur de chargement

    try {
      if (data) {
        console.log("data=", data);
        const formattedData = data.map((item) => {
          const stockAfterOrder = item.Product2
            ? item.Product2.QuantityInStock__c - item.Quantity
            : null;
          const stockStyle =
            stockAfterOrder < 0
              ? "slds-text-color_error slds-text-title_bold slds-theme_alert-texture slds-theme_shade"
              : "slds-text-color_success slds-text-title_bold";
          // Mettre à jour la variable si le stock est inférieur à 0
          if (stockAfterOrder < 0) {
            this.isStockBelowZero = true;
          }

          return {
            Id: item.Id,
            ProductName: item.Product2 ? item.Product2.Name : null,
            UnitPrice: item.UnitPrice,
            TotalPrice: item.TotalPrice,
            Quantity: item.Quantity,
            ProductQuantityInStock: item.Product2
              ? item.Product2.QuantityInStock__c
              : null,
            StockAfterOrder: stockAfterOrder,
            StockAfterOrderStyle: stockStyle
          };
        });

        this.opportunitiesListItem = formattedData;
        this.error = undefined;
        this.isLoading = false; // Arrête le chargement
       
      } else if (error) {
        this.error = error;
        this.opportunitiesListItem = undefined;
        this.isLoading = false; // Arrête le chargement
       
      }
    } catch (e) {
      console.error("Une erreur s'est produite :", e);
    }
     return this.opportunitiesListItem;
  }

  get showTable() {
    return (
      this.userProfileName &&
      this.opportunitiesListItem &&
      this.opportunitiesListItem.length > 0
    );
  }

  get showQuantiteError() {
    var test = this.isStockBelowZero;
    console.log("showQuantiteError = " + test);
    return test;
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    console.log("actionName : " + actionName);
    console.log("Event details:", event.detail);
    if (actionName === "delete") {
      this.deleteOpportunity(row);
    } else if (actionName === "view") {
      this.viewProduct(row);
    }
  }

  async deleteOpportunity(row) {
    try {
      // Appeler la méthode Apex pour supprimer l'opportunité
      console.log("row.Id :" + row.Id);
      await deleteOpportunity({ opportunityId: row.Id });
      // Mettre à jour la liste des opportunités dans le composant
      this.opportunitiesListItem = this.opportunitiesListItem.filter(
        (opp) => opp.Id !== row.Id
      );
      // Afficher un toast de succès
      this.showToast("Succès", "Opportunité supprimée avec succès.", "success");

      // Afficher un toast de succès
      this.showToast("Succès", "Opportunité supprimée avec succès.", "success");
      this.dispatchEvent(new RefreshEvent());
    } catch (error) {
      console.error("Erreur lors de la suppression de l’opportunité :", error);
      console.error("Erreur = :" + error);
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  viewProduct(row) {
    // Logique pour afficher le détail du produit
    console.log(`Voici l id du produit ${row.Id} `);
    //const productId = row.Id; // Obtenez l'ID du produit
    const productUrl = `/lightning/r/OpportunityLineItem/${row.Id}/view`; // Générer l'URL de la page de détails
    console.log(`Voici l url  ` + productUrl);
    window.open(productUrl, "_blank"); // Ouvrir dans un nouvel onglet
  }
}
