package source {
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import source.utils.Figure;
	
	public class InitScene extends Sprite{
		public static var RESET_SCENE:String = 'onResetScene';
		private var SWidth:Number = 742;
		private var SHeight:Number = 530;
		
		private var BPWidth:Number;
		private var BPHeight:Number;
		
		private var frameBitmap:Bitmap;
		
		private var backgroundContainer:Sprite = new Sprite();
		private var frameContainer:Sprite = new Sprite();
		private var buttonContainer:Sprite = new Sprite();
		private var elementsContainer:Sprite = new Sprite();
		private var mainContainer:Sprite = new Sprite();
		
		
		public function InitScene() {
			super();
			//noScale();
			drawFrame();
			initContainer();
			frameContainer.addEventListener(MouseEvent.MOUSE_DOWN, FRAME_MOUSE_DOWN);
			//trace(this + ': DRAW FRAME');
		}
		private function drawFrame():void{
			if(frameBitmap!=null){
				if(frameContainer.contains(frameBitmap)) frameContainer.removeChild(frameBitmap);
			}
			var spr:Sprite = new Sprite();
			spr.graphics.lineStyle(1, 0x000000, 1);
			spr.graphics.beginFill(0x00FF00, 1);
			spr.graphics.drawRect(0,0,SWidth,SHeight);
			spr.graphics.drawRect(5,5,SWidth-10,SHeight-35);
			spr.graphics.endFill();
			var bmp:BitmapData = new BitmapData(spr.width, spr.height, true, 0x00000000);
			bmp.draw(spr, new Matrix());
			bmp.applyFilter(bmp, bmp.rect, new Point(), new BlurFilter());
			frameBitmap = new Bitmap(bmp);
			frameContainer.addChild(frameBitmap);
			buttonContainer.x = SWidth - BPWidth+10;
			buttonContainer.y = SHeight - BPHeight;
		}
		private function initContainer():void{
			super.addChild(backgroundContainer);
			super.addChild(frameContainer);
			super.addChild(buttonContainer);
			super.addChild(elementsContainer);
			super.addChild(mainContainer);
			super.mouseEnabled = false;
		}
		public function setSize(sWidth:String, sHeight:String):void{
			if(sWidth!='' && sHeight!=''){
				this.SHeight = parseFloat(sHeight);
				this.SWidth = parseFloat(sWidth);
				noScale();
				drawFrame();
			}
		}
		private function noScale():void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		public function get container():Sprite{
			return mainContainer;
		}
		public function get controlContainer():Sprite{
			return elementsContainer;
		}
		public function get frame():Sprite{
			return frameContainer;
		}
		public function set stageWidth(value:Number):void{
			try{
				greed = selectedGreed;
				SWidth = value;
				noScale();
				drawFrame();
			}catch(e:ArgumentError){};
		}
		public function get stageWidth():Number{
			return SWidth;
		}
		public function set stageHeight(value:Number):void{
			try{
				greed = selectedGreed;
				SHeight = value;
				noScale();
				drawFrame();
			}catch(e:ArgumentError){};
		}
		public function get stageHeight():Number{
			return SHeight;
		}
		
		private function FRAME_MOUSE_DOWN(event:MouseEvent):void{
			frameContainer.addEventListener(MouseEvent.MOUSE_UP, FRAME_MOUSE_UP);
			var timer:Timer = new Timer(100, 1);
			timer.addEventListener(TimerEvent.TIMER, FRAME_TIMER);
			timer.start();
		}
		private function FRAME_TIMER(event:TimerEvent):void{
			frameContainer.removeEventListener(MouseEvent.MOUSE_UP, FRAME_MOUSE_UP);
		}
		private function FRAME_MOUSE_UP(event:MouseEvent):void{
			frameContainer.removeEventListener(MouseEvent.MOUSE_UP, FRAME_MOUSE_UP);
			super.dispatchEvent(new Event(RESET_SCENE));
		}
		
		
		private var selectedGreed:Boolean = false;
		public function set greed(value:Boolean):void{
			selectedGreed = value;
			if(value){
				Figure.drawGreed(backgroundContainer, 10, stageWidth, stageHeight, 0.3);
			}else{
				backgroundContainer.graphics.clear();
			}
		}
	}
}
