package source {
	import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.xml.*;
	import source.Designer.*;
	import source.Player.*;
	
	// Параметры SWF-файла
	[SWF(width="730", height="500")]
	public class Main extends Sprite{
        public static const GET_MODULE_SETTINGS:String = "onGetModuleSettings";
		private var typeSwf:String = new String;
		private var PartDesigin;
		private var PartPlayer;
		private var arrContent:Array;
		//private var str:XML = <SETTINGS><COLCOUNT>2</COLCOUNT><ROWCOUNT>3</ROWCOUNT><BUTLEFT><IMG id="0">1.png</IMG><IMG id="1">3.png</IMG><IMG id="2">5.png</IMG><IMG id="3">2.png</IMG><IMG id="4">4.png</IMG><IMG id="5">6.png</IMG></BUTLEFT><TOPRIGHT><IMG id="0">g3.png</IMG><IMG id="1">g2.png</IMG><IMG id="2">g6.png</IMG><IMG id="3">g5.png</IMG><IMG id="4">g4.png</IMG><IMG id="5">g1.png</IMG></TOPRIGHT><TRANSPOSITION>5,0,3,1,4,2</TRANSPOSITION></SETTINGS>;
		public function Main() { 
			typeSwf = "Modul";
			//setEnvironment("Designer");
			//setParametrs("",str);
		}
		public function getType():String{
			return typeSwf;
		}
		public function setEnvironment(environment:String){
			switch(environment){
				case "Designer":
				PartDesigin = new AnalogyDes(this);
                this.addEventListener(MouseEvent.MOUSE_DOWN, ON_DESIGNER_MOUSE_DOWN);
				//	Запуск класса выполняющего роль конструктора
				break;
				case "Player":
				//	Запуск класса выполняющего роль плеера
				PartPlayer = new AnalogyPlay(this);
				break;
			}
		}
		public function getSettings():String{
			trace(this + ': GETTING SETTINGS FROM MODUL');
			return PartDesigin.getSettings();
		}
		
		public function setContent(value:Array):void{
			arrContent = value;
		}
		public function setParametrs(Path:String, ParamXML:XMLList){
			setEnvironment("Player");
			//trace(ParamXML);
			PartPlayer.setParametrs(Path, ParamXML, arrContent);
		}
		public function getAnswer():Boolean{
			return PartPlayer.getAswer();
		}
        public function setDessigned(xml:XMLList, content:Array){
//            trace(this + " Input xml : \n" + xml);
//            trace(this + " Input content : \n" + content);
            PartDesigin.setParametrs(xml, content);
        }

        private function ON_DESIGNER_MOUSE_DOWN(event:MouseEvent):void{
            //trace(this + " Click on module scene");
            super.dispatchEvent(new Event(GET_MODULE_SETTINGS));
        }
        public function get objectToSettings():AnalogyDes{
            return PartDesigin;
        }
	}
}