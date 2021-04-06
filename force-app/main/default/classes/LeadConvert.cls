/*
* Author:- Rajani Chatharajupalli
* Created:- 20-03-2021
* Last Updated:- 
* Description:- To convert lead
*/

public with sharing class LeadConvert {
    @InvocableMethod(label = 'Lead Conversion'
    description = 'Converting lead')
    public static void leadConversion(List<FlowInputs> request) {
                

        FlowInputs leadInput = request[0];
        Id inLeadId = leadInput.leadId;   
        Id accntId = leadInput.accId;
        
        system.debug('Lead id is...' + inLeadId);
        
        String UserId='';
        String AccountCId='';
        String ContactId='';
        
            //List<FlowOutputs> leadResults = new List<FlowOutputs>();
        
        if(icxdmsv1__iLead__c.sObjectType.getDescribe().isAccessible()&&
            Schema.sObjectType.icxdmsv1__iLead__c.fields.Id.isAccessible()){
        // Getting Lead data
        icxdmsv1__iLead__c leadinfo =[SELECT Id,Name,icxdmsv1__First_Name__c,icxdmsv1__Last_Name__c,icxdmsv1__Company__c,
                                icxdmsv1__Email__c,icxdmsv1__Mobile__c,icxdmsv1__Lead_Status__c FROM icxdmsv1__iLead__c 
                                WHERE Id= :inLeadId];	
        if(Account.sObjectType.getDescribe().isAccessible()&&
                                Schema.sObjectType.Account.fields.Id.isAccessible()){
        //Getting Account data
        Account acntData = [select Id,Name,icxdmsv1__Partner_Dealer__c,icxdmsv1__Credit_Limit__c,RecordTypeId from Account
                            where Id = :accntId];
        
        // Retrieve Account Dealer Recordtype Id
        Id accRTIdDist = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        
        if(Profile.sObjectType.getDescribe().isAccessible()&&
                                Schema.sObjectType.Profile.fields.Id.isAccessible()){
        // Getting profile id
        Profile DMSPartnerProfileId = [Select Id from Profile where name = 'iDMS Partner Profile'];

        Profile SystemAdminId = [Select Id from Profile where name = 'System Administrator'];
        if(User.sObjectType.getDescribe().isAccessible()&&
                                Schema.sObjectType.User.fields.Id.isAccessible()){
        //User Managerid=[SELECT Id FROM User WHERE ProfileId=: SystemAdminId.id];
        
            
            // Creating Contcat
            Contact contactvals =new Contact();
        
            contactvals.AccountId=acntData.Id;
            contactvals.FirstName=leadinfo.icxdmsv1__First_Name__c;
            contactvals.LastName=leadinfo.icxdmsv1__Last_Name__c;        
            contactvals.Email=leadinfo.icxdmsv1__Email__c;
            contactvals.Phone=leadinfo.icxdmsv1__Mobile__c;
            if(Contact.sObjectType.getDescribe().isCreateable()){
            
            insert contactvals;
        
        // Creating New User
        List<Messaging.SingleEmailMessage> setPWs = new List<Messaging.SingleEmailMessage>();
        User u=new User();
            u.FirstName = contactvals.FirstName;
            u.LastName = contactvals.LastName;
            u.Email=contactvals.Email;
            u.Username=contactvals.FirstName+System.now().millisecond() +'@'+'icxdms'+'.'+'com';//'contactvals.Name'+'@'+'amruthanjan'+'.'+'com'System.now().millisecond() +;
            u.CommunityNickname=contactvals.FirstName+contactvals.LastName;            
            u.ProfileId = DMSPartnerProfileId.Id;
            u.IsActive=true;
            u.ContactId=contactvals.Id;
            u.Alias = contactvals.LastName;
            u.TimeZoneSidKey='Asia/Kolkata';
            u.LocaleSidKey = 'en_US'; // Required
            u.EmailEncodingKey = 'ISO-8859-1'; // Required
            u.LanguageLocaleKey = 'en_US';
            u.EmailPreferencesStayInTouchReminder=True;
            //u.ManagerId=Managerid.Id;
            if(User.sObjectType.getDescribe().isCreateable()){
            insert u; 
        
        
                        
            UserId=u.id;
            System.debug('user values are'+u);
            
            User contid=[Select ContactId,AccountId From User Where id=:u.id];
            
            AccountCId=contid.AccountId;
            ContactId=contid.id;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //Set email address
            String[] toAddresses = new String[] {contactvals.Email};

            mail.setToAddresses(toAddresses);
            mail.setSubject('Subject - User Creation');
            mail.setPlainTextBody('User has been created!');

            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};//setPW}; 
            String body = ' Sample Body to test email is sending or not '; 
            //setPWs.setPlainTextBody(body);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
            System.debug('The email was sent successfully.');
            } else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);          
                }        
        

        //for sharing access
            AccountShare Acctshr = new AccountShare(); 
            Acctshr.AccountId = AccountCId; 
            Acctshr.UserOrGroupId = UserId; 
            Acctshr.AccountAccessLevel = 'Edit'; 
            Acctshr.OpportunityAccessLevel = 'Edit';
            Acctshr.CaseAccessLevel ='Edit';
        
            Database.SaveResult sr = Database.insert(Acctshr,false);
        
        Id accRTIdDistrib = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();                                                                                

        //updating partner dealer field
        Account accs=[Select id,Name From Account Where id=: AccountCId];
        User username=[Select Name From User Where id=: UserId];
        accs.RecordTypeId=accRTIdDistrib;
        accs.icxdmsv1__Partner_Dealer__c=UserId;//username.Name;//UserId;
        accs.icxdmsv1__Credit_Limit__c=1000000;
        if(Account.sObjectType.getDescribe().isUpdateable()){
        update accs;
        
        // Updating Lead Status
        leadinfo.icxdmsv1__Lead_Status__c='Closed - Converted';
        update leadinfo;

        }
    }
            }
        }
        }
    }
    }
    }
    //input details that comes to apex from flow
    public class FlowInputs{

        @InvocableVariable(required=true)
        public ID leadId;
        
        @InvocableVariable(required=true)
        public ID accId;
        
    }

}