package source.BlockOfTask.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class TablePlane extends Sprite{
		public static var SELECT_PLANE:String = 'onSelectPlane';
		
		private var wPlane:Number;
		private var hPlane:Number;
		private var trueSample:Boolean = false;
		private var id:int;
		private var isSelect:Boolean = false;
		public function TablePlane(W:Number, H:Number) {
			super();
			wPlane = W;
			hPlane = H;
			drawSample();
		}
		private function drawSample():void{
			Figure.insertRect(super, wPlane, hPlane, 1, 0, 0x000000, 1, 0xFFFFFF);
		}
		public function set isTrue(value:Boolean):void{
			trueSample = value;
		}
		public function get isTrue():Boolean{
			return trueSample;
		}
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		public function set select(value:Boolean):void{
			isSelect = value;
			if(isSelect){
				super.alpha = 0;
				super.addEventListener(MouseEvent.CLICK, ON_CLICK);
			}else{
				super.alpha = 1;
				super.removeEventListener(MouseEvent.CLICK, ON_CLICK);
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		private function ON_CLICK(e:MouseEvent):void{
			super.dispatchEvent(new Event(SELECT_PLANE));
		}
	}
}
