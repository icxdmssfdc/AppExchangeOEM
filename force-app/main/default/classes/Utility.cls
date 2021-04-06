public with sharing class Utility {
    public static string getAllFields(String SobjectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }

        return strFields;
    }
}