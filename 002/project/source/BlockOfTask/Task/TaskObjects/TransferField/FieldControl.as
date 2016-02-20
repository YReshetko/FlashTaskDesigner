package source.BlockOfTask.Task.TaskObjects.TransferField {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class FieldControl extends EventDispatcher{
		private var container:Sprite;
		private var labelAnimation:String = '';
		private var arrField:Array = new Array();
		public function FieldControl(container:Sprite) {
			super();
			this.container = container;
		}
		public function addField(xml:XMLList):void{
			var ID:int = arrField.length;
			arrField.push(new OneTransferField(xml, this.container));
			arrField[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			arrField[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as OneTransferField).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function CHECK_TASK(e:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get isTransfer():Boolean{
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				if(arrField[i].transfer)return true;
			}
			return false;
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				if(!arrField[i].stand) return false;
			}
			return true;
		}
		public function checkTableFrameSelect(rect:Rectangle):Boolean{
			var i:int;
			var l:int;
			var flag:Boolean = false;
			l = arrField.length;
			for(i=0;i<l;i++){
				flag = flag || (arrField[i] as OneTransferField).checkTableFrameSelect(rect);
			}
			return flag;
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				(arrField[i] as OneTransferField).showAnswer();
			}
		}
	}
	
}
