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
			playerModel.setXML(new XML(ParamXML.PAZZLE));
			pazzleLoader.loadUrl(content[0].byteArray);
		}
		private function LOAD_FILE_COMPLATE(e:Event){
			var pictData:Object = pazzleLoader.getData();
			var settings:Object = playerModel.getSettings();
			var image:Bitmap = Bitmap(pictData.Data);
			var copyImage:BitmapData = new BitmapData(image.width,image.height,true,0xffffffff);
			var imageData:BitmapData = new BitmapData(image.width,image.height,true,0xffffffff);
			copyImage.draw(image, new Matrix());
			imageData.draw(image, new Matrix());
			var pictArr:Array = CuterPict.cutPict(copyImage, settings.numColumn, settings.numLine);
			playerViewer.setPicture(pictArr, settings);
			playerViewer.setSample(imageData);
			addSettings();
		}
		private function addSettings(){
			var inObject:Object = playerModel.getAdditionalSettings();
			if(inObject.jump != 20) playerViewer.setJump(inObject.jump);
			if(inObject.helper != "WITH HELP") playerViewer.setHelp(inObject.helper);
			if(inObject.positioner == "AUTHOR POSITION") playerViewer.setUserPosition(inObject.arrPosition);
			if(inObject.positioner == "ONE COLUMN") playerViewer.setOneColumn();
			if(inObject.positioner == "AROUND FIELD") playerViewer.setAroundField();
		}
		private function initHandler(){
			pazzleLoader.addEventListener(PazzleEvent.LOAD_ONE_FILE, LOAD_FILE_COMPLATE);
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
