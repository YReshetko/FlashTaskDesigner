package source.BlockOfTask.Task.TaskObjects.CheckBox {
	import source.BlockOfTask.Task.TaskObjects.CheckBox.BoxType.ClassicBox;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import source.BlockOfTask.Task.TaskObjects.CheckBox.BoxType.TextBox;
	import source.BlockOfTask.Task.TaskObjects.CheckBox.BoxType.RoundBox;
	
	
	public class OneBox extends Sprite{
		public static var BOX_SELECT:String = 'onBoxSelect';
		
		private var currentType:String = 'text';
		private var currentBox:*;
		private var trueSelect:Boolean = false;
		private var fieldFormat:FieldFormat;
		public function OneBox(value:FieldFormat) {
			super();
			fieldFormat = value;
			boxType = currentType;
			super.addEventListener(MouseEvent.MOUSE_DOWN, BOX_MOUSE_DOWN);
		}
		public function set settings(xml:XML):void{
			if(xml.SELECT.toString()!='') trueSelect = (xml.SELECT.toString()=='true');
			if(xml.TYPE.toString()!='') this.boxType = xml.TYPE.toString();
			if(xml.TEXT.toString()) currentBox.text = xml.TEXT.toString();
			//currentBox.correctFieldSize();
			trace(this + 'SET SETTINGS');
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
				case 'image':
				break;
				case 'round':
					currentBox = new RoundBox();
				break;
				case 'text':
					currentBox = new TextBox();
					
				break;
			}
			currentBox.text = str;
			currentBox.select = flag;
			super.addChild(currentBox);
		}
		public function get boxType():String{
			return currentType;
		}
		public function close():void{
			currentBox.close();
		}
		private function BOX_MOUSE_DOWN(event:MouseEvent):void{
			currentBox.select = !currentBox.select;
			super.dispatchEvent(new Event(BOX_SELECT));
		}
		public function set wField(value:Number):void{
			currentBox.wField = value;
		}
		public function widthAutosize():void{
			wField = currentBox.textWidth + 3;
		}
		public function set hField(value:Number):void{
			currentBox.hField = value;
		}
		public function heightAutosize():void{
			hField = currentBox.textHeight + 3;
		}
		public function set select(value:Boolean):void{
			currentBox.select = value;
		}
		public function get select():Boolean{
			return currentBox.select;
		}
		public function applyFormat():void{
			currentBox.applyFormat = this.fieldFormat;
		}
		public function get complate():Boolean{
			if(this.select == this.trueSelect) return true;
			return false;
		}
		
		public function showAnswer():void{
			currentBox.select = this.trueSelect;
		}
	}
}
