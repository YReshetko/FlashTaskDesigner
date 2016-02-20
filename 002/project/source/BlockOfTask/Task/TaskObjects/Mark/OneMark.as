package source.BlockOfTask.Task.TaskObjects.Mark {
	import flash.display.Sprite;	
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.BlockOfTask.Task.TaskMotion.Blocking;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.geom.Rectangle;

	public class OneMark extends Sprite {
		public static var MARK_IS_SELECT:String = "markIsSelect";
		
		private var NumClass:int = new int;
		private var Mark:MarkVidel;
		private var Vipolneno:Boolean = new Boolean;
		private var animAfterClick:Boolean = false;
		private var isSelect:Boolean = false;
		private var isClick:Boolean = false;
		private var isComplate:Boolean = false;
		
		private var animationToComplate:String = '';
		private var animationToDown:String = '';
		private var currentLabel:String = '';
		
		public function OneMark(xml:XMLList, container:Sprite) { 
			super();
			container.addChild(super);
			Mark = new MarkVidel();
			super.addChild(Mark);
			Mark.tabEnabled = true;
			Vipolneno = false;
			NumClass = parseInt(xml.CLASS);
			super.x = parseFloat(xml.X);
			super.y = parseFloat(xml.Y);
			Mark.width = parseFloat(xml.WIDTH);
			Mark.height = parseFloat(xml.HEIGHT);
			var color:ColorTransform = Mark.transform.colorTransform; 
			//	Присваивание значания цвета переменной
			color.color = uint(xml.COLOR); 
			//	Перекрашивание тана
			Mark.transform.colorTransform = color; 
			if(xml.BLOCK.toString()!=''){
				if(parseFloat(xml.BLOCK)>0){
					var b:Blocking = new Blocking(Mark, parseFloat(xml.BLOCK));
					b.addEventListener(Blocking.END_BLOCKING, BLOCK_END);
				}
			}
			if(xml.ANIMATION.toString()=='true') animAfterClick = true;
			
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') animationToComplate = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') animationToDown = xml.STARTANIMATIONDOWN.toString();
			
			Mark.addEventListener(MouseEvent.MOUSE_DOWN, MARK_MOUSE_DOWN);
		}
		private function BLOCK_END(e:Event):void{
			Mark.mouseEnabled = true;
		}
		private function MARK_MOUSE_DOWN(e:MouseEvent):void{
			isClick = true;
			if(animationToDown != ''){
				this.currentLabel = animationToDown;
				//animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			this.dispatchEvent(new Event(MARK_IS_SELECT));
		}
		public function get mClass():int{
			return NumClass;
		}
		public function get isAnimation():Boolean{
			return animAfterClick;
		}
		public function get mClick():Boolean{
			return isClick;
		}
		public function set mClick(value:Boolean):void{
			isClick = value;
		}
		public function play():void{
			Mark.play();
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			timer.start();
		}
		private function TIMER_COMPLATE(e:TimerEvent):void{
			isComplate = true;
			if(animationToComplate != ''){
				this.currentLabel = animationToComplate;
				//animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get complate():Boolean{
			return isComplate;
		}
		public function get oneClick():Boolean{
			if(!animAfterClick)return true;
			return false;
		}
		public function get animationLabel():String{
			var outStr:String = this.currentLabel;
			this.currentLabel = '';
			return outStr;
		}
		
		public function checkTableFrameSelect(rect:Rectangle):Boolean{
			var posX:Number = super.x + super.width/2;
			var posY:Number = super.y + super.height/2;
			var flag:Boolean = false;
			if(posX>rect.x && posX<(rect.x + rect.width)
			   && posY>rect.y && posY<(rect.y + rect.height)){
				   if(isClick) return false;
				   flag = true;
				   MARK_MOUSE_DOWN(null);
			   }
			return flag;
		}
		
		public function showAnswer():void{
			Mark.play();
		}
	}
}