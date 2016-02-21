package source.Designer {
	import flash.display.Sprite;
	import source.Utilites.PazzleEvent;
	import source.Utilites.OnLoader;
	import source.Utilites.CuterPict;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class DesController {
		private var pazzleModel:DesModel;
		private var pazzleViewer:DesViewer;
		private var loader:OnLoader = new OnLoader();
		public function DesController(mainContainer:Sprite) {
			loader.setContainer(mainContainer);
			pazzleModel = new DesModel();
			pazzleViewer = new DesViewer(mainContainer, pazzleModel);
			//setSettings();
			initHandler();
		}
		private function initHandler(){
			pazzleViewer.addEventListener(PazzleEvent.SETTINGS_CHANGED, VIEW_SIZE_CHANGED);
			pazzleViewer.addEventListener(PazzleEvent.SIZE_CHANGED, VIEW_SIZE_CHANGED);
			pazzleViewer.addEventListener(PazzleEvent.VIEW_CHANGED, VIEW_CHANGED);
			//pazzleViewer.addEventListener(PazzleEvent.OPEN_FILE, LOAD_PICT);
			loader.addEventListener(PazzleEvent.LOAD_MUCH_FILE, LOAD_FILE);
		}
		public function LOAD_PICT(value:Object){
			loader.loadMuchURL([value]);
		}
		private function LOAD_FILE(e:Event){
			var inObject:Object = loader.getData();
			var i:int;
			var image:Bitmap = new Bitmap();
			var copyImage:BitmapData;
			for(i=0;i<inObject.arrName.length;i++){
				image = Bitmap(inObject.arrData[i]);
				copyImage = new BitmapData(image.width,image.height,true,0xffffffff);
				copyImage.draw(image, new Matrix());
				pazzleModel.addImage(copyImage ,inObject.arrName[i]);
			}
			VIEW_SIZE_CHANGED(null);
		}
		private function VIEW_SIZE_CHANGED(e:Event){
			var inObject:Object = pazzleViewer.getSettings()
			pazzleModel.setSettings(inObject);
		}
		private function VIEW_CHANGED(e:Event){
			var inImages:Array = pazzleModel.getImage();
			var inSettings:Object = pazzleModel.getSettings();
			var i:int;
			var copyImage:BitmapData;
			var outArray:Array = new Array;
			for(i=0;i<inImages.length;i++){
				copyImage = new BitmapData(inImages[i].width,inImages[i].height,true,0xffffffff);
				copyImage.draw(inImages[i], new Matrix());
				outArray[i] = new Array;
				outArray[i] = CuterPict.cutPict(copyImage, inSettings.numColumn, inSettings.numLine);
			}
			pazzleViewer.setPictArray(outArray);
		}
		public function getPazzleXML():XML{
			return pazzleModel.getXML();
		}
		
		public function setXML(xml:XMLList, content:Array):void{
			pazzleModel.setXML(xml);
			var i,l:int;
			var arr:Array = new Array();
			l = content.length;
			trace(this + ': num images = ' + l);
			for(i=0;i<l;i++){
				trace(this + ' имя изображения = ' + content[i][0]);
				arr.push({'byteArray':content[i][1],'name':content[i][0]});
			}
			loader.loadMuchURL(arr);
		}
	}
	
}
