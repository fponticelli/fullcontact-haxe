import fullcontact.PersonAPI;
import fullcontact.PersonDataAPI;
import utest.Assert;
import thx.react.Promise;
using Test;

class Test
{
	static var TIMEOUT = 4000;
	public function new() { }

	public function testLookupByEmail()
	{
		var api = new PersonAPI(Config.FULLCONTACT_APIKEY);
		api.lookupByEmail("franco.ponticelli@gmail.com").assertPromise(function(data) {
			Assert.stringContains('"requestId"', data);
		});
	}

	public function testLookupByEmailHtml()
	{
		var api = new PersonAPI(Config.FULLCONTACT_APIKEY);
		api.lookupByEmail("franco.ponticelli@gmail.com", { format : Html }).assertPromise(function(data) {
			Assert.stringContains('<!DOCTYPE HTML>', data);
		});
	}

	static function main()
	{
		var runner = new utest.Runner(),
			report = utest.ui.Report.create(runner);
		runner.addCase(new Test());
		runner.run();
	}

	static function assertPromise<T>(p : Promise<T -> Void>, handler : T -> Void)
	{
		var async = Assert.createAsync(function() { }, TIMEOUT);
		p.then(
			function(a) {
				handler(a);
				async();
			},
			function(err : Dynamic) {
				Assert.fail(Std.string(err));
				async();
			}
		);
	}
}