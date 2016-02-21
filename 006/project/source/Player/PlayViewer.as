package source.Player {
	import flash.display.Sprite;
	import source.FuncPanel.MainPlain;
	import source.Utilites.PazzleEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.FuncPanel.SamplePanel;
	import flash.geom.Matrix;
	
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
		private var startTask:Boolean = false;
		
		private var arrSample:Array;
		
		private var nearBySample:Array = new Array;
		
		private var reflex:String = "VANISHING";
		private var helper:String = "";
		public function PlayViewer() {
			super();
			super.addChild(Loup);
			super.addChild(warkPlain);
			super.addChild(sample);
		}
		public function setPicture(arrPict:Array, inObject:Object){
			var i:int;
			warkPlain.preparePanel(inObject);
			correctPosition(warkPlain);
			for(i=0;i<arrPict.length;i++){
				warkPlain.addPicture(arrPict[i]);
			}
			warkPlain.randomPlace();
			
		}
		private function correctPosition(inObj){
			inObj.x = (wDisplay - inObj.width)/2;
			inObj.y = (hDisplay - inObj.height)/2;
		}
		public function setSample(inImage:Array, inObject:Object){
			var i:int;
			arrSample = new Array();
			arrSample[0] = new Array();
			var image:Bitmap = new Bitmap();
			var copyBMPData:BitmapData
			for(i=0;i<inImage.length;i++){
				arrSample[i] = new Sprite;
				image = new Bitmap(inImage[i]);
				copyBMPData = new BitmapData(image.width, image.height);
				copyBMPData.draw(image, new Matrix());
				arrSample[i].addChild(image);
				sample.addChild(arrSample[i]);
				//trace(this+" OLD SAMPLE ADDED");
				//trace(this + " COPY BITMAP = " + copyBMPData);
				nearBySample[i] = new SamplePanel(copyBMPData, i);
				//trace(this+" NEW SAMPLE ADDED");
				nearBySample[i].closeDragPanel();
				this.addChild(nearBySample[i]);
				nearBySample[i].visible = false;
				//trace(this+" NEW SAMPLE ADDED");
			}
			sample.graphics.lineStyle(1, 0x000000, 0);
			sample.graphics.beginFill(0xDFDFDF, 1);
			sample.graphics.drawRect(0,0,wDisplay, hDisplay);
			sample.graphics.endFill();
			sample.visible = false;
			Loup.y = 496;
			Loup.x = wDisplay/2;
			Loup.addEventListener(MouseEvent.MOUSE_DOWN, LOUP_MOUSE_DOWN);
			orientPicture(inObject);
			warkPlain.addEventListener(PazzleEvent.PICTURE_COMPLATE, PICTURE_COMPLATE);
		}
		private function orientPicture(inObject:Object){
			var i:int;
			var leng:int = arrSample.length;
			trace(this+" SAMPLE LENGTH = " + leng);
			if(inObject.numColumn > inObject.numLine){
				if(leng<=6){
					for(i=0;i<leng;i++){
						arrSample[i].width = wDisplay/2 - 10;
						arrSample[i].height = hDisplay/3 - 10;
						if(i%2!=0){
							arrSample[i].x = wDisplay/2 + 2.5;
						}else{
							arrSample[i].x = 2.5;
						}
						arrSample[i].y = (Math.ceil((i+1)/2)-1)*hDisplay/3+2.5;
					}
				}else{
					for(i=0;i<leng;i++){
						arrSample[i].width = wDisplay/7 - 20;
						arrSample[i].height = hDisplay/10 - 20;
						if(i%7!=0){
							arrSample[i].x = (i%7)*wDisplay/7 + 1;
						}else{
							arrSample[i].x = 1;
						}
						arrSample[i].y = (Math.ceil((i+1)/7)-1)*hDisplay/10+1;
					}
				}
			}else{
				if(leng<=6){
					for(i=0;i<leng;i++){
						arrSample[i].width = wDisplay/3 - 10;
						arrSample[i].height = hDisplay/2 - 10;
						if(i%2!=0){
							arrSample[i].y = hDisplay/2 + 2.5;
						}else{
							arrSample[i].y = 2.5;
						}
						arrSample[i].x = (Math.ceil((i+1)/2)-1)*wDisplay/3+2.5;
					}
				}else{
					for(i=0;i<leng;i++){
						arrSample[i].width = wDisplay/7 - 20;
						arrSample[i].height = hDisplay/10 -20;
						if(i%10!=0){
							arrSample[i].y = (i%10)*hDisplay/10 + 1;
						}else{
							arrSample[i].y = 1;
						}
						arrSample[i].x = (Math.ceil((i+1)/10)-1)*wDisplay/7+1;
					}
				}
			}
		}
		public function removeLoup(){
			Loup.visible = false;
		}
		public function setReflex(s:String){
			reflex = s;
			var i:int;
			if(reflex == "SHOWING"){
				for(i=0;i<arrSample.length;i++){
					arrSample[i].visible = false;
				}
			}
		}
		public function setHelper(s:String){
			helper = s;
		}
		public function setNearBySemple(inArr:Array){
			var i:int;
			for(i=0;i<inArr.length;i++){
				nearBySample[i].x = inArr[i][0];
				nearBySample[i].y = inArr[i][1];
				if(reflex != "SHOWING"){
					nearBySample[i].visible = true;
				}
			}
		}
		private function PICTURE_COMPLATE(e:Event){
			if(helper!= "WITHOUT HELP"){
				if(reflex == "VANISHING"){
					if(Loup.visible){
						arrSample[warkPlain.getComplateID()].visible = false;
					}else{
						nearBySample[warkPlain.getComplateID()].visible = false;
					}
				}
				if(reflex == "SHOWING"){
					if(Loup.visible){
						arrSample[warkPlain.getComplateID()].visible = true;
					}else{
						nearBySample[warkPlain.getComplateID()].visible = true;
					}
				}
			}
			if(Loup.visible){
				LOUP_MOUSE_DOWN(null);
			}
			startTask = true;
			trace(this + " FULL COMPLATE = " + getAnswere());
		}
		private function LOUP_MOUSE_DOWN(e:MouseEvent){
			sample.visible = !sample.visible;
			if(sample.visible){
				super.dispatchEvent(new Event(CLOSE_RESTART));
			}else{
				super.dispatchEvent(new Event(OPEN_RESTART));
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
