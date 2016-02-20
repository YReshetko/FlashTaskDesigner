package source.Task.TaskLayers {
	import flash.display.Sprite;
	import flash.events.Event;
	import source.DesignerMain;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Layers extends Sprite{
		public static var LAYER_CHANGE:String = 'onLayerChange';
		
		private var headLayers:SampleLayer = new SampleLayer();
		private var arrLayer:Array = new Array();
		private var remLayer:SampleLayer;
		private var currentID:int;
		public function Layers() {
			super();
			super.addChild(headLayers);
			headLayers.text = 'Название слоя';
			headLayers.addEventListener(SampleLayer.LAYER_ENABLED, MASS_LAYERS_ENABLED);
			headLayers.addEventListener(SampleLayer.LAYER_VISIBLE, MASS_LAYERS_VISIBLE);
		}
		public function set container(value:Sprite):void{
			value.addChild(super);
		}
		public function set layer(value:Array):void{
			this.clear();
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				arrLayer.push(new SampleLayer());
				arrLayer[i].layer = value[i];
				super.addChild(arrLayer[i]);
				arrLayer[i].y = (i+1)*arrLayer[i].height;
				arrLayer[i].addEventListener(SampleLayer.LAYER_MOUSE_DOWN, ON_LAYER_MOUSE_DOWN);
				arrLayer[i].addEventListener(SampleLayer.LAYER_ENABLED, ONE_LAYER_ENABLED);
				arrLayer[i].addEventListener(SampleLayer.LAYER_VISIBLE, ONE_LAYER_VISIBLE);
				arrLayer[i].ID = i;
			}
		}
		private function clear():void{
			while(arrLayer.length>0) {
				super.removeChild(arrLayer[0]);
				arrLayer[0].clear();
				arrLayer.shift();
			}
		}
		
		
		private function ON_LAYER_MOUSE_DOWN(e:Event):void{
			var ID:int = e.target.ID;
			remLayer = arrLayer[ID] as SampleLayer;
			remLayer.startDrag(false, new Rectangle(0, remLayer.height, 0, super.height - 2*remLayer.height+5));
			super.setChildIndex(remLayer, super.numChildren-1);
			arrLayer.splice(ID, 1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, ON_LAYER_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, ON_LAYER_MOUSE_MOVE);
		}
		private function ON_LAYER_MOUSE_MOVE(e:MouseEvent):void{
			var i:int;
			var l:int;
			var j:int;
			var H:Number = remLayer.height;
			l = arrLayer.length;
			if(remLayer.y<=arrLayer[0].y){
				currentID = 0;
				for(i=0;i<l;i++){
					arrLayer[i].y = (i+2)*H;
				}
				return;
			}
			if(remLayer.y>arrLayer[l-1].y){
				currentID = l;
				for(i=0;i<l;i++){
					arrLayer[i].y = (i+1)*H;
				}
				return;
			}
			for(i=1;i<l;i++){
				if(remLayer.y>arrLayer[i-1].y && remLayer.y<=arrLayer[i].y){
					currentID = i;
					for(j=0;j<i;j++){
						arrLayer[j].y = (j+1)*H;
					}
					for(j=i;j<l;j++){
						arrLayer[j].y = (j+2)*H;
					}
					return;
				}
			}
		}
		private function ON_LAYER_MOUSE_UP(e:MouseEvent):void{
			remLayer.stopDrag();
			arrLayer.splice(currentID, 0, remLayer);
			correctID();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, ON_LAYER_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, ON_LAYER_MOUSE_MOVE);
			super.dispatchEvent(new Event(LAYER_CHANGE));
		}
		private function correctID():void{
			var i:int;
			var l:int;
			l = arrLayer.length;
			for(i=0;i<l;i++){
				arrLayer[i].ID = i;
				arrLayer[i].y = (i+1)*arrLayer[i].height;
			}
		}
		public function get transposition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrLayer.length;
			for(i=0;i<l;i++){
				outArr.push(arrLayer[i].idLayer);
			}
			return outArr;
		}
		
		private function MASS_LAYERS_ENABLED(event:Event):void{
			var i:int;
			var l:int;
			l = arrLayer.length;
			for(i=0;i<l;i++){
				arrLayer[i].enabled = !arrLayer[i].enabled;
			}
		}
		private function MASS_LAYERS_VISIBLE(event:Event):void{
			var i:int;
			var l:int;
			l = arrLayer.length;
			for(i=0;i<l;i++){
				arrLayer[i].visible = !arrLayer[i].visible;
			}
		}
		private function ONE_LAYER_ENABLED(event:Event):void{
			event.target.enabled = !event.target.enabled;
		}
		private function ONE_LAYER_VISIBLE(event:Event):void{
			event.target.visible = !event.target.visible;
		}
	}
	
}
