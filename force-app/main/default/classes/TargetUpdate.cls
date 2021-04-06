public with sharing class TargetUpdate {

    @InvocableMethod(label = 'Update Target'
        description = 'Updating Taregt Revenue and Target Qty depending on Order')
    public static void updateTarget(List <FlowInputs> flowinputs){
        try{
    		FlowInputs input = flowinputs[0];
            
    		
    		Integer tarYear = input.startDate.year();
    		String targetYear = String.valueOf(tarYear); 
            Integer month = input.startDate.month();
    		String tarMonth ='';
			tarMonth = GetStringMonthName.getMonthName(month);        

        
   			//Calling future method
    		TargetUpdateFuture.updateTargetFuture(input.ownerId,input.startDate,input.ordAmount,input.ordQuantity,input.dealerAccntId,
                                         input.userTyp,tarMonth,targetYear);            
     
      		 }//End of try 
        		catch(Exception e) {
   				 	System.debug('An exception occurred: ' + e.getMessage());
            
		}//End of Catch
        
}//End of method

    
//input details that comes to apex from flow
public class FlowInputs{
       
    @InvocableVariable(required=true)
    public ID ownerId;
    
    @InvocableVariable
    public Date startDate;
    
    @InvocableVariable
    public Double ordAmount;
    
    @InvocableVariable
    public Integer ordQuantity;
    
    @InvocableVariable
    public ID ordProductId;
    
    @InvocableVariable
    public Integer ordProdQuantity;
    
    @InvocableVariable
    public Date oldStartDate;
        
    @InvocableVariable
    public Id dealerAccntId;
    
    @InvocableVariable
    public String userTyp;
}

}