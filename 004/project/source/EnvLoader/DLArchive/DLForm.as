package source.EnvLoader.DLArchive {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import source.EnvComponents.EnvButton.SimpleButton;
	import source.MainEnvelope;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import source.EnvEvents.Events;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.filesystem.File;

	public class DLForm extends Sprite{
		private static const month:Array = new Array('января',
													 'февраля',
													 'марта',
													 'апреля',
													 'мая',
													 'июня',
													 'июля',
													 'августа',
													 'сентября',
													 'октября',
													 'ноября',
													 'декабря');
		private static const defaultFolder:int = 0;
		private static const defaultWinRARPath:String = 'C:\Program Files\WinRAR\WinRAR.exe';
		
		private var fieldRusName:TextField = new TextField();
		private var fieldEngName:TextField = new TextField();
		private var fieldAuthorName:TextField = new TextField();
		private var fieldGroup:TextField = new TextField();
		private var fieldDate:TextField = new TextField();
		private var fieldNumTask:TextField = new TextField();
		private var fieldTaskType:TextField = new TextField();
		private var fieldCheckBut:TextField = new TextField();
		private var fieldNumArchive:TextField = new TextField();
		private var file:File;
		
		private var format:TextFormat = new TextFormat();
		
		private var butSave:SimpleButton;
		private var butClose:SimpleButton;
		private var butWinRar:SimpleButton;
		
		private var formSO:SharedObject;
		private var winRarPath:String;
		
		
		public function DLForm() {
			super();
			initFormat();
			initForm();
			initSharedObjects();
			initHandler();
		}
		
		public function inc():void{
			var id:int = parseInt(fieldNumArchive.text);
			++id;
			fieldNumArchive.text = id.toString();
		}
		public function dec():void{
			var id:int = parseInt(fieldNumArchive.text);
			--id;
			fieldNumArchive.text = id.toString();
		}
		public function update():void{
			var date:Date = new Date();
			var currentDay:String = date.date.toString() + ' ' + month[date.month] + ' ' + date.fullYear.toString();
			fieldDate.text = currentDay;
			checkFilling();
			inc();
		}
		private function checkFilling():void{
			if(fieldRusName.text=='' || fieldAuthorName.text == ''){
				butSave.enabled(false);
			}else{
				butSave.enabled(true);
			}
		}
		
		public function get numFolder():int{
			return parseInt(fieldNumArchive.text);
		}
		public function set type(value:String):void{
			fieldTaskType.text = value;
		}
		public function set checkBut(value:String):void{
			fieldCheckBut.text = value;
		}
		public function set numPoint(value:int):void{
			fieldNumTask.text = value.toString();
		}
		public function get numPoint():int{
			return parseInt(fieldNumTask.text);
		}
		
		public function get rname():String{
			return fieldRusName.text;
		}
		public function get ename():String{
			return fieldEngName.text;
		}
		public function get author():String{
			return fieldAuthorName.text;
		}
		public function get group():String{
			return fieldGroup.text;
		}
		public function get date():String{
			return fieldDate.text;
		}
		public function get winrar():String{
			return winRarPath;
		}
		
		//	Инициализация внешнего вида формы
		private function initFormat():void{
			format.size = 15;
			format.bold = true;
			format.font = 'Times New Roman';
			format.align = TextFormatAlign.CENTER;
		}
		private function initForm():void{
			var numLine:int = 1;
			var label:TextField = getNewLabel('Название задания');
			setTextFormat(fieldRusName, 300, 22, label.width + 20, 0);
			label = getNewLabel('Task name', 0, 26*numLine);
			setTextFormat(fieldEngName, 300, 22, fieldRusName.x, 26*numLine);
			
			numLine = 2;
			label = getNewLabel('ФИО Автора', 0, 26*numLine);
			setTextFormat(fieldAuthorName, 200, 22, label.width + 10, 26*numLine);
			var newX:Number = fieldAuthorName.x + fieldAuthorName.width + 10;
			label = getNewLabel('группа', newX, 26*numLine);
			var newW:Number = (fieldRusName.x + fieldRusName.width) - (newX + label.width) - 10
			newX = label.x + label.width + 10;
			setTextFormat(fieldGroup, newW, 22, newX, 26*numLine);
			
			numLine = 3;
			label = getNewLabel('Дата:', 0, 26*numLine);
			setTextFormat(fieldDate, 100, 22, label.width + 10, 26*numLine);
			
			numLine = 4;
			label = getNewLabel('Баллов за задание:', 0, 26*numLine);
			setTextFormat(fieldNumTask, 50, 22, label.width + 10, 26*numLine);
			
			numLine = 5;
			label = getNewLabel('Тип задания:', 0, 26*numLine);
			setTextFormat(fieldTaskType, 100, 22, label.width + 10, 26*numLine);
			newX = fieldTaskType.x + fieldTaskType.width + 20;
			label = getNewLabel('кнопка проверки:', newX, 26*numLine);
			newW = (fieldRusName.x + fieldRusName.width) - (newX + label.width) - 10
			newX = label.x + label.width + 10;
			setTextFormat(fieldCheckBut, newW, 22, newX, 26*numLine);
			
			numLine = 6;
			label = getNewLabel('Номер архива:', 0, 26*numLine);
			setTextFormat(fieldNumArchive, 100, 22, label.width+10, 26*numLine);
			butWinRar = new SimpleButton(80, 22, 'WinRAR');
			super.addChild(butWinRar);
			butWinRar.y = 26*numLine;
			butWinRar.x = fieldNumArchive.x + fieldNumArchive.width + 30;
			fieldNumArchive.restrict = '0-9';
			
			numLine = 8;
			butSave = new SimpleButton(100, 22, 'Сохранить');
			butClose = new SimpleButton(100, 22, 'Закрыть');
			
			super.addChild(butSave);
			super.addChild(butClose);
			butClose.y = butSave.y = 26*numLine;
			newX = (super.width - 250)/2
			butSave.x = newX;
			butClose.x = newX +150;
			
			correctFields();
		}
		private function getNewLabel(value:String, X:Number = 0, Y:Number = 0):TextField{
			var label:TextField = new TextField();
			label.defaultTextFormat = format;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = value;
			super.addChild(label);
			label.x = X;
			label.y = Y;
			label.mouseEnabled = false;
			return label
		}
		private function setTextFormat(field:TextField, W:Number, H:Number, X:Number, Y:Number):void{
			super.addChild(field);
			field.height = H;
			field.width = W;
			field.x = X;
			field.y = Y;
			field.type = TextFieldType.INPUT;
			field.border = true;
			field.background = true;
			field.defaultTextFormat = format;
		}
		private function correctFields():void{
			fieldDate.border = fieldNumTask.border = fieldTaskType.border = fieldCheckBut.border = false;
			fieldDate.background = fieldNumTask.background = fieldTaskType.background = fieldCheckBut.background = false;
			fieldDate.type = fieldNumTask.type = fieldTaskType.type = fieldCheckBut.type = TextFieldType.DYNAMIC;
			fieldDate.mouseEnabled = fieldNumTask.mouseEnabled = fieldTaskType.mouseEnabled = fieldCheckBut.mouseEnabled = false;
			fieldDate.autoSize = fieldNumTask.autoSize = fieldTaskType.autoSize = fieldCheckBut.autoSize = TextFieldAutoSize.LEFT;
		}
		//	Инициализация слушателей
		private function initHandler():void{
			fieldRusName.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			fieldAuthorName.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			fieldAuthorName.addEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_CHANGE);
			fieldRusName.addEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_CHANGE);
			fieldAuthorName.addEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_CHANGE);
			fieldRusName.addEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_CHANGE);
			
			fieldGroup.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			fieldNumArchive.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			
			butSave.addEventListener(MouseEvent.CLICK, SAVE_MOUSE_CLICK);
			butClose.addEventListener(MouseEvent.CLICK, CLOSE_MOUSE_CLICK);
			
			butWinRar.addEventListener(MouseEvent.CLICK, WINRAR_MOUSE_CLICK);
		}
		private function FIELD_FOCUS_CHANGE(e:FocusEvent):void{
			checkFilling();
		}
		private function FIELD_KEY_DOWN(e:KeyboardEvent):void{
			var timer:Timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER, FIELD_TIMER);
			timer.start();
		}
		private function FIELD_TIMER(e:TimerEvent):void{
			checkFilling();
			rememberSharedObjects();
		}
		private function SAVE_MOUSE_CLICK(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.SAVE_TASK));
		}
		private function CLOSE_MOUSE_CLICK(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.WINDOW_CLOSE));
		}
		
		private function WINRAR_MOUSE_CLICK(e:MouseEvent):void{
			file = new File();
			file.browseForDirectory('Выберите каталог с архиватором WinRAR.exe');
			file.addEventListener(Event.SELECT, WINRAR_SELECT);
			file.addEventListener(Event.CANCEL, WINRAR_CANCEL);
		}
		private function WINRAR_SELECT(e:Event):void{
			WINRAR_CANCEL();
			var inFile:File = e.target as File;
			inFile = inFile.resolvePath(inFile.nativePath + '/WinRAR.exe');
			winRarPath = inFile.nativePath;
			rememberSharedObjects();
		}
		private function WINRAR_CANCEL(e:Event = null):void{
			file.removeEventListener(Event.SELECT, WINRAR_SELECT);
			file.removeEventListener(Event.CANCEL, WINRAR_CANCEL);
		}
		//	Инициализация сохранения объектов
		private function initSharedObjects():void{
			formSO = SharedObject.getLocal('Form');
			trace(this + ': SO ARCHIVE = |'+formSO.data.archive+'|');
			if(formSO.data.archive == undefined) fieldNumArchive.text = defaultFolder.toString();
			else fieldNumArchive.text = formSO.data.archive.toString();
			
			if(formSO.data.name != undefined) fieldAuthorName.text = formSO.data.name.toString();
			
			if(formSO.data.group != undefined) fieldGroup.text = formSO.data.group.toString();
			
			if(formSO.data.winrar == undefined) winRarPath = defaultWinRARPath;
			else winRarPath = formSO.data.winrar.toString();
		}
		private function rememberSharedObjects():void{
			delete formSO.data.archive;
			delete formSO.data.name;
			delete formSO.data.group;
			delete formSO.data.winrar;
			
			formSO.data.archive = fieldNumArchive.text;
			formSO.data.name = fieldAuthorName.text;
			formSO.data.group = fieldGroup.text;
			formSO.data.winrar = winRarPath;
			
			try{
				formSO.flush();
			}catch(e:Error){}
		}
	}
	
}
