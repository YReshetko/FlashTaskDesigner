package source.BlockOfTask.Task {
	import source.BlockOfTask.Task.TaskObjects.Palitra.TaskPalitra;
	import source.BlockOfTask.Task.TaskObjects.Palitra.Brush;
	import source.BlockOfTask.Task.TaskObjects.ClassicTan.ControlClassic;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.BlockOfTask.Task.TaskObjects.UserTan.ControlUserTan;
	import source.BlockOfTask.Task.TaskObjects.PictureTan.ControllerPicture;
	import source.PlayerLib.Library;
	import source.BlockOfTask.Task.TaskObjects.Label.LabelController;
	import source.BlockOfTask.Task.TaskObjects.TransferField.FieldControl;
	import source.BlockOfTask.Task.TaskObjects.Mark.MarkController;
	import source.BlockOfTask.Task.TaskObjects.Points.PointsController;
	import source.BlockOfTask.Task.TaskObjects.Swf.SwfController;
	import source.BlockOfTask.Task.TaskObjects.Swf.SwfObject;
	import source.BlockOfTask.Task.TaskObjects.Line.LineController;
	import source.BlockOfTask.Task.TaskObjects.Table.TableController;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import source.utils.Icons.CreateIcon;
	import flash.ui.Mouse;
	import source.BlockOfTask.Task.TaskObjects.CheckBox.CheckBoxController;
	import source.BlockOfTask.Task.TaskObjects.GroupField.GroupFieldController;
	import source.BlockOfTask.Task.TaskObjects.UserButton.ControllerUserButton;
	import flash.geom.Point;
	import source.BlockOfTask.Task.TaskObjects.ShiftField.ShiftFieldController;
	import source.BlockOfTask.Task.TaskObjects.Background.Background;
	import flash.geom.Rectangle;
	import source.BlockOfTask.Task.TaskObjects.PaintPicture.PaintMainController;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisController;
	import flash.utils.ByteArray;
	
	public class SeparatTask extends LayersTask{
		public static var CHECK_TASK:String = 'onCheckTask';
		public static var TASK_COMPLATE:String = 'onTaskComplate';
		public static var GET_LABEL_ANIMATION:String = 'onGetLabelAnimation';
		
		private var task:XMLList;
		private var taskName:String;
		private var uniqu:Boolean = false;
		private var icons:Boolean = false;
		private var health:int = 0;
		private var timer:String = '';
		private var diap:int = 20;
		private var mnimoe:Boolean = false;
		private var libContent:Library;
		private var flashFiles:String;
		private var delBut:Array;
		
		private var currentIcon:CreateIcon;
		public function SeparatTask(task:XMLList, container:Sprite, lib:Library, flashFiles:String) {
			Mouse.show();
			super(container);
			this.task = task;
			this.flashFiles = flashFiles;
			libContent = lib;
			//trace(this + ': XML TASK:\n' + task);
			baseSettings();
			if(task.OBJECTS.toString()!=''){
				addObject(task.OBJECTS);
			}
			if(icons) addIcon();
			if(task.MARKCOUNTER.toString()!=''){
				if(this.markControl != null){
					this.markControl.openCounter = task.MARKCOUNTER.toString() == 'true';
					var point:Point = new Point(parseFloat(task.MARKCOUNTER.@x.toString()), parseFloat(task.MARKCOUNTER.@y.toString()));
					this.markControl.counterPosition = point;
				}
			}
		}
		private function baseSettings():void{
			taskName = task.NAME.toString();
			var layer:String = task.LAYERS.toString();
			if(layer!='') super.setLinkArray(layer);
			uniqu = task.UNIQU.toString()=='true';
			icons = task.ICONS.toString()=='true';
			if(task.HEALTH.toString()!='') health = parseInt(task.HEALTH);
			if(task.TIMER.toString()!='') timer = task.TIMER.toString();
			if(task.DIAP.toString()!='') diap = parseInt(task.DIAP);
			mnimoe = task.MNIMOE.toString()=='true';
			if(task.DELBUT.toString()!='') delBut = task.DELBUT.toString().split(',');
		}
		public function get removeButton():Array{
			if(delBut == null) return null;
			return delBut;
		}
		public function getTime():String{
			return timer;
		}
		public function getHealth():int{
			return health;
		}
		
		
		
		private function addObject(inXml:XMLList):void{
			var str:String;
			var outXml:XMLList;
			for each(var sample:XML in inXml.elements()){
				str = sample.name().toString();
				outXml = new XMLList(sample);
				switch(str){
					case 'PALITRA':
						addPalitra(outXml);
					break;
					case 'CLASSIC':
						addClassic(outXml);
					break;
					case 'USERTAN':
						addUserTan(outXml);
					break;
					case 'PICTURETAN':
						addPictureTan(outXml);	
					break;
					case 'LABEL':
						addLabel(outXml);	
					break;
					case 'CHECKBOX':
						addField(outXml);
					break;
					case 'MARK':
						addMark(outXml);
					break;
					case 'POINTDRAW':
						addPoint(outXml);
					break;
					case 'SWFOBJECT':
						addSwf(outXml);
					break;
					case 'LINE':
						addLine(outXml);
					break;
					case 'TABLE':
						addTable(outXml);
					break;
					case 'TABLEDIF':
						addTableDiff(outXml);
					break;
					case 'CHOICEBOX':
						addCheckBox(outXml);
					break;
					case 'GROUPFIELD':
						addGroupField(outXml);
					break;
					case 'BUTTON':
						addUserButton(outXml);
					break;
					case 'SHIFTFIELD':
						addShiftField(outXml);
					break;
					case 'BACKGROUND':
						new Background(outXml, super.backgroundContainer, this.libContent);
					break;
					case 'PAINT':
						addPaintPicture(outXml);
					break;
					case 'CHARIS':
						addCharisProgram(outXml, this.libContent);
					break;
				}
			}
			isPaint();
			isEntaerArea();
			isDifference();
			labelRecount();
			startCheckTask();
		}
		
		
		
		/*
			Методы и переменные связанные с работой палитры цветов
		*/
		private var palitra:TaskPalitra;
		private var brush:Brush;
		private function addPalitra(xml:XMLList):void{
			Mouse.hide();
			palitra = new TaskPalitra(xml, super.colorPicker);
			brush = new Brush(super.brushContainer, palitra.color);
			brush.startDrag(true);
			brush.mouseEnabled = false;
			palitra.addEventListener(TaskPalitra.CURRENT_COLOR_CHANGE, CHANGE_BRUSH_COLOR);
		}
		private function CHANGE_BRUSH_COLOR(e:Event):void{
			brush.color = e.target.color;
		}
		/*
			Методы и переменные связанные с работой системы классических танов
		*/
		private var classikTan:ControlClassic;
		private function addClassic(xml:XMLList):void{
			classikTan = new ControlClassic(xml, super.getNamedSprite('Компл. таны (Ч)'), super.getNamedSprite('Компл. таны (Ц)'));
			classikTan.inJump = this.diap;
			classikTan.addEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
		}
		/*
			Методы и переменные связанные с работой системы пользовательских танов
		*/
		private var userTan:ControlUserTan;
		private function addUserTan(xml:XMLList):void{
			if(userTan == null){	
				userTan = new ControlUserTan(super.getNamedSprite('Польз. таны (Ч)'), super.getNamedSprite('Польз. таны (Ц)'), libContent);
				userTan.inJump = this.diap;
				userTan.inUniq = this.uniqu;
				userTan.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
				userTan.addEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
			}
			userTan.addTan(xml);
			
		}
		/*
			Методы и переменные связанные с работой системы танов-картинок
		*/
		private var pictureTan:ControllerPicture;
		private function addPictureTan(xml:XMLList):void{
			if(pictureTan == null)	{
				pictureTan = new ControllerPicture(super.getNamedSprite('Картинки таны (Ц)'), super.getNamedSprite('Картинки таны (Ч)'), libContent);
				pictureTan.inJump = this.diap;
				pictureTan.inUniq = this.uniqu;
				pictureTan.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			pictureTan.addTan(xml);
		}
		/*
			Методы и переменные связанные с работой системы рисования растровых изображений
		*/
		private var paintPicture:PaintMainController;
		private function addPaintPicture(xml:XMLList):void{
			if(paintPicture == null){
				paintPicture = new PaintMainController(super.getNamedSprite('Рисование изображений'), libContent);
			}
			paintPicture.addPaint(xml);
		}
		/*
			Методы и переменные связанные с работой полей группировки танов
		*/
		private var groupFieldController:GroupFieldController;
		private function addGroupField(xml:XMLList):void{
			if(groupFieldController == null){
				groupFieldController = new GroupFieldController(super.getNamedSprite('Групповое поле (Ц)'), super.getNamedSprite('Групповое поле (Ч)'), libContent);
				groupFieldController.inJump = this.diap;
				groupFieldController.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			groupFieldController.addGroupField(xml);
		}
		/*
			Методы и переменные связанные с работой системы надписей
		*/
		private var labelControl:LabelController;
		private function addLabel(xml:XMLList):void{
			if(labelControl == null)	{
				labelControl = new LabelController(super.getNamedSprite('Надписи'), super.getNamedSprite('Картинки таны (Ц)'), super.getNamedSprite('Картинки таны (Ч)'));
				labelControl.inJump = this.diap;
				labelControl.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			labelControl.addLabel(xml);
		}
		/*
			Методы и переменные связанные с работой системы перечисляемых полей
		*/
		private var fieldControl:FieldControl;
		private function addField(xml:XMLList):void{
			if(fieldControl == null)	{
				fieldControl = new FieldControl(super.getNamedSprite('Перечисл. поля'));
				fieldControl.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			fieldControl.addField(xml);
		}
		/*
			Методы и переменные связанные с работой системы областей выделения
		*/
		private var markControl:MarkController;
		private function addMark(xml:XMLList):void{
			if(markControl == null)	{
				markControl = new MarkController(super.getNamedSprite('Области выделения'));
				markControl.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			markControl.addMark(xml);
		}
		/*
			Методы и переменные связанные с работой системы точек соединения
		*/
		private var pointControl:PointsController;
		private function addPoint(xml:XMLList):void{
			if(pointControl == null)	{
				pointControl = new PointsController(super.getNamedSprite('Точки соединения'));
				pointControl.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			pointControl.addPoint(xml);
		}
		/*
			Методы и переменные связанные с работой системы swf объектов
		*/
		private var swfControl:SwfController;
		private function addSwf(xml:XMLList):void{
			if(swfControl == null)	{
				swfControl = new SwfController(super.getNamedSprite('SWF объекты'), super.getNamedSprite('SWF таны (Ц)'), super.getNamedSprite('SWF таны (Ч)'), libContent, flashFiles);
				swfControl.inJump = this.diap
				swfControl.addEventListener(SwfObject.CLOSE_RESTART, ON_CLOSE_RESTART);
				swfControl.addEventListener(SwfObject.OPEN_RESTART, ON_OPEN_RESTART);
			}
			swfControl.addSwf(xml);
		}
		private function ON_CLOSE_RESTART(e:Event):void{
			super.dispatchEvent(new Event(SwfObject.CLOSE_RESTART));
		}
		private function ON_OPEN_RESTART(e:Event):void{
			super.dispatchEvent(new Event(SwfObject.OPEN_RESTART));
		}
		/*
			Методы и переменные связанные с работой системы линий
		*/
		private var lineControl:LineController;
		private function addLine(xml:XMLList):void{
			if(lineControl == null)	lineControl = new LineController(super.getNamedSprite('Линии'));
			lineControl.addLine(xml);
		}
		/*
			Методы и переменные связанные с работой системы таблиц
		*/
		private var tableControl:TableController;
		private function addTable(xml:XMLList):void{
			if(tableControl == null)	{
				tableControl = new TableController(super.getNamedSprite('Таблицы'));
				tableControl.addEventListener(TableController.PRASS_SELECT, TABLE_FRAME_SELECT);
			}
			tableControl.addTable(xml);
		}
		private function addTableDiff(xml:XMLList):void{
			if(tableControl == null)	tableControl = new TableController(super.getNamedSprite('Таблицы'));
			tableControl.addLabel(xml);
		}
		/*
			Методы и переменные связанные таблицей выбора вариантов ответов
		*/
		private var checkBoxController:CheckBoxController;
		private function addCheckBox(xml:XMLList):void{
			if(checkBoxController == null) {
				checkBoxController = new CheckBoxController(super.getNamedSprite('Выбор ответов'));
				checkBoxController.addEventListener(GET_LABEL_ANIMATION, START_LABEL_ANIMATION);
			}
			checkBoxController.addCheckBox(xml);
		}
		/*
			Методы и переменные связанные с кнопками задания
		*/
		private var userButtonController:ControllerUserButton;
		private var remSettings:Object;
		public static var CLICK_USER_BUTTON:String = 'onClickUserButton';
		private function addUserButton(xml:XMLList):void{
			if(userButtonController == null){
				userButtonController = new ControllerUserButton(super.getNamedSprite('Кнопки'));
				userButtonController.addEventListener(ControllerUserButton.GET_BUTTON_SETTINGS, GET_BUTTON_SETTINGS);
			}
			userButtonController.addButton(xml);
		}
		private function GET_BUTTON_SETTINGS(event:Event):void{
			remSettings = userButtonController.buttonSettings;
			startLabelAnimation(remSettings.startAnimation);
			super.dispatchEvent(new Event(CLICK_USER_BUTTON));
		}
		public function get buttonSettings():Object{
			return remSettings;
		}
		/*
			Методы и переменные связанные с полями перестановки
		*/
		private var shiftFieldController:ShiftFieldController;
		private function addShiftField(xml:XMLList):void{
			if(shiftFieldController == null){
				shiftFieldController = new ShiftFieldController(super.getNamedSprite('Поля перестановки'), this.libContent);
				
			}
			shiftFieldController.addShiftField(xml);
		}
		/*
			Методы и переменные связанные с заданиям по ЧЯРис
		*/
		private var charisController:CharisController;
		private function addCharisProgram(xml:XMLList, lib:Library):void{
			if(charisController == null){
				charisController = new CharisController(super.getNamedSprite('ЧЯРис'));
			}
			var bytes:ByteArray = lib.getFile(xml.@content);
			charisController.addProgram(xml, bytes);
		}
		/*	
			Методы проверки состояния задания
			РАСКРАШИВАНИЕ, РАЗРЕЗАНИЕ, ПОСТАНОВКА...
		*/
		/*
			Проверка на раскрашенность танов
		*/
		private function PAINT_TAN(e:Event = null):void{
			if(brush!=null){
				if(e!=null){
					e.target.remObject.color = brush.color;
				}
				var F1:Boolean;
				var F2:Boolean;
				F1 = checkPaintComplate(classikTan);
				F2 = checkPaintComplate(userTan);
				if(F1 && F2){
					if(classikTan!=null) classikTan.endPaint();
					if(userTan != null) userTan.endPaint();
					palitra.clear();
					palitra.removeEventListener(TaskPalitra.CURRENT_COLOR_CHANGE, CHANGE_BRUSH_COLOR);
					palitra = null;
					brush.clear();
					brush = null;
					Mouse.show();
					LISTENER_CHECK_TASK(null);
				}
			}
		}
		private function checkPaintComplate(obj):Boolean{
			if(obj != null){
				if(obj.isPaintComplate()) return true;
				else return false;
			}
			return true;
		}
		private function isPaint():void{
			if(classikTan!=null){
				if(classikTan.paint){
					classikTan.enabledTan();
					if(userTan!=null)userTan.enabledTan();
					return;
				}
			}
			if(userTan!=null){
				if(userTan.paint){
					userTan.enabledTan();
					if(classikTan!=null) classikTan.enabledTan();
					return;
				}
			}
			PAINT_TAN();
		}
		
		private function addIcon():void{
			var outArray:Array = new Array();
			var i:int;
			for(i=0;i<11;i++) outArray.push(false);
			if(classikTan!=null){
				if(classikTan.isDrag) outArray[0] = true;
				if(classikTan.isRotation) outArray[1] = true;
				if(classikTan.paint) outArray[2] = true;
				if(classikTan.isSpace) outArray[9] = true;
			}
			if(userTan!=null){
				if(userTan.isDrag) outArray[0] = true;
				if(userTan.isRotation) outArray[1] = true;
				if(userTan.paint) outArray[2] = true;
				if(userTan.isSpace) outArray[9] = true;
			}
			if(pictureTan!=null){
				if(pictureTan.isDrag) outArray[0] = true;
				if(pictureTan.isRotation) outArray[1] = true;
			}
			if(labelControl!=null){
				if(labelControl.isDrag) outArray[0] = true;
				if(labelControl.isInput) outArray[6] = true;
			}
			if(fieldControl!=null){
				if(fieldControl.isTransfer) outArray[3] = true;
			}
			if(markControl!=null){
				if(markControl.isOneClick) outArray[4] = true;
				if(markControl.isDoubleClick) outArray[5] = true;
			}
			if(pointControl!=null){
				if(pointControl.isDraw) outArray[7] = true;
			}
			if(swfControl!=null){
				if(swfControl.isDrag) outArray[0] = true;
			}
			if(tableControl!=null){
				if(tableControl.isArea) {
					outArray[8] = true;
					outArray[0] = false;
					outArray[1] = false;
				}
			}
			if(checkBoxController!=null){
				if(checkBoxController.machChoice) outArray[10] = true;
				if(checkBoxController.oneChoice) outArray[11] = true;
			}
			if(charisController!=null){
				if(charisController.iconIndex != -1) outArray[charisController.iconIndex] = true;
			}
			currentIcon = new CreateIcon(super.iconContainer, outArray);
		}
		/*
			Проверка таблиц на область внесения
		*/
		private function isEntaerArea():void{
			if(tableControl == null) return;
			var area:Array = tableControl.area;
			if(area == null) return;
			
			if(classikTan!=null) classikTan.area = area;
			if(userTan!=null)userTan.area = area;
			if(pictureTan!=null)pictureTan.area = area;
			if(labelControl!=null)labelControl.area = area;
			if(swfControl!=null)swfControl.area = area;
		}
		/*
			Проверка таблиц на закрывающиеся области для сравнения
		*/
		private function isDifference():void{
			if(tableControl == null) return;
			if(!tableControl.isDiff) return;
			if(markControl!=null){
				tableControl.markPosition = markControl.arrPosition;
			}else{
				tableControl.markPosition = null;
			}
			tableControl.addEventListener(TableController.IS_RIGHT_SELECT, ON_RIGHT_SELECT);
		}
		private function ON_RIGHT_SELECT(e:Event):void{
			var arrRect:Array = e.target.rectangle;
			if(markControl!=null)markControl.rectangle = arrRect;
		}
		
		/*
			Пересчёт формул в надписях
		*/
		private function labelRecount():void{
			if(this.labelControl!=null) this.labelControl.formulRecount();
		}
		
		
		/*
			Проверка постановки танов и выполненности всех элементов
		*/
		private function startCheckTask():void{
			if(classikTan!=null) classikTan.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(userTan!=null)userTan.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(pictureTan!=null)pictureTan.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(labelControl!=null){
				labelControl.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
				labelControl.setFocus();
			}
			if(fieldControl!=null)fieldControl.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(markControl!=null)markControl.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(pointControl!=null)pointControl.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(swfControl!=null)swfControl.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(tableControl!=null)tableControl.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(checkBoxController!=null) checkBoxController.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(groupFieldController!=null) groupFieldController.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(shiftFieldController!=null) shiftFieldController.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			if(charisController!=null) charisController.addEventListener(CHECK_TASK, LISTENER_CHECK_TASK);
			LISTENER_CHECK_TASK(null);
		}
		
		private function LISTENER_CHECK_TASK(e:Event):void{
			if(!isComplate()) return;
			trace(this + 'Task COMPLATE');
			super.dispatchEvent(new Event(TASK_COMPLATE));
		}
		public function isComplate():Boolean{
			//trace(this + ': IS COMPLATE START');
			if(classikTan!=null)if(!classikTan.stand) return false;
			//trace(this + ': IS COMPLATE STAP 1');
			if(userTan!=null)if(!userTan.stand) return false;
			//trace(this + ': IS COMPLATE STAP 2');
			if(pictureTan!=null)if(!pictureTan.stand) return false; 
			//trace(this + ': IS COMPLATE STAP 3');
			if(labelControl!=null)if(!labelControl.stand) return false; 
			//trace(this + ': IS COMPLATE STAP 4');
			if(fieldControl!=null)if(!fieldControl.stand) return false; 
			//trace(this + ': IS COMPLATE STAP 5');
			if(markControl!=null)if(!markControl.stand) return false;
			//trace(this + ': IS COMPLATE STAP 6');
			if(pointControl!=null)if(!pointControl.stand) return false;
			//trace(this + ': IS COMPLATE STAP 7');
			if(swfControl!=null)if(!swfControl.stand) return false;
			//trace(this + ': IS COMPLATE STAP 8');
			if(tableControl!=null)if(!tableControl.stand) return false;
			//trace(this + ': IS COMPLATE STAP 9');
			if(checkBoxController!=null) if(!checkBoxController.stand) return false;
			if(groupFieldController!=null) if(!groupFieldController.stand) return false;
			if(shiftFieldController!=null) if(!shiftFieldController.stand) return false;
			if(charisController!=null) if(!charisController.stand) return false;
			if(mnimoe)return false;
			//trace(this + ': IS COMPLATE FINALY');
			return true;
		}
		public function showAnswer():void{
			if(classikTan!=null) classikTan.showAnswer();
			if(userTan!=null) userTan.showAnswer();
			if(pictureTan!=null) pictureTan.showAnswer(); 
			if(labelControl!=null) labelControl.showAnswer(); 
			if(fieldControl!=null) fieldControl.showAnswer(); 
			if(markControl!=null) markControl.showAnswer();
			if(pointControl!=null) pointControl.showAnswer();
			/*if(swfControl!=null) ;
			if(tableControl!=null) ;*/
			if(checkBoxController!=null) checkBoxController.showAnswer();
			if(groupFieldController!=null) groupFieldController.showAnswer();
			if(charisController!=null) charisController.showAnswer();
			/*if(shiftFieldController!=null) ;*/
		}
		
		public function get isMnimoe():Boolean{
			return mnimoe;
		}
		
		
		
		//	Метод запуска анимаций в задании по метке
		private function START_LABEL_ANIMATION(event:Event):void{
			var inLabel:String = event.target.animationLabel;
			if(inLabel == '') return;
			if(userTan!=null) userTan.startLabelAnimation(inLabel);
			if(pictureTan!=null) pictureTan.startLabelAnimation(inLabel);
			if(labelControl!=null) labelControl.startLabelAnimation(inLabel);
			if(userButtonController!=null) userButtonController.startLabelAnimation(inLabel);
		}
		private function startLabelAnimation(inLabel:String):void{
			if(inLabel == '') return;
			if(userTan!=null) userTan.startLabelAnimation(inLabel);
			if(pictureTan!=null) pictureTan.startLabelAnimation(inLabel);
			if(labelControl!=null) labelControl.startLabelAnimation(inLabel);
			if(userButtonController!=null) userButtonController.startLabelAnimation(inLabel);
		}
		
		
		private function TABLE_FRAME_SELECT(event:Event):void{
			var flag:Boolean = false;
			var rect:Rectangle = this.tableControl.selectRectangle;
			if(markControl!=null){
				flag = flag || markControl.checkTableFrameSelect(rect);
			}
			if(fieldControl!=null){
				flag = flag || fieldControl.checkTableFrameSelect(rect);
			}
		}
	}
	
}
