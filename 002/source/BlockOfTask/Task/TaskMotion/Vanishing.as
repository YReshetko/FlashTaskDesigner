package source.BlockOfTask.Task.TaskMotion {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class Vanishing {
		private var spr:Sprite;
		private var timeShow:int;
		private var timeVanish:int;
		public function Vanishing(obj:Sprite, tShow:int, tVanish:int) {
			spr = obj;
			spr.visible = false;
			timeVanish = tVanish;
			var timer:Timer = new Timer(tShow*1000, 1);
			timer.addEventListener(TimerEvent.TIMER, TIME_SHOW);
			timer.start();
		}
		private function TIME_SHOW(e:TimerEvent):void{
			spr.visible = true;
			spr.alpha = 1;
			var timer:Timer = new Timer(timeVanish*1000, 1);
			timer.addEventListener(TimerEvent.TIMER, TIME_VANISH);
			timer.start();
		}
		private function TIME_VANISH(e:TimerEvent):void{
			spr.addEventListener(Event.ENTER_FRAME, MOTION_ENTER_FRAME);
		}
		private function MOTION_ENTER_FRAME(e:Event):void{
			if(spr.alpha>0){
				spr.alpha -= 0.005;
			}else{
				spr.removeEventListener(Event.ENTER_FRAME, MOTION_ENTER_FRAME);
				spr.alpha = 0;
			}
		}
	}
	
}
