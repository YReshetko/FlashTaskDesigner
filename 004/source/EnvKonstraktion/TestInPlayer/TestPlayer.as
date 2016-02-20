package source.EnvKonstraktion.TestInPlayer {
	import flash.display.Sprite;
	import source.EnvDataBase.TskDataBase.TskPlayer.PlayerPanel;
	import source.EnvDataBase.TskDataBase.TskPlayer.TaskPlayer;
	import source.EnvUtils.EnvDraw.Figure;
	
	public class TestPlayer extends Sprite{
		private var taskPlayer:TaskPlayer;
		public function TestPlayer(container:Sprite, width:Number, height:Number) {
			super();
			container.addChild(super);
			super.visible = false;
			taskPlayer = new TaskPlayer();
			super.addChild(taskPlayer);
			initBackGround(width, height);
		}
		private function initBackGround(width:Number, height:Number):void{
			Figure.insertRect(super, width, height);
		}
		public function open(task:String, content:Array):void{
			super.visible = true;
			taskPlayer.loadTaskFromDessigner(task, content);
		}
		public function close():void{
			super.visible = false;
		}
		public function get isOpen():Boolean{
			return super.visible;
		}

	}
	
}
