public class SalesforceCalloutNC {
    public static void namedCredsCallOut(){
        String accountURL = '/services/data/v50.0/sobjects/Account/0012x00000GyobLAAR';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Salesforce_Personal'+accountURL);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getStatus());
        system.debug(res.getBody());
	}
}