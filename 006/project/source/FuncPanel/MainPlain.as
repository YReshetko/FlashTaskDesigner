package source.FuncPanel {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import source.Utilites.PazzleEvent;
	import source.Utilites.SettingPanel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Bitmap;
	
	public class MainPlain extends Sprite{
		private var arrSample:Array = new Array;
		private var arrPlace:Array = new Array;
		private var pictureSprite:Sprite = new Sprite;
		private var pictureIDComplate:int;
		public function MainPlain() {
			super();
			this.focusRect = false;
			initSprite();
		}
		private function initSprite(){
			this.addChild(pictureSprite);
		}
		public function preparePanel(inObject:Object){
			var i,j:int;
			clearPlane();
			for(i=0;i<inObject.numColumn;i++){
				arrSample[i] = new Array;
				for(j=0;j<inObject.numLine;j++){
					arrSample[i][j] = new SamplePict(inObject.wPicture, inObject.hPicture);
					pictureSprite.addChild(arrSample[i][j]);
					arrSample[i][j].x = (i)*arrSample[i][j].width;
					arrSample[i][j].y = (j)*arrSample[i][j].height;
				}
			}
		}
		public function addPicture(arrPict:Array){
			var i,j,ID:int;
			ID = 0;
			for(i=0;i<arrSample.length;i++){
				for(j=0;j<arrSample[i].length;j++){
					arrSample[i][j].setPicture(arrPict[ID]);
					arrSample[i][j].addEventListener(MouseEvent.MOUSE_DOWN, SAMPLE_MOUSE_DOWN);
					ID++;
				}
			}
			for(i=0;i<arrSample.length;i++){
				for(j=0;j<arrSample[i].length;j++){
					arrSample[i][j].initComplate();
				}
			}
		}
		private function clearPlane(){
			var i,j:int;
			while(arrSample.length>0){
				while(arrSample[0].length>0){
					pictureSprite.removeChild(arrSample[0][0]);
					arrSample[0][0] = null;
					arrSample[0].shift();
				}
				arrSample.shift();
			}
		}
		public function randomPlace(){
			var i,j:int;
			for(i=0;i<arrSample.length;i++){
				for(j=0;j<arrSample[i].length;j++){
					arrSample[i][j].randomID();
				}
			}
		}
		private function SAMPLE_MOUSE_DOWN(e:MouseEvent){
			e.target.incID();
			var flag = true;
			var sampleID:int = arrSample[0][0].getID();
			var i,j:int;
			for(i=0;i<arrSample.length;i++){
				for(j=0;j<arrSample[i].length;j++){
					if(sampleID != arrSample[i][j].getID()){
						flag = false;
					}
				}
			}
			if(flag){
				for(i=0;i<arrSample.length;i++){
					for(j=0;j<arrSample[i].length;j++){
						arrSample[i][j].setComplate(true, sampleID);
					}
				}
				pictureIDComplate = sampleID;
				var TIMER:Timer = new Timer(1500, 1);
				TIMER.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
				TIMER.start();
			}
		}
		private function TIMER_COMPLATE(e:TimerEvent){
			this.dispatchEvent(new Event(PazzleEvent.PICTURE_COMPLATE));
			randomPlace();
		}
		public function getComplateID():int{
			return pictureIDComplate;
		}
		public function getComplate():Boolean{
			var outFlag:Boolean = true;
			var i,j:int;
			for(i=0 ; i<arrSample.length; i++){
				for(j=0 ; j<arrSample[i].length; j++){
					if(!arrSample[i][j].getComplate()){
						outFlag = false;
					}
				}
			}
			return outFlag;
		}
	}
	
}
