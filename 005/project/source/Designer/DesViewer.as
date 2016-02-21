package source.Designer {
	import flash.display.Sprite;
	import source.Utilites.PazzleEvent;
	import flash.events.Event;
	import source.FuncPanel.MainPlain;
	
	public class DesViewer extends UserInterface{
		private static const wDisplay:int = 730;
		private static const hDisplay:int = 494;
		
		private var planeContainer:Sprite = new Sprite;
		private var interfaceContainer:Sprite = new Sprite;
		private var pazzleModel:DesModel;
		private var mainPlain:MainPlain = new MainPlain();
		public function DesViewer(mainSprite:Sprite, pazzleModel:DesModel) {
			super(interfaceContainer);
			this.pazzleModel = pazzleModel;
			initContainers(mainSprite);
			initHandler();
		}
		private function initContainers(mainSprite:Sprite){
			mainSprite.addChild(planeContainer);
			mainSprite.addChild(interfaceContainer);
			planeContainer.addChild(mainPlain);
		}
		private function initHandler(){
			pazzleModel.addEventListener(PazzleEvent.MODEL_CHANGED, MODEL_CHANGED);
			pazzleModel.addEventListener(PazzleEvent.SIZE_CHANGED_MODEL, MODEL_SIZE_CHANGED);
			mainPlain.addEventListener(PazzleEvent.POSITION_CHANGED, POSITION_CHANGED);
		}
		private function MODEL_CHANGED(e:Event){
			var inObject:Object = pazzleModel.getSettings();
			super.setSettings(inObject);
		}
		public function setPictArray(arr:Array){
			var inObject:Object = pazzleModel.getSettings();
			mainPlain.setPicture(inObject.numLine, inObject.numColumn, arr);
			MODEL_SIZE_CHANGED(null);
			mainPlain.initPlayer();
			mainPlain.initHandler();
			correctPosition();
		}
		private function correctPosition(){
			mainPlain.x = (wDisplay - mainPlain.width)/2;
			mainPlain.y = (hDisplay - mainPlain.height)/2;
		}
		private function MODEL_SIZE_CHANGED(e:Event){
			var inObject:Object = pazzleModel.getSize();
			mainPlain.width = inObject.wPicture;
			mainPlain.height = inObject.hPicture;
			correctPosition();
			super.setSize(inObject);
		}
		private function POSITION_CHANGED(e:Event){
			pazzleModel.setArrPosition(mainPlain.getPosition());
		}
	}
	
}
