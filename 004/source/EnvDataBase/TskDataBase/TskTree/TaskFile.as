package source.EnvDataBase.TskDataBase.TskTree {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.display.InteractiveObject;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvEvents.Events;
	import source.MainEnvelope;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class TaskFile extends Sprite{
		//	переменная отстояния надписи от иконки
		private var xField:Number = 20;
		//	имя файла
		private var fileName:String;
		//	путь к физическому файлу
		private var filePath:String;
		//	иконка файла
		private var labelFile:fileTask;
		//	цвета выделения файла
		private static var defaultTextColor:uint = 0x000000;
		private static var selectTextColor:uint = 0xFF0000;
		private static var clickTextColor:uint = 0x0000FF;
		//	текстовое поле с именем файла
		private var fieldLabel:TextField = new TextField();
		//	спрайт клика по файлу
		private var listenSprite:Sprite = new Sprite();
		//	определение выделен ли файл
		private var isSelect:Boolean = false;
		public function TaskFile(name:String, taskID:Number) {
			super();
			//	запоминаем имя файла
			fileName = name;
			//	запоминаем путь к физическому файлу
			filePath = 'DataBase/Tasks/'+taskID+'.tsk/Position.txt';
			//	отрисовываем метку файла
			initLabel();
			//	слушаем нажатие на файл
			listenSprite.addEventListener(MouseEvent.MOUSE_DOWN, FILE_LEFT_MOUSE_DOWN);
			listenSprite.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, FILE_RIGHT_MOUSE_DOWN);
		}
		//	метод отрисовки метки файла
		private function initLabel():void{
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = 'Arial';
			fieldFormat.size = 12;
			fieldFormat.bold = true
			fieldLabel.textColor = defaultTextColor;
			fieldLabel.defaultTextFormat = fieldFormat;
			fieldLabel.autoSize = TextFieldAutoSize.LEFT;
			fieldLabel.text = fileName;
			fieldLabel.mouseEnabled = false;
			super.addChild(fieldLabel);
			fieldLabel.x = xField;
			labelFile = new fileTask();
			super.addChild(labelFile);
			Figure.insertRect(listenSprite, super.width, super.height, 1, 0, 0x000000, 0);
			super.addChild(listenSprite);
		}
		
		//	слушаем нажатие левой кнопки мыши
		private function FILE_LEFT_MOUSE_DOWN(e:MouseEvent):void{
			//	устанавливаем фокус на объекте клика
			MainEnvelope.STAGE.focus = listenSprite as InteractiveObject;
			//	устанавливаем цвет клика по файлу
			fieldLabel.textColor = clickTextColor;
			//	диспатчим событие клика
			super.dispatchEvent(new Event(Events.FILE_CLICK));
			//	слушаем снятие фокуса с файла
			listenSprite.addEventListener(FocusEvent.FOCUS_OUT, FILE_FOCUS_OUT);
		}
		//	метод снятия фокуса с файла
		private function FILE_FOCUS_OUT(e:FocusEvent):void{
			var timer:Timer = new Timer(100, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_FOCUS_OUT);
			//	удаление слушателя снятия фокуса
			listenSprite.removeEventListener(FocusEvent.FOCUS_OUT, FILE_FOCUS_OUT);
			timer.start();
		}
		private function TIMER_FOCUS_OUT(event:TimerEvent):void{
			//	изменить выделение файла
			changeSelect();
			//	диспатч снятия фокуса
			super.dispatchEvent(new Event(Events.FILE_FOCUS_OUT));			
		}
		//	метод слушателя клика правой кнопкой мыши
		private function FILE_RIGHT_MOUSE_DOWN(e:MouseEvent):void{
			//	устанавливаем фокус в данный объект
			MainEnvelope.STAGE.focus = listenSprite as InteractiveObject;
			//	устанавливаем выделение данного объекта
			setSelect();
		}
		//	метод установки цвета клика
		public function setClick():void{
			fieldLabel.textColor = clickTextColor;
		}
		//	метод снятия выделения с файла
		public function removeSelect():void{
			fieldLabel.textColor = defaultTextColor;
			isSelect = false;
		}
		//	метод изменения выделения файла
		public function setSelect():void{
			//	изменить метку выделения
			isSelect = !isSelect;
			//	перерисовать цвет выделения
			changeSelect();
		}
		//	метод перерисовки выделения
		private function changeSelect():void{
			if(isSelect){
				fieldLabel.textColor = selectTextColor;
				//	диспатч выделения файла
				super.dispatchEvent(new Event(Events.FILE_SELECT));
			}else{
				fieldLabel.textColor = defaultTextColor;
				//	диспатч снятия выделения с файла
				super.dispatchEvent(new Event(Events.FILE_DESELECT));
			}
		}
		//	метод получения физического пути к файлу с заданием
		public function getLink():Array{
			return [filePath, fileName];
		}
	}
	
}
