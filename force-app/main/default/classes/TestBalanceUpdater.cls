@isTest
private class TestBalanceUpdater {
        
    @testSetup 
    static void setup() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
		User testUser = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='TestBalanceUpdater', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Furgal123@testorg.com', balance__c = 0);
        insert testUser;   
        system.runAs(testUser) {
            Transaction__c tr = new Transaction__c(name = 'test', amount__c = 1000);
            insert tr;
        }
    }
    
    @isTest static void TestBalanceAfterInsert() {
        
        User user = [select Id  FROM user where name = 'TestBalanceUpdater'];

        system.runAs(user) {
                        
            Transaction__c tr = new Transaction__c(name = 'test', amount__c = 500);
        
            Test.startTest();
            insert tr;
            Test.stopTest();
            
            System.assertEquals( 1500 , [select balance__c FROM user where name = 'TestBalanceUpdater'].balance__c);
            
        }
    }
    
    @isTest static void TestBalanceAfterUpdate() {
        
        User user = [select Id  FROM user where name = 'TestBalanceUpdater'];

        system.runAs(user) {
            
            Transaction__c tr = [select id, amount__c from Transaction__c][0];
            tr.amount__c = tr.amount__c + 1000;
    
            Test.startTest();
            update tr;
            Test.stopTest();
            
            System.assertEquals( 2000 , [select balance__c FROM user where name = 'TestBalanceUpdater'].balance__c);
      	}
        
    }
    
    @isTest static void TestBalanceAfterDelete() {
        
        User user = [select Id  FROM user where name = 'TestBalanceUpdater'];

        system.runAs(user) {
        
            Transaction__c tr = [select id, amount__c from Transaction__c][0];
    
            Test.startTest();
            delete tr;
            Test.stopTest();
            
            System.assertEquals( 0 , [select balance__c FROM user where name = 'TestBalanceUpdater'].balance__c);
          }
    }
    
    
    
}