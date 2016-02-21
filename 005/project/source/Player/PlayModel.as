package source.Player {
	import flash.events.EventDispatcher;
	
	public class PlayModel extends EventDispatcher{
		private var url:String = "";
		private var numLine:int = 1;
		private var numColumn:int = 1;
		private var hPicture:Number = 100;
		private var wPicture:Number = 100;
		private var jump:int = 20;
		private var helper:String = "WITH HELP";
		private var positioner:String = "RANDOM";
		private var arrPosition:Array = new Array();
		public function PlayModel() {
			super();
		}
		public function setPath(Path:String){
			if(Path!="")url = Path+"/";
		}
		public function setXML(inXML:XML){
			var nameSample:String = "";
			for each(var sample:XML in inXML.elements()){
				nameSample = sample.name();
				//trace(this + " SAMPLE = " + sample)
				switch (nameSample){
					case "FILENAME":	url+=sample;					break;
					case "NUMLINE":		numLine = parseInt(sample);		break;
					case "NUMCOLUMN":	numColumn = parseInt(sample);	break;
					case "WIDTH":		wPicture = parseFloat(sample);	break;
					case "HEIGHT":		hPicture = parseFloat(sample);	break;
					case "JUMP":		jump = parseInt(sample);		break;
					case "HELPER":		helper = sample;				break;
					case "POSITIONER":	positioner = sample;			break;
					case "POSITION":	setArrPosition(sample);			break;
				}
			}
		}
		private function setArrPosition(inXML:XML){
			var i,j:int;
			for each(var sample:XML in inXML.elements()){
				i = parseInt(sample.@I);
				j = parseInt(sample.@J);
				if(i>=arrPosition.length) arrPosition.push(new Array());
				arrPosition[i][j] = [parseFloat(sample.X), parseFloat(sample.Y), parseInt(sample.R)];
			}
		}
		public function getUrl():String{
			return url;
		}
		public function getSettings():Object{
			var outObject:Object = new Object();
			outObject.numLine = numLine;
			outObject.numColumn = numColumn;
			outObject.wPicture = wPicture;
			outObject.hPicture = hPicture;
			return outObject;
		}
		public function getAdditionalSettings():Object{
			var outObject:Object = new Object();
			outObject.jump = jump;
			outObject.helper = helper;
			outObject.positioner = positioner;
			outObject.arrPosition = arrPosition;
			return outObject;
		}
	}
	
}
