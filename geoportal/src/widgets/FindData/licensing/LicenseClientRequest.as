package widgets.FindData.licensing {
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class LicenseClientRequest {

    private var _urlRequest:URLRequest;
    private var _returnUrl:String;

    public function LicenseClientRequest(url:String) {
        _urlRequest = new URLRequest(url);
        _urlRequest.method = URLRequestMethod.POST;
        //_urlRequest.contentType = "multipart/form-data";
        _urlRequest.contentType = "application/x-www-form-urlencoded";

    }

    public function getUrlRequest():URLRequest {
        return _urlRequest;
    }

    public function compileReturnUrl(securityServiceUrl: String, serviceTitle:String, requestedUrl:String):void {
        // compile return URL when obtained a license
        _returnUrl = securityServiceUrl.replace("/SecurityService", "")+'/catalog/tc/licenseReturn.page?';
        _returnUrl = _returnUrl + 'actType=flex&' + 'titleOfService=' + serviceTitle;
        // append additional parameters from the service url if there are some
        if (requestedUrl.indexOf('?') > 0) {
            var requestedUrlParameters:String = requestedUrl.substring(requestedUrl.indexOf('?') + 1);
            _returnUrl +=  '&' + requestedUrlParameters;
        }
    }

    public function setParams(identity:String,  wssUrl:String):void {
        _urlRequest.data = "ticket=" + encodeURIComponent(identity) + "&WSS=" + encodeURIComponent(wssUrl) + "&returnURL=" + encodeURIComponent(_returnUrl);
    }
}
}
