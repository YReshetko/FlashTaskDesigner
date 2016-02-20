package source.BlockOfTask.Task.TaskMotion {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Blocking extends EventDispatcher{
		public static var END_BLOCKING:String = 'onEndBlocking';
		private var spr:Sprite;
		public function Blocking(obj:Sprite, time:int = 0) {
			spr = obj;
			if(time != 0){
				spr.mouseEnabled = false;
				var timer:Timer = new Timer(time*1000,1);
				timer.addEventListener(TimerEvent.TIMER, TIME_OUT);
				timer.start();
			}
		}
		private function TIME_OUT(e:TimerEvent):void{
			super.dispatchEvent(new Event(END_BLOCKING));
		}

	}
	
}
