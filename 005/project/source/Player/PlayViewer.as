package source.Player {
	import flash.display.Sprite;
	import source.FuncPanel.MainPlain;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PlayViewer extends Sprite{
		public static var CLOSE_RESTART:String = 'onCloseRestart';
		public static var OPEN_RESTART:String = 'onOpenRestart';
		
		private static const wDisplay:int = 730;
		private static const hDisplay:int = 494;
		
		private var remW:Number;
		private var remH:Number;
		
		private var warkPlain:MainPlain = new MainPlain();
		private var sample:Sprite = new Sprite
		private var Loup:LoupBut = new LoupBut();
		private var Loup1:LoupBut1 = new LoupBut1();
		private var startTask:Boolean = false;
		
		private var sampleBitmap:Bitmap;
		public function PlayViewer() {
			super();
			super.addChild(Loup);
			super.addChild(Loup1);
			Loup.visible = false;
			super.addChild(warkPlain);
			super.addChild(sample);
		}
		public function setPicture(arrPict:Array, inObject:Object){
			warkPlain.setPicture(inObject.numLine, inObject.numColumn, arrPict);
			warkPlain.initPlayer();
			remH = warkPlain.height = inObject.hPicture;
			remW = warkPlain.width = inObject.wPicture;
			
			correctPosition(warkPlain);
			warkPlain.randomPlace();
			startTask = true;
		}
		private function correctPosition(inObj){
			inObj.x = (wDisplay - inObj.width)/2;
			inObj.y = (hDisplay - inObj.height)/2;
		}
		public function setSample(inImage:BitmapData){
			sampleBitmap = new Bitmap(inImage);
			sample.addChild(sampleBitmap);
			sample.graphics.lineStyle(1, 0x000000, 0);
			sample.graphics.beginFill(0xDFDFDF, 1);
			sample.graphics.drawRect(0,0,wDisplay, hDisplay);
			sample.graphics.endFill();
			sampleBitmap.width = remW;
			sampleBitmap.height = remH;
			correctPosition(sampleBitmap);
			sample.visible = false;
			Loup1.y = Loup.y = 496;
			Loup1.x = Loup.x = wDisplay/2-15;
			Loup.addEventListener(MouseEvent.MOUSE_DOWN, LOUP_MOUSE_DOWN);
			Loup1.addEventListener(MouseEvent.MOUSE_DOWN, LOUP_MOUSE_DOWN);
		}
		private function LOUP_MOUSE_DOWN(e:MouseEvent){
			sample.visible = !sample.visible;
			if(sample.visible){
				super.dispatchEvent(new Event(CLOSE_RESTART));
				Loup.visible = true;
				Loup1.visible = false;
			}else{
				super.dispatchEvent(new Event(OPEN_RESTART));
				Loup1.visible = true;
				Loup.visible = false;
			}
		}
		public function setUserPosition(arr:Array){
			trace(this + " SET USER POSITION");
			warkPlain.setUserPosition(arr);
		}
		public function setOneColumn(){
			warkPlain.setOneColumn();
		}
		public function setAroundField(){
			warkPlain.setAroundField();
		}
		public function setJump(j:int){
			warkPlain.setJump(j);
		}
		public function setHelp(help:String){
			trace(this + " SET HELP = " + help);
			switch (help){
				case "WITHOUT HELP":
					Loup.visible = false;
				break;
				case "SAMPLE BACKGRAUND":
					trace(this + " SAMPLE = " + sampleBitmap);
					Loup.visible = false;
					warkPlain.setSample(sampleBitmap);
				break;
			}
		}
		public function getAnswere():Boolean{
			var outFlag:Boolean;
			if(!startTask){
				outFlag = false;
			}else{
				outFlag = warkPlain.getComplate();
			}
			return outFlag;
		}
	}
	
}
