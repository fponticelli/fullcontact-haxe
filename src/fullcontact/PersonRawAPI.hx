package fullcontact;

import thx.react.Promise;

class PersonRawAPI
{
	public static var PROTOCOL = "https";
	public static var HOST = "api.fullcontact.com";
	public var apiKey : String;
	public function new(apiKey : String)
		this.apiKey = apiKey;

	public function lookupByEmail(email : String, ?options : LookupPersonOptions)
		return lookup(merge(options, { apiKey : apiKey, email : email }));

	public function lookupByEmailMD5(emailMD5 : String, ?options : LookupPersonOptions)
		return lookup(merge(options, { apiKey : apiKey, emailMD5 : emailMD5 }));

	public function lookupByPhone(phone : String, ?options : LookupPersonOptions)
		return lookup(merge(options, { apiKey : apiKey, phone : phone }));

	public function lookupByTwitter(twitter : String, ?options : LookupPersonOptions)
		return lookup(merge(options, { apiKey : apiKey, twitter : twitter }));

	public function lookupByFacebook(username : String, ?options : LookupPersonOptions)
		return lookup(merge(options, { apiKey : apiKey, facebookUsername : username }));


	public static function lookup(opt : LookupPersonOptions)
	{
		var qs     = normalizeLookupParams(opt),
			format = extractFormat(qs);
		return execute(true, "v2", "person", format, qs);
	}

	static function execute(use_get : Bool, version : String, uri : String, format : String, qs : {})
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
		if(true == opt.queue)
			opt.queue = 1;
		if(null != opt.format)
			opt.format = Std.string(opt.format).toLowerCase();
		if(null != opt.style)
			opt.style = Std.string(opt.style).toLowerCase();
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

	static function merge(src : LookupPersonOptions, dst : LookupPersonOptions)
	{
		Reflect.fields(src).map(function(key) Reflect.setField(dst, key, Reflect.field(src, key)));
		return dst;
	}
}

enum PersonAPIFormat {
	Html;
	Json;
	Xml;
}

enum PersonAPIStyle {
	List;
	Dictionary;
}

typedef LookupPersonOptions = {
	?apiKey : String,
	?email : String,
	?emailMD5 : String,
	?phone : String,
	?twitter : String,
	?facebookUsername : String,
	?queue : Bool,
	?format : PersonAPIFormat,
	?css : String,
	?prettyPrint : Bool,
	?webhookUrl : String,
	?webhookId : String,
	?style : PersonAPIStyle,
	?countryCode : String
}