package source.BlockOfTask.Task.TaskObjects.BaseTan {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;

	public class BaseLineTan extends BaseTan{
		public static var FIND_POSITION:String = 'onFindPosition';
		public static var SET_COLOR_ON_TAN:String = 'onSetColorOnTan';
		public static var CUT_COMPLATE:String = 'onCutComplate'
		
		private var arrTanDraw:Array;
		
		private var typeColor:int = 1;
		private var typeBlack:int = 1;
		
		private var colorTan:Sprite = new Sprite();
		private var blackTan:Sprite = new Sprite();
		
		private var colorFill:Sprite = new Sprite();
		private var colorLine:Sprite = new Sprite();
		
		private var blackFill:Sprite = new Sprite();
		private var blackLine:Sprite = new Sprite();
		
		private var tanCurrentColor:uint;
		private var tanTrueColor:uint;
		
		private var isPaint:Boolean = false;
		private var isRepaint:Boolean = false;
		
		private var isCleenColor:Boolean = false;
		
		private var arrCutPoint:Array;
		private var arrCutLine:Array;
		private var isCut:Boolean = false;
		private var arrPointPosition:Array;
		private var cutHelp:Boolean = false;
		private var startTColor:int = 1;
		
		private var lineThick:Number = 1;
		private var lineColor:uint = 0x000000;
		
		public function BaseLineTan(colorCont:Sprite, blackCont:Sprite) {
			super();
			
			colorTan.addChild(colorFill);
			colorTan.addChild(colorLine);
			
			blackTan.addChild(blackFill);
			blackTan.addChild(blackLine);
			
			blackCont.addChild(blackTan);
			colorCont.addChild(colorTan);
			
			super.tanColor = colorTan;
			super.tanBlack = blackTan;
			
			super.addEventListener(BaseTan.MOUSE_DISABLED, MOUSE_DISABLED);
			super.addEventListener(BaseTan.START_POSITION, START_POSITION_TAN);
		}
		//	Вращение тана
		private function COLOR_TAN_KEY_DOWN(e:KeyboardEvent):void{
			var num:int;
			//trace(this + ': KEY = ' + e.keyCode);
			switch(e.keyCode){
				case 32:
					if(arrTanDraw.length>1){
						if(typeColor == arrTanDraw.length){
							drawColorTan(arrTanDraw[0]);
							typeColor = 1;
						}else{
							++typeColor;
							drawColorTan(arrTanDraw[typeColor-1]);
						}
						super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
					}
				break;
			}
		}
		public function set arrPoint(value:Array):void{
			arrTanDraw = value;
			if(value.length>1) colorTan.addEventListener(KeyboardEvent.KEY_DOWN, COLOR_TAN_KEY_DOWN);
			drawColorTan(arrTanDraw[0]);
			drawBlackTan(arrTanDraw[0]);
		}
		public function get arrPoint():Array{
			return arrTanDraw;
		}
		public function get isSpace():Boolean{
			if(arrTanDraw.length>1) return true;
			return false;
		}
		public function get arrColorPoint():Array{
			return arrTanDraw[typeColor-1];
		}
		public function get arrBlackPoint():Array{
			return arrTanDraw[typeBlack-1];
		}
		public function set startTypeColor(value:int):void{
			startTColor = value;
		}
		private function START_POSITION_TAN(event:Event):void{
			
			this.typeC = startTColor;
		}
		/*
			ОТРИСОВКА ТАНОВ
		*/
		private function drawColorTan(arrPoint:Array):void{
			colorFill.graphics.clear();
			colorLine.graphics.clear();
			Figure.insertCurve(colorFill, arrPoint, 1, lineThick, color, 1, color);
			Figure.insertCurveWithoutFill(colorLine, arrPoint, 1, lineThick, lineColor);
			
		}
		private function drawBlackTan(arrPoint:Array):void{
			blackFill.graphics.clear();
			blackLine.graphics.clear();
			Figure.insertCurve(blackFill, arrPoint, 1, lineThick, 0x000000, 1, 0x000000);
			Figure.insertCurve(blackLine, arrPoint, 0, lineThick, 0x000000, 0);
			
		}
		public function centring():void{
			colorFill.x = colorLine.x = -colorFill.width/2;
			colorFill.y = colorLine.y = -colorFill.height/2;
			blackFill.x = blackLine.x = -blackLine.width/2;
			blackFill.y = blackLine.y = -blackLine.height/2;
		}
		
		
		public function set colorCleen(value:Boolean):void{
			this.isCleenColor = value;
		}
		public function get color():uint{
			return tanCurrentColor;
		}
		
		private var colorRemoveTimer:Timer;
		public function set color(value:uint):void{
			if(isCleenColor){
				if(colorRemoveTimer!=null){
					colorRemoveTimer.stop();
					if(colorRemoveTimer.hasEventListener(TimerEvent.TIMER)) colorRemoveTimer.removeEventListener(TimerEvent.TIMER, COLOR_REMOVE_TIMER);
				}
				if(super.hasEventListener(Event.ENTER_FRAME)) super.removeEventListener(Event.ENTER_FRAME, CLEEN_COLOR_EF);
			}
			tanCurrentColor = value;
			drawColorTan(arrTanDraw[typeColor-1]);
			if(tanCurrentColor == this.tanTrueColor && this.isPaint) {
				if(super.deleteB){ 
					super.stand = true;
					super.colorTanPaintComplate();
				}
			}
			if(isRepaint){
				if(tanCurrentColor != this.tanTrueColor){
					this.isPaint = true;
					super.stand = false;
				}
			}
			if(isCleenColor){
				if(tanCurrentColor != this.tanTrueColor){
					colorRemoveTimer = new Timer(1000, 1);
					colorRemoveTimer.addEventListener(TimerEvent.TIMER, COLOR_REMOVE_TIMER);
					colorRemoveTimer.start();
					
				}
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
			
		}
		private function COLOR_REMOVE_TIMER(event:TimerEvent):void{
			super.addEventListener(Event.ENTER_FRAME, CLEEN_COLOR_EF);
		}
		private function CLEEN_COLOR_EF(event:Event):void{
			var currentColor:ColorTransform = new ColorTransform();
			currentColor.color = tanCurrentColor;
			var grayColor:ColorTransform = new ColorTransform();
			grayColor.color = 0x696969;
			var resultColor:ColorTransform = new ColorTransform();
			if((grayColor.blueOffset - currentColor.blueOffset)>10)resultColor.blueOffset = Math.round(currentColor.blueOffset + (grayColor.blueOffset - currentColor.blueOffset)/21);
			else resultColor.blueOffset = grayColor.blueOffset;
			
			if((grayColor.greenOffset - currentColor.greenOffset)>10)resultColor.greenOffset = Math.round(currentColor.greenOffset + (grayColor.greenOffset - currentColor.greenOffset)/21);
			else resultColor.greenOffset = grayColor.greenOffset;
			
			if((grayColor.redOffset - currentColor.redOffset)>10)resultColor.redOffset = Math.round(currentColor.redOffset + (grayColor.redOffset - currentColor.redOffset)/21);
			else resultColor.redOffset = grayColor.redOffset;
			
			tanCurrentColor = resultColor.color;
			drawColorTan(arrTanDraw[typeColor-1]);
			if(resultColor.color == grayColor.color) super.removeEventListener(Event.ENTER_FRAME, CLEEN_COLOR_EF);
		}
		public function get animationColor():uint{
			return tanCurrentColor;
		}
		public function set animationColor(value:uint):void{
			tanCurrentColor = value;
			drawColorTan(arrTanDraw[typeColor-1]);
		}
		
		
		public function get paint():Boolean{
			return isPaint;
		}
		public function paintTan(time:int = 0):void{
			isPaint = true;
			isRepaint = true;
			tanTrueColor = color;
			super.stand = false;
			super.dragEvent = false;
			if(time==0||time==1){
				TIMER_COMPLATE(null);
			}else{
				var timer:Timer = new Timer(time*1000,1);
				timer.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
				timer.start();
			}
		}
		private function TIMER_COMPLATE(e:TimerEvent):void{
			color = 0x696969;
			colorTan.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_TAN_PAINT);
		}
		private function COLOR_TAN_PAINT(e:MouseEvent):void{
			super.dispatchEvent(new Event(SET_COLOR_ON_TAN));
		}
		public function isPaintComplate():Boolean{
			return tanTrueColor == this.color;
		}
		public function endPaint():void{
			if(!isCut){
				isPaint = false;
				colorTan.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_TAN_PAINT);
				if(super.deleteB) super.stand = true;
				else super.dragEvent = true;
			}
		}
		
		
		
		
		public function set line(value:Boolean):void{
			colorLine.visible = value;
		}
		public function set fill(value:Boolean):void{
			if(!value) colorFill.alpha = 0;
		}
		
		public function set alphaBGBlack(value:Boolean):void{
			blackFill.visible = !value;
		}
		
		
		public function set image(value:Bitmap):void{
			colorTan.addChild(value);
			value.x = -value.width/2;
			value.y = -value.height/2;
			colorTan.setChildIndex(value, 0);
			value.mask = this.colorFill;
			trace(this + ': BITMAP = ' + value);
		}
		
		/*
			РАЗРЕЗАНИЕ
		*/
		
		public function cutTan(inArray:Array, help:Boolean = false, isUserTan:Boolean = false, isScale:Boolean = false):void{
			trace(this + ': START CUT');
			super.stand = false;
			super.dragEvent = false;
			isCut = true;
			cutHelp = help;
			blackTan.mouseChildren = true;
			var i:int;
			var l:int = inArray[typeBlack-1].length;
			arrPointPosition = inArray;
			trace(arrPointPosition);
			arrCutPoint = new Array();
			arrCutLine = new Array();
			for(i=0;i<l;i++){
				arrCutPoint.push(new CutPoint());
				arrCutLine.push(false);
				blackTan.addChild(arrCutPoint[i]);
				trace(this + ' PUSH NEW POINT');
				if(isUserTan){
					arrCutPoint[i].x = arrPointPosition[typeBlack-1][i][0];
					arrCutPoint[i].y = arrPointPosition[typeBlack-1][i][1];
				}else{
					arrCutPoint[i].x = arrPointPosition[typeBlack-1][i][0]-blackFill.width/2;
					arrCutPoint[i].y = arrPointPosition[typeBlack-1][i][1]-blackFill.height/2;
				}
				if(isScale){
					arrCutPoint[i].scaleX = 0.4;
					arrCutPoint[i].scaleY = 0.4;
				}
				trace(this + ' POSITION POINT');
				arrCutPoint[i].addEventListener(CutPoint.POINT_SELECT, POINT_SELECT);
				trace(this + ' LISTENER POINT');
			}
			blackTan.addEventListener(MouseEvent.MOUSE_OVER, CUT_HELP_MOUSE_OVER);
			blackTan.addEventListener(MouseEvent.MOUSE_OUT, CUT_HELP_MOUSE_OUT);
		}
		private function CUT_HELP_MOUSE_OVER(e:MouseEvent):void{
			blackTan.parent.setChildIndex(blackTan, blackTan.parent.numChildren-1);
			if(cutHelp) blackFill.alpha = 0.3;
		}
		private function CUT_HELP_MOUSE_OUT(e:MouseEvent):void{
			if(cutHelp) blackFill.alpha = 1;
		}
		private function POINT_SELECT(e:Event):void{
			e.target.select = !e.target.select;
			var firstID:int = -9;
			var secondID:int = -9;
			var numSelect:int = 0;
			var i:int;
			var l:int = arrCutPoint.length;
			for(i=0;i<l;i++){
				if(arrCutPoint[i].select) {
					++numSelect;
					switch(numSelect){
						case 0:
						break;
						case 1:
						firstID = i;
						break;
						case 2:
						secondID = i;
						break;
						default:
						removeAllSelect();
						return;
					}
				}
			}
			trace(this + ': POINT 1');
			if((firstID+1) == secondID || (firstID == 0 && secondID == (l-1))){
				drawCutLine(firstID, secondID);
				trace(this + ': POINT 1.1');
				if(secondID == (l-1) && firstID == 0){
					arrCutLine[secondID] = true;
				}else{
					arrCutLine[firstID] = true;
				}
				trace(this + ': POINT 1.2');
				checkCut();
				trace(this + ': POINT 1.3');
				removeAllSelect();
				trace(this + ': POINT 1.4');
				return;
			}
			trace(this + ': POINT 2');
			if(firstID >= 0 && secondID >= 0){
				removeAllSelect();
			}
		}
		private function removeAllSelect():void{
			var i:int;
			var l:int = arrCutPoint.length;
			for(i=0;i<l;i++){
				arrCutPoint[i].select = false;
			}
		}
		private function drawCutLine(ind1:int, ind2:int):void{
			var X1:Number = arrPointPosition[typeBlack-1][ind1][0];
			var Y1:Number = arrPointPosition[typeBlack-1][ind1][1];
			var X2:Number = arrPointPosition[typeBlack-1][ind2][0];
			var Y2:Number = arrPointPosition[typeBlack-1][ind2][1];
			Figure.insertLine(blackLine, X1, Y1, X2, Y2, 1, 2, 0xFFFFFF);
			
		}
		private function checkCut():void{
			var i:int;
			var l:int = arrCutLine.length;
			for(i=0;i<l;i++){
				if(!arrCutLine[i]) return;
			}
			clearCutPoint();
		}
		private function clearCutPoint():void{
			isCut = false;
			var i:int;
			var l:int = arrCutPoint.length;
			for(i=0;i<l;i++){
				arrCutPoint[i].removeEventListener(CutPoint.POINT_SELECT, POINT_SELECT);
				blackTan.removeChild(arrCutPoint[i]);
			}
			CUT_HELP_MOUSE_OUT(null);
			blackTan.removeEventListener(MouseEvent.MOUSE_OVER, CUT_HELP_MOUSE_OVER);
			blackTan.removeEventListener(MouseEvent.MOUSE_OUT, CUT_HELP_MOUSE_OUT);
			super.dispatchEvent(new Event(CUT_COMPLATE));
		}
		public function get cut():Boolean{
			return isCut;
		}
		public function endCut():void{
			if(!isPaint){
				if(!super.stand) super.dragEvent = true;
				if(!colorTan.visible) super.stand = true;
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}

		public function set tanLineThick(value:Number):void{
			this.lineThick = value;
			drawBlackTan(arrTanDraw[typeBlack-1]);
			drawColorTan(arrTanDraw[typeColor-1]);
		}
		public function get tanLineThick():Number{
			return this.lineThick;
		}
		public function set tanLineColor(value:uint):void{
			this.lineColor = value;
			drawBlackTan(arrTanDraw[typeBlack-1]);
			drawColorTan(arrTanDraw[typeColor-1]);
		}
		public function get tanLineColor():uint{
			return this.lineColor;
		}

		/*
			ТИП ТАНОВ (ПЕРЕВОРОТ ПО ПРОБЕЛУ)
		*/
		public function set typeC(value:int):void{
			typeColor = value;
			drawColorTan(arrTanDraw[typeColor-1]);
		}
		public function get typeC():int{
			return typeColor;
		}
		public function set typeB(value:int):void{
			typeBlack = value;
			drawBlackTan(arrTanDraw[typeBlack-1]);
			if(isCut){
				clearCutPoint();
				cutTan(arrPointPosition, cutHelp);
			}
		}
		public function get typeB():int{
			return typeBlack;
		}
		private function MOUSE_DISABLED(e:Event):void{
			if(isPaint) colorTan.mouseEnabled = true;
		}
	}
	
}
