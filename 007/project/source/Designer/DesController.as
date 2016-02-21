package source.Designer {
	import flash.display.Sprite;
	import alternativa.engine3d.core.View;
	import flash.events.TextEvent;
	import flash.events.Event;
	import source.Designer.LoaderPackage.LoadPict;
	import flash.events.ErrorEvent;
	
	public class DesController {
		private var mainSprite:Sprite;
		private var myModel:DesModel;
		private var myView:DesView;
		
		private var currentID:int;
		
		private var picLoader:LoadPict = new LoadPict();
		public function DesController(mainSprite:Sprite) {
			this.mainSprite = mainSprite;
			myModel = new DesModel();
			myView = new DesView(myModel);
			
			this.mainSprite.addChild(myView);
			
			addListeners();
		}
		private function addListeners(){
			myView.addEventListener(TextEvent.TEXT_INPUT, VIEW_TEXT_INPUT);
			myView.addEventListener(Event.COMPLETE, VIEW_CHANGE);
			
			picLoader.addEventListener(Event.CHANGE, PIC_LOADER_COMPLATE);
			picLoader.addEventListener(Event.CANCEL, PIC_LOADER_CANCEL);
			picLoader.addEventListener(ErrorEvent.ERROR, PIC_LOADER_ERROR);
		}
		private function VIEW_TEXT_INPUT(e:TextEvent){
			myModel.setColumnLine(myView.getColLine()[0],myView.getColLine()[1]);
		}
		private function VIEW_CHANGE(e:Event){
			
			currentID = myView.getActiveID();
			picLoader.openFile();
		}
		private function PIC_LOADER_COMPLATE(e:Event){
			var arr:Array = picLoader.getData();
			myModel.setPict(currentID,arr[0],arr[1]);
		}
		private function PIC_LOADER_CANCEL(e:Event){}
		private function PIC_LOADER_ERROR(e:ErrorEvent){
			trace("Class DesController: PICT LOAD ERROR");
		}
		public function getTaskSettings():String{
			var parArr:Array = myModel.getModel();
			var i:int;
			var outStr:String = "";
			outStr += "<COLCOLUMN>"+parArr[0]+"</COLCOLUMN>\r\n";
			outStr += "<COLLINE>"+parArr[1]+"</COLLINE>\r\n";
			for(i=0;i<parArr[2].length;i++){
				if(parArr[2][i].length!=0){
					outStr += "<IMAGE ID='"+i+"'>"+parArr[2][i][0]+"</IMAGE>\r\n";
				}
			}
			return outStr;
		}
	}
	
}
