public class TransactionController {
    
    public List<Transaction__c> getTransactions() {
        return [select id, name, amount__c, createdDate, ownerId from Transaction__c
                where ownerId = :userInfo.getUserId() order by createdDate desc];
    }
    
    public void removeTransaction()
    {
        Id cId = ApexPages.currentPage().getParameters().get('delTransaction');
        Transaction__c tr = [select Id, name from Transaction__c where id = :cId];
        delete tr;
        
    }
    
    public PageReference editTransaction()
    {
        PageReference pageRef= new PageReference('/'+ApexPages.currentPage().getParameters().get('editTransaction'));
        pageRef.setredirect(true);
        return pageRef;
                
    }
    
}