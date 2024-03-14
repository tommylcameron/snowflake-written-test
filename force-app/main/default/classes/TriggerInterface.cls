public interface TriggerInterface {
    
    void beforeInsert(List<sObject> newRecordList);

    void afterInsert(List<sObject> newRecordList, Map<Id, sObject> newRecordMap);

    void beforeUpdate(Map<Id, sObject> oldRecordMap, Map<Id, sObject> newRecordMap);

    void afterUpdate(Map<Id, sObject> oldRecordMap, Map<Id, sObject> newRecordMap);

    void beforeDelete(List<sObject> oldRecordList, Map<Id, sObject> oldRecordMap);

    void afterDelete(Map<Id, sObject> oldRecordMap);

    void afterUndelete(List<sObject> newRecordList, Map<Id, sObject> newRecordMap);
    
}