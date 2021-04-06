public with sharing class TargetQtyProductUpdate {

    @InvocableMethod(label = 'Update Target for Qty With Product'
        description = 'Updating Taregt Revenue and Target Qty depending on Order')
    public static void updateTargetQtyWithProd(List <FlowInputs> flowinputs){
	try{
   		 FlowInputs input = flowinputs[0]; 
            Integer month = input.startDate.month();
    		Integer tarYear = input.startDate.year();
    		String targetYear = String.valueOf(tarYear); 
            
    		String targetMonth ='';
			targetMonth = GetStringMonthName.getMonthName(month);      
    
        	//Calling future method
    		TargetUpdateFuture.updateSKUWithQtyFuture(input.ownerId,input.startDate,input.ordProductId,input.ordProdAmount,input.ordProdQuantity,input.dealerAccntId,
                                         input.userTyp,targetMonth,targetYear);

    }//End of Try
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
    public ID ordProductId;   
        
    @InvocableVariable
    public Double ordProdAmount;
    
    @InvocableVariable
    public Integer ordProdQuantity;
    
    @InvocableVariable
    public String userTyp;
    
    @InvocableVariable
    public Id dealerAccntId;

}
    
}