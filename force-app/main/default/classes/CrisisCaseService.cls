public class CrisisCaseService {
    // Input Wrapper Class
    public class CrisisCaseInput {
        @InvocableVariable(label='Location')
        public String location;

        @InvocableVariable(label='Required Skills')
        public String requiredSkills;
    }

    // Output Wrapper Class
    public class CrisisCaseOutput {
        @InvocableVariable(label='Name')
        public String name;

        @InvocableVariable(label='Severity')
        public Integer severity;

        @InvocableVariable(label='Type')
        public String type;

        @InvocableVariable(label='Location')
        public String location;

        @InvocableVariable(label='Status')
        public String status;

        @InvocableVariable(label='Description')
        public String description;

        // Constructor
        public CrisisCaseOutput(String name, Integer severity, String type, String location, String status, String description) {
            this.name = name;
            this.severity = severity;
            this.type = type;
            this.location = location;
            this.status = status;
            this.description = description;
        }
    }

    // Invocable Method
    @InvocableMethod(label='Get Crisis Case Recommendations')
    public static List<List<CrisisCaseOutput>> getCrisisCaseRecommendations(List<CrisisCaseInput> inputs) {
        List<CrisisCaseOutput> results = new List<CrisisCaseOutput>();

        for (CrisisCaseInput input : inputs) {
            // Dynamic filtering based on required skills
            List<Crisis_Case__c> crisisCases;

            if (String.isNotBlank(input.requiredSkills)) {
                // Query with required skills
                crisisCases = [
                    SELECT Name, Severity__c, Type__c, Location__c, Status__c, Description__c
                    FROM Crisis_Case__c
                    WHERE Location__c = :input.location
                    OR Type__c = :input.requiredSkills
                ];
            } else {
                // Query without filtering by required skills
                crisisCases = [
                    SELECT Name, Severity__c, Type__c, Location__c, Status__c, Description__c
                    FROM Crisis_Case__c
                    WHERE Location__c = :input.location
                ];
            }

            // Map queried records to output wrapper class
            for (Crisis_Case__c crisisCase : crisisCases) {
                results.add(new CrisisCaseOutput(
                    crisisCase.Name,
                    crisisCase.Severity__c != null ? Integer.valueOf(String.valueOf(crisisCase.Severity__c)) : null, // Safely handle potential null and ensure Integer
                    crisisCase.Type__c,
                    crisisCase.Location__c,
                    crisisCase.Status__c,
                    crisisCase.Description__c
                ));
            }
        }

        // Return the results as a list of lists
        return new List<List<CrisisCaseOutput>> { results };
    }
}