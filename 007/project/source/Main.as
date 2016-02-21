package source {
	import flash.display.Sprite;
	import source.Designer.DesController;
	import source.Player.PlayController;

	// Параметры SWF-файла
	[SWF(width="730", height="496")]
	public class Main extends Sprite {
		//private static var myXML:String = "<SETTINGS><COLCOLUMN>1</COLCOLUMN><COLLINE>1</COLLINE><IMAGE ID='0'>1.png</IMAGE><IMAGE ID='1'>2.png</IMAGE><IMAGE ID='2'>3.png</IMAGE><IMAGE ID='3'>4.png</IMAGE><IMAGE ID='4'>5.png</IMAGE><IMAGE ID='5'>6.png</IMAGE></SETTINGS>";
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
				break;
			}
		}
		public function getType():String{
			return typeApp;
		}
		public function getSettings():String{
			 return DesCont.getTaskSettings();
		}
		public function setContent(value:Array):void{
			arrContent = value;
		}
		public function setParametrs(Path:String, ParamXML:XMLList){
			setEnvironment("Player");
			PlayCont.setSettings(Path, ParamXML, arrContent);
		}
		public function getAnswer():Boolean{
			return PlayCont.getAnswer();
		}
	}
	
}
