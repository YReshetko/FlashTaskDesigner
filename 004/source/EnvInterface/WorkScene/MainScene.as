package source.EnvInterface.WorkScene {
	import flash.display.Sprite;
	import source.EnvInterface.EnvPanel.Panel;
	import flash.display.Stage;
	import source.MainEnvelope
	import source.EnvInterface.WorkScene.DLCourses.CourseController;
	import source.Components.Button;
	import flash.events.MouseEvent;
	import source.DBSaver.DBController;
	
	public class MainScene extends Sprite{
		private var userDBPanel:Panel = new Panel('База пользователя');
		private var dlDBPanel:Panel = new Panel('Курсы пользователя');
		private var courseController:CourseController;
		private var STAGE:Stage;
		private var butSave:Button = new Button('Сохранить базу');
		private var reloadDB:Button = new Button('Обновить базу');
		public function MainScene() {
			super();
			STAGE = MainEnvelope.STAGE;
			initPanels();
			initButtons();
		}
		public function set courses(value:Object):void{
			courseController = new CourseController(value, dlDBPanel, userDBPanel);
		}
		
		
		private function initPanels():void{
			super.addChild(userDBPanel);
			super.addChild(dlDBPanel);
			
			userDBPanel.x = userDBPanel.y = 0
			userDBPanel.setSizePanel(STAGE.nativeWindow.width/2, STAGE.nativeWindow.height - 90);
			
			dlDBPanel.x = STAGE.nativeWindow.width/2;
			dlDBPanel.y = 0;
			dlDBPanel.setSizePanel(STAGE.nativeWindow.width/2, STAGE.nativeWindow.height - 90);
			userDBPanel.removeDragble();
			dlDBPanel.removeDragble();
			userDBPanel.activeHandler(false);
			dlDBPanel.activeHandler(false);
		}
		private function initButtons():void{
			var w:Number = userDBPanel.WIDTH/2;
			super.addChild(butSave);
			super.addChild(reloadDB);
			reloadDB.y = butSave.y = userDBPanel.HEIGHT+butSave.height;
			reloadDB.width = butSave.width = w;
			reloadDB.x = w;
			
			butSave.addEventListener(MouseEvent.CLICK, SAVE_CLICK);
		}
		private function SAVE_CLICK(event:MouseEvent):void{
			var arr:Array = courseController.saveTasks;
			/*var i,l:int;
			l = arr.length;
			for(i=0;i<l;i++){
				trace(this + '{tid:' + arr[i].tid + ', cid:' + arr[i].cid + ', nid:' + arr[i].nid + ', link:' + arr[i].link + ', name:' + arr[i].name +  '}');
			}*/
			new DBController(super, arr);
		}

	}
	
}
