package source.Task {
	import flash.display.Sprite;
	import source.Task.TaskObjects.ClassicTan.ControlClassic;
	import source.Task.TaskSettings.SettingsSystem;
	import flash.events.Event;
	import source.Task.TaskObjects.Label.LabelController;
	import source.utils.TaskSettings;
	import source.utils.GetOutFileName;
	import source.Task.TaskObjects.Mark.MarkController;
	import source.Task.TaskObjects.Points.PointsController;
	import source.Task.TaskObjects.Table.TableController;
	import source.Task.TaskObjects.TransferField.FieldControl;
	import source.Task.TaskObjects.Line.LineController;
	import flash.utils.ByteArray;
	import source.Task.TaskObjects.PictureTan.ControllerPicture;
	import source.Task.TaskObjects.Swf.SwfController;
	import source.utils.ColorPicker.ColorPicker;
	import source.Task.TaskObjects.Palitra.TaskPalitra;
	import source.Task.TaskObjects.UserTan.ControlUserTan;
	import flash.display.Bitmap;
	import source.Task.TaskObjects.CheckBox.CheckBoxController;
	import source.Task.TaskObjects.GroupField.GroupFieldController;
	import source.Task.TaskObjects.UserButton.ControllerUserButton;
	import flash.geom.Point;
	import source.Task.TaskObjects.ShiftField.ShiftFieldController;
	import source.Task.TaskSceneControl.IconControl;
	import flash.net.SharedObject;
	import source.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.Task.TaskObjects.CoordinatePlane.CoordinateController;
	import source.Task.TaskObjects.PaintPicture.PaintMainController;
	import source.Task.TaskObjects.PictureTan.OnePictureTan;
	import source.DesignerMain;
	import source.Task.TaskObjects.CharisProgram.CharisController;
	
	public class OneTask extends InitLayers{
		public static var GET_OBJECT_SETTINGS:String = 'onGetObjectSettings';
		public static var CHECK_TAN_INPUT_FIELD:String = 'onCheckTanInputField';
		
		public static var LABEL:String = 'label';
		public static var MARK:String = 'mark';
		public static var LINE:String = 'line';
		public static var POINT:String = 'point';
		public static var TABLE:String = 'table';
		public static var FIELD:String = 'field';
		public static var SELECT:String = 'select';
		public static var CHECK:String = 'check';
		public static var GROUP_FIELD:String = 'groupField';
		public static var BUTTON:String = 'button';
		public static var SHIFT_FIELD:String = 'shiftField';
		public static var CORDINATE:String = 'cordinate';
		public static var PAINT:String = 'paintpanel';
		
		public var tName:String = 'Задание';
		public var tLevel:int = 1;
		public var tUniq:Boolean = true;
		public var taskIcon:Boolean = true;
		public var tUnderstand:Boolean = false;
		public var tRestart:Boolean = false;
		public var tDontkonw:Boolean = false;
		public var tMnimoe:Boolean = false;
		public var tJump:int = 20;
		public var tHealth:int = 0;
		public var tTimer:String = '00.00';
		public var isTimer:Boolean = false;
		
		private var classicControl:ControlClassic;
		private var userTanControl:ControlUserTan;
		private var labelControl:LabelController;
		private var markController:MarkController;
		private var pointController:PointsController;
		private var tableController:TableController;
		private var fieldController:FieldControl;
		private var lineController:LineController;
		private var pictureController:ControllerPicture;
		private var swfController:SwfController;
		private var checkBoxController:CheckBoxController;
		private var groupFieldController:GroupFieldController;
		private var coordinateController:CoordinateController;
		private var paintMainController:PaintMainController;
		private var charisController:CharisController;
		
		private var palitra:TaskPalitra;
		
		private var settingsSystem:SettingsSystem;
		private var colorPicker:ColorPicker;
		private var iconControl:IconControl;
		private var saveTempSettings:SharedObject;
		public function OneTask(settings:SettingsSystem, picker:ColorPicker) {
			super();
			settingsSystem = settings;
			colorPicker = picker;
			initStartSettingsTask();
			super.addEventListener(InitLayers.GET_OBJECTS_SETTINGS, SETTINGS_SELECT_OBJECTS);
			super.addEventListener(InitLayers.COPY_SELECTED_PACK, ON_COPY_SELECTED_PACK);
			super.addEventListener(InitLayers.DELETE_SELECTED_PACK, ON_DELETE_SELECTED_PACK);
			super.addEventListener(InitLayers.RESIZE_SELECT, ON_RESIZE_SELECT);
		}
		private function initStartSettingsTask():void{
			iconControl = new IconControl(super);
			saveTempSettings = SharedObject.getLocal('TempSettings');
			if(saveTempSettings.data.icons != undefined){
				tIcon = saveTempSettings.data.icons.toString()=='true';
			}
		}
		public function get levelAndName():Array{
			return [tLevel, tName];
		}
		public function setBaseSettings(inXml:XML, arrData:Array):void{
			tName = inXml.NAME.toString();
			tLevel = parseInt(inXml.@level);
			var layer:String = inXml.LAYERS.toString();
			if(layer!='') super.setLinkArray('('+layer+')');
			tUniq = inXml.UNIQU.toString()=='true';
			tIcon = inXml.ICONS.toString()=='true';
			if(inXml.HEALTH.toString()!='') tHealth = parseInt(inXml.HEALTH);
			if(inXml.TIMER.toString()!='') {
				tTimer = inXml.TIMER.toString();
				isTimer = true;
			}
			if(inXml.DIAP.toString()!='') tJump = parseInt(inXml.DIAP);
			tMnimoe = inXml.MNIMOE.toString()=='true';
			if(inXml.DELBUT.toString()!='') {
				var DelBut:Array = inXml.DELBUT.toString().split(',');
				if(DelBut[0]=='1') tUnderstand = true;
				if(DelBut[1]=='1') tRestart = true;
				if(DelBut[2]=='1') tDontkonw = true;
			}
			addObject(inXml.OBJECTS, arrData);
			if(inXml.MARKCOUNTER.toString()!='') {
				this.openMarkCounter = inXml.MARKCOUNTER.toString() == 'true';
				if(inXml.MARKCOUNTER.@x.toString()!='' && inXml.MARKCOUNTER.@y.toString()!=''){
					var outPoint:Point = new Point(parseFloat(inXml.MARKCOUNTER.@x.toString()), parseFloat(inXml.MARKCOUNTER.@y.toString()));
					this.markController.counterPosition = outPoint;
				}
			}
		}
		private function addObject(inXml:XMLList, arrData:Array):void{
			trace(this + ': IN DATA ARRAY = ' + arrData);
			var str:String;
			var outXml:XMLList;
			var ID:int;
			var arrContent:Array;
			for each(var sample:XML in inXml.elements()){
				//trace(this + ': XML SAMPLE = ' + sample)
				str = sample.name().toString();
				outXml = new XMLList(sample);
				switch(str){
					case 'PALITRA':
						this.addPalitra(outXml);
					break;
					case 'CLASSIC':
						this.addTaskComplect(outXml);
					break;
					case 'USERTAN':
						ID = GetOutFileName.getIDBitmapName(arrData, outXml.IMAGE.@name.toString());
						if(ID==-1){
							this.addUserTan(outXml);
						}else{
							this.addUserTan(outXml, null, arrData[ID][0], arrData[ID][1]);
						}
					break;
					case 'PICTURETAN':
						//trace(this + ': IN PICTURE = ' + outXml.IMAGE.toString());
						//trace(this + ': ARR DATA = ' + arrData);
						ID = GetOutFileName.getIDBitmapName(arrData, outXml.IMAGE.toString());
						//trace(this + ': ID = ' + ID);
						if(ID!=-1) this.addPicture(arrData[ID][1], outXml);	
					break;
					case 'LABEL':
						this.addLabel(outXml);	
					break;
					case 'CHECKBOX':
						this.addField(outXml);
					break;
					case 'MARK':
						this.addMark(outXml);
					break;
					case 'POINTDRAW':
						this.addPoint(outXml);
					break;
					case 'SWFOBJECT':
						ID = GetOutFileName.getIDBitmapName(arrData, outXml.NAME.toString());
						arrContent = GetOutFileName.getArrayBitmapForSWF(outXml, arrData);
						trace(this + ': length array content to swf file =' + arrContent.length);
						if(ID!=-1) this.addMovie(arrData[ID][1], outXml, arrContent);
					break;
					case 'LINE':
						this.addLine(outXml);
					break;
					case 'TABLE':
						this.addTable(outXml);
					break;
					case 'TABLEDIF':
						this.addTableDiff(outXml);
					break;
					case 'CHOICEBOX':
						this.addCheckBox(outXml);
					break;
					case 'GROUPFIELD':
						arrContent = GetOutFileName.getArrayBitmap(outXml, arrData);
						trace(this + ': ARRAY CONTENT = ' + arrContent);
						this.addGroupField(outXml, arrContent);
					break;
					case 'BUTTON':
						this.addUserButton(outXml);
					break;
					case 'SHIFTFIELD':
						this.addShiftField(outXml);
					break;
					case 'COORDINATE':
						addCoordinate(outXml);
					break;
					case 'PAINT':
						addPaintController(outXml);
					break;
					case 'CHARIS':
						ID = GetOutFileName.getIDBitmapName(arrData, outXml.@content.toString());
						addCharis(outXml, arrData[ID][1]);
					break;
				}
			}
		}
		public function setDrawer(rect:Object, type:String):void{
			trace(this + ': TYPE SELECT = ' + type);
			switch(type){
				case LABEL:
					addLabel(TaskSettings.getDefaultLabelXML(rect));
				break;
				case MARK:
					addMark(TaskSettings.getDefaultMarkXML(rect));
				break;
				case POINT:
					addPoint(TaskSettings.getDefaultPointDrawXML(rect));
				break;
				case TABLE:
					addTable(TaskSettings.getDefaultTableXML(rect));
				break;
				case FIELD:
					addField(TaskSettings.getDefaultFieldXML(rect));
				break;
				case LINE:
					addLine(TaskSettings.getDefaultLineXML(rect));
				break;
				case CHECK:
					addCheckBox(TaskSettings.getDefaultCheckBoxXML(rect));
				break;
				case GROUP_FIELD:
					addGroupField(TaskSettings.getDefaultGroupFieldXML(rect), null);
				break;
				case SELECT:
					objectsSelect(rect);
				break;
				case BUTTON:
					addUserButton(TaskSettings.getDefaultButtonXML(rect));
				break;
				case SHIFT_FIELD:
					addShiftField(TaskSettings.getDefaultShiftField(rect));
				break;
				case CORDINATE:
					addCoordinate(TaskSettings.getCoordinateXML(rect));
				break;
				case PAINT:
					addPaintController(TaskSettings.getPaintXML(rect));
				break;
			}
		}
		public function addPictAsTan(name:String, bitmap:ByteArray, x:Number, y:Number):void{
			if(swfController != null){
				var obj:Object = new Object();
				obj.name = name;
				obj.byteArray = bitmap;
				if(swfController.setImage(obj)) return;
			}
			addPicture(bitmap, TaskSettings.getDefaultPictureXML(name, x, y));
		}
		public function addSwfObject(name:String, swf:ByteArray, x:Number, y:Number):void{
			addMovie(swf, TaskSettings.getDefaultSWFXML(name, x, y));
		}
		public function addCharisProgram(name:String, text:ByteArray, width:Number, height:Number):void{
			var xml:XMLList = TaskSettings.getDefaultCharisSettings(name, width, height);
			addCharis(xml, text);
		}
		public function addFigure(value:Object, x:Number, y:Number):void{
			var xml:XMLList = TaskSettings.getUserTan(value, x, y);
			trace(this + ': USER XML = ' + xml);
			addUserTan(xml);
		}
		public function addTaskComplect(inXml:XMLList):void{
			if(classicControl == null) {
				classicControl = new ControlClassic(super.getNamedSprite('Компл. таны (Ч)'), super.getNamedSprite('Компл. таны (Ц)'));
				classicControl.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			classicControl.addTaskSets(inXml);
		}
		public function addComplect(inXml:XMLList = null):void{
			if(classicControl == null) {
				classicControl = new ControlClassic(super.getNamedSprite('Компл. таны (Ч)'), super.getNamedSprite('Компл. таны (Ц)'));
				classicControl.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			classicControl.addSets(inXml);
		}
		public function addUserTan(inXml:XMLList = null, bitmap:Bitmap = null, name:String = '', byteArray:ByteArray = null):void{
			if(userTanControl == null) {
				userTanControl = new ControlUserTan(super.getNamedSprite('Польз. таны (Ч)'), super.getNamedSprite('Польз. таны (Ц)'));
				userTanControl.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				userTanControl.addEventListener(CHECK_TAN_INPUT_FIELD, CHECK_TAN);
				userTanControl.dragContainer = super.dragContainer;
			}
			//trace(this + ': BITMAP = ' + bitmap + ', NAME = ' + name);
			userTanControl.addTan(inXml, bitmap, name, byteArray);
		}
		
		public function addLabel(inXml:XMLList = null):void{
			if(labelControl == null) {
				labelControl = new LabelController(super.getNamedSprite('Надписи'), super.getNamedSprite('Картинки таны (Ц)'), super.getNamedSprite('Картинки таны (Ч)'));
				labelControl.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				labelControl.addEventListener(CHECK_TAN_INPUT_FIELD, CHECK_TAN);
				labelControl.dragContainer = super.dragContainer;
			}
			labelControl.addLabel(inXml);
		}
		public function addMark(inXml:XMLList = null):void{
			if(markController == null) {
				markController = new MarkController(super.getNamedSprite('Области выделения'));
				markController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				markController.dragContainer = super.dragContainer;
			}
			markController.addMark(inXml);
		}
		public function get openMarkCounter():Boolean{
			if(markController == null) return false;
			return markController.openCounter;
		}
		public function set openMarkCounter(value:Boolean):void{
			if(markController == null) return;
			markController.openCounter = value;
		}
		public function addPoint(inXml:XMLList = null):void{
			if(pointController == null) {
				pointController = new PointsController(super.getNamedSprite('Точки соединения'));
				pointController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				pointController.dragContainer = super.dragContainer;
			}
			pointController.addPoint(inXml);
		}
		public function addTable(inXml:XMLList = null):void{
			if(tableController == null) {
				tableController = new TableController(super.getNamedSprite('Таблицы'));
				tableController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				tableController.dragContainer = super.dragContainer;
			}
			tableController.addTable(inXml);
		}
		public function addTableDiff(inXml:XMLList):void{
			if(tableController != null){
				tableController.diffSettings = inXml;
			}
		}
		public function addLine(inXml:XMLList = null):void{
			if(lineController == null) {
				lineController = new LineController(super.getNamedSprite('Линии'));
				lineController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				lineController.dragContainer = super.dragContainer;

			}
			lineController.addLine(inXml);
		}
		public function addField(inXml:XMLList = null):void{
			if(fieldController == null) {
				fieldController = new FieldControl(super.getNamedSprite('Перечисл. поля'));
				fieldController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				fieldController.dragContainer = super.dragContainer;
			}
			fieldController.addField(inXml);
		}
		public function addCheckBox(inXml:XMLList = null):void{
			if(checkBoxController==null){
				checkBoxController = new CheckBoxController(super.getNamedSprite('Выбор ответов'));
				checkBoxController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				checkBoxController.dragContainer = super.dragContainer;
			}
			checkBoxController.addCheckBox(inXml);
		}
		public function addGroupField(inXml:XMLList = null, content:Array = null):void{
			if(groupFieldController==null){
				groupFieldController = new GroupFieldController(super.getNamedSprite('Групповое поле (Ц)'), super.getNamedSprite('Групповое поле (Ч)'));
				groupFieldController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				/*---------------------------------*/
			}
			groupFieldController.addGroupField(inXml, content);
		}
		public function addPicture(byteArray:ByteArray, inXml:XMLList = null):void{
			if(pictureController == null) {
				pictureController = new ControllerPicture(super.getNamedSprite('Картинки таны (Ц)'), super.getNamedSprite('Картинки таны (Ч)'));
				pictureController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
				pictureController.addEventListener(CHECK_TAN_INPUT_FIELD, CHECK_TAN);
				pictureController.dragContainer = super.dragContainer;
			}
			pictureController.addTan(inXml, byteArray);
		}
		public function addMovie(byteArray:ByteArray, inXml:XMLList = null, content:Array = null):void{
			if(swfController == null) {
				swfController = new SwfController(super.getNamedSprite('SWF объекты'), super.getNamedSprite('SWF таны (Ц)'), super.getNamedSprite('SWF таны (Ч)'));
				swfController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			swfController.addSwf(inXml, byteArray, content);
		}
		public function addPalitra(inXml:XMLList = null):void{
			if(palitra == null) {
				palitra = new TaskPalitra(inXml, super.palitraContainer, super.brushContainer);
				palitra.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}else{
				palitra.visible = !palitra.visible;
			}
		}
		
		//	Добавление пользовательских кнопок
		private var userButtonController:ControllerUserButton;
		public function addUserButton(inXml:XMLList = null):void{
			if(userButtonController == null){
				userButtonController = new ControllerUserButton(super.getNamedSprite('Кнопки'));
				userButtonController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			userButtonController.addButton(inXml);
		}
		//	Добавление полей перестановки
		private var shiftFieldController:ShiftFieldController;
		public function addShiftField(inXml:XMLList = null):void{
			if(shiftFieldController==null){
				shiftFieldController = new ShiftFieldController(super.getNamedSprite('Поля перестановки'));
				shiftFieldController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			shiftFieldController.addShiftField(inXml);
		}
		
		//	Добавление координатной плоскости
		public function addCoordinate(inXml:XMLList = null):void{
			if(coordinateController==null){
				coordinateController = new CoordinateController(super.getNamedSprite('Координатная плоскость'));
				coordinateController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			coordinateController.addPlane(inXml);
		}
		
		//	Добавление панели рисования в задание
		public function addPaintController(inXml:XMLList = null):void{
			if(this.paintMainController == null){
				paintMainController = new PaintMainController(super.getNamedSprite('Панель рисования'));
				paintMainController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			paintMainController.addPaint(inXml);
		}
		private function addCharis(xml:XMLList, text:ByteArray):void{
			if(charisController == null){
				charisController = new CharisController(super.getNamedSprite("ЧЯРис"));
				charisController.addEventListener(GET_OBJECT_SETTINGS, CREATE_PANEL_SETTINGS);
			}
			charisController.addProgram(xml, text);
			/*trace(this + " charis xml:\n" + xml);
			trace(this + " charis program:\n" + text);*/
		}
		
		public function objectsSelect(rect:Object):void{
			trace(this + 'LABEL VISIBLE = '+super.getNamedSprite('Надписи').visible)
			trace(this + 'LABEL MOUSE ENABLED = '+super.getNamedSprite('Надписи').mouseChildren);
			var flag:Boolean = false;
			if(userTanControl != null){ 
				userTanControl.selectObject(rect, super.getNamedSprite('Польз. таны (Ч)').visible && super.getNamedSprite('Польз. таны (Ч)').mouseEnabled, super.getNamedSprite('Польз. таны (Ц)').visible && super.getNamedSprite('Польз. таны (Ц)').mouseEnabled);
				flag = true;
			}
			if(pictureController != null) {
				pictureController.selectObject(rect, super.getNamedSprite('Картинки таны (Ч)').visible && super.getNamedSprite('Картинки таны (Ч)').mouseEnabled, super.getNamedSprite('Картинки таны (Ц)').visible && super.getNamedSprite('Картинки таны (Ц)').mouseEnabled);
				flag = true;
			}
			if(lineController != null && super.getNamedSprite('Линии').visible && super.getNamedSprite('Линии').mouseEnabled) {
				lineController.selectObject = rect;
				flag = true;
			}
			if(checkBoxController != null && super.getNamedSprite('Выбор ответов').visible && super.getNamedSprite('Выбор ответов').mouseEnabled) {
				checkBoxController.selectObject = rect;
				flag = true;
			}
			if(labelControl != null && super.getNamedSprite('Надписи').visible && super.getNamedSprite('Надписи').mouseChildren) {
				labelControl.selectObject = rect;
				flag = true;
			}
			if(markController != null && super.getNamedSprite('Области выделения').visible && super.getNamedSprite('Области выделения').mouseEnabled) {
				markController.selectObject = rect;
				flag = true;
			}
			if(pointController != null && super.getNamedSprite('Точки соединения').visible && super.getNamedSprite('Точки соединения').mouseEnabled) {
				pointController.selectObject = rect;
				flag = true;
			}
			if(tableController != null && super.getNamedSprite('Таблицы').visible && super.getNamedSprite('Таблицы').mouseEnabled) {
				tableController.selectObject = rect;
				flag = true;
			}
			if(fieldController != null && super.getNamedSprite('Перечисл. поля').visible && super.getNamedSprite('Перечисл. поля').mouseEnabled) {
				fieldController.selectObject = rect;
				flag = true;
			}
			if(flag){
				super.drawSelect();
			}
			/*
			if(swfController != null)*/

		}
		private function ON_RESIZE_SELECT(event:Event):void{
			var obj:Object = super.resize;
			if(userTanControl != null) userTanControl.resize = obj;
		}
		private function ON_DELETE_SELECTED_PACK(event:Event):void{
			if(userTanControl != null) userTanControl.removeSelectedObject();
			if(pictureController != null) pictureController.removeSelectedObject();
			if(lineController != null) lineController.removeSelectedObject();
			if(labelControl != null) labelControl.removeSelectedObject();
			if(markController != null) markController.removeSelectedObject();
			if(pointController != null) pointController.removeSelectedObject();
			if(tableController != null) tableController.removeSelectedObject();
			if(fieldController != null) fieldController.removeSelectedObject();
			if(checkBoxController != null) checkBoxController.removeSelectedObject();
			super.removeSelect();
		}
		private function ON_COPY_SELECTED_PACK(event:Event):void{
			trace(this + ': COPY SELECTED PACK ' + userTanControl);
			if(userTanControl != null) userTanControl.copySelectedObject();
			if(pictureController != null) pictureController.copySelectedObject();
			if(lineController != null) lineController.copySelectedObject();
			if(labelControl != null) labelControl.copySelectedObject();
			if(markController != null) markController.copySelectedObject();
			if(pointController != null) pointController.copySelectedObject();
			if(tableController != null) tableController.copySelectedObject();
			if(fieldController != null) fieldController.copySelectedObject();
			if(checkBoxController != null) checkBoxController.copySelectedObject()
		}
		private function CHECK_TAN(event:Event):void{
			var remObject:*  = event.target.remember;
			if(this.groupFieldController!=null) groupFieldController.child = remObject;
			if(shiftFieldController!=null) shiftFieldController.child = remObject;
			if(remObject is OnePictureTan && this.paintMainController!=null){
				 paintMainController.child = remObject;
			}
		}
		private function  SETTINGS_SELECT_OBJECTS(event:Event = null):void{
			var xmlArray:Array = new Array();
			var objectsArray:Array = new Array();
			var currentObject:Object;
			if(userTanControl != null){
				currentObject = userTanControl.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(pictureController != null){
				currentObject = pictureController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(lineController != null){
				currentObject = lineController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(checkBoxController != null){
				currentObject = checkBoxController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(labelControl != null){
				currentObject = labelControl.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(markController != null){
				currentObject = markController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(pointController != null){
				currentObject = pointController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(tableController != null){
				currentObject = tableController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			if(fieldController != null){
				currentObject = fieldController.selectSettings;
				if(currentObject.select){
					xmlArray.push(currentObject.xml);
					objectsArray.push(currentObject.data);
				}
			}
			var outObject:Object = new Object();
			outObject.xml = xmlArray;
			outObject.data = objectsArray;
			settingsSystem.addObjects(outObject);
		}
		private function CREATE_PANEL_SETTINGS(e:Event):void{
			if(e.target.remember!=null){
				var inObject:Object = e.target.remember;
				var outObject:Object = new Object();
				outObject.data = inObject;
				outObject.xml = inObject.listSettings;
				settingsSystem.addObject(outObject);
				colorPicker.object = inObject;
				if(palitra != null){
					if(!palitra.select) return;
					if(inObject.toString() == '[object OnePicker]') return;
					try{
						inObject.color = palitra.color;
					}catch(e:Error){}
				}
			}else{
				colorPicker.object = null;
			}
		}
		
		public function reset():void{
			if(userTanControl != null) userTanControl.selectReset();
			if(pictureController != null) pictureController.selectReset();
			if(lineController != null) lineController.selectReset();
			if(checkBoxController != null) checkBoxController.selectReset();
			if(labelControl != null) {
				labelControl.reset();
				labelControl.selectReset();
			}
			if(markController != null) markController.selectReset();
			if(pointController != null) pointController.selectReset();
			if(tableController != null) tableController.selectReset();
			if(fieldController != null) fieldController.selectReset();
			if(checkBoxController!=null) checkBoxController.reset();
			if(charisController!=null) charisController.reset();
			super.removeSelect();
		}
		
		public function get content():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			var inArr:Array;
			if(pictureController != null) {
				inArr = pictureController.content;
				l = inArr.length;
				for(i=0;i<l;i++){
					outArr.push(inArr[i]);
				}
			}
			if(swfController != null) {
				inArr = swfController.content;
				l = inArr.length;
				for(i=0;i<l;i++){
					outArr.push(inArr[i]);
				}
			}
			return outArr;
		}
		
		/*public function get userContent():Array{
			var outArray:Array = new Array();
			if(paintMainController!=null) return paintMainController.authorImages;
			return outArray;
		}*/
		public function get authorBitmap():Array{
			if(paintMainController!=null) return paintMainController.authorBitmap;
			return [];
		}
		public function get authorByteArray():Array{
			if(paintMainController!=null) return paintMainController.authorByteArray;
			return [];
		}
		public function get authorFileName():Array{
			if(paintMainController!=null) return paintMainController.authorFileName;
			return [];
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<TASK/>');
			outXml.@level = tLevel.toString();
			outXml.NAME = tName;
			outXml.LAYERS = super.getLayerSettings();
			if(tHealth!=0) outXml.HEALTH = tHealth.toString();
			if(isTimer) outXml.TIMER = tTimer;
			outXml.DIAP = tJump.toString();
			outXml.UNIQU = tUniq.toString();
			outXml.MNIMOE = tMnimoe.toString();
			outXml.ICONS = tIcon.toString();
			var str:String;
			if(tUnderstand) str = '1,';
			else str = '0,'
			if(tRestart) str += '1,';
			else str += '0,';
			if(tDontkonw) str += '1';
			else str += '0';
			outXml.DELBUT = str;
			if(this.openMarkCounter){
				outXml.MARKCOUNTER = this.openMarkCounter.toString();
				outXml.MARKCOUNTER.@x = this.markController.counterPosition.x;
				outXml.MARKCOUNTER.@y = this.markController.counterPosition.y;
			}else{
				outXml.MARKCOUNTER = this.openMarkCounter.toString();
			}
			var objXml:XMLList = new XMLList('<OBJECTS/>');
			var currentXmlArr:Array;
			var i:int;
			var l:int;
			if(palitra!=null){
				if(palitra.visible){
					objXml.appendChild(palitra.listPosition);
				}
			}
			if(this.classicControl!=null){
				objXml.appendChild(classicControl.listPosition);
			}
			objXml = addXml(objXml, 'userTanControl');
			objXml = addXml(objXml, 'pictureController');
			objXml = addXml(objXml, 'markController');
			objXml = addXml(objXml, 'lineController');
			objXml = addXml(objXml, 'pointController');
			objXml = addXml(objXml, 'tableController');
			objXml = addXml(objXml, 'fieldController');
			objXml = addXml(objXml, 'labelControl');
			objXml = addXml(objXml, 'swfController');
			objXml = addXml(objXml, 'checkBoxController');
			objXml = addXml(objXml, 'groupFieldController');
			objXml = addXml(objXml, 'userButtonController');
			objXml = addXml(objXml, 'shiftFieldController');
			objXml = addXml(objXml, 'paintMainController');
			objXml = addXml(objXml, 'charisController');
			outXml.appendChild(objXml);
			return outXml;
		}
		private function addXml(inXml:XMLList, str:String):XMLList{
			var outXml:XMLList = inXml;
			var i:int;
			var l:int;
			var currentXmlArr:Array;
			if(this[str]!=null){
				currentXmlArr = this[str].listPosition;
				l = currentXmlArr.length;
				for(i=0;i<l;i++){
					outXml.appendChild(currentXmlArr[i]);
				}
			}
			return outXml;
		}
		
		public function get isCorrectPosition():Boolean{
			if(userTanControl != null) if(!userTanControl.isCorrectPosition) return false;
			if(pictureController != null) if(!pictureController.isCorrectPosition) return false;
			if(checkBoxController != null) if(!checkBoxController.isCorrectPosition) return false;
			if(labelControl != null) if(!labelControl.isCorrectPosition) return false;
			if(markController != null) if(!markController.isCorrectPosition) return false;
			if(pointController != null) if(!pointController.isCorrectPosition) return false;
			if(fieldController != null) if(!fieldController.isCorrectPosition) return false;
			if(groupFieldController!=null) if(!groupFieldController.isCorrectPosition) return false;
			return true;
		}
		public function normalizePosition():void{
			if(userTanControl != null) userTanControl.normalizePosition()
			if(pictureController != null) pictureController.normalizePosition()
			if(checkBoxController != null) checkBoxController.normalizePosition()
			if(labelControl != null) labelControl.normalizePosition()
			if(markController != null) markController.normalizePosition()
			if(pointController != null) pointController.normalizePosition()
			if(fieldController != null) fieldController.normalizePosition()
			if(groupFieldController!=null) groupFieldController.normalizePosition()
		}
		
		
		public function set tIcon(value:Boolean):void{
			taskIcon = value;
			if(value)iconControl.open();
			else iconControl.close();
			
			delete saveTempSettings.data.icons;
			saveTempSettings.data.icons = value.toString();
			try{
				saveTempSettings.flush();
			}catch(error:Error){}
		}
		public function get tIcon():Boolean{
			return taskIcon;
		}
		
		public function setBlackOnColor():void{
			if(userTanControl != null) userTanControl.setBlackOnColor();
			if(pictureController != null) pictureController.setBlackOnColor();
		}
		public function setColorOnBlack():void{
			if(userTanControl != null) userTanControl.setColorOnBlack();
			if(pictureController != null) pictureController.setColorOnBlack();
		}
		
		public function userTanOnPicture():void{
			if(userTanControl == null || pictureController == null) return;
			var userArr:Array = userTanControl.tanWithImages;
			var pictArr:Array = pictureController.imageSettingsForTan;
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			var obj:Object;
			var objTan:Object;
			var X:Number;
			var Y:Number;
			l = userArr.length;
			k = pictArr.length;
			if(l == 0 || k == 0) return;
			for(j=0;j<k;j++){
				obj = pictArr[j]
				for(i=0;i<l;i++){
					objTan = userArr[i][0];
					if(obj.name == objTan.name){
						userArr[i][1].colorR = 0;
						userArr[i][1].blackR = 0;
						X = (obj.x - obj.width/2) + (objTan.rectangle.x + objTan.rectangle.width/2);
						Y = (obj.y - obj.height/2) + (objTan.rectangle.y + objTan.rectangle.height/2);
						userArr[i][1].setColorPosition(X, Y);
						userArr[i][1].setBlackPosition(X, Y);
					}
				}
			}
		}
		
		
		public function get checkPaintColors():Boolean{
			if(palitra == null) return true;
			if(userTanControl == null) return true;
			var arrTanColor:Array = userTanControl.paintColor;
			var arrPointColor:Array = palitra.arrColors;
			if(arrTanColor.length == 0) return true;
			if(arrPointColor.length == 0) return false;
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			var flag:Boolean;
			l = arrTanColor.length;
			k = arrPointColor.length;
			for(i=0;i<l;i++){
				flag = true;
				for(j=0;j<k;j++){
					if(arrTanColor[i] == arrPointColor[j]) {
						flag = false;
						break;
					}
				}
				if(flag) return false;
			}
			return true;
		}
	}
	
}
