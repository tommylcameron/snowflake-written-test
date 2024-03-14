@isTest
public with sharing class OpportunityTests {
    private static integer numRecs = 200;

    @TestSetup
    static void makeData(){
        List<Account> usAccs = TestDataFactory.createUSAccounts(numRecs, TRUE);
        List<Account> ukAccs = TestDataFactory.createUKAccounts(numRecs, TRUE);
        List<Opportunity> opps = new List<Opportunity>();
        List<Opportunity> usOpps = TestDataFactory.createUSOpps(numRecs, FALSE);
        List<Opportunity> ukOpps = TestDataFactory.createUKOpps(numRecs, FALSE);
        for(Integer i = 0; i < numRecs; i++){
            usOpps[i].AccountId = usAccs[i].Id;
            usOpps[i].Amount = Math.random() * 100;
            ukOpps[i].AccountId = ukAccs[i].Id;
            ukOpps[i].Amount = Math.random() * 100;
            opps.add(usOpps[i]);
            opps.add(ukOpps[i]);
        }
        insert opps;
    }

    @IsTest
    static void itShouldSetAmountUSDOnInsertUSD(){
        List<Opportunity> usOpps = [SELECT Amount, Amount_USD__c FROM Opportunity WHERE CurrencyIsoCode = 'USD'];
        for(Opportunity usOpp : usOpps){
            Assert.areEqual(usOpp.Amount, usOpp.Amount_USD__c, 'Since this is a US opp, \'Amount USD\' should equal \'Amount\'');
        }
    }

    @IsTest
    static void itShouldSetAmountUSDOnInsertUK(){
        Date todaysDate = System.today();
        DatedConversionRate rate = [SELECT ConversionRate FROM DatedConversionRate WHERE StartDate = :todaysDate and IsoCode = 'GBP' LIMIT 1];
        List<Opportunity> ukOpps = [SELECT Amount, Amount_USD__c FROM Opportunity WHERE CurrencyIsoCode = 'GBP'];
        for(Opportunity ukOpp : ukOpps){
            Assert.areEqual(ukOpp.Amount/rate.ConversionRate, ukOpp.Amount_USD__c, '\'Amount USD\' should be equal to the amount divided by the conversion rate');
        }
    }

    @IsTest
    static void itShouldSetAmountUSDOnUpdateUS(){
        List<Opportunity> usOpps = [SELECT Amount, Amount_USD__c FROM Opportunity WHERE CurrencyIsoCode = 'USD'];
        for(Opportunity usOpp : usOpps){
            usOpp.Amount = Math.random() * 100;
        }

        Test.startTest();
        update usOpps;
        Test.stopTest();

        List<Opportunity> updatedUsOpps = [SELECT Amount, Amount_USD__c FROM Opportunity WHERE CurrencyIsoCode = 'USD'];
        for(Opportunity usOpp : updatedUsOpps){
            Assert.areEqual(usOpp.Amount, usOpp.Amount_USD__c, 'Since this is a US opp, \'Amount USD\' should equal \'Amount\'');
        }
    }

    @IsTest
    static void itShouldSetAmountUSDOnUpdateUK(){
        Date yesterday = System.today().addDays(-1);
        List<Opportunity> ukOpps = [SELECT Amount, Amount_USD__c FROM Opportunity WHERE CurrencyIsoCode = 'GBP'];
        for(Opportunity ukOpp : ukOpps){
            ukOpp.CloseDate = yesterday;
        }

        Test.startTest();
        update ukOpps;
        Test.stopTest();

        DatedConversionRate rate = [SELECT ConversionRate FROM DatedConversionRate WHERE StartDate = :yesterday and IsoCode = 'GBP' LIMIT 1];
        List<Opportunity> updatedUkOpps = [SELECT Amount, Amount_USD__c FROM Opportunity WHERE CurrencyIsoCode = 'GBP'];
        for(Opportunity updatedUkOpp : updatedUkOpps){
            Assert.areEqual(updatedUkOpp.Amount/rate.ConversionRate, updatedUkOpp.Amount_USD__c, '\'Amount USD\' should be equal to the amount divided by the conversion rate');
        }
    }

    @IsTest
    static void itShouldTestDelete(){
        List<Opportunity> opps = [SELECT Id FROM Opportunity];

        Test.startTest();
        delete opps;
        Test.stopTest();
        
        List<Opportunity> deletedOpps = [SELECT Id FROM Opportunity];
        Assert.areEqual(0, deletedOpps.size(), 'Opps should be deleted');
    }

    @IsTest
    static void itShouldCoverUndelete(){
        List<Opportunity> opps = [SELECT Id FROM Opportunity];
        delete opps;

        List<Opportunity> deletedOpps = [SELECT Id FROM Opportunity ALL ROWS];
        Test.startTest();
        undelete deletedOpps;
        Test.stopTest();

        List<Opportunity> recoveredOpps = [SELECT Id FROM Opportunity];
        Assert.areEqual(deletedOpps.size(), recoveredOpps.size(), 'Should undelete opportunities');
    }
}