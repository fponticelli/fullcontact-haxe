import fullcontact.FullContactAPI;
import utest.Assert;
import thx.react.Promise;
using Test;

class Test
{
	static var TIMEOUT = 4000;
	public function new() { }

	public function testApi()
	{
		var api = new FullContactAPI(Config.FULLCONTACT_APIKEY);
		api.lookupPersonByEmail("franco.ponticelli@gmail.com").assertPromise(function(data) {
			Assert.stringContains('"requestId', data);
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