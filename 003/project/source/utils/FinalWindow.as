package source.utils {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.TextEvent;
	import flash.events.Event;
	
	public class FinalWindow extends Sprite{
		public static var TASK_SELECT:String = 'onTaskSelect';
		private var wWidth:Number;
		private var wHeight:Number;
		private var currentTask:int;
		public function FinalWindow(W:Number, H:Number) {
			super();
			this.wWidth = W - 12;
			this.wHeight = H - 36;
			Figure.insertRect(super, this.wWidth, this.wHeight, 1, 0);
		}
		public function set report(value:String):void{
			var field:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 14;
			field.htmlText = value;
			//field.setTextFormat(format);
			field.width = this.wWidth - 30;
			field.height = this.wHeight - 30;
			super.addChild(field);
			field.x = 15;
			field.y = 15;
			field.addEventListener(TextEvent.LINK, MOVE_TO_TASK);
		}
		private function MOVE_TO_TASK(e:TextEvent){
			trace(this + ': GO TO TASK = ' + e.text);
			currentTask = parseInt(e.text);
			super.dispatchEvent(new Event(TASK_SELECT));
		}
		public function get task():int{
			return currentTask;
		}
	}
	
}
