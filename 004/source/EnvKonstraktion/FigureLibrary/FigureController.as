package source.EnvKonstraktion.FigureLibrary {
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import source.EnvInterface.EnvPanel.Panel;
	import source.MainEnvelope;
	import flash.events.MouseEvent;
	import source.EnvUtils.EnvDraw.Figure;
	
	public class FigureController extends Sprite{
		public static var ADD_FIGURE:String = 'onAddFigure';
		private static const figureURL:String = 'DataBase/Figure.xml';
		private var inXml:XMLList;
		private var figureArr:Array = new Array();
		private var currentContent:Object;
		private var dragSample:Sprite = new Sprite();
		private var currentEvent:MouseEvent;
		private var inPanel:Panel;
		public function FigureController(panel:Panel) {
			super();
			inPanel = panel;
			panel.mainContainer.addChild(super);
			loadBaseFigure();
		}
		public function panelVisible():void{
			inPanel.visible = !inPanel.visible;
		}
		private function loadBaseFigure():void{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = figureURL;
			urlLoader.addEventListener(Event.COMPLETE, LOAD_BASE_COMPLATE);
			urlLoader.load(urlRequest);
		}
		private function LOAD_BASE_COMPLATE(event:Event):void{
			inXml = new XMLList(event.target.data);
			var ID:int;
			for each(var sample:XML in inXml.elements()){
				ID = figureArr.length;
				figureArr.push(new OneFigure(new XMLList(sample)));
				super.addChild(figureArr[ID]);
				if(ID == 0){
					figureArr[ID].x = figureArr[ID].width/2 + 10;
					figureArr[ID].y = figureArr[ID].height/2 + 10;
				}else{
					figureArr[ID].x = figureArr[ID].width/2 + 10;
					figureArr[ID].y = figureArr[ID-1].y + figureArr[ID-1].height/2 + figureArr[ID].height/2 + 10
				}
				figureArr[ID].addEventListener(OneFigure.FIGURE_SELECT, ONE_FIGURE_SELECT);
			}
		}
		private function ONE_FIGURE_SELECT(event:Event):void{
			currentContent = event.target.content;
			Figure.insertDiffCurve(dragSample, currentContent.data, 1, 1, 0x000000, 1, 0xEE00AA);
			MainEnvelope.STAGE.addChild(dragSample);
			dragSample.startDrag(true);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, FIGURE_MOUSE_UP);
		}
		private function FIGURE_MOUSE_UP(event:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, FIGURE_MOUSE_UP);
			currentEvent = event;
			super.dispatchEvent(new Event(ADD_FIGURE));
		}
		public function clear():void{
			currentContent = null;
			currentEvent = null;
			dragSample.graphics.clear();
			MainEnvelope.STAGE.removeChild(dragSample);
		}
		public function get event():MouseEvent{
			return currentEvent;
		}
		public function get sample():Sprite{
			return dragSample;
		}
		public function get content():Object{
			return currentContent;
		}

	}
	
}
