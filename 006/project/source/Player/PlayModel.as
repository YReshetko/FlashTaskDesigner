package source.Player {
	import flash.events.EventDispatcher;
	
	public class PlayModel extends EventDispatcher{
		private var url:String = "";
		private var arrUrl:Array = new Array;
		private var numLine:int = 1;
		private var numColumn:int = 1;
		private var hPicture:int = 100;
		private var wPicture:int = 100;
		private var helper:String = "WITH HELP";
		private var reflex:String = "VANISHING";
		private var arrPosSample:Array = new Array();
		public function PlayModel() {
			super();
		}
		public function setPath(Path:String){
			if(Path!="")url = Path+"/";
		}
		public function setXML(inXML:XML){
			var nameSample:String = "";
			var sample:XML;
			for each(sample in inXML.NAMESPACE.elements()){
				nameSample = sample.name();
				if(nameSample == "FILENAME") arrUrl.push(url+sample);
			}
			for each(sample in inXML.elements()){
				nameSample = sample.name();
				switch (nameSample){
					case "NUMLINE":		numLine = parseInt(sample);		break;
					case "NUMCOLUMN":	numColumn = parseInt(sample);	break;
					case "WIDTH":		wPicture = parseInt(sample);	break;
					case "HEIGHT":		hPicture = parseInt(sample);	break;
					case "HELPER":		helper = sample;				break;
					case "REFLEX":		reflex = sample;				break;
				}
			}
			if(helper == "NEARBY"){
				for each(sample in inXML.SAMPLEPOSITION.elements()){
					nameSample = sample.name();
					if(nameSample == "SAMPLE") arrPosSample.push([parseInt(sample.X), parseInt(sample.Y)]);
				}
			}
			trace(this + " URL SPACE = " + arrUrl);
			trace(this + " LINE = " + numLine + "; COLUMN = " + numColumn + "; W = " + wPicture);
			trace(this + " ARRAY POSITION = " + arrPosSample);
		}
		public function getUrl():Array{
			return arrUrl;
		}
		public function getSettings():Object{
			var outObject:Object = new Object();
			outObject.numLine = numLine;
			outObject.numColumn = numColumn;
			outObject.wPicture = wPicture;
			outObject.hPicture = hPicture;
			return outObject;
		}
		public function getHelper():String{
			return helper;
		}
		public function getReflex():String{
			return reflex;
		}
		public function getArrSample():Array{
			return arrPosSample;
		}
	}
	
}
