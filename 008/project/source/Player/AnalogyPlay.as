package source.Player {
	import flash.display.Sprite;
	import flash.xml.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import source.Player.Objects.*;
	import flash.utils.ByteArray;

	public class AnalogyPlay {
		private static var _W:int = 730;
		private static var _H:int = 494;
		private var objectSprite:Sprite = new Sprite;
		private var Greed:Sprite = new Sprite;
		private var overSprite:Sprite = new Sprite;
		private var TopLeft:Array = new Array;
		private var TopRight:Array = new Array;
		private var BootLeft:Array = new Array;
		private var BootRight:Array = new Array;
		private var deltaX:Number;
		private var deltaY:Number;
		private var GlobalID:int = -1;
		
		private var arrContent:Array;
		public function AnalogyPlay(spr:Sprite) {
			spr.addChild(objectSprite);
			spr.addChild(Greed);
			spr.addChild(overSprite);
		}
		public function setParametrs(path:String, ParamXML:XMLList, content:Array){
			arrContent = content;
			Greed.graphics.lineStyle(2,0x000000);
			drawFrame(0,0,parseInt(ParamXML.COLCOUNT), parseInt(ParamXML.ROWCOUNT), TopL, TopLeft);
			drawFrame((_W+5)/2,0,parseInt(ParamXML.COLCOUNT), parseInt(ParamXML.ROWCOUNT), TopR, TopRight);
			drawFrame(0,(_H+5)/2,parseInt(ParamXML.COLCOUNT), parseInt(ParamXML.ROWCOUNT), BootL, BootLeft);
			drawFrame((_W+5)/2,(_H+5)/2,parseInt(ParamXML.COLCOUNT), parseInt(ParamXML.ROWCOUNT), BootR, BootRight);
			LoadRightImages(path, ParamXML.TOPRIGHT);
			LoadLeftImages(path, ParamXML.BUTLEFT);
			Transposition(ParamXML.TRANSPOSITION.split(","));
			EventListeners();
		}
		private function drawFrame(_X:int, _Y:int, ColCount:int, RowCount:int, CLS:Object, arr:Array){
			trace("Analogy: DRAW GREED")
			Greed.graphics.drawRect(_X,_Y,(_W-5)/2, (_H-5)/2);
			Greed.graphics.moveTo(_X,_Y+20);
			Greed.graphics.lineTo(_X+(_W-5)/2, _Y+20);
			var i,j:int;
			deltaX = ((_W-5)/2)/ColCount;
			deltaY = ((_H-5)/2-20)/RowCount;
			var arrX:Array = new Array;
			var arrY:Array = new Array;
			for(i=1;i<ColCount;i++){
				Greed.graphics.moveTo(_X+deltaX*i,_Y+20);
				Greed.graphics.lineTo(_X+deltaX*i,_Y+(_H-5)/2);
				arrX.push(_X+deltaX*(i-1));
			}
			arrX.push(_X+deltaX*(ColCount-1));
			for(i=1;i<RowCount;i++){
				Greed.graphics.moveTo(_X,(_Y+20)+deltaY*i);
				Greed.graphics.lineTo(_X+(_W-5)/2,(_Y+20)+deltaY*i);
				arrY.push((_Y+20)+deltaY*(i-1));
			}
			arrY.push((_Y+20)+deltaY*(RowCount-1));
			var ID:int;
			//trace("arrX = "+arrX);
			//trace("arrY = "+arrY);
			for(i=0;i<ColCount;i++){
				for(j=0;j<RowCount;j++){
					ID = arr.length;
					arr.push(new CLS(deltaX, deltaY, ID));
					objectSprite.addChild(arr[ID]);
					arr[ID].x = arrX[i];
					arr[ID].y = arrY[j];
				}
			}
		}
		private function getImage(name:String):ByteArray{
			var i,l:int;
			l = arrContent.length;
			for(i=0;i<l;i++){
				if(name == arrContent[i].name){
					return arrContent[i].byteArray;
				}
			}
			return null;
		}
		private function LoadRightImages(path:String, ParamXML:XMLList){
			//trace(ParamXML.IMG.(@id == 2));
			var i:int
			for(i=0;i<TopRight.length;i++){
				if(ParamXML.IMG.(@id == i)!="null"){
					TopRight[i].loadContent(getImage(ParamXML.IMG.(@id == i)));
				}
			}
		}
		private function LoadLeftImages(path:String, ParamXML:XMLList){
			//trace(ParamXML.IMG.(@id == 2));
			var i:int
			for(i=0;i<BootLeft.length;i++){
				if(ParamXML.IMG.(@id == i)!="null"){
					BootLeft[i].loadContent(getImage(ParamXML.IMG.(@id == i)));
				}
			}
		}
		private function Transposition(arr:Array){
			var i:int;
			for(i=0;i<arr.length;i++){
				if(arr[i]!=-1){
					TopLeft[arr[i]].setSprite(BootLeft[i].getSpriteIMG());
				}
				BootRight[i].setTargetID(arr[i]);
			}
		}
		private function EventListeners(){
			var i:int;
			for(i=0;i<TopRight.length;i++){
				TopRight[i].setDragMethod(START_DRAG, STOP_DRAG);
			}
		}
		public function START_DRAG(_id:int,e:MouseEvent){
			GlobalID = _id;
			var i:int;
			for(i=0;i<BootRight.length;i++){
				if(BootRight[i].getTargetedID() == GlobalID){
					BootRight[i].setTargetedID(-1);
				}
			}
			var LocalPoint:Point = new Point(e.localX, e.localY);
			var GlobalPoint:Point = e.target.localToGlobal(LocalPoint);
			TopRight[GlobalID].getFuncSprite().x = GlobalPoint.x-deltaX/2;
			TopRight[GlobalID].getFuncSprite().y = GlobalPoint.y-deltaY/2;
			overSprite.addChild(TopRight[GlobalID].getFuncSprite());
			TopRight[GlobalID].getFuncSprite().startDrag();
			
		}
		public function STOP_DRAG(_id:int){
			GlobalID = -1;
			TopRight[_id].getFuncSprite().stopDrag();
			var i:int;
			var flag:Boolean = true;
			for(i=0;i<BootRight.length;i++){
				if(Math.abs(TopRight[_id].getFuncSprite().x-BootRight[i].x)<deltaX/2&&
					Math.abs(TopRight[_id].getFuncSprite().y-BootRight[i].y)<deltaY/2&&
					BootRight[i].getTargetedID()==-1){
					BootRight[i].setSprite(TopRight[_id].getFuncSprite());
					BootRight[i].setTargetedID(_id);
					flag = false;
				}
			}
			if(flag){
				TopRight[_id].setSprite();
			}
			trace("ОТВЕТ = "+getAswer())
		}
		public function getAswer():Boolean{
			var i:int;
			var flag:Boolean = true;
			for(i=0;i<BootRight.length;i++){
				trace("BootRight["+i+"] = "+BootRight[i].Asced());
				if(!BootRight[i].Asced()){
					flag = false;
				}
			}
			return flag;
		}
	}
	
}