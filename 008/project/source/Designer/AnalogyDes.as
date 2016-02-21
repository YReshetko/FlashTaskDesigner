package source.Designer {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TextEvent;
	import flash.utils.Timer;
	import source.Designer.Instrument.*;
	public class AnalogyDes {
		private var PanelSett;
		private static var _W:int = 730;
		private static var _H:int = 494;
		private var GlobalX:int;
		private var GlobalY:int;
		private var GlobalPoint;
		private var TargetID:int;
		private var TIMER:Timer = new Timer(10);
		private var TextTIMER:Timer = new Timer(10,1);
		private var Greed:Sprite = new Sprite;
		private var ObjSprite:Sprite = new Sprite;
		private var OverSprite:Sprite = new Sprite;
		private var TopLeft:Array = new Array;
		private var TopRight:Array = new Array;
		private var BootLeft:Array = new Array;
		private var BootRight:Array = new Array;
		public function AnalogyDes(spr:Sprite) { 
			PanelSett = new PanelSettingsModul();
			PanelSett.Col.text = 3;
			PanelSett.Row.text = 4;
			PanelSett.Col.restrict = "0-9";
			PanelSett.Row.restrict = "0-9";
			drawGreed(3,4);
			spr.addChild(ObjSprite);
			spr.addChild(Greed);
			spr.addChild(PanelSett);
			PanelSett.x = _W/2;
			spr.addChild(OverSprite);
			
			TIMER.addEventListener(TimerEvent.TIMER, TIMER_EVENT);
			TextTIMER.addEventListener(TimerEvent.TIMER, TextTIMER_EVENT);
			PanelSett.Col.addEventListener(TextEvent.TEXT_INPUT, TextINPUT);
			PanelSett.Row.addEventListener(TextEvent.TEXT_INPUT, TextINPUT);
		}
		private function drawGreed(ColCount:int, RowCount:int){
			Greed.graphics.clear();
			OverSprite.graphics.clear();
			Greed.graphics.lineStyle(2,0x000000);
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
				//trace(BootRight[i].getID());
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
		private function TextINPUT(e:TextEvent){
			TextTIMER.start();
		}
		private function TextTIMER_EVENT(e:TimerEvent){
			var COL:int = parseInt(PanelSett.Col.text);
			var ROW:int = parseInt(PanelSett.Row.text);
			if(COL>15){
				COL = 15;
			}
			if(COL<1){
				COL = 1;
			}
			if(ROW>15){
				ROW = 15;
			}
			if(ROW<1){
				ROW = 1;
			}
			clearArray();
			drawGreed(COL,ROW);
			PanelSett.Col.text = COL.toString();
			PanelSett.Row.text = ROW.toString();
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
			s = '<COLCOUNT>'+PanelSett.Col.text+'</COLCOUNT>';
			s += '\r\n<ROWCOUNT>'+PanelSett.Row.text+'</ROWCOUNT>';
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
	}
}