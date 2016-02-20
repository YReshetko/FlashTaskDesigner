package source.Task.TaskObjects.CheckBox {
	import source.Task.TaskObjects.CheckBox.BoxType.ClassicBox;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import source.Task.TaskObjects.CheckBox.BoxType.TextBox;
	import source.Task.TaskObjects.CheckBox.BoxType.RoundBox;
	import flash.text.TextFormat;
	
	
	public class OneBox extends Sprite{
		public static var DRAG_UP:String = 'onDragUp';
		public static var DRAG_DOWN:String = 'onDragDown';
		public static var DRAG_LEFT:String = 'onDragLeft';
		public static var DRAG_RIGHT:String = 'onDragRight';
		public static var DELETE:String = 'onDelete';
		public static var START_DRAG:String = 'onStartDrag';
		public static var STOP_DRAG:String = 'onStopDrag';
		public static var BOX_SELECT:String = 'onBoxSelect';
		public static var COPY_BOX:String = 'onCopyBox';
		
		private var currentType:String = 'text';
		private var currentBox:*;
		private var fieldFormat:FieldFormat;
		public function OneBox(value:FieldFormat) {
			super();
			fieldFormat = value;
			boxType = currentType;
			super.addEventListener(MouseEvent.MOUSE_DOWN, BOX_MOUSE_DOWN);
		}
		public function set settings(xml:XML):void{
			if(xml.SELECT.toString()!='') this.select = (xml.SELECT.toString()=='true');
			if(xml.TYPE.toString()!='') this.boxType = xml.TYPE.toString();
			if(xml.TEXT.toString()) currentBox.text = xml.TEXT.toString();
			currentBox.correctFieldSize();
			trace(this + 'SET SETTINGS');
			this.applyFormat();
		}
		public function correctSize():void{
			currentBox.correctFieldSize();
		}
		public function set boxType(value:String):void{
			currentType = value;
			var str:String = '';
			var flag:Boolean = false;
			try{
				super.removeChild(currentBox)
				str = currentBox.text
				flag = currentBox.select;
				currentBox = null;
				
			}catch(error:Error){}
			switch(value){
				case 'classic':
					currentBox = new ClassicBox();
				break;
				case 'round':
					currentBox = new RoundBox();
				break;
				case 'image':
				break;
				case 'text':
					currentBox = new TextBox();
				break;
			}
			currentBox.text = str;
			currentBox.select = flag;
			super.addChild(currentBox);
			applyFormat();
		}
		public function get boxType():String{
			return currentType;
		}
		public function close():void{
			currentBox.close();
		}
		private function BOX_MOUSE_DOWN(event:MouseEvent):void{
			if(!currentBox.isClose()) return;
			super.addEventListener(KeyboardEvent.KEY_DOWN, BOX_KEY_DOWN);
			super.addEventListener(MouseEvent.MOUSE_MOVE, BOX_MOUSE_MOVE);
			super.addEventListener(MouseEvent.MOUSE_UP, BOX_MOUSE_UP);
		}
		private function BOX_MOUSE_MOVE(event:MouseEvent):void{
			super.removeEventListener(MouseEvent.MOUSE_UP, BOX_MOUSE_UP);
			super.removeEventListener(MouseEvent.MOUSE_MOVE, BOX_MOUSE_MOVE);
			super.addEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
			super.dispatchEvent(new Event(START_DRAG));
		}
		private function DRAG_MOUSE_UP(event:MouseEvent):void{
			super.removeEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
			super.dispatchEvent(new Event(STOP_DRAG));
		}
		private function BOX_MOUSE_UP(event:MouseEvent):void{
			currentBox.select = !currentBox.select;
			super.dispatchEvent(new Event(BOX_SELECT));
			super.removeEventListener(MouseEvent.MOUSE_UP, BOX_MOUSE_UP);
			super.removeEventListener(MouseEvent.MOUSE_MOVE, BOX_MOUSE_MOVE);
		}
		private function BOX_KEY_DOWN(event:KeyboardEvent):void{
			if(!currentBox.isClose()) return;
			switch(event.keyCode){
				case Keyboard.W:
					super.dispatchEvent(new Event(DRAG_UP));
				break;
				case Keyboard.A:
					super.dispatchEvent(new Event(DRAG_LEFT));
				break;
				case Keyboard.S:
					super.dispatchEvent(new Event(DRAG_DOWN));
				break;
				case Keyboard.D:
					super.dispatchEvent(new Event(DRAG_RIGHT));
				break;
				case Keyboard.DELETE:
					super.dispatchEvent(new Event(DELETE));
				break;
				case Keyboard.C:
				if(event.ctrlKey){
					super.dispatchEvent(new Event(COPY_BOX));
				}
				break;
			}
		}
		public function applyFormat():void{
			currentBox.applyFormat = this.fieldFormat;
			
		}
		public function set select(value:Boolean):void{
			currentBox.select = value;
		}
		public function get select():Boolean{
			return currentBox.select;
		}
		public function set w(value:Number):void{
			 currentBox.wField = value;
		}
		public function set h(value:Number):void{
			currentBox.hField = value;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<BOX/>');
			outXml.TYPE = this.boxType;
			outXml.@x = super.x;
			outXml.@y = super.y;
			outXml.@width = currentBox.wField;
			outXml.@height = currentBox.hField;
			outXml.SELECT = this.select.toString();
			outXml.appendChild(new XML('<TEXT><![CDATA['+currentBox.text+']]></TEXT>'));
			return outXml;
		}
	}
}
