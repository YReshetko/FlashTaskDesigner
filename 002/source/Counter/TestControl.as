package source.Counter {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.Event;
	
	public class TestControl extends Sprite{
		public static var HYBRID_TYPE:int = 0;
		public static var TEST_TYPE:int = 1;
		public static var SIMPLE_TYPE:int = 2;
		
		private var pointContainer:Sprite = new Sprite();
		private var pointMask:Sprite = new Sprite();
		
		public static var hPoints:Number = 30;
		private var wPoints:Number = 100;
		
		private var subWidth:int = 0;
		private var field:TextField;
		private var points:AddedPoints;
		public function TestControl(value:Sprite) {
			super();
			value.addChild(super);
			super.addChild(pointContainer);
			super.addChild(pointMask);
			pointContainer.mask = pointMask;
			drawMask();
		}
		override public function set width(value:Number):void{
			wPoints = value - subWidth;
			drawMask();
		}
		override public function get width():Number{
			return wPoints;
		}
		private function drawMask():void{
			pointMask.graphics.clear();
			pointMask.graphics.lineStyle(1, 0, 0);
			pointMask.graphics.beginFill(0, 1);
			pointMask.graphics.drawRect(0,0,wPoints,hPoints);
			pointMask.graphics.endFill();
		}
		
		/*
			value.type - тип пакета описывается константами данного класса
				- HYBRID_TYPE - гибридный пакет
				- TEST_TYPE - тестовый пакет
				- SIMPLE_TYPE - одиночное задание (возможно с подводящими)
			value.tasks - массив заданий 
			value.partition - разбиение на части
		*/
		public function set counter(value:Object):void{
			trace('Init Counter...');
			switch(value.type){
				case HYBRID_TYPE:
					initField();
					trace('Hybrid...');
					pointContainer.x = subWidth;
					pointMask.x = subWidth;
					
					initPoints();
					points.test = value;
				break;
				case TEST_TYPE:
					initPoints();
					points.test = value;
				break;
				case SIMPLE_TYPE:
					initField();
				break;
			}
		}
		
		
		
		/*
			value.type - тип пакета описывается константами данного класса
				- HYBRID_TYPE - гибридный пакет
				- TEST_TYPE - тестовый пакет
				- SIMPLE_TYPE - одиночное задание (возможно с подводящими)
			value.CurrentTask - номер текущего сданного задания
			value.CurrentStatus - логическая переменная сдано задание или нет
		*/
		public function set complateTask(value:Object):void{
			switch(value.type){
				case HYBRID_TYPE:
					points.complate = value;
				break;
				case TEST_TYPE:
					points.complate = value;
				break;
				case SIMPLE_TYPE:
				break;
			}
		}
		
		/*
			value.type - тип пакета описывается константами данного класса
				- HYBRID_TYPE - гибридный пакет
				- TEST_TYPE - тестовый пакет
				- SIMPLE_TYPE - одиночное задание (возможно с подводящими)
			value.CurrentTask - номер текущего сданного задания
			value.CurrentStatus - логическая переменная сдано задание или нет
			value.NextTask - номер следующего задания
			value.TreePosition - позиция задания в дереве
			value.GoToNextTree - логическая переменная для смены заданий в гибридном пакете
		*/
		public function set goToTask(value:Object):void{
			switch(value.type){
				case HYBRID_TYPE:
					field.text = value.TreePosition;
					if(value.GoToNextTree){
						points.task = value.NextTask;
					}
				break;
				case TEST_TYPE:
					points.task = value.NextTask;
				break;
				case SIMPLE_TYPE:
					field.text = value.TreePosition;
				break;
			}
		}
		private function initPoints():void{
			trace('Init Points...');
			points = new AddedPoints(pointContainer);
			points.addEventListener(AddedPoints.GO_TO_POSITION, POINTS_TO_POSITION);
		}
		private function initField():void{
			trace('Init Field...');
			subWidth = 60;
			width = wPoints;
			field = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 15;
			format.bold = true;
			format.align = TextFormatAlign.LEFT;
			field.width = subWidth;
			field.height = 30;
			field.defaultTextFormat = format;
			super.addChild(field);
			field.mouseEnabled = false;
			
		}
		private function POINTS_TO_POSITION(event:Event):void{
			if(points.width>this.width){
				if(points.position>this.width/2){
					if(Math.abs(points.x)+this.width<points.width){
						super.addEventListener(Event.ENTER_FRAME, ANIMATION_TO_POSITION);
					}
				}
			}
		}
		private function ANIMATION_TO_POSITION(event:Event):void{
			//points.position
			var newPosition:Number = Math.abs(points.x)+this.width/2 - points.position;
			if(Math.abs(newPosition)>0.5){
				points.x +=  (newPosition)/5;
			}else{
				//points.x =  newPosition;
				super.removeEventListener(Event.ENTER_FRAME, ANIMATION_TO_POSITION);
			}
		}
	}
	
}
