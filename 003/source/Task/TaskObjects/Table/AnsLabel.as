package source.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	import source.utils.Figure;
	
	public class AnsLabel extends Sprite{
		public static var GET_SETTINGS:String = 'onGetSettings';
		private var field:TextField = new TextField();
		private var defaultText:String = 'НЕТ';
		private var defClass:int = 0;
		
		private var wMarkCont:int = 150;
		private var hMarkCont:int = 50;
		private var trueMark:Sprite = new Sprite();
		private var falseMark:Sprite = new Sprite();
		private var shirma:Sprite = new Sprite();
		
		private var isDrag:Boolean = false;
		
		public function AnsLabel(container:Sprite, numClass:int) {
			super();
			super.addChild(trueMark);
			super.addChild(falseMark);
			container.addChild(super);
			initField();
			initContainers();
			isClass = numClass;
			color = 0x09F7A3;
			super.addChild(trueMark);
			super.addChild(falseMark);
		}
		private function initContainers():void{
			drawMark();
			trueMark.addEventListener(MouseEvent.MOUSE_DOWN, TRUE_MOUSE_DOWN);
			falseMark.addEventListener(MouseEvent.MOUSE_DOWN, FALSE_MOUSE_DOWN);
		}
		private function TRUE_MOUSE_DOWN(e:MouseEvent):void{
			trueMark.startDrag();
			isDrag = true;
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, ON_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function FALSE_MOUSE_DOWN(e:MouseEvent):void{
			falseMark.startDrag();
			isDrag = true;
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, ON_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		public function setPosition(X:Number, Y:Number):void{
			super.x = X;
			super.y = Y;
		}
		private function initField():void{
			super.addChild(field);
			super.addChild(shirma);
			
			var format:TextFormat = new TextFormat();
			format.align = 'center';
			format.size = 50;
			field.autoSize = TextFieldAutoSize.CENTER;
			field.background = true;
			field.defaultTextFormat = format;
			this.text = defaultText;
			
			shirma.alpha = 0;
			field.mouseEnabled = false;
			shirma.addEventListener(MouseEvent.MOUSE_DOWN, ON_MOUSE_DOWN);
		}
		private function ON_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, ON_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function ON_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, ON_MOUSE_UP);
		}
		public function set isClass(value:int):void{
			defClass = value;
		}
		public function get isClass():int{
			return defClass;
		}
		public function set text(value:String):void{
			defaultText = value;
			field.text = defaultText;
			field.x = field.y = 0;
			Figure.insertRect(shirma, field.width, field.height);
			shirma.x = shirma.y = 0;
			drawMark();
		}
		public function get text():String{
			return defaultText;
		}
		public function set color(value:uint):void{
			field.backgroundColor = value;
		}
		public function get color():uint{
			return field.backgroundColor;
		}
		public function set textColor(value:uint):void{
			field.textColor = value;
		}
		public function get textColor():uint{
			return field.textColor;
		}
		override public function set width(value:Number):void{
			wMarkCont = value;
			drawMark();
		}
		override public function get width():Number{
			return wMarkCont;
		}
		override public function set height(value:Number):void{
			hMarkCont = value;
			drawMark();
		}
		override public function get height():Number{
			return hMarkCont;
		}
		public function set markSettings(value:XMLList):void{
			trueMark.x = parseFloat(value.TRUE_X);
			trueMark.y = parseFloat(value.TRUE_Y);
			falseMark.x = parseFloat(value.FALSE_X);
			falseMark.y = parseFloat(value.FALSE_Y);
			wMarkCont = parseFloat(value.WIDTH);
			hMarkCont = parseFloat(value.HEIGHT);
			isDrag = true;
			drawMark();
		}
		private function drawMark():void{
			Figure.insertRect(trueMark, wMarkCont, hMarkCont, 1, 1, 0x000000, 1, 0x00FF00);
			Figure.insertRect(falseMark, wMarkCont, hMarkCont, 1, 1, 0x000000, 1, 0xFF0000);
			if(!isDrag){
				trueMark.x = -trueMark.width;
				falseMark.x = field.width;
			}
		}
		
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ОБЛАСТЬ СРАВНЕНИЯ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40"><![CDATA[' + this.width.toString() + ']]></FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40"><![CDATA[' + this.height.toString() + ']]></FIELD>');
			var blockList:XMLList = new XMLList('<BLOCK label="размер областей отметок"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);			
			
			
			var labelList:XMLList = new XMLList('<FIELD label="надпись" type="string" variable="text" width="100"><![CDATA[' + this.text + ']]></FIELD>');
			blockList = new XMLList('<BLOCK label="подпись области клика"/>');
			blockList.appendChild(labelList);
			outXml.appendChild(blockList);			
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="color">' + this.color.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="text" variable="textColor">' + this.textColor.toString() + '</COLOR>'));
			return outXml;
		}
		public function clear():void{
			super.removeEventListener(MouseEvent.MOUSE_DOWN, ON_MOUSE_DOWN);
			super.parent.removeChild(super);
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<TABLEDIF/>');
			outXml.@numClass = this.isClass;
			outXml.X = super.x;
			outXml.Y = super.y;
			outXml.COLOR = '0x'+this.color.toString(16);
			outXml.TEXTCOLOR = '0x'+this.textColor.toString(16);
			outXml.appendChild(new XML('<TEXT><![CDATA['+this.text+']]></TEXT>'));
			outXml.MARK.TRUE_X = trueMark.x;
			outXml.MARK.TRUE_Y = trueMark.y;
			outXml.MARK.FALSE_X = falseMark.x;
			outXml.MARK.FALSE_Y = falseMark.y;
			outXml.MARK.WIDTH = this.width;
			outXml.MARK.HEIGHT = this.height;
			return outXml;
		}
	}
	
}
