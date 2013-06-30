package fullcontact;

import fullcontact.PersonRawAPI;
using thx.react.Promise;

class PersonAPI
{
	public var api : PersonRawAPI;
	public function new(apiKey : String)
		this.api = new PersonRawAPI(apiKey);

	public function lookupByEmail(email : String, ?options : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return api.lookupByEmail(email, fixOptions(options)).transform(transformJson);

	public function lookupByEmailMD5(emailMD5 : String, ?options : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return api.lookupByEmailMD5(emailMD5, fixOptions(options)).transform(transformJson);

	public function lookupByPhone(phone : String, ?options : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return api.lookupByPhone(phone, fixOptions(options)).transform(transformJson);

	public function lookupByTwitter(twitter : String, ?options : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return api.lookupByTwitter(twitter, fixOptions(options)).transform(transformJson);

	public function lookupByFacebook(username : String, ?options : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return api.lookupByFacebook(username, fixOptions(options)).transform(transformJson);

	static function transformJson(data : String) : PersonResponse
	{
		return cast haxe.Json.parse(data);
	}

	static function fixOptions(opt : LookupPersonOptions)
	{
		if(null == opt) opt = {};
		opt.format = Json;
		return opt;
	}

	public static function lookup(opt : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return PersonRawAPI.lookup(opt).transform(transformJson);
}

extern class PersonResponse 
{
	var status : Int;
	var likelihood : Float;
	var requestId : String;


	var familyName : String;
	var givenName : String;
	var fullName : String;
	var websites : Array<{ url : String }>;
	var demographics : {
			locationGeneral : String,
			gender : String,
			?age : String,
			?ageRange : String
		};
	var socialProfiles : Array<{
			type : String,
			typeId : String,
			typeName : String,
			url : String,
			id : Int,
			?username : String,
			?bio : String,
			?followers : Int,
			?following : Int,
			?rss : String
		}>;

	var organizations : Array<{
			name : String,
			?title : String,
			?startDate : String,
			?endDate : String,
			isPrimary : Bool
		}>;

	var digitalFootprint : {
	    	topics : Array<{
					value : String,
					provider : String
				}>,
			scores : Array<{
					value : Float,
					provider : String,
					type : String
				}>
		};
    var photos : Array<{
			url : String,
			type : String,
			typeId : String,
			typeName : String,
			isPrimary : Bool,
			?photoBytesMD5 : String
    	}>;
}