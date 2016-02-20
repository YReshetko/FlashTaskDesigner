package source.utils.TestAnimation {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import source.utils.Figure;
	
	public class TransitionTask extends Sprite{
		public static var ANIMATION_COMPLATE:String = 'onAnimationComplate';
		private var wStage:Number;
		private var hStage:Number;
		private var currentObj:MovieClip;
		
		private var xCounter:Number = 150;
		private var yCounter:Number;
		
		private var xDistance:Number;
		private var yDistance:Number;
		private var aDistance:Number;
		
		private var numIter:int;
		private var currentIter:int = 0;
		private var mainContainer:Sprite;
		private var timer:Timer = new Timer(1000, 1);
		private var isFinalTask:Boolean;
		
		public function TransitionTask(container:Sprite, W:Number, H:Number) {
			super();
			mainContainer = container;
			wStage = W;
			hStage = H;
			yCounter = hStage - 30;
		}
		public function setAnswer(value:Boolean, isFinal:Boolean = false):void{
			clear();
			isFinalTask = isFinal;
			Figure.insertRect(super, wStage, hStage-30, 1, 0, 0x000000, 0.2);
			mainContainer.addChild(super);
			if(value){
				currentObj = new finalTask();
			}else{
				currentObj = new failTask();
			}
			super.addChild(currentObj);
			currentObj.gotoAndStop(1);
			currentObj.x = wStage/2;
			currentObj.y = hStage/2;
			
			xDistance = xCounter - wStage/2;
			yDistance = yCounter - hStage/2;
			
			numIter = Math.round(Math.sqrt(xDistance*xDistance+yDistance*yDistance)/30);
			
			xDistance = xDistance/numIter;
			yDistance = yDistance/numIter;
			aDistance = 1/numIter;
			currentObj.play();
			
			timer.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			timer.start();
		}
		private function TIMER_COMPLATE(e:TimerEvent):void{
			timer.removeEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			if(!isFinalTask) super.addEventListener(Event.ENTER_FRAME, ON_ENTER_FRAME);
			else super.dispatchEvent(new Event(ANIMATION_COMPLATE));
		}
		private function ON_ENTER_FRAME(e:Event):void{
			++currentIter;
			if(currentIter == numIter){
				super.removeEventListener(Event.ENTER_FRAME, ON_ENTER_FRAME);
				super.dispatchEvent(new Event(ANIMATION_COMPLATE));
				clear();
			}else{
				currentObj.x += xDistance;
				currentObj.y += yDistance;
				currentObj.alpha -= aDistance;
			}
		}
		public function clear():void{
			currentIter = 0;
			if(currentObj!=null) {
				currentObj.alpha = 1;
				if(super.contains(currentObj)) super.removeChild(currentObj);
			}
			currentObj = null;
		}
	}
	
}
