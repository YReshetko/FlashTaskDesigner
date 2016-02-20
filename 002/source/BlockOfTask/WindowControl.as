package source.BlockOfTask {
	import source.utils.PlayerTimer.TimerController;
	import source.utils.HelthTask.HelthViewer;
	import source.utils.TestCounter.CounterController;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.utils.TestAnimation.TransitionTask;
	import flash.events.Event;
	import source.utils.FinalWindow;
	import source.Counter.TestControl;
	import flash.events.MouseEvent;
	
	public class WindowControl extends EventDispatcher{
		public static var TIMER_COMPLATE:String = 'onTimerComplate';
		public static var SHOW_TASK:String = 'onShowTask';
		
		private var currentTimer:TimerController;
		private var currentHelth:HelthViewer;
		private var testCounter:TestControl;
		private var transitionTask:TransitionTask;
		private var finalWindow:FinalWindow;
		private var controlContainer:Sprite;
		private var transitionContainer:Sprite;
		private var sWidth:Number = 742;
		private var sHeight:Number = 530;
		private var showCurrentTask:Number;
		public function WindowControl(value:Sprite, transContainer:Sprite) {
			super();
			controlContainer = value;
			transitionContainer = transContainer;
			
		}
		public function setSize(width:Number, height:Number):void{
			sWidth = width;
			sHeight = height;
		}
		public function set currentTaskComplate(value:Object):void{
			testCounter.complateTask = value;
		}
		public function set nextTaskCounter(value:Object):void{
			testCounter.goToTask = value;
		}
		public function initTest(value:Object):void{
			if(testCounter!=null)if(controlContainer.contains(testCounter))controlContainer.removeChild(testCounter)
			testCounter = new TestControl(controlContainer);
			testCounter.width = this.sWidth - 380;
			testCounter.x = 75;
			testCounter.y = this.sHeight - 30;
			
			testCounter.counter = value;
		}
		public function initAnimation():void{
			transitionTask = new TransitionTask(transitionContainer, sWidth, sHeight);
		}
		public function clear():void{
			if(testCounter!=null)if(controlContainer.contains(testCounter))controlContainer.removeChild(testCounter);
			testCounter = null;
		}
		public function reloadTimer(time:String, helth:int):void{
			stopTask();
			if(time!=''){
				//trace(this + ': ADD TIMER;  TIME = ' + time);
				currentTimer = new TimerController(controlContainer, sHeight);
				currentTimer.addEventListener(TimerController.ENDED_TIME, TASK_TIMER_COMPLATE);
				currentTimer.setTimer(time);
			}
			if(helth!=0){
				currentHelth = new HelthViewer(helth);
				controlContainer.addChild(currentHelth);
				currentHelth.x = this.sWidth;
				currentHelth.addEventListener(HelthViewer.END_HELTH, TASK_TIMER_COMPLATE);
			}
		}
		public function stopTimer():void{
			if(currentTimer!=null){
				currentTimer.stopTimer();
			}
		}
		public function stopTask():void{
			if(currentTimer!=null){
				//trace(this + ': REMOVE TIMER');
				currentTimer.stopTimer();
				currentTimer.removeTimer();
				currentTimer.removeEventListener(TimerController.ENDED_TIME, TASK_TIMER_COMPLATE);
				currentTimer = null;
			}
			if(currentHelth!=null){
				controlContainer.removeChild(currentHelth);
				currentHelth.removeEventListener(HelthViewer.END_HELTH, TASK_TIMER_COMPLATE);
				currentHelth = null;
			}
		}
		private function TASK_TIMER_COMPLATE(event:Event):void{
			super.dispatchEvent(new Event(TIMER_COMPLATE));
		}
		public function missClick():void{
			if(currentHelth!=null){
				currentHelth.minusHelth();
			}
		}
		public function writeAnswer(value:Array, currentID:int):void{
			if(testCounter!=null){
				//testCounter.setAnswer(value, currentID);
			}
			
			//super.dispatchEvent(new Event(TASK_CHANGE));
		}
		public function setAnimation(value:Boolean, isFinal:Boolean = false):void{
			//trace(this + ': is Final: = ' + isFinal);
			transitionTask.setAnswer(value, isFinal);
			transitionTask.addEventListener(TransitionTask.ANIMATION_COMPLATE, ANIMATION_COMPLATE);
		}
		private function ANIMATION_COMPLATE(event:Event):void{
			super.dispatchEvent(new Event(TransitionTask.ANIMATION_COMPLATE));
		}
		
		public function finalTest(value:Array = null, mnim:Array = null):void{
			trace(this + ': ARR MNIM = ' + mnim)
			finalWindow = new FinalWindow(this.sWidth, this.sHeight);
			if(value!=null){
				var i:int;
				var l:int;
				var outString:String = '';
				l = value.length;
				for(i=0;i<l;i++){
					if(value[i]!=undefined){
						if(i<mnim.length){
							trace(this+': IN MNIMOE');
							if(mnim[i]){
								outString += "<a href='event:"+i+"'><font color='#0000FF'><b>"+(i+1) + ". Задание  - Мнимое</b></font></a>\n";
							}else{
								if(value[i]){
									outString += "<a href='event:"+i+"'><font color='#006600'><b>"+(i+1) + ". Задание  - Выполнено</b></font></a>\n";
								}else{
									outString += "<a href='event:"+i+"'><font color='#FF0000'><b>"+(i+1) + ". Задание - Не выполнено</b></font></a>\n";
								}
							}
						}else{
							if(value[i]){
								outString += "<a href='event:"+i+"'><font color='#006600'><b>"+(i+1) + ". Задание  - Выполнено</b></font></a>\n";
							}else{
								outString += "<a href='event:"+i+"'><font color='#FF0000'><b>"+(i+1) + ". Задание - Не выполнено</b></font></a>\n";
							}
						}
					}
				}
				finalWindow.report = outString;
			}//finalWindow.report = testCounter.getHiperLincs();
			transitionContainer.addChild(finalWindow);
			finalWindow.x = finalWindow.y = 6;
			finalWindow.addEventListener(FinalWindow.TASK_SELECT, TASK_SELECT);
		}
		private function TASK_SELECT(e:Event):void{
			trace(this + ': HIPER LINCSELECT ' + e.target.task);
			showCurrentTask = e.target.task;
			finalWindow.alpha = 0;
			finalWindow.addEventListener(MouseEvent.MOUSE_DOWN, SHOW_FINAL_WINDOW);
			super.dispatchEvent(new Event(SHOW_TASK));
		}
		public function get currentTask():Number{
			return showCurrentTask;
		}
		private function SHOW_FINAL_WINDOW(event:MouseEvent):void{
			finalWindow.removeEventListener(MouseEvent.MOUSE_DOWN, SHOW_FINAL_WINDOW);
			finalWindow.alpha = 1;
		}
	}
	
}
