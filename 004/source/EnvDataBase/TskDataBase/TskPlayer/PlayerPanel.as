package source.EnvDataBase.TskDataBase.TskPlayer {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class PlayerPanel extends Sprite{
		private static const deltaX:int = 5;
		private static const deltaY:int = 25;
		private static const deltaW:int = 10;
		
		private var nextTask:playNextTask = new playNextTask();
		private var prevTask:playPrevTask = new playPrevTask();
		private var nextFile:playNextFile = new playNextFile();
		private var prevFile:playPrevFile = new playPrevFile();
		
		
		private var fieldLabel:TextField;
		public function PlayerPanel() {
			super();
			initPanel();
			initHandler();
		}
		private function initPanel():void{
			super.addChild(prevFile);
			super.addChild(prevTask);
			super.addChild(nextTask);
			super.addChild(nextFile);
			prevFile.y = prevTask.y = nextTask.y = nextFile.y = deltaY;
			prevFile.x = deltaX;
			prevTask.x = prevFile.x + prevFile.width + deltaW;
			nextTask.x = prevTask.x + prevTask.width + deltaW;
			nextFile.x = nextTask.x + nextTask.width + deltaW;
			Figure.insertRect(super, super.width + deltaX*2, super.height + deltaY + deltaX*2, 1, 1, 0x000000, 0.7);
			
			fieldLabel = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = 'Arial';
			textFormat.size = 12;
			textFormat.bold = true;
			fieldLabel.autoSize = TextFieldAutoSize.CENTER;
			fieldLabel.border = true;
			fieldLabel.defaultTextFormat = textFormat;
			fieldLabel.mouseEnabled = false;
			super.addChild(fieldLabel);
			fieldLabel.x = super.width/2;
		}
		private function initHandler():void{
			prevFile.addEventListener(MouseEvent.MOUSE_DOWN, PREV_FILE_MD);
			prevTask.addEventListener(MouseEvent.MOUSE_DOWN, PREV_TASK_MD);
			nextTask.addEventListener(MouseEvent.MOUSE_DOWN, NEXT_TASK_MD);
			nextFile.addEventListener(MouseEvent.MOUSE_DOWN, NEXT_FILE_MD);
		}
		private function PREV_FILE_MD(e:MouseEvent):void{
			
		}
		private function PREV_TASK_MD(e:MouseEvent):void{
			
		}
		private function NEXT_TASK_MD(e:MouseEvent):void{
			
		}
		private function NEXT_FILE_MD(e:MouseEvent):void{
			
		}
		
		
		public function setLabel(s:String):void{
			fieldLabel.text = s;
		}
		
	}
	
}
