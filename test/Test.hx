import fullcontact.FullContactAPI;
import utest.Assert;

class Test
{
	public function new() { }

	public function testApi()
	{
		var api = new FullContactAPI(Config.FULLCONTACT_APIKEY);
	}

	static function main()
	{
		var runner = new utest.Runner(),
			report = utest.ui.Report.create(runner);
		runner.addCase(new Test());
		runner.run();
	}
}