package source.SocketConnection {
	import flash.display.Sprite;
	import source.Components.Label;
	import source.Components.Field;
	import source.Components.Button;
	import source.Components.COEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SocketUpload extends Sprite{
		
		public static var UPLOAD_TASK:String = 'onUploadTask';
		
		private var numTaskLabel:Label = new Label();
		private var tskLabel:Label = new Label();
		private var tskField:Field = new Field();
		private var pointTsk:Label = new Label();
		
		private var nameLabel:Label = new Label();
		private var nameField:Label = new Label();
		
		private var courseLabel:Label = new Label();
		private var courseField:Label = new Label();
		
		private var dlPathLabel:Label = new Label();
		private var dlPathField:Label = new Label();
		
		private var pcPathLabel:Label = new Label();
		private var pcPathField:Label = new Label();
		
		private var prepareButton:Button = new Button('Отправить');
		
		private var taskID:String = '';
		private var userStatus:Number = -1;
		
		public function SocketUpload() {
			super();
			init();
		}
		private function init():void{
			super.addChild(numTaskLabel);
			numTaskLabel.text = 'Номер задания:';
			pointTsk.text = '.tsk';
			numTaskLabel.x = -numTaskLabel.width - 5;
			pointTsk.x = tskLabel.x = tskField.x = 5;
			tskField.addEventListener(COEvent.INPUT_TEXT, TSK_INPUT_FIELD);
			
			super.addChild(nameLabel);
			super.addChild(nameField);
			nameLabel.text = 'Название задания:';
			nameField.y = nameLabel.y = 25;
			nameLabel.x = -nameLabel.width - 5;
			nameField.x = 5;
			
			super.addChild(pcPathLabel);
			super.addChild(pcPathField);
			pcPathLabel.text = 'Полный путь на PC:';
			pcPathField.text = '/temp/Position.txt';
			pcPathField.y = pcPathLabel.y = 50;
			pcPathLabel.x = -pcPathLabel.width - 5;
			pcPathField.x = 5;
			
			super.addChild(prepareButton);
			prepareButton.y = 75;
			prepareButton.x = -prepareButton.width/2;
			
			prepareButton.visible = false;
			prepareButton.addEventListener(MouseEvent.CLICK, UPLOAD_CLICK);
		}
		public function set status(value:Number):void{
			userStatus = value;
			if(userStatus<1){
				if(super.contains(tskLabel)) super.removeChild(tskLabel);
				if(super.contains(tskField)) super.removeChild(tskField);
				if(super.contains(pointTsk)) super.removeChild(pointTsk);
			}else{
				if(userStatus == 3){
					if(super.contains(tskField)) super.removeChild(tskField);
					super.addChild(tskLabel);
					super.addChild(pointTsk);
				}else{
					if(userStatus == 2 || userStatus == 1){
						if(super.contains(tskLabel)) super.removeChild(tskLabel);
						super.addChild(tskField);
						super.addChild(pointTsk);
						pointTsk.x = tskField.x + tskField.width;
					}
				}
				tid = taskID;
			}
		}
		public function set tid(value:String):void{
			taskID = value;
			tskLabel.text = value;
			tskField.text = value;
			if(taskID == ''){
				prepareButton.visible = false;
				if(super.contains(pointTsk)) super.removeChild(pointTsk);
				return;
			}
			prepareButton.visible = true;
			super.addChild(pointTsk);
			if(super.contains(tskLabel)){
				pointTsk.x = tskLabel.x + tskLabel.width;
			}
			if(super.contains(tskField)){
				pointTsk.x = tskField.x + tskField.width;
			}
		}
		public function get tid():String{
			return taskID;
		}
		
		private function TSK_INPUT_FIELD(event:Event):void{
			tid = tskField.text;
		}
		public function set taskName(value:String):void{
			nameField.text = value;
		}
		public function clear():void{
			tid = '';
			taskName = '';
			prepareButton.visible = false;
		}
		private function UPLOAD_CLICK(event:MouseEvent):void{
			super.dispatchEvent(new Event(UPLOAD_TASK));
		}
	}
	
}
