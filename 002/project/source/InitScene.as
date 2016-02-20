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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class InitScene extends Sprite{
		
		public static var BACK_IN_TREE:String = 'onBackInTree';
		public static var RELOAD_TASK:String = 'onReloadTask';
		public static var NEXT_IN_TREE:String = 'onNextInTree';
		public static var CHECK_TASK:String = 'onCheckTask';
		public static var CLICK_MISS:String = 'onClickMiss';
		
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
		private var consoleSprite:Sprite = new Sprite();
		
		private var maskSprite:Sprite = new Sprite();
		
		private var BUnderstand:Understand = new Understand();
		private var BRestart:Restart = new Restart();
		private var BDontknow:* = new DontKnow();
		private var BCheck:CheckTask = new CheckTask();
		
		
		public function InitScene() {
			super();
			//noScale();
			initButton();
			drawFrame();
			initContainer();
		}
		public function set isNextTaskButton(value:Boolean):void{
			buttonContainer.removeChild(BDontknow);
			BDontknow.removeEventListener(MouseEvent.MOUSE_DOWN, DONT_KNOW_MOUSE_DOWN);
			var flag:Boolean = BDontknow.visible;
			BDontknow = null;
			
			if(value){
				BDontknow = new NextTask();
			}else{
				BDontknow = new DontKnow();
			}
			buttonContainer.addChild(BDontknow);
			BDontknow.addEventListener(MouseEvent.MOUSE_DOWN, DONT_KNOW_MOUSE_DOWN);
			BDontknow.x = BRestart.x+BRestart.width;
			BDontknow.y = BRestart.y;
			this.dontknow = flag;
		}
		private function initButton():void{
			buttonContainer.addChild(BUnderstand);
			buttonContainer.addChild(BRestart);
			buttonContainer.addChild(BDontknow);
			buttonContainer.addChild(BCheck);
			BRestart.x = BUnderstand.width;
			BCheck.x = BDontknow.x = BRestart.x+BRestart.width;
			understand = false;
			restart = false;
			dontknow = false;
			check = false;
			BPWidth = buttonContainer.width;
			BPHeight = buttonContainer.height;
			BUnderstand.addEventListener(MouseEvent.MOUSE_DOWN, UNDERSTAND_MOUSE_DOWN);
			BRestart.addEventListener(MouseEvent.MOUSE_DOWN, RESTART_MOUSE_DOWN);
			BDontknow.addEventListener(MouseEvent.MOUSE_DOWN, DONT_KNOW_MOUSE_DOWN);
			BCheck.addEventListener(MouseEvent.MOUSE_DOWN, CHECK_MOUSE_DOWN);
		}
		private function UNDERSTAND_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(BACK_IN_TREE));
		}
		private function RESTART_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(RELOAD_TASK));
		}
		private function DONT_KNOW_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(NEXT_IN_TREE));
		}
		private function CHECK_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(CHECK_TASK));
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
			frameContainer.addEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
			buttonContainer.x = SWidth - BPWidth+10;
			buttonContainer.y = SHeight - BPHeight;
			drawMask();
		}
		private function BG_MOUSE_DOWN(e:MouseEvent):void{
			trace(this + ': CLICK ON SCENE');
			super.dispatchEvent(new Event(CLICK_MISS));
		}
		private function initContainer():void{
			super.addChild(backgroundContainer);
			super.addChild(frameContainer);
			super.addChild(buttonContainer);
			super.addChild(elementsContainer);
			super.addChild(mainContainer);
			super.addChild(consoleSprite);
			super.addChild(maskSprite);
			super.mask = maskSprite;
			mainContainer.mouseEnabled = false;
			mainContainer.tabEnabled = false;
		}
		public function setSize(sWidth:String, sHeight:String):void{
			if(sWidth == 'NaN' || sWidth == '') return;
			else SWidth = parseFloat(sWidth);
			if(sHeight == 'NaN' || sHeight == '') return;
			else SHeight = parseFloat(sHeight);
			drawFrame();
			drawMask();
			if(sHeight == '530' && sWidth  == '742') return;
			trace(this + ': SET SIZE');
			noScale();
			
		}
		private function noScale():void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		public function set understand(value:Boolean):void{
			BUnderstand.visible = value;
		}
		public function set restart(value:Boolean):void{
			BRestart.visible = value;
		}
		public function set dontknow(value:Boolean):void{
			BDontknow.visible = value;
			if (value) check = false;
		}
		public function set check(value:Boolean):void{
			BCheck.visible = value;
			if (value) dontknow = false;
		}
		public function get container():Sprite{
			return mainContainer;
		}
		public function get controlContainer():Sprite{
			return elementsContainer;
		}
		public function get butContainer():Sprite{
			return buttonContainer;
		}
		public function set stageWidth(value:Number):void{
			SWidth = value;
			drawMask();
		}
		public function set stageHeight(value:Number):void{
			SHeight = value;
			drawMask();
		}
		public function get stageWidth():Number{
			return SWidth;
		}
		public function get stageHeight():Number{
			return SHeight;
		}
		public function get console():Sprite{
			return consoleSprite;
		}
		
		private function drawMask():void{
			maskSprite.graphics.clear();
			maskSprite.graphics.lineStyle(1, 0, 1);
			maskSprite.graphics.beginFill(0,1);
			maskSprite.graphics.drawRect(0, 0, SWidth, SHeight);
			maskSprite.graphics.endFill();
		}
	}
	
}
