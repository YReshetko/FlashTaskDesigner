package source.BlockOfTask.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import source.BlockOfTask.Task.Animation.ObjectAnimation;
	import source.MainPlayer;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class OneTable extends Sprite {
		public static var FRAME_SELECT:String = 'onFrameSelect';
		
		public static var RIGHT_SELECT:String = 'onRightSelect';
		public static var DIFF_COMPLATE:String = 'onDiffComplate';
		public static var FALSE_SELECT:String = 'onFalseSelect';
		
		private var STAGE:Stage;
		
		private var arrRasst:Array = new Array;
		private var entarArea:Boolean = false;
		private var arrSample:Array;
		
		private var wTable:Number;
		private var hTable:Number;
		private var xTable:Number;
		private var yTable:Number;
		private var tTable:Number;
		private var tColor:uint;
		private var numLine:Number;
		private var numColumn:Number;
		private var adhereDifferences:Boolean = false;
		private var classDifferences:int = 0;
		private var classHelp:Boolean = false;
		
		private var complate:Boolean = true;
		
		private var objectAnimation:ObjectAnimation;
		
		private var frameSelect:Boolean = false;
		public function OneTable(xml:XMLList, container:Sprite) { 
			super();
			STAGE = MainPlayer.STAGE;
			container.addChild(super);
			var i:int;
			var j:int;
			var thick:int;
			var X:Number;
			var Y:Number;
			var W:Number;
			var H:Number;
			var color:uint;
			xTable = X = parseFloat(xml.X);
			yTable = Y = parseFloat(xml.Y);
			wTable = W = parseFloat(xml.WIDTH);
			hTable = H = parseFloat(xml.HEIGHT);
			if(xml.THICK.toString() != '')tTable = thick = parseInt(xml.THICK);
			else thick = 2;
			if(xml.COLOR.toString() != '')tColor = color = uint(xml.COLOR);
			else color = 0x000000;
			numLine = parseInt(xml.LINE);
			if(numLine<1) numLine = 1;
			numColumn = parseInt(xml.COLUMN);
			if(numColumn<1) numColumn = 1;
			super.graphics.lineStyle(thick, color);
			
			crRamka(super, X ,Y, W, H);
			crStroki(super, X, Y, W, H, numLine);
			crStolbci(super, X, Y, W, H, numColumn);
			
			if(xml.ENTERAREA.toString() == 'true'){
				trace(this + ': TABLE IS ENTER AREA');
				entarArea = true;
				for(i=0;i<numColumn;i++){
					for(j=0;j<numLine;j++){
						arrRasst[arrRasst.length] = new Array;
						arrRasst[arrRasst.length-1][0] = X+i*W/numColumn;
						arrRasst[arrRasst.length-1][1] = Y+j*H/numLine;
						arrRasst[arrRasst.length-1][2] = X+(i+1)*W/numColumn;
						arrRasst[arrRasst.length-1][3] = Y+(j+1)*H/numLine;
					}
				}
			}
			if(xml.DIFF.toString()!=''){
				complate = false;
				this.isAdhere = true;
				this.isClass = parseInt(xml.DIFF.NUMCLASS);
				this.isHelp = xml.DIFF.HELP.toString() == 'true';
			}
			if(xml.ANIMATION.@step.toString()!=''){
				this.setListAnimation(xml.ANIMATION);
			}
			
			if(xml.FRAME.toString()!='') if(xml.FRAME.toString() == 'true') createFrame();
		}
		private function crRamka(tab:Object,_X:Number,_Y:Number,_W:Number,_H:Number):void{
			tab.graphics.moveTo(_X,_Y);
			tab.graphics.lineTo(_X+_W,_Y);
			tab.graphics.lineTo(_X+_W,_Y+_H);
			tab.graphics.lineTo(_X,_Y+_H);
			tab.graphics.lineTo(_X,_Y);
		}
		private function crStroki(tab:Object,_X:Number,_Y:Number,_W:Number,_H:Number,_Str:int):void{
			for(var i:int=1;i<_Str;i++){
				tab.graphics.moveTo(_X,_Y+((_H/_Str)*i));
				tab.graphics.lineTo(_X+_W,_Y+((_H/_Str)*i));
			}
		}
		private function crStolbci(tab:Object,_X:Number,_Y:Number,_W:Number,_H:Number,_Stl:int):void{
			for(var i:int=1;i<_Stl;i++){
				tab.graphics.moveTo(_X+((_W/_Stl)*i),_Y);
				tab.graphics.lineTo(_X+((_W/_Stl)*i),_Y+_H);
			}
		}
		public function get area():Boolean{
			return entarArea;
		}
		public function get arrArea():Array{
			return arrRasst;
		}
		
		
		// Новые возможности для отличий
		public function set isAdhere(value:Boolean):void{
			adhereDifferences = value;
			if(!value) return;
			var W:Number = wTable/numColumn - tTable;
			var H:Number = hTable/numLine - tTable;
			arrSample = new Array();
			var i:int;
			var j:int;
			var ID:int;
			for(i=0;i<numLine;i++){
				for(j=0;j<numColumn;j++){
					ID = arrSample.length;
					arrSample.push(new TablePlane(W, H));
					super.addChild(arrSample[ID]);
					arrSample[ID].x = xTable + j*(W+tTable) + tTable/2;
					arrSample[ID].y = yTable + i*(H+tTable) + tTable/2;
					arrSample[ID].ID = ID;
				}
			}
		}
		public function get isAdhere():Boolean{
			return adhereDifferences;
		}
		public function set isClass(value:int):void{
			classDifferences = value;
		}
		public function get isClass():int{
			return classDifferences;
		}
		public function set isHelp(value:Boolean):void{
			classHelp = value;
		}
		public function get isHelp():Boolean{
			return classHelp;
		}
		
		public function set markPosition(inArr:Array):void{
			trace(this + ': IN MARK POSITION = ' + inArr)
			if(inArr == null) return;
			var i:Number;
			var j:Number;
			var l:Number;
			var k:Number;
			l = arrSample.length;
			k = inArr.length;
			for(i=0;i<k;i++){
				for(j=0;j<l;j++){ //trace(this + ': FIND POSITION');
					if(inArr[i][0]>arrSample[j].x && inArr[i][0]<arrSample[j].x+arrSample[j].width &&
					   inArr[i][1]>arrSample[j].y && inArr[i][1]<arrSample[j].y+arrSample[j].height){
						   trace(this + ': FIND POSITION');
						   arrSample[j].isTrue = true;
						//   trace(this + ': SET');
					   }
				}
			}
		}
		public function startDiff():void{
			arrSample[0].select = true;
			arrSample[0].addEventListener(TablePlane.SELECT_PLANE, PLANE_SELECT);
		}
		public function get currentBool():Boolean{
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if(arrSample[i].select){
					return arrSample[i].isTrue;
				}
			}
			return false;
		}
		public function get rectangle():Rectangle{
			var outRect:Rectangle = new Rectangle();
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if(arrSample[i].select){
					outRect.x = arrSample[i].x;
					outRect.y = arrSample[i].y;
					outRect.width = arrSample[i].width;
					outRect.height = arrSample[i].height;
					return outRect;
				}
			}
			return outRect;
		}
		
		public function nextSample():void{
			var i:int;
			var j:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if(arrSample[i].select){
					arrSample[i].removeEventListener(TablePlane.SELECT_PLANE, PLANE_SELECT);
					var timer:Timer = new Timer(1500, 1);
					timer.addEventListener(TimerEvent.TIMER, ON_TIMER);
					timer.start();
					return;
				}
			}
		}
		public function nextFalseSample():void{
			var i:int;
			var j:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if(arrSample[i].select){
					arrSample[i].removeEventListener(TablePlane.SELECT_PLANE, PLANE_SELECT);
					ON_TIMER()
					return;
				}
			}
		}
		private function ON_TIMER(e:TimerEvent = null):void{
			var i:int;
			var j:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if(arrSample[i].select){
					arrSample[i].select = false;
					
					if(i<l-1){
						arrSample[i+1].select = true;
						arrSample[i+1].addEventListener(TablePlane.SELECT_PLANE, PLANE_SELECT);
					}else{
						//	Завершение выполнения
						trace(this + ': COMPLATE');
						complate = true;
						while(arrSample.length>0){
							super.removeChild(arrSample[0]);
							arrSample.shift();
						}
						super.dispatchEvent(new Event(DIFF_COMPLATE));
					}
					return;
				}
			}
		}
		public function set animationColor(value:uint):void{
			super.graphics.clear();
			tColor = value;
			super.graphics.lineStyle(this.tTable, tColor);
			crRamka(super, this.xTable, this.yTable, this.wTable, this.hTable);
			crStroki(super, this.xTable, this.yTable, this.wTable, this.hTable, this.numLine);
			crStolbci(super, this.xTable, this.yTable, this.wTable, this.hTable, this.numColumn);
		}
		public function get animationColor():uint{
			return tColor;
		}
		public function setListAnimation(value:XMLList):void{
			objectAnimation = new ObjectAnimation(super.parent as Sprite, super);
			objectAnimation.objectClass = this;
			objectAnimation.listPosition = value;
		}
		private function PLANE_SELECT(e:Event):void{
			trace(this + ': IS SELECT');
			if(e.target.isTrue){
				trace(this + ': IS TRUE');
				super.dispatchEvent(new Event(RIGHT_SELECT));
			}else{
				super.dispatchEvent(new Event(FALSE_SELECT));
			}
		}
		public function get isComplate():Boolean{
			return this.complate;
		}
		
		
		
		private var arrFrameReplace:Array;
		private var tableFrame:TableFrame;
		private function createFrame():void{
			var w:Number = wTable/numColumn;
			var h:Number = hTable/numLine;
			arrFrameReplace = new Array();
			var i:int;
			var j:int;
			var lineArr:Array
			for(i=0;i<numLine;i++){
				lineArr = new Array();
				for(j=0;j<numColumn;j++){
					lineArr.push({'x':xTable+(j*w), 'y':yTable+(i*h)});
				}
				arrFrameReplace.push(lineArr);
			}
			tableFrame = new TableFrame(w, h);
			super.addChild(tableFrame);
			tableFrame.x = arrFrameReplace[0][0].x;
			tableFrame.y = arrFrameReplace[0][0].y;
			
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, FRAME_KEY_DOWN);
		}
		private function FRAME_KEY_DOWN(event:KeyboardEvent):void{
			var currentPosition:Object = idFrame;
			trace(this + ' isFrame = ' + currentPosition);
			if(currentPosition==null) return;
			trace(this + ' not return');
			var w:Number = arrFrameReplace[0].length;
			var h:Number = arrFrameReplace.length;
			var movePosition:Object = new Object();
			//left
			if(currentPosition.j!=0){
				movePosition.left = [currentPosition.i, currentPosition.j-1];
			}else{
				if(currentPosition.i!=0){
					movePosition.left = [currentPosition.i-1, w-1];
				}else{
					movePosition.left = [h-1, w-1];
				}
			}
			//right
			if(currentPosition.j!=w-1){
				movePosition.right = [currentPosition.i, currentPosition.j+1];
			}else{
				if(currentPosition.i!=h-1){
					movePosition.right = [currentPosition.i+1, 0];
				}else{
					movePosition.right = [0, 0];
				}
			}
			//up
			if(currentPosition.i!=0){
				movePosition.up = [currentPosition.i-1, currentPosition.j];
			}else{
				if(currentPosition.j!=0){
					movePosition.up = [h-1, currentPosition.j-1];
				}else{
					movePosition.up = [h-1, w-1];
				}
			}
			//down
			if(currentPosition.i!=h-1){
				movePosition.down = [currentPosition.i+1, currentPosition.j];
			}else{
				if(currentPosition.j!=w-1){
					movePosition.down = [0, currentPosition.j+1];
				}else{
					movePosition.down = [0, 0];
				}
			}
			
			var str:String = '';
			switch(event.keyCode){
				case Keyboard.LEFT:
					str = 'left';
				break;
				case Keyboard.RIGHT:
					str = 'right';	
				break;
				case Keyboard.UP:
					str = 'up';
				break;
				case Keyboard.DOWN:
					str = 'down';
				break;
				case Keyboard.ENTER:
					super.dispatchEvent(new Event(FRAME_SELECT));
				break;
				case Keyboard.SPACE:
					super.dispatchEvent(new Event(FRAME_SELECT));
				break;
			}
			if(str == '') return;
			tableFrame.x = arrFrameReplace[movePosition[str][0]][movePosition[str][1]].x;
			tableFrame.y = arrFrameReplace[movePosition[str][0]][movePosition[str][1]].y;
		}
		private function get idFrame():Object{
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			l = arrFrameReplace.length;
			k = arrFrameReplace[0].length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(Math.abs(tableFrame.x - arrFrameReplace[i][j].x)<2 && Math.abs(tableFrame.y - arrFrameReplace[i][j].y)<2){
						return {'i':i, 'j':j};
					}
				}
			}
			return null;
		}
		
		public function get areaSelect():Rectangle{
			var rect:Rectangle = new Rectangle(tableFrame.x, tableFrame.y, tableFrame.width, tableFrame.height);
			return rect;
		}
	}
}