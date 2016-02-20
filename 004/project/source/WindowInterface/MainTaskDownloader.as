package source.WindowInterface {
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import source.utils.DataBaseUpdate.DLConnection;
	import source.WindowInterface.Logon;
	import flash.events.Event;
	import flash.display.Stage;
	import source.EnvInterface.WorkScene.MainScene;
	import source.EnvUtils.EnvDraw.Figure;
	import source.MainEnvelope;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import source.DBSaver.TempSaver;
	
	
	public class MainTaskDownloader extends Sprite {
		public static var STAGE:Stage;
		public static var dlConnection:DLConnection = new DLConnection();
		public static var tempSaver:TempSaver = new TempSaver();
		private var login:Logon;
		private var mainScene:MainScene;
		private var container:Sprite;
		private var WIDTH:Number;
		private var HEIGHT:Number;
		public function MainTaskDownloader(W:Number, H:Number, container:Sprite) {
			super();
			this.container = container;
			this.HEIGHT = H;
			this.WIDTH = W;
			STAGE = MainEnvelope.STAGE;
			initBackground();
			initLogin();
		}
		private function initBackground():void{
			Figure.insertRect(super, WIDTH, HEIGHT);
		}
		public function set open(value:Boolean):void{
			if(value){
				this.container.addChild(super);
			}else{
				if(this.container.contains(super)){
					this.container.removeChild(super);
				}
			}
		}
		public function get open():Boolean{
			if(this.container.contains(super)) return true;
			return false;
		}
		private function initLogin():void{
			login = new Logon();
			super.addChild(login);
			login.x = WIDTH/2;
			login.y = HEIGHT/2 - login.height;
			login.addEventListener(Logon.COURSE_LOAD, COURSE_LOADED);
		}
		private function COURSE_LOADED(event:Event):void{
			trace(this + ': ONLINE COURSE LOADED');
			login.removeEventListener(Logon.COURSE_LOAD, COURSE_LOADED);
			super.removeChild(login);
			mainScene = new MainScene();
			super.addChild(mainScene);
			mainScene.courses = login.data;
		}
	}
	
}
