package source.BlockOfTask.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import source.MainPlayer;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class AnsLabel extends Sprite{
		public static var FALSE_SELECT:String = 'onFolseSelect';
		private var field:TextField = new TextField();
		private var defaultText:String = 'НЕТ';
		private var defClass:int = 0;
		private var trueContainer:PlaceForMark;
		private var falseContainer:PlaceForMark;
		public function AnsLabel(container:Sprite, inXml:XMLList) {
			super();
			container.addChild(super);
			initField();
			this.setPosition(parseFloat(inXml.X), parseFloat(inXml.Y));
			this.isClass = parseInt(inXml.@numClass);
			this.color = uint(inXml.COLOR);
			this.textColor = uint(inXml.TEXTCOLOR);
			this.text = inXml.TEXT;
			if(inXml.MARK.toString()!=''){
				var W:Number = parseFloat(inXml.MARK.WIDTH);
				var H:Number = parseFloat(inXml.MARK.HEIGHT);
				trueContainer = new PlaceForMark(W, H);
				falseContainer = new PlaceForMark(W, H);
				super.addChild(trueContainer);
				super.addChild(falseContainer);
				trueContainer.x = parseFloat(inXml.MARK.TRUE_X);
				trueContainer.y = parseFloat(inXml.MARK.TRUE_Y);
				
				falseContainer.x = parseFloat(inXml.MARK.FALSE_X);
				falseContainer.y = parseFloat(inXml.MARK.FALSE_Y);
				
				trueContainer.variant = true;
				falseContainer.variant = false;
			}
		}
		public function setPosition(X:Number, Y:Number):void{
			super.x = X;
			super.y = Y;
		}
		private function initField():void{
			var format:TextFormat = new TextFormat();
			format.align = 'center';
			format.size = 50;
			field.autoSize = TextFieldAutoSize.CENTER;
			field.background = true;
			field.defaultTextFormat = format;
			super.addChild(field);
			field.mouseEnabled = false;
			super.addEventListener(MouseEvent.MOUSE_DOWN, ON_MOUSE_DOWN);
		}
		
		private function ON_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(FALSE_SELECT));
			super.removeEventListener(MouseEvent.MOUSE_DOWN, ON_MOUSE_DOWN);
			var timer:Timer = new Timer(1500, 1);
			timer.addEventListener(TimerEvent.TIMER, ON_TIMER);
			timer.start();
		}
		private function ON_TIMER(e:TimerEvent):void{
			super.addEventListener(MouseEvent.MOUSE_DOWN, ON_MOUSE_DOWN);
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
		public function set answer(value:Boolean):void{
			if(value){
				trueContainer.putAns();
			}else{
				falseContainer.putAns();
			}
		}
		
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ОБЛАСТЬ СРАВНЕНИЯ';
			var widthList:XMLList = new XMLList('<FIELD label="надпись" type="string" variable="text" width="100"><![CDATA[' + this.text + ']]></FIELD>');
			
			var blockList:XMLList = new XMLList('<BLOCK label="подпись области клика"/>');
			blockList.appendChild(widthList);
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
			return outXml;
		}
	}
	
}
