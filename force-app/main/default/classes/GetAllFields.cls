/*
* Author:- Vasmi Alla
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- To get all fields of an Object
* Description:- 
*/
public with sharing class GetAllFields {
    public static string getAllObjectField(String objectName)
    {
        String query ='';
        String sObjectApiName = objectName;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String strFields ='';
        
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields =='')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        return strFields;
    }
}