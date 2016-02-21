package source.Designer {
	import flash.events.Event;
	import source.Utilites.PazzleEvent;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	
	public class DesModel extends Sprite{
		private var numLine:int = 1;
		private var numColumn:int = 1;
		private var wPicture:int = 100;
		private var hPicture:int = 100;
		private var fileName:Array = new Array;
		private var image:Array = new Array;
		private var helper:String;
		private var reflex:String;
		private var arrPosSample:Array = new Array();
		public function DesModel() {
			super();
		}
		public function getSettings():Object{
			return prepareObject();
		}
		public function addImage(image:BitmapData, fileName:String){
			trace(this+" PICTURE = " + image + "; NAME = " + fileName);
			this.image.push(image);
			this.fileName.push(fileName);
		}
		public function getImage():Array{
			return image;
		}
		public function removeImage(ID:int){
			image.splice(ID,1);
			fileName.splice(ID,1);
		}
		public function setSettings(inObject:Object){
			numLine = inObject.numLine;
			numColumn = inObject.numColumn;
			wPicture = inObject.wPicture;
			hPicture = inObject.hPicture;
			helper = inObject.helper;
			reflex = inObject.reflex;
			if(numLine == 0) numLine = 1;
			if(numColumn == 0) numColumn = 1;
			this.dispatchEvent(new Event(PazzleEvent.MODEL_CHANGED));
		}
		private function prepareObject():Object{
			var outObject:Object = new Object();
			outObject.numLine = numLine;
			outObject.numColumn = numColumn;
			outObject.wPicture = wPicture
			outObject.hPicture = hPicture
			outObject.helper = helper;
			outObject.reflex = reflex;
			return outObject;
		}
		public function setPositionSample(inArr:Array){
			clearArrSample();
			var i:int;
			for(i=0;i<inArr.length;i++){
				arrPosSample[i] = new Array();
				arrPosSample[i][0] = inArr[i][0];
				arrPosSample[i][1] = inArr[i][1];
			}
		}
		private function clearArrSample(){
			while(arrPosSample.length>0){
				arrPosSample.shift();
			}
		}
		public function getXML():XML{
			var i:int;
			var outXML:XML = new XML('<LISTINGIMAGES/>');
			var litleList:XML = new XML('<NAMESPACE/>');
			var posList:XML = new XML('<SAMPLEPOSITION/>')
			var sampleXML:XML;
			var str:String;
			if(image == null) return outXML;
			for(i=0;i<fileName.length;i++){
				sampleXML = new XML("<FILENAME ID='"+i+"'>"+fileName[i]+"</FILENAME>");
				litleList.appendChild(sampleXML);
			}
			outXML.appendChild(litleList);
			outXML.NUMLINE = numLine;
			outXML.NUMCOLUMN = numColumn;
			outXML.WIDTH = wPicture;
			outXML.HEIGHT = hPicture;
			outXML.HELPER = helper;
			outXML.REFLEX = reflex;
			if(helper == "NEARBY"){
				for(i=0;i<arrPosSample.length;i++){
					sampleXML = new XML("<SAMPLE ID='"+i+"'><X>"+arrPosSample[i][0]+"</X><Y>"+arrPosSample[i][1]+"</Y></SAMPLE>");
					posList.appendChild(sampleXML);
				}
			}
			outXML.appendChild(posList);
			return outXML;
		}
		public function setXML(value:XMLList):void{
			var inObject:Object = new Object();

			inObject.numLine = parseInt(value.LISTINGIMAGES.NUMLINE.toString());
			inObject.numColumn = parseInt(value.LISTINGIMAGES.NUMCOLUMN.toString());
			inObject.wPicture = parseFloat(value.LISTINGIMAGES.WIDTH.toString());
			inObject.hPicture = parseFloat(value.LISTINGIMAGES.HEIGHT.toString());
			inObject.helper = value.LISTINGIMAGES.HELPER.toString();
			inObject.reflex = value.LISTINGIMAGES.REFLEX.toString();
			
			setSettings(inObject);
		}
	}
	
}
