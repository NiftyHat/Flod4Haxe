package;

import demos.Demo1;
import flash.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new Demo1(this.stage));
	}
}
