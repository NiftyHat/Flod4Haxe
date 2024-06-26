﻿package
{
	import demos.Demo1;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class Main extends Sprite
	{
		
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(new Demo1(stage));
			// entry point
		}
	
	}

}