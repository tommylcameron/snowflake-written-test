public with sharing class OpportunityHelper {

    public Map<String, DatedConversionRate> conversionRateMap;

    public void getRelatedData(List<Opportunity> opps){
        getConversionRateMap(opps);
    }

    public void getConversionRateMap(List<Opportunity> opps){
        if(conversionRateMap == null){
            conversionRateMap = new Map<String, DatedConversionRate>();
            List<Date> closeDates = new List<Date>();
            List<String> currencyIsoCodes = new List<String>();
            for(Opportunity opp : opps){
                if(opp.CloseDate != null && opp.CurrencyIsoCode != null){
                    closeDates.add(opp.CloseDate);
                    currencyIsoCodes.add(opp.CurrencyIsoCode);
                }
            }
            List<DatedConversionRate> rates = [SELECT StartDate, IsoCode, ConversionRate FROM DatedConversionRate WHERE StartDate IN :closeDates AND IsoCode IN :currencyIsoCodes];
            for(DatedConversionRate rate : rates){
                String uniqueKey = rate.IsoCode + rate.StartDate.format();
                if(!conversionRateMap.containsKey(uniqueKey)){
                    conversionRateMap.put(uniqueKey, rate);
                }
            }
        } 
    }

    public DatedConversionRate getConversionRate(Opportunity opp){
        DatedConversionRate conversionRate = new DatedConversionRate();
        String uniqueKey = opp.CurrencyIsoCode + opp.CloseDate.format();
        if(conversionRateMap != null && conversionRateMap.containsKey(uniqueKey)){
            conversionRate = conversionRateMap.get(uniqueKey);
            return conversionRate;
        } else {
            return null;
        }
    }

    public void setAmountUSDValue(Opportunity opp, DatedConversionRate rate){
        try{
            if(opp.CurrencyIsoCode == 'USD'){
                opp.Amount_USD__c = opp.Amount;
            } else if (rate != null){
                opp.Amount_USD__c = opp.Amount / (rate.ConversionRate);
            } else {
                System.debug('No ' + opp.CurrencyIsoCode + ' Rate found for ' + opp.CloseDate + ', unable to set Amount USD for opp id: ' + opp.Id);
            }
        } catch (Exception e){
            System.debug(e.getTypeName() + ' Exception caught: '+ e.getMessage());
            System.debug('Line: ' + e.getLineNumber());
            System.debug('Cause: ' + e.getCause());
        } 
    }
}