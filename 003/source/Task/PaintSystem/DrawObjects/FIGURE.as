package source.Task.PaintSystem.DrawObjects {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import source.utils.ContextClass.MyMenu;
	import flash.events.ContextMenuEvent;
	
	public class FIGURE extends Sprite{
		private static const cosBeta:Number = Math.cos(Math.PI/8);
		private static const sinBeta:Number = Math.sin(Math.PI/8);
		
		public static var DELETE_FIGURE:String = 'onDeleteFigure';
		public static var FIGURE_EDIT:String = 'onEditFigure';
		private var color:uint = 0xEEEEEE;
		private var pointArray:Array;
		private var isPrint:Boolean = false;
		private var printRect:Rectangle;
		public function FIGURE(inArray:Array) {
			pointArray = inArray;
			pointArray[0][2] = NaN;
			pointArray[0][3] = NaN;
			super();
			Figure.insertCurve(super, pointArray, 1, 2, 0x000000, 1, color);
			pointArray = inArray;
			super.addEventListener(MouseEvent.MOUSE_DOWN, FIGURE_MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_UP, FIGURE_MOUSE_UP);
			super.addEventListener(KeyboardEvent.KEY_DOWN, FIGURE_REMOVE);
			super.tabEnabled = true;
			super.tabChildren = false;
			new MyMenu(super, ['Редактировать'], [EDIT_FIGURE]);
		}
		public function clear():void{
			super.removeEventListener(MouseEvent.MOUSE_DOWN, FIGURE_MOUSE_DOWN);
			super.removeEventListener(MouseEvent.MOUSE_UP, FIGURE_MOUSE_UP);
			super.removeEventListener(KeyboardEvent.KEY_DOWN, FIGURE_REMOVE);
			while(super.numChildren>0){
				super.removeChildAt(0);
			}
			printRect = null;
			pointArray = null;
		}
		private function FIGURE_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			super.parent.setChildIndex(super, super.parent.numChildren-1);
		}
		private function FIGURE_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
		}
		private function FIGURE_REMOVE(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.DELETE) super.dispatchEvent(new Event(DELETE_FIGURE));
			if(event.keyCode == Keyboard.LEFT) changeFigure('left');
			if(event.keyCode == Keyboard.RIGHT) changeFigure('right');
			if(event.keyCode == Keyboard.PAGE_DOWN) changeFigure('dec');
			if(event.keyCode == Keyboard.PAGE_UP) changeFigure('inc');
		}
		public function setImage(rect:Rectangle, bmp:Bitmap):void{
			isPrint = true;
			printRect = rect;
			super.addChild(bmp);
			bmp.x = -rect.width/2;
			bmp.y = -rect.height/2;
			var spr:Sprite = new Sprite();
			Figure.insertCurve(spr, pointArray, 1, 2, 0x000000, 1, color);
			super.addChild(spr);
			bmp.mask = spr;
		}
		public function get settingsList():XMLList{
			var outXml:XMLList = new XMLList('<FIGURE/>');
			var additionalXml:XMLList;
			var flag:Boolean = this.checkType();
			if(flag) outXml.@type = 'curve';
			else outXml.@type = 'line';
			var pointXml:XMLList = new XMLList('<POINTS/>');
			var i:int;
			var l:int;
			l = pointArray.length;
			for(i=0;i<l;i++){
				additionalXml = new XMLList('<POINT/>');
				additionalXml.@id = i;
				additionalXml.@x = pointArray[i][0];
				additionalXml.@y = pointArray[i][1];
				if(i!=0 && flag){
					additionalXml.@anchorX = pointArray[i][2];
					additionalXml.@anchorY = pointArray[i][3];
				}
				pointXml.appendChild(additionalXml);
			}
			outXml.appendChild(pointXml);
			var colorXml:XMLList = new XMLList('<COLOR/>');
			colorXml.X = super.x;
			colorXml.Y = super.y;
			colorXml.R = 0;
			colorXml.COLOR = '0x'+color.toString(16);
			outXml.appendChild(colorXml);
			var blackXml:XMLList = new XMLList('<BLACK/>');
			blackXml.X = super.x;
			blackXml.Y = super.y;
			blackXml.R = 0;
			outXml.appendChild(blackXml);
			if(isPrint){
				additionalXml = new XMLList('<IMAGE/>');
				additionalXml.@x = printRect.x;
				additionalXml.@y = printRect.y;
				additionalXml.@width = printRect.width;
				additionalXml.@height = printRect.height;
				outXml.appendChild(additionalXml);
			}
			return outXml;
		}
		private function checkType():Boolean{
			var i:int;
			var l:int;
			l = pointArray.length;
			for(i=1;i<l;i++){
				if(Math.abs(pointArray[i][2]-(pointArray[i-1][0] + (pointArray[i][0] - pointArray[i-1][0])/2))>3||
				   Math.abs(pointArray[i][3]-(pointArray[i-1][1] + (pointArray[i][1] - pointArray[i-1][1])/2))>3){
					   return true;
				   }
			}
			return false;
		}
		public function EDIT_FIGURE(event:ContextMenuEvent):void{
			super.dispatchEvent(new Event(FIGURE_EDIT));
		}
		public function get points():Array{
			return pointArray;
		}
		
		private function changeFigure(type:String):void{
			var currentMethod:Function;
			if(type == 'inc' || type == 'dec') currentMethod = resizeFigure;
			if(type == 'left' || type == 'right') currentMethod = rotationFigure;
			while(super.numChildren>0){
				super.removeChildAt(0);
			}
			printRect = null;
			isPrint = false
			var obj:Object;
			var r:Number = Math.sqrt(pointArray[0][0]*pointArray[0][0] + pointArray[0][1]*pointArray[0][1]);
			var proportion:Number = 1;
			if(type == 'inc') proportion = r/(r+5);
			if(type == 'dec') proportion = r/(r-5);
			obj = currentMethod(pointArray[0][0], pointArray[0][1], type, proportion);
			pointArray[0][0] = obj.X;
			pointArray[0][1] = obj.Y;
			var i:int;
			var l:int;
			l = pointArray.length;
			for(i=1;i<l;i++){
				obj = currentMethod(pointArray[i][0], pointArray[i][1], type, proportion);
				pointArray[i][0] = obj.X;
				pointArray[i][1] = obj.Y;
				obj = currentMethod(pointArray[i][2], pointArray[i][3], type, proportion);
				pointArray[i][2] = obj.X;
				pointArray[i][3] = obj.Y;
			}
			var inArray:Array = pointArray;
			inArray[0][2] = NaN;
			inArray[0][3] = NaN;
			super.graphics.clear();
			Figure.insertCurve(super, inArray, 1, 2, 0x000000, 1, color);
		}
		private function resizeFigure(X:Number, Y:Number, type:String, proportion:Number):Object{
			var r:Number = Math.sqrt(X*X+Y*Y);
			var cosAlpha:Number = X/r;
			var sinAlpha:Number = Y/r;
			r = r/proportion;
			return {'X':r*cosAlpha, 'Y':r*sinAlpha};
		}
		private function rotationFigure(X:Number, Y:Number, type:String, proportion:Number):Object{
			var r:Number = Math.sqrt(X*X+Y*Y);
			var cosAlpha:Number = X/r;
			var sinAlpha:Number = Y/r;
			var sinResult:Number;
			var cosResult:Number;
			if(type == 'left'){
				sinResult = sinAlpha*cosBeta + cosAlpha*sinBeta;
				cosResult = cosAlpha*cosBeta - sinAlpha*sinBeta;
			}
			if(type == 'right'){
				sinResult = sinAlpha*cosBeta - cosAlpha*sinBeta;
				cosResult = cosAlpha*cosBeta + sinAlpha*sinBeta;
			}
			return {'X':r*cosResult, 'Y':r*sinResult};
		}
	}
	
}
