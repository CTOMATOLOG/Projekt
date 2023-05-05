public with sharing class SearchController {
    @AuraEnabled
    public static List<sObject> findInAllFields(String pSearchTerm, String pObjectName, String pNameField){
        if(pSearchTerm.length()<2)
            return null;
        List<List<sObject>> responseList = search.query('FIND {'+pSearchTerm+'*} IN ALL FIELDS Returning '+ pObjectName + '(Id,'+pNameField+')');
        return responseList.get(0);

    }
    @AuraEnabled
    public static String getObjectLabel(String pObjectName){
        String objectLabel = pObjectName;
        String[] typesArray = new String[]{pObjectName};
        // Make the describe call
        Schema.DescribeSobjectResult[] resultsArray = Schema.describeSObjects(typesArray);
        // For each returned result, get object label
        for(Schema.DescribeSobjectResult result_i : resultsArray) {
            objectLabel = result_i.getLabel();
        }
        return objectLabel;
    }
    @AuraEnabled
    public static String getNameField(String pObjectName){
        String nameField = 'Name';
        String[] typesArray = new String[]{pObjectName};
        // Make the describe call
        Schema.DescribeSobjectResult[] resultsArray = Schema.describeSObjects(typesArray);
        // For each returned result, get name field
        for(Schema.DescribeSobjectResult result_i : resultsArray) {
            Map<String,Schema.SObjectField> objectFieldsMap = result_i.fields.getMap();
            for(Schema.SObjectField field_j : objectFieldsMap.values())
            {
                Schema.DescribeFieldResult describeFieldResult = field_j.getDescribe();
                if(describeFieldResult.isNameField()){
                    nameField = (String)describeFieldResult.getName();
                    break;
                }
            }
        }
        return nameField;
    }
}