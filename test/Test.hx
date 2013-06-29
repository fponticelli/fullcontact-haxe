import utest.Assert;

class Test
{
	public function new() { }

	public function testApi()
	{

	}

	static function main()
	{
		var runner = new utest.Runner(),
			report = utest.ui.Report.create(runner);
		runner.addCase(new Test());
		runner.run();
	}
}