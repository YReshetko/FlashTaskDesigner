package source.Task.TaskObjects.Line {
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import source.utils.Figure;

	public class OneLine extends Sprite{
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var REMOVE_LINE:String = 'onRemoveLine';
		private var X2:Number;
		private var Y2:Number;
		private var thick:int;
		private var colorLine:uint;
		private var isDelete:Boolean = false;
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		public function OneLine(xml:XMLList, container:Sprite) {
			super();
			super.x = parseFloat(xml.SPRITE_X);
			super.y = parseFloat(xml.SPRITE_Y);
			remContainer = container;
			thick = parseInt(xml.THICK);
			colorLine = uint(xml.COLOR);
			X2 = parseFloat(xml.POINT_X.toString());
			Y2 = parseFloat(xml.POINT_Y.toString());
			container.addChild(super);
			super.addEventListener(MouseEvent.MOUSE_DOWN, LINE_MOUSE_DOWN);
			super.addEventListener(KeyboardEvent.KEY_DOWN, LINE_KEY_DOWN);
			redrawLine();
		}
		public function set select(value:Boolean):void{
			if(isSelect == value) return;
			isSelect = value;
			if(value){
				selectContainer.addChild(super);
				selectContainer.addChild(boundsContainer);
				drawSelect();
			}else{
				boundsContainer.graphics.clear();
				selectContainer.removeChild(boundsContainer);
				remContainer.addChild(super);
			}
		}

		public function get select():Boolean{
			return isSelect;
		}
		public function drawSelect():void{
			boundsContainer.graphics.clear();
			var rect:Rectangle = super.getBounds(super.parent);
			var W:Number = rect.width + 4;
			var H:Number = rect.height + 4;
			Figure.insertCurve(boundsContainer, [[-W/2, -H/2],[W/2, -H/2],[W/2, H/2],[-W/2, H/2],[-W/2, -H/2]], 1, 1, 0x0000FF, 0);
			Figure.insertCircle(boundsContainer, 2.5, 1, 0.1, 0x000000, 1, 0xFFFFFF);
			//blackSelectContainer.rotation = this.blackR*22.5;
			boundsContainer.x = rect.x + W/2;
			boundsContainer.y = rect.y + H/2;
		}
		private function LINE_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.A:
					super.x = super.x - 1;
				break;
				case Keyboard.D:
					super.x = super.x + 1;
				break;
				case Keyboard.W:
					super.y = super.y - 1;
				break;
				case Keyboard.S:
					super.y = super.y + 1;
				break;
				case Keyboard.DELETE:
				isDelete = true;
				super.dispatchEvent(new Event(REMOVE_LINE));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		public function get remove():Boolean{
			return isDelete;
		}
		public function clear():void{
			super.removeEventListener(MouseEvent.MOUSE_DOWN, LINE_MOUSE_DOWN);
			super.removeEventListener(KeyboardEvent.KEY_DOWN, LINE_KEY_DOWN);
			super.graphics.clear();
			super.parent.removeChild(super);
		}
		private function LINE_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, LINE_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function LINE_MOUSE_UP(e:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, LINE_MOUSE_UP);
			super.stopDrag();
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		public function get x1():Number{
			return super.x;
		}
		public function set x1(value:Number):void{
			super.x = value;
			if(isSelect) this.drawSelect();
		}
		public function get y1():Number{
			return super.y;
		}
		public function set y1(value:Number):void{
			super.y = value;
			if(isSelect) this.drawSelect();
		}
		
		public function get x2():Number{
			return X2;
		}
		public function set x2(value:Number):void{
			X2 = value;
			redrawLine();
			if(isSelect) this.drawSelect();
		}
		public function get y2():Number{
			return Y2;
		}
		public function set y2(value:Number):void{
			Y2 = value;
			redrawLine();
			if(isSelect) this.drawSelect();
		}
		public function get thickLine():int{
			return thick;
		}
		public function set thickLine(value:int):void{
			thick = value;
			redrawLine();
			if(isSelect) this.drawSelect();
		}
		public function get color():uint{
			return colorLine;
		}
		public function set color(value:uint):void{
			colorLine = value;
			redrawLine();
		}
		
		private function redrawLine():void{
			super.graphics.clear();
			super.graphics.lineStyle(thick, colorLine);
			super.graphics.moveTo(0,0);
			super.graphics.lineTo(X2, Y2);
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ЛИНИЯ';
			var x1List:XMLList = new XMLList('<FIELD label="x1" type="number" variable="x1" width="40">' + this.x1.toString() + '</FIELD>');
			var y1List:XMLList = new XMLList('<FIELD label="y1" type="number" variable="y1" width="40">' + this.y1.toString() + '</FIELD>');
			
			var x2List:XMLList = new XMLList('<FIELD label="x2" type="number" variable="x2" width="40">' + this.x2.toString() + '</FIELD>');
			var y2List:XMLList = new XMLList('<FIELD label="y2" type="number" variable="y2" width="40">' + this.y2.toString() + '</FIELD>');
			
			var thickList:XMLList = new XMLList('<FIELD label="толщина" type="number" variable="thickLine" width="40">' + this.thickLine.toString() + '</FIELD>');
			
			var blockList:XMLList = new XMLList('<BLOCK label="позиция линии"/>');
			blockList.appendChild(x1List);
			blockList.appendChild(y1List);
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="смещение конечной точки"/>');
			blockList.appendChild(x2List);
			blockList.appendChild(y2List);
			outXml.appendChild(blockList);
			
			
			blockList = new XMLList('<BLOCK label="вид"/>');
			blockList.appendChild(thickList);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="line" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<LINE/>');
			outXml.SPRITE_X = x1;
			outXml.SPRITE_Y = y1;
			outXml.THICK = this.thick;
			outXml.COLOR = this.color;
			outXml.POINT_X = x2;
			outXml.POINT_Y = y2;
			return outXml;
		}
	}
}