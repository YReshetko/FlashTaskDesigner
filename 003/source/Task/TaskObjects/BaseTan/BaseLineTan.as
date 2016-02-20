package source.Task.TaskObjects.BaseTan {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.display.Bitmap;
	import source.utils.ContextClass.MyMenu;
	import flash.events.ContextMenuEvent;
	import source.Task.TaskSystem;

	public class BaseLineTan extends BaseTan{
		public static var SET_COLOR_ON_TAN:String = 'onSetColorOnTan';
		
		public static var CHANGE_DEPTH_OVER_ALL:String = 'onChangeDepthOverAll';
		public static var CHANGE_DEPTH_OVER_ONE:String = 'onChangeDepthOverOne';
		public static var CHANGE_DEPTH_UNDER_ALL:String = 'onChangeDepthUnderAll';
		public static var CHANGE_DEPTH_UNDER_ONE:String = 'onChangeDepthUnderOne';
		
		private var arrTanDraw:Array;
		
		private var typeColor:int = 1;
		private var typeBlack:int = 1;
		
		private var symmetry:int = 1;
		
		private var colorTan:Sprite = new Sprite();
		private var blackTan:Sprite = new Sprite();
		
		private var colorFill:Sprite = new Sprite();
		private var colorLine:Sprite = new Sprite();
		
		private var blackFill:Sprite = new Sprite();
		private var blackLine:Sprite = new Sprite();
		
		private var tanCurrentColor:uint;
		
		private var isPaint:Boolean = false;
		private var isCut:Boolean = false;
		private var cHelp:Boolean = false;
		
		private var isCleenColor:Boolean = false
		
		private var pTime:int = 0;
		
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
			super.animationClass = this;
			super.dragEvent = true;
			new MyMenu(colorTan, ['Редактировать', 'Поверх всех', 'Поднять на 1', 'Опустить на 1', 'Ниже всех'], [editColorTan, overAll, overOne, underOne, underAll]);
			new MyMenu(blackTan, ['Редактировать'], [editBlackTan]);
		}
		public function editColorTan(event:ContextMenuEvent):void{
			trace(this + ': EDIT THIS TAN');
			TaskSystem.paintPanel.setOutFigure({'points':arrTanDraw[typeColor-1], 'x':colorTan.x, 'y':colorTan.y, 'rotation':super.colorR});
		}
		public function overAll(event:ContextMenuEvent):void{
			var depth:int = colorTan.parent.numChildren-1;
			colorTan.parent.setChildIndex(colorTan, depth);
			super.dispatchEvent(new Event(CHANGE_DEPTH_OVER_ALL));
		}
		public function overOne(event:ContextMenuEvent):void{
			var depth:int = colorTan.parent.getChildIndex(colorTan)+1;
			colorTan.parent.setChildIndex(colorTan, depth);
			super.dispatchEvent(new Event(CHANGE_DEPTH_OVER_ONE));
		}
		public function underOne(event:ContextMenuEvent):void{
			var depth:int = colorTan.parent.getChildIndex(colorTan)-1;
			colorTan.parent.setChildIndex(colorTan, depth);
			super.dispatchEvent(new Event(CHANGE_DEPTH_UNDER_ONE));
		}
		public function underAll(event:ContextMenuEvent):void{
			var depth:int = 0;
			colorTan.parent.setChildIndex(colorTan, depth);
			super.dispatchEvent(new Event(CHANGE_DEPTH_UNDER_ALL));
		}
		public function editBlackTan(event:ContextMenuEvent):void{
			trace(this + ': EDIT THIS TAN');
			TaskSystem.paintPanel.setOutFigure({'points':arrTanDraw[typeBlack-1], 'x':blackTan.x, 'y':blackTan.y, 'rotation':super.blackR});
		}
		
		override public function clear():void{
			super.clear();
			if(this.arrTanDraw.length>1) {
				colorTan.removeEventListener(KeyboardEvent.KEY_DOWN, COLOR_TAN_KEY_DOWN);
				blackTan.removeEventListener(KeyboardEvent.KEY_DOWN, BLACK_TAN_KEY_DOWN);
			}
			colorTan.removeChild(colorFill);
			colorTan.removeChild(colorLine);
			
			blackTan.removeChild(blackFill);
			blackTan.removeChild(blackLine);
			
			blackTan.parent.removeChild(blackTan);
			colorTan.parent.removeChild(colorTan);
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
					}
				break;
			}
		}
		private function BLACK_TAN_KEY_DOWN(e:KeyboardEvent):void{
			var num:int;
			//trace(this + ': KEY = ' + e.keyCode);
			switch(e.keyCode){
				case 32:
					if(arrTanDraw.length>1){
						if(typeBlack == arrTanDraw.length){
							drawBlackTan(arrTanDraw[0]);
							typeBlack = 1;
						}else{
							++typeBlack;
							drawBlackTan(arrTanDraw[typeBlack-1]);
						}
					}
				break;
			}
		}
		public function set arrPoint(value:Array):void{
			//trace(this + ': length new array = ' + value.length);
			if(arrTanDraw!=null){
				while(arrTanDraw.length>0) {
					arrTanDraw.shift();
				}
			}
			arrTanDraw = null;
			arrTanDraw = value;
			/*for(var i:int = 0; i<value.length; i++){
				trace(this + ' arr = ' + value[i]);
			}*/
			if(value.length>1) {
				colorTan.addEventListener(KeyboardEvent.KEY_DOWN, COLOR_TAN_KEY_DOWN);
				blackTan.addEventListener(KeyboardEvent.KEY_DOWN, BLACK_TAN_KEY_DOWN);
			}
			drawColorTan(arrTanDraw[0]);
			drawBlackTan(arrTanDraw[0]);
		}
		public function get arrPoint():Array{
			return arrTanDraw;
		}
		public function get arrColorPoint():Array{
			return arrTanDraw[typeColor-1];
		}
		public function get arrBlackPoint():Array{
			return arrTanDraw[typeBlack-1];
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
		
		
		
		public function get color():uint{
			return tanCurrentColor;
		}
		public function set color(value:uint):void{
			tanCurrentColor = value;
			drawColorTan(arrTanDraw[typeColor-1]);
			//super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get paint():Boolean{
			return isPaint;
		}
		public function set paint(value:Boolean):void{
			isPaint = value;
		}
		public function get paintTime():int{
			return pTime;
		}
		public function set paintTime(value:int):void{
			pTime = value;
		}
		public function set line(value:Boolean):void{
			colorLine.visible = value;
		}
		public function get line():Boolean{
			return colorLine.visible;
		}
		public function set fill(value:Boolean):void{
			if(!value) colorFill.alpha = 0;
			else colorFill.alpha = 1;
		}
		public function get fill():Boolean{
			if(colorFill.alpha == 0) return false;
			return true;
		}
		public function set alphaBGBlack(value:Boolean):void{
			blackFill.visible = !value;
		}
		public function get alphaBGBlack():Boolean{
			return !blackFill.visible;
		}
		public function set alphaLineBlack(value:Boolean):void{
			this.blackLine.visible = value;
		}
		public function get alphaLineBlack():Boolean{
			return this.blackLine.visible
		}
		
		
		/*
			РАЗРЕЗАНИЕ
		*/
		
		public function get cut():Boolean{
			return isCut;
		}
		public function set cut(value:Boolean):void{
			isCut = value;
		}
		public function get cutHelp():Boolean{
			return cHelp;
		}
		public function set cutHelp(value:Boolean):void{
			cHelp = value;
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
			ТИП ТАНОВ (ПЕРЕВОРОТ ПО ПРОБЕЛУ)
		*/
		public function set typeC(value:int):void{
			typeColor = value;
			trace(this + ': CURRENT COLOR ARRAY = ' + arrTanDraw[typeColor-1])
			drawColorTan(arrTanDraw[typeColor-1]);
		}
		public function get typeC():int{
			return typeColor;
		}
		public function set typeB(value:int):void{
			typeBlack = value;
			trace(this + ': CURRENT BLACK ARRAY = ' + arrTanDraw[typeBlack-1])
			drawBlackTan(arrTanDraw[typeBlack-1]);
		}
		public function get typeB():int{
			return typeBlack;
		}
		
		public function set isSymmetryTan(value:Number):void{
			symmetry = value;
		}
		public function get isSymmetryTan():Number{
			return symmetry;
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
		
		public function get cleenColor():Boolean{
			return isCleenColor;
		}
		public function set cleenColor(value:Boolean):void{
			isCleenColor = value;
		}
		
		public function get listLineSettings():XMLList{
			var outXml:XMLList = super.baseSettings;
			var fillList:XMLList = new XMLList('<MARK label="Прозрачность фона цветного" variable="fill">'+this.fill.toString()+'</MARK>');
			var lineList:XMLList = new XMLList('<MARK label="Прозрачность линии цветного" variable="line">'+this.line.toString()+'</MARK>');
			var alphaBGBlackList:XMLList = new XMLList('<MARK label="Прозрачность фона чёрного" variable="alphaBGBlack">'+this.alphaBGBlack.toString()+'</MARK>');
			var alphaLineBlackList:XMLList = new XMLList('<MARK label="Прозрачность линий чёрного" variable="alphaLineBlack">'+this.alphaLineBlack.toString()+'</MARK>');
			var paintList:XMLList = new XMLList('<MARK label="Раскрашивание" variable="paint">'+this.paint.toString()+'</MARK>');
			var cleenColorList:XMLList = new XMLList('<MARK label="Стирать если неверно" variable="cleenColor">'+this.cleenColor.toString()+'</MARK>');
			var cutList:XMLList = new XMLList('<MARK label="Разрезание" variable="cut">'+this.cut.toString()+'</MARK>');
			outXml.BLOCK.(@label == 'прозрачность').appendChild(alphaBGBlackList);
			outXml.BLOCK.(@label == 'прозрачность').appendChild(alphaLineBlackList);
			outXml.BLOCK.(@label == 'прозрачность').appendChild(fillList);
			outXml.BLOCK.(@label == 'прозрачность').appendChild(lineList);
			var blockList:XMLList = new XMLList('<BLOCK label="действия над танами"/>');
			blockList.appendChild(paintList);
			blockList.appendChild(cleenColorList);
			blockList.appendChild(cutList);
			outXml.appendChild(blockList);
			
			var lineThickList:XMLList = new XMLList('<FIELD label="толщина линии" type="number" variable="tanLineThick" width="40">' + this.tanLineThick.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="линия тана"/>');
			blockList.appendChild(lineThickList);
			outXml.appendChild(blockList);
			
			var isSymmetryList:XMLList = new XMLList('<FIELD label="симметричность" type="number" variable="isSymmetryTan" width="40">' + this.isSymmetryTan.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="Симметричность тана"/>');
			blockList.appendChild(isSymmetryList);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="color">' + this.color.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="line" variable="tanLineColor">' + this.tanLineColor.toString() + '</COLOR>'));
			
			return outXml;
		}
	}
	
}
