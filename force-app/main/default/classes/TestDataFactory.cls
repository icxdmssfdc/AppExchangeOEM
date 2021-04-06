/*
* Author:- Somesh Mamidwar
* Created:- 22-03-2021
* Last Updated:- 
* Feature:- TestDataFactory
* Description:- This class is created to setup all test data.
*/

@isTest 
public with sharing class TestDataFactory {

    // This method is to create Dealer Account
    public static Account createDealerAccount()
    {
        Id accDealerRectId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Dealer Account';
        acc.recordTypeId = accDealerRectId;
        acc.Credit_Limit__c=200000;
        insert acc;
        return acc;
    }

    // This method is to create Retailer Account
    public static Account createRetailerAccount(Id accId)
    {
        Id accRetailererRectId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Retailer Account';
        acc.recordTypeId = accRetailererRectId;
        acc.ParentId=accId;
        insert acc;
        return acc;
    }
    //This method is to create Contact
    public static Contact createContact(Id accId)
    {
           Contact con = new Contact();
           con.FirstName='Test';
           con.LastName='Contact';
           con.AccountId=accId;
           insert con;
        return con;
    }
    
    // This method is to create Product
    public static icxdmsv1__Products__c createProduct(String prodName)
    {
        icxdmsv1__Products__c prod = new icxdmsv1__Products__c();
        prod.Name = prodName;
        prod.icxdmsv1__Family__c = 'Others';
        prod.icxdmsv1__IsActive__c = true;
        prod.icxdmsv1__Default_Price__c = 200;
        prod.icxdmsv1__Min_Qty__c = 200;
        prod.icxdmsv1__Max_Qty__c = 500;
        prod.icxdmsv1__StockKeepingUnit__c = 'TESTSKU0011';
        insert prod;
        return prod;
    }

}