package source.Designer {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
	import flash.display.Graphics;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TextEvent;
import flash.net.URLLoader;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.utils.Timer;
	import source.Designer.Instrument.*;
	public class AnalogyDes extends EventDispatcher{
		//private var PanelSett;
		private static var _W:int = 730;
		private static var _H:int = 494;
		private var GlobalX:int;
		private var GlobalY:int;
		private var GlobalPoint;
		private var TargetID:int;
		private var TIMER:Timer = new Timer(10);
		private var Greed:Sprite = new Sprite;
		private var ObjSprite:Sprite = new Sprite;
		private var OverSprite:Sprite = new Sprite;
		private var TopLeft:Array = new Array;
		private var TopRight:Array = new Array;
		private var BootLeft:Array = new Array;
		private var BootRight:Array = new Array;
        private var loadedXML:XMLList;

        private var arrContent:Array;

        private var _columns:int = 3;
        private var _lines = 4;
		public function AnalogyDes(spr:Sprite) {
			drawGreed(_columns,_lines);
			spr.addChild(ObjSprite);
			spr.addChild(Greed);
			spr.addChild(OverSprite);
			
			TIMER.addEventListener(TimerEvent.TIMER, TIMER_EVENT);
		}

        public function setParametrs(ParamXML:XMLList, content:Array){
            arrContent = content;
            loadedXML = ParamXML;
            _columns = parseInt(ParamXML.COLCOUNT);
            _lines = parseInt(ParamXML.ROWCOUNT);
            drawGreed(_columns, _lines);
            loadImagesCollection();
        }

        private function LoadRightImages(ParamXML:XMLList){
            //trace(ParamXML.IMG.(@id == 2));
            var i:int
            for(i=0;i<TopRight.length;i++){
                if(ParamXML.IMG.(@id == i)!="null"){
                    TopRight[i].LoadContent(getImage(ParamXML.IMG.(@id == i)), ParamXML.IMG.(@id == i));
                }
            }
        }
        private function LoadLeftImages(ParamXML:XMLList){
            //trace(ParamXML.IMG.(@id == 2));
            var i:int
            for(i=0;i<BootLeft.length;i++){
                if(ParamXML.IMG.(@id == i)!="null"){
                    BootLeft[i].LoadContent(getImage(ParamXML.IMG.(@id == i)), ParamXML.IMG.(@id == i));
                }
            }
        }
        private function Transposition(arr:Array){
            var i:int;
            for(i=0;i<arr.length;i++){
                if(arr[i]!=-1){
                    TopLeft[arr[i]].setContent(BootLeft[i].BitmapCopy());
                }
                BootRight[i].setContent(arr[i], TopRight[arr[i]].BitmapCopy());
                //BootRight[i].setTargetID(arr[i]);
            }
        }
        private function getImage(name:String):BitmapData{
            var i,l:int;
            l = bitmapArray.length;
            for(i=0;i<l;i++){
                if(name == bitmapArray[i].name){
                    return bitmapArray[i].bitmap;
                }
            }
            return null;
        }

        private var currentFileName:String = "";
        private var currentIndex:int = 0;
        private var bitmapArray:Array;
        private function loadImagesCollection(){
            currentFileName = "";
            currentIndex = 0;
            bitmapArray = new Array();
            processLoadingImages();
        }
        private function processLoadingImages():void{
            if(currentIndex < arrContent.length){
                currentFileName = arrContent[currentIndex][0];
                var loader:Loader = new Loader();
                var context:LoaderContext = new LoaderContext();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, IMAGE_LOAD_COMPLATE);
                loader.loadBytes(arrContent[currentIndex][1], context);
            }else{
                trace(this + " loaded imagex = " + bitmapArray.length);
                LoadRightImages(loadedXML.TOPRIGHT);
                LoadLeftImages(loadedXML.BUTLEFT);
                Transposition(loadedXML.TRANSPOSITION.split(","));
            }
        }
        private function IMAGE_LOAD_COMPLATE(e:Event):void{
            var value:Bitmap = e.target.content;
            bitmapArray.push({
                name : currentFileName,
                bitmap : value.bitmapData
            });
            ++currentIndex;
            processLoadingImages();
        }


		private function drawGreed(ColCount:int, RowCount:int){
			Greed.graphics.clear();
			OverSprite.graphics.clear();
			Greed.graphics.lineStyle(2,0x000000);
            clearArray();
			drawFrame(0,0,ColCount,RowCount, SimpleObj, TopLeft);
			drawFrame((_W+5)/2,0,ColCount,RowCount, LoadLineObj, TopRight);
			drawFrame(0,(_H+5)/2,ColCount,RowCount, LoadObj, BootLeft);
			drawFrame((_W+5)/2,(_H+5)/2,ColCount,RowCount, LineObj, BootRight);
			EventListeners();
		}

		private function drawFrame(_X:int, _Y:int, ColCount:int, RowCount:int, CLS:Object, arr:Array){
			Greed.graphics.drawRect(_X,_Y,(_W-5)/2, (_H-5)/2);
			Greed.graphics.moveTo(_X,_Y+20);
			Greed.graphics.lineTo(_X+(_W-5)/2, _Y+20);
			var i,j:int;
			var deltaX:Number = ((_W-5)/2)/ColCount;
			var deltaY:Number = ((_H-5)/2-20)/RowCount;
			var arrX:Array = new Array();
			var arrY:Array = new Array();
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
			for(i=0;i<ColCount;i++){
				for(j=0;j<RowCount;j++){
					ID = arr.length;
					arr.push(new CLS(deltaX, deltaY, ID));
					ObjSprite.addChild(arr[ID]);
					arr[ID].x = arrX[i];
					arr[ID].y = arrY[j];
				}
			}
		}
		private function EventListeners(){
			var i:int;
			for(i=0;i<TopRight.length;i++){
				TopRight[i].startFunction(POINT_OVER, POINT_OUT);
				BootRight[i].selectObject(BootRightSelect);
			}
		}
		public function POINT_OVER(_id:int, POINT){
			trace(_id);
			GlobalX = TopRight[_id].x + TopRight[_id].width/2;
			GlobalY = TopRight[_id].y + TopRight[_id].height/2;
			GlobalPoint = POINT;
			TIMER.start();
			OverSprite.addChild(POINT);
			POINT.startDrag(true);
			var i:int;
			for(i=0;i<BootRight.length;i++){
				if(BootRight[i].getID() == _id){
					BootRight[i].clearContent();
					TopLeft[_id].clearContent();
				}
			}
		}
		public function POINT_OUT(_id:int, POINT){
			POINT.stopDrag();
			TIMER.stop();
			TopRight[_id].setPoint();
			if(TargetID>-1){
				trace("Loading");
				BootRight[TargetID].clearContent();
				BootRight[TargetID].setContent(_id, TopRight[_id].BitmapCopy());
				drawLine(GlobalX, GlobalY, BootRight[TargetID].x + BootRight[TargetID].width/2, BootRight[TargetID].y + BootRight[TargetID].height/2);
				if(BootLeft[TargetID].getContent()){
					TopLeft[_id].setContent(BootLeft[TargetID].BitmapCopy());
				}else{
					BootLeft[TargetID].LoadContent(TopRight[_id].BitmapCopy(), TopRight[_id].getFileName());
					TopLeft[_id].setContent(BootLeft[TargetID].BitmapCopy());
				}
			}else{
				OverSprite.graphics.clear();
			}
		}
		private function TIMER_EVENT(e:TimerEvent){
			drawLine(GlobalX, GlobalY, GlobalPoint.x, GlobalPoint.y);
			var i:int;
			TargetID = -1;
			for(i=0;i<BootRight.length;i++){
				if(getHitTest(BootRight[i])){
					BootRight[i].greenColor();
					TargetID = i;
				}else{
					BootRight[i].greyColor();
				}
			}
		}
		public function BootRightSelect(_id:int, _target_id:int){
			if(_target_id!=-1){
				drawLine(TopRight[_target_id].x + TopRight[_target_id].width/2, TopRight[_target_id].y + TopRight[_target_id].height/2, BootRight[_id].x + BootRight[_id].width/2, BootRight[_id].y + BootRight[_id].height/2);
				//trace(getSettings());
			}
		}
		private function drawLine(x1,y1,x2,y2){
			OverSprite.graphics.clear();
			OverSprite.graphics.lineStyle(2,0xff0000);
			OverSprite.graphics.moveTo(x1, y1);
			OverSprite.graphics.lineTo(x2, y2);
		}
		private function getHitTest(obj):Boolean{
			var flag:Boolean = false;
			if(GlobalPoint.x > obj.x && GlobalPoint.x < obj.x+obj.width &&
				GlobalPoint.y > obj.y && GlobalPoint.y < obj.y+obj.height){
				flag = true;
			}else{
				flag = false;
			}
			return flag;
		}

        public function set columns(value:int):void{
            _columns = value;
            drawGreed(_columns,_lines);
        }
        public function get columns():int{
            return _columns;
        }

        public function set lines(value:int):void{
            _lines = value;
            drawGreed(_columns,_lines);
        }
        public function get lines():int{
            return _lines;
        }
		public function clearArray(){
			var i:int;
			for(i=0;i<TopRight.length;i++){
				TopLeft[i].clearContent();
				TopRight[i].clearContent();
				BootLeft[i].clearContent();
				BootRight[i].clearContent();
			}
			while(TopRight.length>0){
				ObjSprite.removeChild(TopLeft[0]);
				ObjSprite.removeChild(TopRight[0]);
				ObjSprite.removeChild(BootLeft[0]);
				ObjSprite.removeChild(BootRight[0]);
				TopRight.shift();
				TopLeft.shift();
				BootLeft.shift();
				BootRight.shift();
			}
		}
		public function getSettings():String{
			var s:String = new String;
			var i:int;
			trace(this + ': Start Getting Modul Settings');
            s = '<COLCOUNT>'+_columns+'</COLCOUNT>';
			s += '\r\n<ROWCOUNT>'+_lines+'</ROWCOUNT>';
			s += '\r\n<BUTLEFT>';
			trace(this + ': Stap 1 - Complate');
			for(i=0;i<BootLeft.length;i++){
				if(BootLeft[i].getFileName()!="" && BootRight[i].getID()!=-1){
					s+='\r\n\t\t<IMG id="'+i+'">'+BootLeft[i].getFileName()+'</IMG>';
				}else{
					s+='\r\n\t\t<IMG id="'+i+'">null</IMG>';
				}
			}
			trace(this + ': Stap 2 - Complate');
			s += '\r\n</BUTLEFT>\r\n<TOPRIGHT>';
			for(i=0;i<TopRight.length;i++){
				if(TopRight[i].getFileName()!="" ){
					s+='\r\n\t\t<IMG id="'+i+'">'+TopRight[i].getFileName()+'</IMG>';
				}else{
					s+='\r\n\t\t<IMG id="'+i+'">null</IMG>';
				}
			}
			trace(this + ': Stap 3 - Complate');
			s += '\r\n</TOPRIGHT>\r\n<TRANSPOSITION>\r\n';
			for(i=0;i<BootRight.length-1;i++){
				s += BootRight[i].getID()+',';
			}
			s += BootRight[BootRight.length-1].getID()+'\r\n</TRANSPOSITION>';
			trace(this + ': Complate Getting Modul Settings');
			return s;
		}
        public function get listSettings():XMLList{
            var outXml:XMLList = new XMLList('<PACKAGE/>');
            outXml.@label = 'МОДУЛЬ АНАЛОГИЯ';
            var columnsList:XMLList = new XMLList('<FIELD label="столбцов" type="number" variable="columns" width="40">' + this.columns.toString() + '</FIELD>');
            var linesList:XMLList = new XMLList('<FIELD label="строк" type="number" variable="lines" width="40">' + this.lines.toString() + '</FIELD>');

            var blockList:XMLList = new XMLList('<BLOCK label="ячейки"/>');
            blockList.appendChild(columnsList);
            blockList.appendChild(linesList);
            outXml.appendChild(blockList);
            return outXml;
        }
	}
}