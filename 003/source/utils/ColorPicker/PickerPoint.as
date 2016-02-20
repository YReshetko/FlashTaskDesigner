package source.utils.ColorPicker
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class PickerPoint extends Sprite
	{

		public static var wPoint:Number = 10;
		public static var hPoint:Number = 10;

		private var isSelect:Boolean = false;

		private var color:uint;
		public function PickerPoint(color:uint)
		{
			super();
			this.color = color;
			drawPoint();
			initListener();
		}
		private function drawPoint():void
		{
			super.graphics.clear();
			if (isSelect)
			{
				super.graphics.lineStyle(0.1, 0xFFFF00, 1);
			}
			else
			{
				super.graphics.lineStyle(0.1, 0x000000, 1);
			}
			super.graphics.beginFill(this.color, 1);
			super.graphics.drawRect(0, 0, wPoint, hPoint);
			super.graphics.endFill();
		}
		private function initListener():void
		{
			super.addEventListener(MouseEvent.MOUSE_DOWN, POINT_MD);
			super.addEventListener(MouseEvent.ROLL_OVER, POINT_R_OVER);
			super.addEventListener(MouseEvent.ROLL_OUT, POINT_R_OUT);
		}
		private function POINT_MD(e:MouseEvent):void
		{
			super.dispatchEvent(new Event(ColorPicker.COLOR_CHANGE));
		}
		private function POINT_R_OVER(e:MouseEvent):void
		{
			isSelect = true;
			super.parent.setChildIndex(super, super.parent.numChildren-1);
			drawPoint();
		}
		private function POINT_R_OUT(e:MouseEvent):void
		{
			isSelect = false;
			drawPoint();
		}
		public function get selectedColor():uint
		{
			return this.color;
		}
	}

}