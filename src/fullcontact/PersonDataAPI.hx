package fullcontact;

import fullcontact.PersonAPI;
using thx.react.Promise;

class PersonDataAPI
{
	public var api : PersonAPI;
	public function new(apiKey : String)
	{
		this.api = new PersonAPI(apiKey);
	}

	public function lookupByEmail(email : String, ?options : LookupPersonOptions)
		return api.lookupByEmail(email, options).pipe(pipe);

	public function lookupByEmailMD5(emailMD5 : String, ?options : LookupPersonOptions)
		return api.lookupByEmailMD5(emailMD5, options).pipe(pipe);

	public function lookupByPhone(phone : String, ?options : LookupPersonOptions)
		return api.lookupByPhone(phone, options).pipe(pipe);

	public function lookupByTwitter(twitter : String, ?options : LookupPersonOptions)
		return api.lookupByTwitter(twitter, options).pipe(pipe);

	public function lookupByFacebook(username : String, ?options : LookupPersonOptions)
		return api.lookupByFacebook(username, options).pipe(pipe);

	static function pipe(data : String)
	{
		var deferred = new Deferred();
		var ob : PersonResponse = haxe.Json.parse(data);
		deferred.resolve(ob);
		return deferred.promise;
	}

	public static function lookup(opt : LookupPersonOptions) : Promise<PersonResponse -> Void>
		return PersonAPI.lookup(opt).pipe(pipe);
}

extern class PersonResponse 
{

}