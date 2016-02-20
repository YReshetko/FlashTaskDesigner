package source.BlockOfTask.Task.TaskMotion {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class Showing {
		private var spr:Sprite;
		public function Showing(obj:Sprite, time:int) {
			spr = obj;
			obj.alpha = 0;
			obj.visible = false;
			var timer:Timer = new Timer(time*1000,1);
			timer.addEventListener(TimerEvent.TIMER, TIME_OUT);
			timer.start();
		}
		private function TIME_OUT(e:TimerEvent):void{
			spr.visible = true;
			spr.addEventListener(Event.ENTER_FRAME, SPR_ENTER_FRAME);
		}
		private function SPR_ENTER_FRAME(e:Event):void{
			if(spr.alpha<1){
				spr.alpha += 0.005;
			}else{
				trace(this + ': END SHOWING');
				spr.removeEventListener(Event.ENTER_FRAME, SPR_ENTER_FRAME);
				spr.alpha = 1;
			}
		}

	}
	
}
