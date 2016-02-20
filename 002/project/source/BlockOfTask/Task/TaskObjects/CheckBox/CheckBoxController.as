package source.BlockOfTask.Task.TaskObjects.CheckBox {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.BlockOfTask.Task.SeparatTask;
	//import source.Task.OneTask;
	
	public class CheckBoxController extends EventDispatcher{
		private var container:Sprite;
		private var arrChBox:Array = new Array();
		private var labelAnimation:String = '';
		private var remTarget:*;
		public function CheckBoxController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addCheckBox(xml:XMLList):void{
			var ID:int = arrChBox.length;
			arrChBox.push(new CheckBoxClass(xml, this.container));
			arrChBox[ID].addEventListener(CheckBoxClass.BOX_SELECT, BOX_IS_SELECT);
			arrChBox[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as CheckBoxClass).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function BOX_IS_SELECT(event:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(!arrChBox[i].complate) return false;
			}
			
			return true;
		}
		public function get machChoice():Boolean{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(!arrChBox[i].oneSelect) return true;
			}
			return false;
		}
		public function get oneChoice():Boolean{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(arrChBox[i].oneSelect) return true;
			}
			return false;
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				(arrChBox[i] as CheckBoxClass).showAnswer();
			}
		}

	}
	
}
