package source.utils.ColorPicker
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.filters.BlurFilter;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.events.Event;

	public class PickerPanel extends Sprite
	{
		public static var pWidth:Number = 200;
		public static var pHeight:Number = 140;

		public static var pFill:uint = 0x969696;
		private var pointArray:Array;

		private var currentColor:uint;
		public function PickerPanel()
		{
			super();
			super.focusRect = false;
			//drawPanel();
			addPoints();
		}
		private function drawPanel():void
		{
			var spr:Sprite = new Sprite();
			spr.graphics.lineStyle(1, 0x696969, 1);
			spr.graphics.beginFill(pFill, 0.7);
			spr.graphics.drawRoundRect(0 ,0 ,pWidth, pHeight, 10, 10);
			spr.graphics.endFill();
			var bmpData:BitmapData = new BitmapData(spr.width,spr.height);
			bmpData.draw(spr, new Matrix());
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(), new BlurFilter(3, 3, 2));
			var bmp:Bitmap = new Bitmap(bmpData);
			bmp.alpha = 0.5;
			super.addChild(bmp);
		}
		private function addPoints():void
		{
			pointArray = new Array();
			var color:ColorTransform = new ColorTransform();
			var stap:Number = 51;
			var i:int;
			var j:int;
			var k:int;
			var ID:int;
			var startX:Number;
			var startY:Number = 0;
			var remX:Number;
			for (i=0; i<6; i++)
			{
				color.redOffset = stap * i;
				startX = (i%3)*(PickerPoint.wPoint*6);
				if(i<3) startY = 0;
				else startY = PickerPoint.hPoint*6;
				for (j=0; j<6; j++)
				{
					startY +=  PickerPoint.hPoint;
					remX = startX;
					color.blueOffset = stap * j;
					for (k=0; k<6; k++)
					{
						remX +=  PickerPoint.wPoint;
						color.greenOffset = stap * k;
						ID = pointArray.length;
						pointArray.push(new PickerPoint(color.color));
						super.addChild(pointArray[ID]);
						pointArray[ID].x = remX;
						pointArray[ID].y = startY;
						pointArray[ID].addEventListener(ColorPicker.COLOR_CHANGE, SELECT_COLOR);
					}
				}
			}
		}
		private function SELECT_COLOR(e:Event):void
		{
			color = e.target.selectedColor;
			super.dispatchEvent(new Event(ColorPicker.COLOR_CHANGE));
		}
		public function set color(value:uint):void
		{
			currentColor = value;
		}
		public function get color():uint
		{
			return currentColor;
		}
		public function clearPanel():void
		{
			while (pointArray.length>0)
			{
				pointArray[0].removeEventListener(ColorPicker.COLOR_CHANGE, SELECT_COLOR);
				super.removeChild(pointArray[0]);
				pointArray.shift();
			}
		}
	}

}