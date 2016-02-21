package source {
	import flash.display.Sprite;
	import source.Designer.DesController;
	import source.Player.PlayController;
	import source.Player.PlayViewer;
	import flash.events.Event;

	// Параметры SWF-файла
	[SWF(width="730", height="496")]
	public class Main extends Sprite {
		//private static var myXML:String = "<SETTINGS><LISTINGIMAGES><NAMESPACE><FILENAME ID='0'>3.png</FILENAME><FILENAME ID='1'>4.png</FILENAME></NAMESPACE><NUMLINE>2</NUMLINE><NUMCOLUMN>4</NUMCOLUMN><WIDTH>100</WIDTH><HEIGHT>100</HEIGHT><HELPER>WITHOUT HELP</HELPER><REFLEX>SHOWING</REFLEX><SAMPLEPOSITION><SAMPLE ID='0'><X>30</X><Y>30</Y></SAMPLE><SAMPLE ID='1'><X>50</X><Y>50</Y></SAMPLE></SAMPLEPOSITION></LISTINGIMAGES></SETTINGS>";
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
		private function ON_CLOSE_RESTART(e:Event):void{
			trace(this + ': DISPATHC CLOSE RESTART');
			super.dispatchEvent(new Event(PlayViewer.CLOSE_RESTART));
		}
		private function ON_OPEN_RESTART(e:Event):void{
			trace(this + ': DISPATHC OPEN RESTART');
			super.dispatchEvent(new Event(PlayViewer.OPEN_RESTART));
		}
		public function getType():String{
			return typeApp;
		}
		public function getSettings():String{
			 return DesCont.getPazzleXML();
		}
		public function putContent():void{
			DesCont.LOAD_PICT(arrContent[0]);
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
		
		public function setDessigned(xml:XMLList, content:Array):void{
			DesCont.setXML(xml, content);
		}
	}
	
}
