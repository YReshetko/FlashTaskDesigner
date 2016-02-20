package source.EnvDataBase.TskDataBase.TskPlayer {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import source.EnvEvents.Events;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvLoader.LoadFiles;
	import source.EnvUtils.EnvString.ConvertString;
	import flash.filesystem.File;
	
	public class TaskPlayer extends Sprite{
		private static const pathPlayer:String = 'Player.swf';
		private var player:*;
		private var playNavigator:PlayerPanel;
		
		private var loader:LoadFiles = new LoadFiles();
		
		private var currentArrTask:Array = new Array();
		private var currentID:int;
		private var currentTask:String;
		public function TaskPlayer() {
			super();
			var loader:Loader = new Loader();
			super.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.INIT, PLAYER_INIT);
			loader.load(new URLRequest(pathPlayer));
		}
		private function PLAYER_INIT(e:Event):void{
			player = e.target.content;
			Figure.insertRect(super, player.width, player.height, 0, 0, 0x000000, 1, 0xFFFFFF);
			playNavigator = new PlayerPanel();
			super.addChild(playNavigator);
			playNavigator.x = (player.width - playNavigator.width)/2;
			playNavigator.y = player.height + 5;
			super.dispatchEvent(new Event(Events.WINDOW_INIT_COMPLATE));
		}
		
		public function setArrayOfTask(arr:Array):void{
			clearCurrentArrTask();
			var i:int;
			var leng:int = arr.length;
			for(i=0;i<leng;i++){
				currentArrTask.push(arr[i]);
			}
			currentID = 0;
			loadCurrentTask();
		}
		private function clearCurrentArrTask():void{
			while(currentArrTask.length>0){
				currentArrTask.shift();
			}
		}
		
		private function loadCurrentTask():void{
			var basePath:String = currentArrTask[currentID][0].substring(0, currentArrTask[currentID][0].lastIndexOf('/'));
			basePath = File.applicationDirectory.nativePath.toString() +'/'+ basePath + '/';
			playNavigator.setLabel(currentArrTask[currentID][1]);
			player.url = basePath;
			basePath = File.applicationDirectory.nativePath.toString() + '/DataBase/Images/';
			player.imageUrl = basePath;
			player.startLoadingTask();
		}
		public function loadTaskFromDessigner(task:String, library:Array):void{
			player.setTaskFromDesigner(task, library);
		}
	}
	
}
