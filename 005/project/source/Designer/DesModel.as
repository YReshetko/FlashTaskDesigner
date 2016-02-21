package source.Designer {
	import flash.events.Event;
	import source.Utilites.PazzleEvent;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	
	public class DesModel extends Sprite{
		private var numLine:int = 1;
		private var numColumn:int = 1;
		private var wPicture:Number;
		private var hPicture:Number;
		private var relationPict:Number;
		private var fileName:String;
		private var helper:String;
		private var positioner:String;
		private var jump:int = 20;
		private var arrPosition:Array = new Array();
		private var image:BitmapData;
		public function DesModel() {
			super();
		}
		public function getSettings():Object{
			return prepareObject();
		}
		public function setFileName(fileName:String){
			this.fileName = fileName;
		}
		public function setImage(image:BitmapData){
			this.image = image;
			wPicture = image.width;
			hPicture = image.height;
			relationPict = wPicture/hPicture;
		}
		public function getSize():Object{
			var outObject:Object = new Object();
			outObject.wPicture = wPicture
			outObject.hPicture = hPicture
			outObject.relationPict = relationPict;
			return outObject;
		}
		public function setSize(inObject:Object){
			wPicture = inObject.wPicture
			hPicture = inObject.hPicture
			this.dispatchEvent(new Event(PazzleEvent.SIZE_CHANGED_MODEL));
		}
		public function getImage():BitmapData{
			return image;
		}
		public function setSettings(inObject:Object){
			numLine = inObject.numLine;
			numColumn = inObject.numColumn;
			if(numLine == 0) numLine = 1;
			if(numColumn == 0) numColumn = 1;
			helper = inObject.helper;
			positioner = inObject.positioner;
			jump = inObject.jump;
			this.dispatchEvent(new Event(PazzleEvent.MODEL_CHANGED));
		}
		public function getHelper():String{
			return helper;
		}
		private function clearArrPosition(){
			var i,j:int;
			while (arrPosition.length>0){
				while (arrPosition[0].length>0){
					arrPosition[0].shift();
				}
				arrPosition.shift();
			}
		}
		public function setArrPosition(arr:Array){
			clearArrPosition();
			var i,j:int;
			for(i=0;i<numColumn;i++){
				arrPosition[i] = new Array;
				for(j=0;j<numLine;j++){
					arrPosition[i][j] = arr[i][j];
				}
			}
		}
		private function prepareObject():Object{
			var outObject:Object = new Object();
			outObject.numLine = numLine;
			outObject.numColumn = numColumn;
			outObject.helper = helper;
			outObject.positioner = positioner;
			outObject.jump = jump;
			return outObject;
		}
		public function setXML(value:XMLList):void{
			var inObject:Object = new Object();

			inObject.numLine = parseInt(value.PAZZLE.NUMLINE.toString());
			inObject.numColumn = parseInt(value.PAZZLE.NUMCOLUMN.toString());
			
			inObject.wPicture = parseFloat(value.PAZZLE.WIDTH.toString());
			inObject.hPicture = parseFloat(value.PAZZLE.HEIGHT.toString());
			
			inObject.helper = value.PAZZLE.HELPER.toString();
			inObject.positioner = value.PAZZLE.POSITIONER.toString();
			inObject.jump = parseInt(value.PAZZLE.JUMP.toString());
			setSize(inObject);
			setSettings(inObject);
		}
		public function getXML():XML{
			var outXML:XML = new XML('<PAZZLE/>');
			if(image == null) return outXML;
			outXML.FILENAME = fileName;
			outXML.NUMLINE = numLine;
			outXML.NUMCOLUMN = numColumn;
			outXML.WIDTH = wPicture;
			outXML.JUMP = jump;
			outXML.HEIGHT = hPicture;
			outXML.HELPER = helper;
			outXML.POSITIONER = positioner;
			if(positioner == "AUTHOR POSITION"){
				outXML.POSITION = new XMLList(getPositionXML());
			}
			return outXML;
		}
		private function getPositionXML():String{
			var outString:String = "<POSITION>\n\r";
			var i,j:int;
			for(i=0;i<arrPosition.length;i++){
				for(j=0;j<arrPosition[i].length;j++){
					outString += "<SAMPLE I='"+i+"' J='"+j+"'><X>"+arrPosition[i][j][0]+"</X><Y>"+arrPosition[i][j][1]+"</Y><R>"+arrPosition[i][j][2]+"</R></SAMPLE>\n\r";
				}
			}
			outString += "</POSITION>\n\r";
			return outString;
		}
	}
	
}
