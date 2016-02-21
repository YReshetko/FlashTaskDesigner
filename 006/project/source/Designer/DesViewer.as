package source.Designer {
	import flash.display.Sprite;
	import source.Utilites.PazzleEvent;
	import flash.events.Event;
	import source.FuncPanel.MainPlain;
	import source.FuncPanel.SamplePanel;
	import flash.events.MouseEvent;
	
	public class DesViewer extends UserInterface{
		private static const wDisplay:int = 730;
		private static const hDisplay:int = 494;
		
		private var arrSample:Array = new Array();
		
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
			MODEL_CHANGED(null);
		}
		private function MODEL_CHANGED(e:Event){
			trace(this + " MODEL IS CHANGED");
			var inObject:Object = pazzleModel.getSettings();
			super.setSettings(inObject);
			mainPlain.preparePanel(inObject);
			correctPosition();
			super.dispatchEvent(new Event(PazzleEvent.VIEW_CHANGED));
		}
		public function setPictArray(arr:Array){
			var i:int;
			for(i=0;i<arr.length;i++){
				mainPlain.addPicture(arr[i]);
			}
			addArrSample(pazzleModel.getImage());
		}
		private function addArrSample(inArr:Array){
			clearSample();
			var i:int;
			for(i=0;i<inArr.length;i++){
				arrSample[i] = new SamplePanel(inArr[i], i);
				arrSample[i].initButton();
				interfaceContainer.addChild(arrSample[i]);
				arrSample[i].x = arrSample[i].y = 20*i+30;
				arrSample[i].addEventListener(PazzleEvent.SAMPLE_CHANGED, MY_SAMPLE_CHANGE);
				arrSample[i].addEventListener(PazzleEvent.SAMPLE_REMOVE, MY_SAMPLE_REMOVE);
				arrSample[i].addEventListener(MouseEvent.MOUSE_UP, SAMPLE_MOUSE_UP);
			}
			SAMPLE_MOUSE_UP(null);
		}
		private function clearSample(){
			while(arrSample.length>0){
				interfaceContainer.removeChild(arrSample[0]);
				arrSample.shift();
			}
		}
		private function MY_SAMPLE_CHANGE(e:Event){
			var inObject:Object = e.target.getNewData();
			pazzleModel.addImage(inObject.bitmap, inObject.fileName);
			pazzleModel.removeImage(inObject.ID);
			MODEL_CHANGED(null);
		}
		private function MY_SAMPLE_REMOVE(e:Event){
			pazzleModel.removeImage(e.target.getID());
			MODEL_CHANGED(null);
		}
		private function correctPosition(){
			mainPlain.x = (wDisplay - mainPlain.width)/2;
			mainPlain.y = (hDisplay - mainPlain.height)/2;
		}
		private function SAMPLE_MOUSE_UP(e:MouseEvent){
			var i:int;
			var outArr:Array = new Array();
			for(i=0;i<arrSample.length;i++){
				outArr[i] = [arrSample[i].x, arrSample[i].y];
			}
			pazzleModel.setPositionSample(outArr);
		}
	}
	
}
