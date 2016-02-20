package source.Task.TaskObjects.PaintPicture {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	
	public class PaintMainController extends EventDispatcher{
		private var container:Sprite;
		private var arrPaints:Array = new Array();
		private var remTarget:PaintView;
		public function PaintMainController(container:Sprite) {
			super();
			this.container = container;
		}
		
		public function addPaint(xml:XMLList):void{
			var ID:int = arrPaints.length;
			arrPaints.push(new PaintObjectController(xml, this.container));
			arrPaints[ID].addEventListener(PaintView.GET_SETTINGS, PUSH_SETTINGS);
			/*
			arrMark[ID].addEventListener(OneMark.REMOVE_MARK, ON_REMOVE_MARK);
			arrMark[ID].addEventListener(OneMark.COPY_OBJECT, ON_COPY_OBJECT);
			arrMark[ID].addEventListener(OneMark.MARK_SET_CLASS, ON_SET_CLASS);
			arrMark[ID].selectContainer = dragContainer;
			recountCounter();*/
		}
		public function PUSH_SETTINGS(event:Event):void{
			remTarget = (event.target as PaintObjectController).object;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():PaintView{
			return remTarget;
		}
		
		public function set child(value:*):void{
			var remSprite:Sprite = value.tanColor;
			var i:int;
			var l:int;
			l = arrPaints.length;
			for(i=0;i<l;i++){
				if(remSprite.hitTestObject((arrPaints[i] as PaintObjectController).object)){
					(arrPaints[i] as PaintObjectController).setChild(value.content, value.fileName);
					value.removeTan();
					return;
				}
			}
		}
		
		/*public function get authorImages():Array{
			var outArray:Array = new Array();
			var i,l:int;
			l = arrPaints.length;
			for(i=0;i<l;i++){
				outArray.push((arrPaints[i] as PaintObjectController).authorImage);
			}
			return outArray;
		}*/
		public function get authorBitmap():Array{
			var outArray:Array = new Array();
			var i:int;
			var l:int;
			l = arrPaints.length;
			for(i=0;i<l;i++){
				outArray.push((arrPaints[i] as PaintObjectController).authorBitmap);
			}
			return outArray;
		}
		public function get authorByteArray():Array{
			var outArray:Array = new Array();
			var i:int;
			var l:int;
			l = arrPaints.length;
			for(i=0;i<l;i++){
				outArray.push((arrPaints[i] as PaintObjectController).authorByteArray);
			}
			return outArray;
		}
		public function get authorFileName():Array{
			var outArray:Array = new Array();
			var i:int;
			var l:int;
			l = arrPaints.length;
			for(i=0;i<l;i++){
				outArray.push((arrPaints[i] as PaintObjectController).authorFileName);
			}
			return outArray;
		}
		
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrPaints.length;
			for(i=0;i<l;i++){
				outArr.push(arrPaints[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
		

	}
	
}
