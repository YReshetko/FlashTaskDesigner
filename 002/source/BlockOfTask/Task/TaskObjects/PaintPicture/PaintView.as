package source.BlockOfTask.Task.TaskObjects.PaintPicture {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.system.LoaderContext;

	public class PaintView extends Sprite{
		public static var SET_COLOR:String = 'onSetColor';
		public static var RESIZE_PANEL:String = 'onResizePanel';
		public static var GET_SETTINGS:String = 'onGetSettings';
		
		private var bitmap:Bitmap;
		
		private var bitmapContainer:Sprite = new Sprite();
		private var frame:Sprite = new Sprite();
		
		private var color:uint = 0xFF000000;
		private var think:int = 1;
		
		private var startX:Number;
		private var startY:Number;
		private var endX:Number;
		private var endY:Number;
		
		private var WPanel:Number;
		private var HPanel:Number;
		
		private var isPaint:Boolean = false;
		private var isEraser:Boolean = false;
		
		public var setableColor:uint;
		
		private var backgroundBitmap:Bitmap;
		public function PaintView() {
			super();
		}
		public function drawPanel(width:Number, height:Number):void{
			WPanel = width;
			HPanel = height;
			frame.graphics.lineStyle(1, 0x000000, 1);
			frame.graphics.drawRect(0, 0, width, height);
			bitmap = new Bitmap(new BitmapData(width, height, true, 0x00FFFFFF));
			super.addChild(bitmapContainer);
			
			bitmapContainer.addChild(bitmap);
			bitmapContainer.addChild(frame);
			bitmapContainer.addEventListener(MouseEvent.MOUSE_DOWN, BITMAP_MD);
			super.dispatchEvent(new Event(RESIZE_PANEL));
		}
		
		public function setBackgroundImage(content:ByteArray):void{
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_PICTURE_COMPLATE);
			loader.loadBytes(content, context);
		}
		private function LOAD_PICTURE_COMPLATE(event:Event):void{
			backgroundBitmap =  event.target.content;
			super.addChildAt(backgroundBitmap,0);
		}
		private function BITMAP_MD(event:MouseEvent):void{
			if(!isPaint && !isEraser) return;
			bitmapContainer.addEventListener(MouseEvent.MOUSE_MOVE, BITMAP_MM);
			bitmapContainer.addEventListener(MouseEvent.MOUSE_UP, BITMAP_MU);
			startX = event.localX;
			startY = event.localY;
		}
		private function BITMAP_MU(event:MouseEvent):void{
			bitmapContainer.removeEventListener(MouseEvent.MOUSE_MOVE, BITMAP_MM);
			bitmapContainer.removeEventListener(MouseEvent.MOUSE_UP, BITMAP_MU);
			startX = endX;
			startY = endY;
		}
		private function BITMAP_MM(event:MouseEvent):void{
			endX = event.localX;
			endY = event.localY;
			startDrawLine();
		}
		
		private function startDrawLine():void{
			var deltaX:Number;
			var deltaY:Number;
			var oneLineStep:int;
			var i:int;
			var j:int;
			deltaX = endX - startX;
			deltaY = endY - startY;
			if(Math.abs(deltaX) > Math.abs(deltaY)){
				oneLineStep = Math.abs(Math.round(deltaX/deltaY));
				for(i=0;i<Math.abs(deltaX);i++){
					if(i%oneLineStep == 0) startY += sign(deltaY);
					startX += sign(deltaX);
					setDot(startX, startY);
				}
			}else{
				oneLineStep = Math.abs(Math.round(deltaY/deltaX));
				for(i=0;i<Math.abs(deltaY);i++){
					if(i%oneLineStep == 0) startX += sign(deltaX);
					startY += sign(deltaY);
					setDot(startX, startY);
				}
			}
		}
		private function setDot(x:Number, y:Number):void{
			var dotColor:uint;
			if(isPaint) dotColor = color;
			if(isEraser) dotColor = 0x00FFFFFF;
			var data:BitmapData = bitmap.bitmapData;
			for(var i:int = -1; i<think-1 ;i++){
				for(var j:int = -1;j<think-1;j++){
					data.setPixel32(x+i, y+j, dotColor);
				}
			}
		}
		private function sign(x:Number):int{
			return  x>0?1:-1;
		}
		
		public function set drawColor(color:uint):void{
			this.color = rebuildColor(color);
		}
		public function get drawColor():uint{
			return this.color;
		}
		
		private function rebuildColor(value:uint):uint{
			var colorStr:String = value.toString(16);
			while(colorStr.length<7) colorStr = '0' + colorStr ;
			colorStr = '0xFF' + colorStr;
			return uint(colorStr);
		}
		
		public function set paint(value:Boolean):void{
			this.isPaint = value;
		}
		public function get paint():Boolean{
			return this.isPaint;
		}
		
		public function set eraser(value:Boolean):void{
			isEraser = value;
		}
		public function get eraser():Boolean{
			return isEraser;
		}
		
		
		public function set brushThink(value:Number):void{
			think = value;
		}
		public function get brushThink():Number{
			return think;
		}
		
		public function set Color(value:uint):void{
			setableColor = value;
			super.dispatchEvent(new Event(SET_COLOR));
		}
		public function get Color():uint{
			return 0x000000;
		}
		public function get panelWidth():Number{
			return WPanel;
		}
		public function get panelHeight():Number{
			return HPanel;
		}
	}
	
}
