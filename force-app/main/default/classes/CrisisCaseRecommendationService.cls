public with sharing class CrisisCaseRecommendationService {
    @InvocableMethod(label='Get Volunteer Recommendations' description='Returns a list of suitable volunteers')
    public static List<Volunteer__c> getRecommendations(List<Request> requests) {
        List<Volunteer__c> results = new List<Volunteer__c>();
        
        for (Request req : requests) {
            results.addAll([
                SELECT Id, Name, Location__c, Skillset__c, Availability__c
                FROM Volunteer__c
                WHERE Location__c = :req.crisisLocation
                  AND Skillset__c LIKE :('%' + req.requiredSkills + '%')
                  AND Availability__c = true
                ORDER BY LastModifiedDate DESC
                LIMIT 10
            ]);
        }
        return results;
    }
    
    public class Request {
        @InvocableVariable(required=true description='Crisis Location')
        public String crisisLocation;
        
        @InvocableVariable(required=true description='Required Skills')
        public String requiredSkills;
    }
}