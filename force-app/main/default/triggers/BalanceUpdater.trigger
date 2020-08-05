trigger BalanceUpdater on Transaction__c (after insert, after update, after delete) {
    
    List<User> users = new List<User>();
    
    
    if (Trigger.isInsert) {
        
        List<ID> ownerIds = new List<Id>();
        
        for (Transaction__c tr : Trigger.new) {
            ownerIds.add(tr.ownerId);
        }
        
        users = [select id, balance__c from user where id IN :ownerIds];
        
        for (User us : users) {
            for (Transaction__c tr : Trigger.new) {
                If (tr.OwnerId == us.Id) {
                        us.balance__c = us.balance__c + tr.amount__c;
                }
            }
        }
        
    }
    
    else if (Trigger.isUpdate) {
        
		List<ID> ownerIds = new List<Id>();
        
        for (Transaction__c tr : Trigger.new) {
            ownerIds.add(tr.ownerId);
        }
        
        users = [select id, balance__c from user where id IN :ownerIds];
        
        for (Transaction__c trOld : Trigger.old) {
            for (User us : users) {
                If (trOld.OwnerId == us.Id) {
                    us.balance__c = us.balance__c + Trigger.newMap.get(trOld.ID).amount__c - trOld.amount__c;
                }
            }
    	}
    }
    
    else if (Trigger.isDelete) {
        
        List<ID> ownerIds = new List<Id>();
        
        for (Transaction__c tr : Trigger.old) {
            ownerIds.add(tr.ownerId);
        }
        
        users = [select id, balance__c from user where id IN :ownerIds];
        
        for (User us : users) {
            for (Transaction__c tr : Trigger.old) {
                If (tr.OwnerId == us.Id) {
                        us.balance__c = us.balance__c - tr.amount__c;
                }
            }
        }
        
    }
        
    update users;    

}