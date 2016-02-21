package source.Designer {
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Designer.InteractiveObject.CreateIcon;
	import source.Designer.InteractiveObject.CreatePanel;
	import flash.events.TextEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import source.Designer.Viewer3D.Controller3D;
	
	public class DesView extends Sprite{
		private var myModel:DesModel;
		
		private var wScene:int;
		private var hScene:int;
		
		private var xCenter:int;
		private var yCenter:int;
		
		private var numCol:int;
		private var numLin:int;
		private var bitMapArr:Array;
		
		private var arrIcon:Array = new Array;
		private var wIcon:int;
		private var hIcon:int;
		private var activeIconID:int;
		
		private var viewSprite:Sprite = new Sprite;
		private var iconSprite:Sprite = new Sprite;
		
		private var panelSprite:Sprite = new Sprite;
		private var settPanel:CreatePanel;
		
		private var viewController:Controller3D;
		public function DesView(_model:DesModel) {
			super();
			myModel = _model;
			super.addChild(viewSprite);
			super.addChild(iconSprite);
			super.addChild(panelSprite);
			
			wScene = myModel.getScene()[0];
			hScene = myModel.getScene()[1];
			
			addSettingsPanel();
			viewController = new Controller3D(wScene, hScene, viewSprite);
			
			myModel.addEventListener(Event.CHANGE, MODEL_LISTENER);
			MODEL_LISTENER(null);
		}
		private function addSettingsPanel(){
			settPanel = new CreatePanel(myModel.getModel()[0],myModel.getModel()[1]);
			panelSprite.addChild(settPanel);
			settPanel.x = (wScene - settPanel.width)/2;
			settPanel.y = hScene - settPanel.height;
			settPanel.addEventListener(TextEvent.TEXT_INPUT, PANEL_TEXT_INPUT);
		}
		private function MODEL_LISTENER(e:Event){
			var arr:Array = myModel.getModel();
			numCol = arr[0];
			numLin = arr[1];
			bitMapArr = arr[2];
			
			reloadIcon();
			replaceIcon();
			
			viewController.updateScene(createObject3D());
		}
		private function reloadIcon(){
			var i:int;
			var etLeng:int
			if(numLin>=numCol){
				etLeng = Math.round( ( ( hScene-(hScene/3) ) /3) /numLin);
			}else{
				etLeng = Math.round( ( ( wScene-(wScene/3) ) /3) /numCol);
			}
			while(arrIcon.length>0){
				arrIcon[0].removeEventListener(Event.CHANGE, ICON_CHANGE);
				iconSprite.removeChild(arrIcon[0]);
				arrIcon.shift();
			}
			for(i=0;i<6;i++){
				if(bitMapArr[i]!=""){
					arrIcon.push(new CreateIcon(numCol, numLin, etLeng, getBitmap(bitMapArr[i][1], null)));
				}else{
					arrIcon.push(new CreateIcon(numCol, numLin, etLeng));
				}
				iconSprite.addChild(arrIcon[i]);
				arrIcon[i].addEventListener(Event.CHANGE, ICON_CHANGE);
			}
		}
		private function replaceIcon(){
			if(numLin>=numCol){
				arrIcon[2].y = hScene - arrIcon[2].height;
				arrIcon[1].y = arrIcon[2].y/2;
				
				arrIcon[5].y = hScene - arrIcon[5].height;
				arrIcon[4].y = arrIcon[5].y/2;
				
				arrIcon[3].x = arrIcon[4].x = arrIcon[5].x = wScene - arrIcon[3].width;
			}else{
				arrIcon[2].x = wScene - arrIcon[2].width;
				arrIcon[1].x = arrIcon[2].x/2;
				
				arrIcon[5].x = wScene - arrIcon[5].width;
				arrIcon[4].x = arrIcon[5].x/2;
				
				arrIcon[3].y = arrIcon[4].y = arrIcon[5].y = hScene - arrIcon[3].height;
			}
		}
		private function getBitmap(bmp:Bitmap, rect:Rectangle):BitmapData{
			var bmpData:BitmapData = new BitmapData(bmp.width, bmp.height, true, 0xFFFFFFFF);
			bmpData.draw(bmp, new Matrix(), null, null, rect, false);
			return bmpData;
		}
		private function PANEL_TEXT_INPUT(e:TextEvent){
			var arr:Array = settPanel.getSettings();
			numCol = arr[0];
			numLin = arr[1];
			super.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT));
		}
		public function getColLine():Array{
			return [numCol, numLin];
		}
		
		private function ICON_CHANGE(e:Event){
			var i:int;
			//trace("Class DesView: DISPATCH OPEN WINDOW");
			for(i=0;i<arrIcon.length;i++){
				if(arrIcon[i].getActive()){
					activeIconID = i;
					super.dispatchEvent(new Event(Event.COMPLETE));
					arrIcon[i].setDisactive();
					return;
				}
			}
		}
		public function getActiveID():int{
			return activeIconID;
		}
		private function createObject3D():Object{
			var outObj:Object = new Object();
			var i:int;
			outObj.colColumn = numCol;
			outObj.colLine = numLin;
			outObj.arrBmpData = new Array;
			for(i=0;i<bitMapArr.length;i++){
				if(bitMapArr[i]!=""){
					outObj.arrBmpData.push(getBitmap(bitMapArr[i][1], null))
				}else{
					outObj.arrBmpData.push(null);
				}
			}
			return outObj;
		}
	}
	
}
