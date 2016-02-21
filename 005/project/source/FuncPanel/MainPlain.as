package source.FuncPanel {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import source.Utilites.PazzleEvent;
	import flash.display.Bitmap;
	
	public class MainPlain extends Sprite{
		private var arrSample:Array = new Array;
		private var arrPlace:Array = new Array;
		private var currentTarget;
		private var myWidth:Number;
		private var myHeight:Number;
		private var pictureSprite:Sprite = new Sprite;
		private var sampleSprite:Sprite = new Sprite;
		private var placeSprite:Sprite = new Sprite;
		private var jump:int = 20;
		public function MainPlain() {
			super();
			this.focusRect = false;
			initSprite();
		}
		private function initSprite(){
			this.addChild(placeSprite);
			this.addChild(sampleSprite);
			this.addChild(pictureSprite);
		}
		public function setPicture(numLine:int, numColumn:int, arrPict:Array){
			//trace(this+ " "+ arrPict);
			var i,j,ID:int;
			clearPlane();
			ID = 0;
			for(i=0;i<numColumn;i++){
				arrSample[i] = new Array;
				for(j=0;j<numLine;j++){
					arrSample[i][j] = new SamplePict(arrPict[ID]);
					pictureSprite.addChild(arrSample[i][j]);
					arrSample[i][j].x = (i+0.5)*arrSample[i][j].width;
					arrSample[i][j].y = (j+0.5)*arrSample[i][j].height;
					ID++;
				}
			}
			myWidth = this.width;
			myHeight = this.height;
			trace(this + " WIDTH = " + myWidth + "; HEIGHT = " + myHeight);
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
		public function initPlayer(){
			var i,j:int;
			for(i=0 ; i<arrSample.length; i++){
				arrPlace[i] = new Array;
				for(j=0 ; j<arrSample[i].length; j++){
					arrSample[i][j].setID(i+"_"+j);
					arrPlace[i][j] = new SamplePlace(arrSample[i][j].height, arrSample[i][j].width, i+"_"+j);
					placeSprite.addChild(arrPlace[i][j]);
					arrPlace[i][j].x = arrSample[i][j].x;
					arrPlace[i][j].y = arrSample[i][j].y;
				}
			}
		}
		public function randomPlace(){
			var i,j:int;
			var randomR:int;
			var randomX:int;
			var randomY:int;
			for(i=0 ; i<arrSample.length; i++){
				for(j=0 ; j<arrSample[i].length; j++){
					randomX = Math.ceil(Math.random()*myWidth);
					randomY = Math.ceil(Math.random()*myHeight);
					randomR = Math.ceil(Math.random()*15);
					arrSample[i][j].x = randomX;
					arrSample[i][j].y = randomY;
					arrSample[i][j].setRotation(randomR);
					arrSample[i][j].rotation = -22.5 * randomR;
				}
			}
			initHandler();
		}
		public function initHandler(){
			var i,j:int;
			for(i=0 ; i<arrSample.length; i++){
				for(j=0 ; j<arrSample[i].length; j++){
					arrSample[i][j].addEventListener(MouseEvent.MOUSE_DOWN, SAMPLE_MOUSE_DOWN);
					arrSample[i][j].addEventListener(MouseEvent.MOUSE_UP, SAMPLE_MOUSE_UP);
				}
			}
			this.addEventListener(KeyboardEvent.KEY_DOWN, SAMPLE_KEY_DOWN);
		}
		private function SAMPLE_MOUSE_DOWN(e:MouseEvent){
			e.target.startDrag();
			currentTarget = e.target;
			currentTarget.setComplate(false);
			stage.focus = this;
			pictureSprite.setChildIndex(currentTarget, pictureSprite.numChildren - 1);
		}
		private function SAMPLE_MOUSE_UP(e:MouseEvent){
			stopDrag();
			var currentPlace:SamplePlace = getPlace();
			trace(currentPlace);
			if(currentPlace!=null && currentTarget.getRotation() == 0){
				currentTarget.x = currentPlace.x;
				currentTarget.y = currentPlace.y;
				if(currentTarget.getID() == currentPlace.getID()){
					currentTarget.setComplate(true);
				}else{
					currentTarget.setComplate(false);
				}
			}
			super.dispatchEvent(new Event(PazzleEvent.POSITION_CHANGED));
		}
		private function SAMPLE_KEY_DOWN(e:KeyboardEvent){
			trace(e.keyCode);
			switch (e.keyCode){
				case 37:
					currentTarget.decRotation();
					currentTarget.rotation += 22.5;
					super.dispatchEvent(new Event(PazzleEvent.POSITION_CHANGED));
				break;
				case 39:
					currentTarget.incRotation();
					currentTarget.rotation -= 22.5;
					super.dispatchEvent(new Event(PazzleEvent.POSITION_CHANGED));
				break;
			}
		}
		private function getPlace(){
			var i,j:int;
			for(i=0 ; i<arrPlace.length; i++){
				for(j=0 ; j<arrPlace[i].length; j++){
					if(Math.abs(currentTarget.x - arrPlace[i][j].x)<jump && Math.abs(currentTarget.y - arrPlace[i][j].y)<jump){
						return arrPlace[i][j];
					}
				}
			}
			return null;
		}
		public function getPosition(){
			var i,j:int;
			var outArray:Array = new Array;
			for(i=0 ; i<arrSample.length; i++){
				outArray[i] = new Array;
				for(j=0 ; j<arrSample[i].length; j++){
					outArray[i][j] = [arrSample[i][j].x, arrSample[i][j].y, arrSample[i][j].getRotation()];
				}
			}
			return outArray;
		}
		public function setJump(j:int){
			jump = j;
		}
		public function setSample(bmp:Bitmap){
			trace(this+" ADD BITMAP")
			sampleSprite.addChild(bmp);
			bmp.alpha = 0.5;
			bmp.x = bmp.y = 0;
			bmp.scaleX = 1;bmp.scaleY = 1;
		}
		public function setUserPosition(arrPosition:Array){
			trace(this+" SET USER POSITION ARRAY = " + arrPosition);
			var i,j:int;
			for(i=0 ; i<arrSample.length; i++){
				for(j=0 ; j<arrSample[i].length; j++){
					arrSample[i][j].x = arrPosition[i][j][0];
					arrSample[i][j].y = arrPosition[i][j][1];
					arrSample[i][j].rotation = 22.5 * arrSample[i][j].getRotation();
					arrSample[i][j].setRotation(arrPosition[i][j][2]);
					arrSample[i][j].rotation = -22.5 * arrSample[i][j].getRotation();
					currentTarget = arrSample[i][j];
					SAMPLE_MOUSE_UP(null);
				}
			}
		}
		public function setAroundField(){
			var i,j:int;
			var num:int;
			for(i=0 ; i<arrSample.length; i++){
				for(j=0 ; j<arrSample[i].length; j++){
					num = Math.ceil(Math.random()*3);
					switch (num){
						case 0:
							arrSample[i][j].y = -arrSample[i][j].height/2;
						break;
						case 1:
							arrSample[i][j].y = myHeight + arrSample[i][j].height/2;
						break;
						case 2:
							arrSample[i][j].x = -arrSample[i][j].width/2;
						break;
						case 3:
							arrSample[i][j].x = myWidth + arrSample[i][j].width/2;
						break;
					}
				}
			}
		}
		public function setOneColumn(){
			var columnX:Number = myWidth + arrSample[0][0].width/2;
			var columnY:Number = myHeight - arrSample[0][0].height/2;
			var i,j:int;
			for(i=0 ; i<arrSample.length; i++){
				for(j=0 ; j<arrSample[i].length; j++){
					arrSample[i][j].x = columnX;
					arrSample[i][j].y = columnY;
				}
			}
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
