package source.BlockOfTask.Task.TaskObjects.Mark {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class MarkCounter extends Sprite{
		private var field:TextField = new TextField();
		private var isOpen:Boolean = false;
		private var totalMark:int = 0;
		private var currentMark:int = 0;
		public function MarkCounter(container:Sprite) {
			super();
			container.addChild(super);
			initField();
		}
		public function set total(value:int):void{
			totalMark = value;
			writeField();
		}
		public function get total():int{
			return totalMark;
		}
		public function set current(value:int):void{
			currentMark = value;
			writeField();
		}
		public function get current():int{
			return currentMark;
		}
		public function writeField():void{
			field.text = currentMark + ' / ' + totalMark;
		}
		private function initField():void{
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.background = true;
			field.backgroundColor = 0x00DD00;
			field.border = true;
			field.defaultTextFormat = format;
			field.mouseEnabled = false;
			super.mouseEnabled = false;
			writeField();
		}
		public function set open(value:Boolean):void{
			isOpen = value;
			if(value){
				super.addChild(field);
				writeField();
			}else{
				if(super.contains(field)) super.removeChild(field);
			}
		}
		public function get open():Boolean{
			return isOpen;
		}
		

	}
	
}
