package source.Designer {
	import flash.display.Sprite;
	import source.Utilites.PazzleEvent;
	import source.Utilites.OnLoader;
	import source.Utilites.CuterPict;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	public class DesController {
		private var pazzleModel:DesModel;
		private var pazzleViewer:DesViewer;
		private var loader:OnLoader = new OnLoader();
		public function DesController(mainContainer:Sprite) {
			loader.setContainer(mainContainer);
			pazzleModel = new DesModel();
			pazzleViewer = new DesViewer(mainContainer, pazzleModel);
			setSettings();
			initHandler();
		}
		
		private function setSettings(){
			var inObject:Object = pazzleModel.getSettings();
			pazzleViewer.setSettings(inObject);
		}
		
		private function initHandler(){
			pazzleViewer.addEventListener(PazzleEvent.SETTINGS_CHANGED, VIEW_CHANGED);
			pazzleViewer.addEventListener(PazzleEvent.SIZE_CHANGED, VIEW_SIZE_CHANGED);
			//pazzleViewer.addEventListener(PazzleEvent.OPEN_FILE, LOAD_PICT);
			loader.addEventListener(PazzleEvent.LOAD_ONE_FILE, LOAD_FILE);
		}
		private function VIEW_CHANGED(e:Event){
			trace(this + " SETTINGS IS CHANGED");
			var inObject:Object = e.target.getSettings();
			pazzleModel.setSettings(inObject);
			cutPicture();
		}
		public function LOAD_PICT(name:String, value:ByteArray){
			trace(this + ': Start Load Image')
			loader.loadUrl(value, name);
		}
		private function LOAD_FILE(e:Event){
			trace(this + ': Load Image Complate');
			var inObject:Object = loader.getData();
			trace(this+" "+inObject.fileName);
			pazzleModel.setFileName(inObject.fileName);
			var image:Bitmap = inObject.Data;
			var copyImage:BitmapData = new BitmapData(image.width,image.height,true,0xffffffff);
			copyImage.draw(image, new Matrix());
			pazzleModel.setImage(copyImage);
			cutPicture();
		}
		private function cutPicture(){
			var image:BitmapData = pazzleModel.getImage();
			if(image!=null){
				var inObject:Object = pazzleModel.getSettings();
				var pictArr:Array = CuterPict.cutPict(image, inObject.numColumn, inObject.numLine);
				pazzleViewer.setPictArray(pictArr);
			}
		}
		private function VIEW_SIZE_CHANGED(e:Event){
			var modelSize:Object = pazzleModel.getSize();
			var viewSize:Object = pazzleViewer.getSize();
			var outObject:Object = new Object();
			if (modelSize.wPicture == viewSize.wPicture){
				outObject.hPicture = viewSize.hPicture;
				outObject.wPicture = modelSize.relationPict*viewSize.hPicture;
			}else{
				if(modelSize.hPicture == viewSize.hPicture){
					outObject.wPicture = viewSize.wPicture;
					outObject.hPicture = viewSize.wPicture/modelSize.relationPict;
				}else{
					outObject.wPicture = modelSize.wPicture;
					outObject.hPicture = modelSize.hPicture;
				}
			}
			pazzleModel.setSize(outObject);
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
			loader.loadUrl(arr[0].byteArray, arr[0].name);
		}
	}
	
}
