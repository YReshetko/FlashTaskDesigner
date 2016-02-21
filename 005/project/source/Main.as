package source {
	import flash.display.Sprite;
	import source.Designer.DesController;
	import source.Player.PlayController;
	import source.Player.PlayViewer;
	import flash.events.Event;

	// Параметры SWF-файла
	[SWF(width="730", height="496")]
	public class Main extends Sprite {
		//private static var myXML:String = "<SETTINGS><PAZZLE><FILENAME>3.JPG</FILENAME><NUMLINE>2</NUMLINE><NUMCOLUMN>3</NUMCOLUMN><WIDTH>408</WIDTH><HEIGHT>306</HEIGHT><JUMP>400</JUMP><HELPER>WITH HELP</HELPER><POSITIONER>AROUND FIELD</POSITIONER><POSITION><SAMPLE I='0' J='0'><X>67.25</X><Y>299</Y><R>15</R></SAMPLE><SAMPLE I='0' J='1'><X>-734.9</X><Y>2128.7</Y><R>15</R></SAMPLE><SAMPLE I='1' J='0'><X>2462.2</X><Y>-605</Y><R>4</R></SAMPLE><SAMPLE I='1' J='1'><X>2473.5</X><Y>3710.7</Y><R>12</R></SAMPLE><SAMPLE I='2' J='0'><X>4631</X><Y>604.1</Y><R>1</R></SAMPLE><SAMPLE I='2' J='1'><X>5207.3</X><Y>2479</Y><R>1</R></SAMPLE></POSITION></PAZZLE></SETTINGS>";
		private var typeApp:String = "Modul";
		private var mainContainer:Sprite = new Sprite;
		
		private var DesCont:DesController;
		private var PlayCont:PlayController;
		
		private var arrContent:Array;
		public function Main() {
			//setEnvironment("Designer");
			addChild(mainContainer);
			//setParametrs("", new XMLList(myXML));
		}
		public function setEnvironment(environment:String){
			switch(environment){
				case "Designer":
				DesCont = new DesController(mainContainer);
				break;
				case "Player":
				PlayCont = new PlayController(mainContainer);
				PlayCont.addEventListener(PlayViewer.CLOSE_RESTART, ON_CLOSE_RESTART);
				PlayCont.addEventListener(PlayViewer.OPEN_RESTART, ON_OPEN_RESTART);
				break;
			}
		}
		public function getType():String{
			return typeApp;
		}
		public function getSettings():String{
			 return DesCont.getPazzleXML();
		}
		
		public function putContent():void{
			DesCont.LOAD_PICT(arrContent[0].name, arrContent[0].byteArray);
		}
		
		public function setContent(value:Array):void{
			arrContent = value;
		}
		public function setParametrs(Path:String, ParamXML:XMLList){
			setEnvironment("Player");
			PlayCont.setSettings(Path, ParamXML, arrContent);
		}
		public function getAnswer():Boolean{
			return PlayCont.getAnswere();
		}
		private function ON_CLOSE_RESTART(e:Event):void{
			trace(this + ': DISPATHC CLOSE RESTART');
			super.dispatchEvent(new Event(PlayViewer.CLOSE_RESTART));
		}
		private function ON_OPEN_RESTART(e:Event):void{
			trace(this + ': DISPATHC OPEN RESTART');
			super.dispatchEvent(new Event(PlayViewer.OPEN_RESTART));
		}
		
		public function setDessigned(xml:XMLList, content:Array):void{
			DesCont.setXML(xml, content);
		}
	}
	
}
