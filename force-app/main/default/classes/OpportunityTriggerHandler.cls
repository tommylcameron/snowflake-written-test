public with sharing class OpportunityTriggerHandler implements TriggerInterface{

    public static void beforeInsert(List<sObject> newRecordList){
        List<Opportunity> oppList = (List<Opportunity>)newRecordList;
        //INSTANTIATE HELPER AND RETRIEVE RELATED RECORDS BEFORE PROCESSING LOGIC
        OpportunityHelper helper = new OpportunityHelper();
        helper.getRelatedData(oppList);

        for(Opportunity opp : oppList){
            if(opp.CloseDate != null && opp.Amount != null){
                String uniqueKey = opp.CurrencyIsoCode + opp.CloseDate.format();
                DatedConversionRate conversionRate = helper.conversionRateMap.containsKey(uniqueKey) ? helper.conversionRateMap.get(uniqueKey) : null;
                helper.setAmountUSDValue(opp, conversionRate);
            }
        }
    }

    public static void afterInsert(List<sObject> newRecordList, Map<Id, sObject> newRecordMap){

    }

    public static void beforeUpdate(Map<Id, sObject> oldRecordMap, Map<Id, sObject> newRecordMap){
        Map<Id, Opportunity> oldOppMap = (Map<Id, Opportunity>)oldRecordMap;
        Map<Id, Opportunity> newOppMap = (Map<Id, Opportunity>)newRecordMap;

        OpportunityHelper helper = new OpportunityHelper();
        helper.getRelatedData(newOppMap.values());

        for(Opportunity newOpp : newOppMap.values()){
            Opportunity oldOpp = oldOppMap.get(newOpp.Id);
            if(oldOpp.CloseDate != newOpp.CloseDate || oldOpp.Amount != newOpp.Amount){
                String uniqueKey = newOpp.CurrencyIsoCode + newOpp.CloseDate.format();
                DatedConversionRate conversionRate = helper.conversionRateMap.containsKey(uniqueKey) ? helper.conversionRateMap.get(uniqueKey) : null;
                helper.setAmountUSDValue(newOpp, conversionRate);
            }
        }
    }

    public static void afterUpdate(Map<Id, sObject> oldRecordMap, Map<Id, sObject> newRecordMap){

    }

    public static void beforeDelete(List<sObject> oldRecordList, Map<Id, sObject> oldRecordMap){

    }

    public static void afterDelete(Map<Id, sObject> oldRecordMap){

    }

    public static void afterUndelete(List<sObject> newRecordList, Map<Id, sObject> newRecordMap){

    }
}