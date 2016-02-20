package source.utils.PlayerTimer {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	public class TimerController extends TimerViewer{
		public static var ENDED_TIME:String = 'endedTime';
		private static const intArr:Array = ['0','1','2','3','4','5','6','7','8','9'];
		private var taskTimer:Timer = new Timer(1000);
		private var startTime:String;
		private var Seconds:int;
		private var Minutes:int;
		public function TimerController(container:Sprite, hContainer:Number) {
			super(hContainer);
			container.addChild(super);
			taskTimer.addEventListener(TimerEvent.TIMER, taskTimer_TIMER);
		}
		public function setTimer(s:String){
			stopTimer();
			startTime = s;
			var inString:String = correctTime(startTime);
			super.setNewTime(inString);
			super.fieldEnabled(true);
			Minutes = parseInt(inString.substr(0,2));
			Seconds = parseInt(inString.substr(3,2));
			startTimer();
		}
		
		public function stopTimer(){
			taskTimer.stop();
		}
		public function startTimer(){
			taskTimer.start();
		}
		public function removeTimer(){
			taskTimer.stop();
			super.fieldEnabled(false);
		}
		public function reloadTimer(){
			setTimer(startTime);
		}
		public function getTime():String{
			return getTimeString();
		}
		
		
		private function taskTimer_TIMER(e:TimerEvent){
			if(Minutes!=0 || Seconds!=0){
				decrimentTime();
				super.setNewTime(getTimeString());
			}else{
				taskTimer.stop();
				super.fieldEnabled(false);
				this.dispatchEvent(new Event(ENDED_TIME));
			}
		}
		private function getTimeString():String{
			var outString:String = "";
			var min:String = Minutes.toString();
			var sec:String = Seconds.toString();
			if(min.length==1) min = "0"+min;
			if(sec.length==1) sec = "0"+sec;
			outString = min+"."+sec;
			return outString;
		}
		private function decrimentTime(){
			if(Seconds!=0) --Seconds;
			else{
				-- Minutes;
				Seconds = 59;
			}
		}
		
		private function correctTime(s:String):String{
			var outString:String = new String;
			outString = "";
			if(s.length != 5){
				outString = "01.30";
			}else{
				if(checkSymbol(s.charAt(0), intArr)) outString += s.charAt(0);
				else outString += "0";
				
				if(checkSymbol(s.charAt(1), intArr)) outString += s.charAt(1);
				else outString += "1";
				
				outString += ".";
				
				if(checkSymbol(s.charAt(3), intArr)) outString += s.charAt(3);
				else outString += "3";
				
				if(checkSymbol(s.charAt(4), intArr)) outString += s.charAt(4);
				else outString += "0";
			}
			return outString;
		}
		private function checkSymbol(s:String, arrS:Array):Boolean{
			var flag = false;
			var i:int;
			for(i=0;i<arrS.length;i++){
				if(arrS[i] == s){
					flag = true;
					break;
				}
			}
			return flag;
		}
	}
	
}