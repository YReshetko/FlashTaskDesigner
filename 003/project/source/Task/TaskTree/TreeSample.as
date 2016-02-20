package source.Task.TaskTree {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import source.utils.Figure;
	import source.utils.ContextClass.MyMenu;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	
	public class TreeSample extends Sprite{
		private static var MenuArr:Array = ['Удалить', 'Дублировать'];
		
		public static var REMOVE_TASK:String = 'onRemoveTask';
		public static var DUPLICATE_TASK:String = 'onDuplicateTask';
		
		private static var deltaX:Number = -18;
		private static var deltaY:Number = -10;
		public static var hSample:int = 18;
		
		private var fileClip:FileClip = new FileClip();
		private var field:TextField = new TextField();
		private var id:int;
		private var sampleLevel:int;
		private var lineSprite:Sprite = new Sprite();
		private var sampleLine:Array = new Array();
		public function TreeSample(container:Sprite) {
			super();
			super.addChild(fileClip);
			super.addChild(field);
			container.addChild(super);
			fileClip.mouseEnabled = false;
			initField();
			super.addChild(lineSprite);
			new MyMenu(super, MenuArr, [removeTask, duplicateTask]);
		}
		private function initField():void{
			var format:TextFormat = new TextFormat();
			format.size = 13;
			format.bold = true;
			field.defaultTextFormat = format;
			field.mouseEnabled = false;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.x = fileClip.x + fileClip.width;
		}
		private function initBackground():void{
			super.graphics.clear();
			var W:Number = super.width;
			var H:Number = super.height;
			Figure.insertRect(super, W, H, 1, 0, 0x000000, 0);
			
		}
		override public function set name(value:String):void{
			field.text = value;
			this.initBackground();
		}
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		public function set level(value:int):void{
			sampleLevel = value;
			clearLine();
			var i:int;
			for(i=1;i<sampleLevel;i++){
				sampleLine.push(new VertLine());
				lineSprite.addChild(sampleLine[i-1]);
				sampleLine[i-1].x = (i-1)*deltaX - 7;
				sampleLine[i-1].y = deltaY;
			}
		}
		public function get level():int{
			return sampleLevel;
		}
		private function clearLine():void{
			while(sampleLine.length>0){
				lineSprite.removeChild(sampleLine[0]);
				sampleLine.shift();
			}
		}
		public function takeSample(value:Boolean):void{
			lineSprite.visible = value;
		}
		
		private function removeTask(e:ContextMenuEvent):void{
			super.dispatchEvent(new Event(REMOVE_TASK));
		}
		private function duplicateTask(e:ContextMenuEvent):void{
			super.dispatchEvent(new Event(DUPLICATE_TASK));
		}
		public function set selectTask(value:Boolean):void{
			if(value) field.textColor = 0x00FF00;
			else field.textColor = 0x000000;
		}
	}
	
}
