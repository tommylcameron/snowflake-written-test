@isTest
public with sharing class TestDataFactory {
     
    public static list<Account> createUSAccounts(Integer numAccounts, Boolean doInsert){
        List<Account> newAccs = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++){
            Account acc = new Account();
            acc.Name = 'Test US Account ' + String.valueOf(i);
            acc.CurrencyIsoCode = 'USD';
            newAccs.add(acc);
        }
        if(doInsert){
            insert newAccs;
        }
        return newAccs;
    }

    public static list<Account> createUKAccounts(Integer numAccounts, Boolean doInsert){
        List<Account> newAccs = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++){
            Account acc = new Account();
            acc.Name = 'Test UK Account ' + String.valueOf(i);
            acc.CurrencyIsoCode = 'GBP';
            newAccs.add(acc);
        }
        if(doInsert){
            insert newAccs;
        }
        return newAccs;
    }

    public static List<Opportunity> createUSOpps(Integer numOpps, Boolean doInsert){
        List<Opportunity> newOpps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test US Opportunity ' + String.valueOf(i);
            opp.CurrencyIsoCode = 'USD';
            opp.CloseDate = System.today();
            opp.StageName = 'Prospecting';
            newOpps.add(opp);
        }
        if(doInsert){
            insert newOpps;
        }
        return newOpps;
    }

    public static List<Opportunity> createUKOpps(Integer numOpps, Boolean doInsert){
        List<Opportunity> newOpps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test UK Opportunity ' + String.valueOf(i);
            opp.CurrencyIsoCode = 'GBP';
            opp.CloseDate = System.today();
            opp.StageName = 'Prospecting';
            newOpps.add(opp);
        }
        if(doInsert){
            insert newOpps;
        }
        return newOpps;
    }
}