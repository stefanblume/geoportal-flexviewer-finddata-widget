package widgets.FindData.licensing {
public class SecurityServiceClient {
    import com.esri.viewer.utils.Hashtable;

    import flash.net.navigateToURL;
    import flash.profiler.showRedrawRegions;

    import mx.collections.ArrayList;
    import mx.controls.Alert;
    import mx.rpc.AsyncResponder;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;

    import widgets.FindData.licensing.LicenseDialog;
    import widgets.FindData.licensing.SecurityServiceClient;

    import widgets.FindData.licensing.TermsOfUseDialog;
    public function SecurityServiceClient() {
    }

    public static function httpServiceToSecurityService(listener:Function, faultListener:Function, requestParams:Object, httpMethod:String, securityServiceUrl:String):void {
        var httpService:HTTPService = new HTTPService();
        httpService.url = securityServiceUrl;
        httpService.method = httpMethod;
        httpService.resultFormat = "text";
        httpService.requestTimeout = 60.0;
        httpService.addEventListener("result", listener);
        httpService.addEventListener("fault", faultListener);
        httpService.send(requestParams);
    }

    private function getText(isSuccess:Boolean, isSecured:Boolean, isLicensed:Boolean, isLoggedIn:Boolean, isLicenseModelAvailable:Boolean, isGatewayAccessibilityChecked:Boolean, isGatewayAccessible:Boolean, licModelsLength:uint):String {
        var text:String;
        text = "isSuccess: " + isSuccess +
                "\nisSecured: " + isSecured +
                "\nisLicensed: " + isLicensed +
                "\nisLoggedIn: " + isLoggedIn +
                "\nisLicenseModelAvailable: " + isLicenseModelAvailable +
                "\nisLicenseModelLength: " + licModelsLength +
                "\nisGatewayAccessibilityChecked: " + isGatewayAccessibilityChecked +
                "\nisGatewayAccessible: " + isGatewayAccessible;
        return text;


    }

    public static function parseLicenses(licenseReferences:Array, licenseReferencesHttpAuthUrl:Array, licenseReferenceTermsOfUse:Array):Hashtable {
        var licenses:Hashtable = new Hashtable();
        for (var i:int = 0; i < licenseReferences.length; i++) {
            //Alert.show("parse " + i + " of " + licenseReferences.length);
            try {
                var licenseReference:* = licenseReferences[i];
                var licenseReferencesHttpAuthUrl2:* = licenseReferencesHttpAuthUrl[i];
                var licenseReferenceTermsOfUse2:* = licenseReferenceTermsOfUse[i];
                //Alert.show("licenseReference", licenseReference);
                //Alert.show("licenseReferencesHttpAuthUrl2", licenseReferencesHttpAuthUrl2);
                // Alert.show("licenseReferenceTermsOfUse2", licenseReferenceTermsOfUse2);
                var lic:Object = { licenseReference:licenseReference,
                    licenseReferenceHttpAuthUrl:licenseReferencesHttpAuthUrl2,
                    licenseReferenceTermsOfUse:licenseReferenceTermsOfUse2
                };
                var licId:String = lic.licenseReference.licenseId;
                //Alert.show("licid", licId+"");
                licenses.add(licId, lic);

            } catch (error:Error) {
                Alert.show("error", error.getStackTrace());
            }

        }
        //Alert.show("return");
        return licenses;
    }


    /*
     * https://www.spatialni.gov.uk/geoportal/link?act=addToMap&fwd=%2Fgeoportal%2Fviewer%2Findex.jsp%3Ftitle%3DVirgin%2BMedia%2B%2528Licensed%2529%2BWMS%26resource%3Dwms%253Ahttps%253A%252F%252Fwww.spatialni.gov.uk%252Fwss%252Fservice%252FVirgin_Media%252FWSS%253Frequest%253DGetCapabilities%2526service%253DWMS%2526version%253D1.3.0
     * /geoportal/viewer/index.jsp?title=Virgin+Media+%28Licensed%29+WMS&resource=wms%3Ahttps%3A%2F%2Fwww.spatialni.gov.uk%2Fwss%2Fservice%2FVirgin_Media%2FWSS%3Frequest%3DGetCapabilities%26service%3DWMS%26version%3D1.3.0
     *
     *  /geoportal/viewer/index.jsp?title=Virgin+Media+%28Licensed%29+WMS
     * resource=wms%3Ahttps%3A%2F%2Fwww.spatialni.gov.uk%2Fwss%2Fservice%2FVirgin_Media%2FWSS%3Frequest%3DGetCapabilities%26service%3DWMS%26version%3D1.3.0
     *
     * wms:https://www.spatialni.gov.uk/wss/service/Virgin_Media/WSS?request=GetCapabilities&service=WMS&version=1.3.0
     * */
    public static function parseSiteUrl(siteUrl:String):String {
        //Alert.show(siteUrl, "siteUrl");
        var params:Array = getParameterArray(siteUrl);
        for each(var param:String in params) {
            if (param.search("fwd") != -1) {
                var encodedUrl:String = param.substr(4, param.length);
                var decodedUrl:String = decodeURIComponent(encodedUrl);
                if (decodedUrl.charAt(0) == "/"){
                    var subParams:Array = getParameterArray(decodedUrl);
                    for each(var subParam:String in subParams) {
                        if (subParam.search("resource") != -1) {
                            //Alert.show(subParam, "subParam");
                            var encodedSubUrl:String = subParam.substr(9, subParam.length);
                            var decodedSubUrl:String = decodeURIComponent(encodedSubUrl);
                            decodedSubUrl = decodedSubUrl.substr(decodedSubUrl.indexOf(":")+1, decodedSubUrl.length);
                            //Alert.show(decodedSubUrl, "decodedSubUrl");
                            return decodedSubUrl;
                        }
                    }
                }
                return decodedUrl;
            }
        }
        return siteUrl;
    }

    private static function getParameterArray(url:String):Array {
        var paramString:String = getParameters(url);
        var params:Array = paramString.split("&");
        return params;
    }

    private static function getParameters(url:String):String {
        var paramStartPos:int = url.indexOf("?") + 1;
        var paramString:String = url.substr(paramStartPos, url.length);
        return paramString;
    }
}
}
