package source.EnvKonstraktion.AddidtionTools {
	import flash.display.Sprite;
	import source.MainEnvelope;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.display.NativeWindow;
	public class SelectMenu extends Sprite{
		private var STAGE:Stage = MainEnvelope.STAGE;
		public static var TOOL_SELECT:String = 'onToolSelect';
		private var timer:Timer = new Timer(200, 1);
		private var toolsContainer:Sprite;
		private var primitiveArray:Array = new Array();
		
		private var currentPrimitive:*;
		private var currentCommand:String;
		private var currentEvent:MouseEvent;
		public function SelectMenu() {
			super();
		}
		public function set toolArray(value:Array):void{
			primitiveArray = value;
			currentPrimitive = primitiveArray[0][0];
			currentCommand = primitiveArray[0][1];
			addCurrentTool();
			currentPrimitive.addEventListener(MouseEvent.MOUSE_DOWN, PRIMITIVE_MOUSE_DOWN);
		}
		private function PRIMITIVE_MOUSE_DOWN(event:MouseEvent):void{
			currentEvent = event;
			currentPrimitive.addEventListener(MouseEvent.MOUSE_UP, PRIMITIVE_MOUSE_UP);
			currentPrimitive.removeEventListener(MouseEvent.MOUSE_DOWN, PRIMITIVE_MOUSE_DOWN);
			timer.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			timer.start();
		}
		private function PRIMITIVE_MOUSE_UP(event:MouseEvent):void{
			timer.stop();
			currentEvent = null;
			timer.removeEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			currentPrimitive.removeEventListener(MouseEvent.MOUSE_UP, PRIMITIVE_MOUSE_UP);
			currentPrimitive.addEventListener(MouseEvent.MOUSE_DOWN, PRIMITIVE_MOUSE_DOWN);
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		private function TIMER_COMPLATE(event:TimerEvent):void{
			currentPrimitive.removeEventListener(MouseEvent.MOUSE_UP, PRIMITIVE_MOUSE_UP);
			timer.removeEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			toolsContainer = new Sprite();
			var i:int;
			var l:int;
			var Y:Number;
			l = primitiveArray.length;
			//trace(this + 'create sprite');
			for(i=0;i<l;i++){
				if(currentCommand!=primitiveArray[i][1]){
					Y = toolsContainer.height;
					toolsContainer.addChild(primitiveArray[i][0]);
					primitiveArray[i][0].y = Y;
					primitiveArray[i][0].x = 0;
					primitiveArray[i][0].addEventListener(MouseEvent.MOUSE_DOWN, TOOL_MOUSE_DOWN);
					//trace(this + ': addListeners');
				}
			}
			STAGE.addChild(toolsContainer);
			toolsContainer.x = currentEvent.stageX;
			toolsContainer.y = currentEvent.stageY;
			if(toolsContainer.x + toolsContainer.width > STAGE.nativeWindow.width) toolsContainer.x = STAGE.nativeWindow.width -  toolsContainer.width - 30;
			if(toolsContainer.y + toolsContainer.height > STAGE.nativeWindow.height) toolsContainer.y = STAGE.nativeWindow.height -  toolsContainer.height - 30;
			//STAGE.focus = toolsContainer;
			//toolsContainer.addEventListener(FocusEvent.FOCUS_OUT, TOOLS_FOCUS_OUT);
			STAGE.addEventListener(MouseEvent.MOUSE_DOWN, TOOLS_FOCUS_OUT);
			currentEvent = null;
			//trace(this + ': complate add');
		}
		private function TOOL_MOUSE_DOWN(event:MouseEvent):void{
			trace(this + ': tool mouse down');
			removeCurrentTool();
			trace(this + ': remove tool handler');
			currentPrimitive = event.target;
			var i:int;
			var l:int;
			l = primitiveArray.length;
			for(i=0;i<l;i++){
				if(currentPrimitive == primitiveArray[i][0]) {
					currentCommand = primitiveArray[i][1];
					trace(this + ': add command');
					break;
				}
			}
			addCurrentTool();
			TOOLS_FOCUS_OUT();
			
		}
		private function TOOLS_FOCUS_OUT(event:MouseEvent = null):void{
			trace(this + ': focus out');
			removeHandler();
			STAGE.removeChild(toolsContainer);
			STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, TOOLS_FOCUS_OUT);
			trace(this + ': remove focus handler');
			currentPrimitive.addEventListener(MouseEvent.MOUSE_DOWN, PRIMITIVE_MOUSE_DOWN);
			trace(this + ': add current tool handler');
		}
		private function removeHandler():void{
			var i:int;
			var l:int;
			l = primitiveArray.length;
			for(i=0;i<l;i++){
				if(toolsContainer.contains(primitiveArray[i][0])) toolsContainer.removeChild(primitiveArray[i][0])
				if(primitiveArray[i][0].hasEventListener(MouseEvent.MOUSE_DOWN)) primitiveArray[i][0].removeEventListener(MouseEvent.MOUSE_DOWN, TOOL_MOUSE_DOWN);
			}
		}
		private function addCurrentTool():void{
			//trace(this + ': add current tool');
			super.addChild(currentPrimitive);
			//trace(this + ': add child complate');
			currentPrimitive.x = 0;
			currentPrimitive.y = 0;
			//trace(this + ': correct position');
		}
		private function removeCurrentTool():void{
			super.removeChild(currentPrimitive);
		}
		public function get command():String{
			return this.currentCommand;
		}
	}
	
}
