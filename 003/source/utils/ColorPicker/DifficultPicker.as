package source.utils.ColorPicker {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.events.Event;
	
	public class DifficultPicker extends Sprite{
		
		
		private static const wStripColor:int = 10;
		private static const hStripColor:int = 256;
		private var mainStripColor:Bitmap;
		private var fieldOfPixels:Bitmap;
		private var fieldOfPixelsData:BitmapData;
		private var fieldSprite:Sprite;
		private var maskSprite:Sprite;
		private var dragPointer:Sprite;
		private var mainPointer:Sprite;
		private var pointerRectangleDrag:Rectangle;
		private var mainPointerRectangleDrag:Rectangle;
		public function DifficultPicker() {
			super();
			drawStripColor();
			initFieldOfPixels();
			
		}
		private function drawStripColor():void{
			var warkBitmapData:BitmapData = new BitmapData(wStripColor, hStripColor, false);
			var colorTransform:ColorTransform = new ColorTransform();
			var rect:Rectangle;
			colorTransform.greenOffset = 0;
			colorTransform.blueOffset = 0;
			var i:int;
			var j:int;
			for(i=0;i<hStripColor;i++){
				colorTransform.redOffset = i;
				rect = new Rectangle(0, i, wStripColor, 1);
				warkBitmapData.fillRect(rect, colorTransform.color);
			}
			mainStripColor = new Bitmap(warkBitmapData);
			super.addChild(mainStripColor);
			addPointer();
		}
		private function addPointer():void{
			var spr:Sprite = new Sprite;
			Figure.insertCurve(spr, [[0, 10],[20, 20],[20, 0]], 1, 0.1, 0x000000, 0xFF0FF0);
			dragPointer = new Sprite;
			dragPointer.addChild(spr);
			spr.y = -10;
			super.addChild(dragPointer);
			dragPointer.scaleX = 0.5;
			dragPointer.scaleY = 0.5;
			dragPointer.x = wStripColor;
			pointerRectangleDrag = new Rectangle(wStripColor, 0, 0, hStripColor-1);
			dragPointer.addEventListener(MouseEvent.MOUSE_DOWN, POINTER_MOUSE_DOWN);
		}
		private function POINTER_MOUSE_DOWN(e:MouseEvent):void{
			dragPointer.startDrag(false, pointerRectangleDrag);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, POINTER_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, POINTER_MOUSE_MOVE);
		}
		private function POINTER_MOUSE_MOVE(e:MouseEvent = null):void{
			//trace(this + ': CURRENT COLOR = ' + mainStripColor.bitmapData.getPixel(0, dragPointer.y).toString(16));
			drawFieldOfPixels(mainStripColor.bitmapData.getPixel(0, dragPointer.y));
			super.dispatchEvent(new Event(ColorPicker.COLOR_CHANGE));
		}
		private function POINTER_MOUSE_UP(e:MouseEvent):void{
			dragPointer.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, POINTER_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, POINTER_MOUSE_MOVE);
			MAIN_POINTER_MOUSE_MOVE();
		}
		
		private function initFieldOfPixels():void{
			fieldOfPixelsData = new BitmapData(hStripColor, hStripColor, false);
			fieldOfPixels = new Bitmap(fieldOfPixelsData);
			fieldSprite = new Sprite();
			fieldSprite.addChild(fieldOfPixels);
			super.addChild(fieldSprite);
			fieldSprite.x = dragPointer.x + dragPointer.width + 20;
			POINTER_MOUSE_MOVE();
			addMainPointer();
		}
		private function addMainPointer():void{
			mainPointer = new Sprite();
			var spr:Sprite = new Sprite();
			maskSprite = new Sprite();
			maskSprite.graphics.lineStyle(1, 0, 1);
			maskSprite.graphics.beginFill(0x000000, 1);
			maskSprite.graphics.drawRect(0, 0, hStripColor-1, hStripColor-1);
			maskSprite.graphics.endFill();
			Figure.insertCircle(spr, 5, 1, 0.1, 0x000000, 0);
			mainPointer.addChild(spr);
			fieldSprite.addChild(mainPointer);
			fieldSprite.addChild(maskSprite);
			mainPointer.mask = maskSprite;
			mainPointer.mouseChildren = false;
			mainPointerRectangleDrag = new Rectangle(0, 0, hStripColor-1, hStripColor-1);
			fieldSprite.addEventListener(MouseEvent.MOUSE_DOWN, MAIN_POINTER_MOUSE_DOWN);
		}
		private function MAIN_POINTER_MOUSE_DOWN(e:MouseEvent):void{
			mainPointer.startDrag(true, mainPointerRectangleDrag);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, MAIN_POINTER_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, MAIN_POINTER_MOUSE_MOVE);
		}
		private function MAIN_POINTER_MOUSE_MOVE(e:MouseEvent = null):void{
			super.dispatchEvent(new Event(ColorPicker.COLOR_CHANGE));
		}
		private function MAIN_POINTER_MOUSE_UP(e:MouseEvent):void{
			mainPointer.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, MAIN_POINTER_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, MAIN_POINTER_MOUSE_MOVE);
			MAIN_POINTER_MOUSE_MOVE();
		}
		private function drawFieldOfPixels(redColor:uint):void{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = redColor;
			var i:int;
			var j:int;
			for(i=0;i<hStripColor;i++){
				colorTransform.greenOffset = i;
				for(j=0;j<hStripColor;j++){
					colorTransform.blueOffset = j;
					fieldOfPixelsData.setPixel(j, i, colorTransform.color);
				}
			}
		}
		
		public function set color(value:uint):void{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = value;
			dragPointer.y = colorTransform.redOffset;
			drawFieldOfPixels(mainStripColor.bitmapData.getPixel(0, dragPointer.y));
			mainPointer.x = colorTransform.blueOffset;
			mainPointer.y = colorTransform.greenOffset;
		}
		public function get color():uint{
			return fieldOfPixelsData.getPixel(mainPointer.x, mainPointer.y);
		}
	}
	
}
