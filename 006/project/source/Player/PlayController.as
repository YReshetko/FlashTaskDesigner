package source.Player {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import source.Utilites.OnLoader;
	import source.Utilites.PazzleEvent;
	import source.Utilites.CuterPict;
	import flash.events.EventDispatcher;
	
	public class PlayController extends EventDispatcher{
		private var playerViewer:PlayViewer;
		private var playerModel:PlayModel = new PlayModel();
		private var pazzleLoader:OnLoader = new OnLoader();
		public function PlayController(mainContainer:Sprite) {
			pazzleLoader.setContainer(mainContainer);
			playerViewer = new PlayViewer();
			mainContainer.addChild(playerViewer);
			initHandler();
		}
		public function setSettings(Path:String, ParamXML:XMLList, content:Array){
			playerModel.setPath(Path);
			playerModel.setXML(new XML(ParamXML.LISTINGIMAGES));
			pazzleLoader.loadMuchURL(content);
		}
		private function LOAD_FILE_COMPLATE(e:Event){
			var pictData:Object = pazzleLoader.getData();
			var settings:Object = playerModel.getSettings();
			var leng:int = pictData.arrData.length;
			var i:int;
			var image:Bitmap = new Bitmap();
			var copyImage:BitmapData;
			var imageData:BitmapData;
			var outArrBitmap:Array = new Array();
			var outArrSample:Array = new Array();
			for(i=0;i<leng;i++){
				image = Bitmap(pictData.arrData[i]);
				copyImage = new BitmapData(image.width,image.height,true,0xffffffff);
				imageData = new BitmapData(image.width,image.height,true,0xffffffff);
				copyImage.draw(image, new Matrix());
				imageData.draw(image, new Matrix());
				outArrBitmap.push(CuterPict.cutPict(copyImage, settings.numColumn, settings.numLine));
				outArrSample.push(imageData);
			}
			playerViewer.setPicture(outArrBitmap, settings);
			playerViewer.setSample(outArrSample, settings);
			var helper:String = playerModel.getHelper();
			playerViewer.setReflex(playerModel.getReflex());
			if(helper != "WITH HELP") playerViewer.removeLoup();
			if(helper == "NEARBY") playerViewer.setNearBySemple(playerModel.getArrSample());
			playerViewer.setHelper(helper);
		}
		private function initHandler(){
			pazzleLoader.addEventListener(PazzleEvent.LOAD_MUCH_FILE, LOAD_FILE_COMPLATE);
			playerViewer.addEventListener(PlayViewer.CLOSE_RESTART, ON_CLOSE_RESTART);
			playerViewer.addEventListener(PlayViewer.OPEN_RESTART, ON_OPEN_RESTART);
		}
		private function ON_CLOSE_RESTART(e:Event):void{
			super.dispatchEvent(new Event(PlayViewer.CLOSE_RESTART));
		}
		private function ON_OPEN_RESTART(e:Event):void{
			super.dispatchEvent(new Event(PlayViewer.OPEN_RESTART));
		}
		public function getAnswere():Boolean{
			return playerViewer.getAnswere();
		}
	}
}
