package fullcontact;

import thx.react.Promise;

class FullContactAPI
{
	public static var PROTOCOL = "https";
	public static var HOST = "api.fullcontact.com";
	public var apiKey : String;
	public function new(apiKey : String)
	{
		this.apiKey = apiKey;
	}

	public function lookupPersonByEmail(email : String, ?options : LookupPersonByEmailOptions)
	{
		var qs = normalizeLookupParams(merge(options, { apiKey : apiKey, email : email })),
			format = extractFormat(qs);
		return execute(true, "v2", "person", format, qs);
	}

	public function lookupPersonByEmailMD5(emailMD5 : String, ?options : LookupPersonByEmailOptions)
	{
		var qs = normalizeLookupParams(merge(options, { apiKey : apiKey, emailMD5 : emailMD5 })),
			format = extractFormat(qs);
		return execute(true, "v2", "person", format, qs);
	}

	function execute(use_get : Bool, version : String, uri : String, format : String, qs : {})
	{
		var http = new haxe.Http('$PROTOCOL://$HOST/$version/$uri${null==format?"":"."+format}'),
			deferred = new Deferred();
		if(null != qs)
			Reflect.fields(qs).map(function(key) http.setParameter(key, Reflect.field(qs, key)));
		http.onData = function(data) deferred.resolve(data);
		http.onError = function(err) deferred.reject(err);
		http.request(!use_get);
		return deferred.promise;
	}

	static function normalizeLookupParams(opt : Dynamic)
	{
		if(opt.queue)
			opt.queue = 1;
		return opt;
	}

	static function extractFormat(opt : {})
	{
		var format = Reflect.field(opt, "format");
		if(null == format)
			format = "json";
		else
			Reflect.deleteField(opt, "format");
		return format;
	}

	static function merge(src : {}, ?dst : {})
	{
		if(null == dst) dst = {};
		Reflect.fields(src).map(function(key) Reflect.setField(dst, key, Reflect.field(src, key)));
		return dst;
	}
}

typedef LookupPersonByEmailOptions = {
	?queue : Bool
}