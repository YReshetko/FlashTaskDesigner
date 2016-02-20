package source.BlockOfTask {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.PlayerLib.Library;
	import source.utils.TaskSettings;
	import flash.events.Event;
	import source.BlockOfTask.Task.SeparatTask;
	import source.utils.PlayerTimer.TimerController;
	import source.utils.HelthTask.HelthViewer;
	import source.utils.TestCounter.CounterController;
	import source.BlockOfTask.Task.TaskObjects.Swf.SwfObject;
	import source.utils.FinalWindow;
	import flash.events.MouseEvent;
	import source.utils.TestAnimation.TransitionTask;
	import flash.ui.Mouse;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import source.BlockOfTask.PlayerConsole.Console;
	import source.BlockOfTask.PlayerConsole.ConsoleEvent;
	import flash.net.FileReference;
	import source.BlockOfTask.PackageInfo.Info;
	import source.MainPlayer;
	import source.utils.Figure;
	
	public class TaskController extends EventDispatcher{
		public static var TASK_CHANGE:String = 'onTaskChange';
		public static var TASK_COMPLATE_AUTO:String = 'onTaskComplateAuto';
		
		public static var HIDE_UNDERSTAND:String = 'onHideUnderstand';
		public static var HIDE_RESTART:String = 'onHideRestart';
		public static var HIDE_DONT_KNOW:String = 'onHideDontKnow';
		public static var HIDE_CHECK:String = 'onHideCheck';
		
		public static var SHOW_UNDERSTAND:String = 'onShowUnderstand';
		public static var SHOW_RESTART:String = 'onShowRestart';
		public static var SHOW_DONT_KNOW:String = 'onShowDontKnow';
		public static var SHOW_CHECK:String = 'onShowCheck';
		
		public static var TASK_FULL_COMPLATE:String = 'onTaskFullComplate';
		
		//	Контейнер отображения
		private var mainContainer:Sprite;
		private var buttonContainer:Sprite;
		private var TaskComplate:Boolean = false;
		//	Библиотека контента
		private var libContent:Library;
		//	Объект текущего задания
		private var currentTask:SeparatTask;
		private var currentXML:XMLList;
		/*
			обеъкты управления данными
		*/
		private var model:TaskModel;
		private var windowControl:WindowControl;
		private var controlContainer:Sprite;
		private var isReloadTimer:Boolean = true;
		private var isTimerComplate:Boolean = false;
		private var consoleSprite:Sprite;
		private var console:Console;
		
		private var isAutoDelivery:Boolean = true;
		private var timerDelivery:int = 0;
		/*
			остальное
		*/
		private var taskXML:XMLList;
		//	Параметр записи работали из консоли или нет
		private var isOpenConsole:Boolean = false;
		//	Объект информации о типе пакета
		private var info:Info = new Info();
		
		private var isShowAnswer:Boolean = false;
		public function TaskController(container:Sprite, lib:Library, controlContainer:Sprite, butContainer:Sprite, console:Sprite) {
			super();
			mainContainer = container;
			this.controlContainer = controlContainer;
			buttonContainer = butContainer;
			consoleSprite = console;
			consoleSprite.addChild(info);
			info.addEventListener(Info.SHOW_ANSWER, ON_SHOW_ANSWER);
			info.addEventListener(Info.BUG_REPORT, ON_BUG_REPORT);
			model = new TaskModel();
			windowControl = new WindowControl(controlContainer, container);
			windowControl.addEventListener(WindowControl.TIMER_COMPLATE, TASK_TIMER_COMPLATE);
			libContent = lib;
		}
		public function set path(value:String):void{
			model.path = value;
		}
		public function setSize(sWidth:String, sHeight:String):void{
			if(sWidth!='' && sHeight!=''){
				model.setSize(parseFloat(sWidth), parseFloat(sHeight));
				windowControl.setSize(parseFloat(sWidth), parseFloat(sHeight));
			}
		}
		public function openConsole():void{
			if(console==null){
				console = new Console(model.width, model.height);
				consoleSprite.addChild(console);
				if(console.visible) console.setFocus();
				console.addEventListener(ConsoleEvent.GET_AUTHOR, CONSOLE_GET_AUTHOR);
				console.addEventListener(ConsoleEvent.GET_PACKAGE, CONSOLE_GET_PACKAGE);
				console.addEventListener(ConsoleEvent.GET_TASK, CONSOLE_GET_TASK);
				console.addEventListener(ConsoleEvent.GET_TREE, CONSOLE_GET_TREE);
				console.addEventListener(ConsoleEvent.SET_COMPLATE, CONSOLE_SET_COMPLATE);
				console.addEventListener(ConsoleEvent.SET_FAIL, CONSOLE_SET_FAIL);
				console.addEventListener(ConsoleEvent.GO_TO_TASK, CONSOLE_GO_TO_TASK);
				console.addEventListener(ConsoleEvent.SAVE_TASK, CONSOLE_SAVE_TASK);
			}else {
				console.visible = !console.visible;
				if(console.visible) console.setFocus();
			}
		}
		//	Установка нового пакета заданий (преднастройка)
		public function set task(value:XMLList):void{
			mainContainer.mouseChildren = true;
			TaskComplate = false;
			model.data = value;
			info.data = [model.typePackage, model.typeDelevery, model.typePart, model.noMoreTaskSend];
			taskXML = value;
			if(taskXML.ISAUTODELIVERY.toString()!='') isAutoDelivery = taskXML.ISAUTODELIVERY.toString()=='true';
			if(taskXML.TIMERDELIVERY.toString()!='') {
				var s:String = taskXML.TIMERDELIVERY.toString();
				var min:int = parseInt(s.substr(0,2));
				var sec:int = parseInt(s.substr(3,2));
				timerDelivery = min*60 + sec;
				trace(this + ' num sec del = ' + timerDelivery);
			}
			//cleenTask();
			//if(model.test) windowControl.initTest(model.numberTask);
			windowControl.initTest(model.initObjectCounter);
			if(model.animation) windowControl.initAnimation();
			startTask(model.firstTask);
			reloadTimer();
		}
		public function startTask(value:XMLList):void{
			buttonContainer.mouseChildren = true;
			Mouse.show();
			trace(value);
			if(value.name() == 'COMPLATE' && value.toString()=='true') {
				finalPackage();
				return;
			}
			updateButton();
			clearContainer();
			currentTask = null;
			currentTask = new SeparatTask(value, mainContainer, libContent, model.path);
			windowControl.nextTaskCounter = model.currentTreePosition;
			if(currentTask.removeButton != null){
				if(currentTask.removeButton[0] == '1') dispatchVisButton(HIDE_UNDERSTAND);
				if(currentTask.removeButton[1] == '1') dispatchVisButton(HIDE_RESTART);
				if(!model.check){if(currentTask.removeButton[2] == '1') dispatchVisButton(HIDE_DONT_KNOW);}
				else dispatchVisButton(SHOW_CHECK);
			}
			if(!model.check) currentTask.addEventListener(SeparatTask.TASK_COMPLATE, TASK_COMPLATE);
			currentTask.addEventListener(SwfObject.CLOSE_RESTART, ON_CLOSE_RESTART);
			currentTask.addEventListener(SwfObject.OPEN_RESTART, ON_OPEN_RESTART);
			currentTask.addEventListener(SeparatTask.CLICK_USER_BUTTON, CLICK_USER_BUTTON);
			reloadTimer();
		}
		private function ON_CLOSE_RESTART(e:Event):void{
			this.dispatchVisButton(HIDE_RESTART);
		}
		private function ON_OPEN_RESTART(e:Event):void{
			this.dispatchVisButton(SHOW_RESTART);
		}
		private function CLICK_USER_BUTTON(event:Event):void{
			var inObject:Object = currentTask.buttonSettings;
			var flag:Boolean = (inObject.gotoTask == 0 && !inObject.dontKnow && !inObject.restart && !inObject.understand && !inObject.check);
			if(inObject.asTrue){
				if(!currentTask.isMnimoe && (model.test||model.currentLevel==1)){
					model.complateTask(true);
					windowControl.writeAnswer(model.complated, model.taskID);
				}
				super.dispatchEvent(new Event(TASK_CHANGE));
				if(flag){
					currentXML = model.getTask(TaskModel.TASK_NEXT);
					changeTask(true);
					return;
				}else{
					if(inObject.gotoTask != 0){
						currentXML = model.gotoTask(inObject.gotoTask-1);
						changeTask(false);
						return;
					}
					if(inObject.dontKnow){
						currentXML = model.getTask(TaskModel.DONT_KNOW);
						changeTask(true);
						return;
					}
					if(inObject.restart){
						currentXML = model.getTask(TaskModel.TASK_RESTART);
						changeTask(true);
						return;
					}
					if(inObject.understand){
						currentXML = model.getTask(TaskModel.UNDERSTAND);
						changeTask(true);
						return;
					}
				}
			}else{
				if(inObject.asFalse){
					if(!currentTask.isMnimoe && (model.test||model.currentLevel==1)){
						model.complateTask(false);
						windowControl.writeAnswer(model.complated, model.taskID);
					}
					super.dispatchEvent(new Event(TASK_CHANGE));
					if(flag){
						currentXML = model.getTask(TaskModel.DONT_KNOW);
						changeTask(false);
						return;
					}else{
						if(inObject.gotoTask != 0){
							currentXML = model.gotoTask(inObject.gotoTask-1);
							changeTask(false);
							return;
						}
						if(inObject.dontKnow){
							currentXML = model.getTask(TaskModel.DONT_KNOW);
							changeTask(false);
							return;
						}
						if(inObject.restart){
							currentXML = model.getTask(TaskModel.TASK_RESTART);
							changeTask(false);
							return;
						}
						if(inObject.understand){
							currentXML = model.getTask(TaskModel.UNDERSTAND);
							changeTask(false);
							return;
						}
					}
				}
			}
			if(inObject.gotoTask != 0){
				currentXML = model.gotoTask(inObject.gotoTask-1);
				changeTask(false);
				return;
			}
			if(inObject.dontKnow){
				this.dontKnow();
				return;
			}
			if(inObject.restart){
				this.restart();
				return;
			}
			if(inObject.understand){
				this.undersatnd();
				return;
			}
		}
		private function reloadTimer():void{
			if(isReloadTimer) windowControl.reloadTimer(currentTask.getTime(), currentTask.getHealth());
			isReloadTimer = true;
		}
		public function missClick():void{
			if(windowControl!=null){
				windowControl.missClick();
			}
		}
		private function TASK_TIMER_COMPLATE(e:Event):void{
			if(model.isNotFull()){
				model.comment = 't-';
				isTimerComplate = true;
				windowControl.stopTimer();
				return;
			}
			buttonContainer.mouseChildren = false;
			writeAnswer();
			trace(this + ' isMnimoe timerComplate')
			if(currentTask.isMnimoe){
				writeAnswerCounter(true);
				currentXML = model.getTask(TaskModel.TASK_NEXT);
				startTask(currentXML);
				return;
			}else{
				if(model.currentLevel==1 && model.typePackage == 'Обычный' && !model.hasPodvod){
					mainContainer.mouseChildren = false;
					dispatchVisButton(HIDE_RESTART);
					windowControl.setAnimation(false, true);
					return;
				}
			}
			if(currentTask.isComplate()){
				writeAnswerCounter(true);
				currentXML = model.getTask(TaskModel.TASK_NEXT);
			}else{
				writeAnswerCounter(false);
				currentXML = model.getTask(TaskModel.TASK_MISSTAKE);
			}
			changeTask(currentTask.isComplate());
		}
		public function checkTask():void{
			buttonContainer.mouseChildren = false;
			writeAnswer();
			writeAnswerCounter(currentTask.isComplate());
			if(model.test){
				currentXML = model.getTask(TaskModel.TASK_NEXT);
			}else{
				if(currentTask.isComplate()){
					currentXML = model.getTask(TaskModel.TASK_NEXT);
				}else{
					currentXML = model.getTask(TaskModel.TASK_MISSTAKE);
				}
			}
			changeTask(currentTask.isComplate());
		}
		private function TASK_COMPLATE(e:Event):void{
			if(model.isNotFull()){
				if(isTimerComplate){
					writeAnswerCounter(false);
					dontKnow();
					return;
				}else{
					writeAnswerCounter(true);
					model.comment = '+';
				}
			}
			buttonContainer.mouseChildren = false;
			writeAnswer();
			writeAnswerCounter(currentTask.isComplate());
			currentXML = model.getTask(TaskModel.TASK_NEXT);
			changeTask(currentTask.isComplate());
		}
		
		public function restart():void{
			buttonContainer.mouseChildren = false;
			if(TaskComplate){
				if(windowControl!=null){
					windowControl.stopTask();
					windowControl.clear();
				}
				task = taskXML;
				TaskComplate = false;
				return;
			}
			currentXML = model.getTask(TaskModel.TASK_RESTART);
			if(!model.mnimoe) isReloadTimer = false;
			startTask(currentXML);
		}
		public function undersatnd():void{
			buttonContainer.mouseChildren = false;
			currentXML = model.getTask(TaskModel.UNDERSTAND);
			startTask(currentXML);
			
		}
		
		private function BLOCK_FRAME_MOUSE_DOWN(event:MouseEvent):void{
			if(MainPlayer.STAGE.contains(event.target as Sprite)){
				MainPlayer.STAGE.removeChild(event.target as Sprite);
				if((event.target as Sprite).hasEventListener(MouseEvent.MOUSE_DOWN)){
					(event.target as Sprite).removeEventListener(MouseEvent.MOUSE_DOWN, BLOCK_FRAME_MOUSE_DOWN);
				}
			}
			restart();
		}
		public function dontKnow():void{
			if(isShowAnswer){
				var spr:Sprite = Figure.returnRect(model.width, model.height, 1, 0, 0, 0.1, 0x00FF00);
				MainPlayer.STAGE.addChild(spr);
				spr.addEventListener(MouseEvent.MOUSE_DOWN, BLOCK_FRAME_MOUSE_DOWN);
				currentTask.showAnswer();
				return;
			}
			if(model.isNotFull()){
				if(isTimerComplate){
					writeAnswerCounter(false);
					isTimerComplate = false;
				}else{
					model.comment = 'n-';
				}
			}
			writeAnswerCounter(currentTask.isComplate());
			buttonContainer.mouseChildren = false;
			if(model.test){
				model.complateTask(false);
				windowControl.writeAnswer(model.complated, model.taskID);
				super.dispatchEvent(new Event(TASK_CHANGE));
			}else writeAnswer();
			currentXML = model.getTask(TaskModel.DONT_KNOW);
			changeTask(currentTask.isComplate());
		}
		private function changeTask(value:Boolean):void{
			windowControl.stopTimer();
			if(model.animation){
				windowControl.addEventListener(TransitionTask.ANIMATION_COMPLATE, ANIMATION_COMPLATE);
				windowControl.setAnimation(value, (currentXML.name() == 'COMPLATE' && currentXML.toString()=='true'));
			}else{
				startTask(currentXML);
			}
		}
		private function ANIMATION_COMPLATE(event:Event):void{
			windowControl.removeEventListener(TransitionTask.ANIMATION_COMPLATE, ANIMATION_COMPLATE);
			startTask(currentXML);
		}
		
		private function writeAnswerCounter(value:Boolean):void{
			var inObject:Object = model.currentTaskObject;
			inObject.CurrentStatus = value;
			windowControl.currentTaskComplate = inObject;
		}
		private function writeAnswer():void{
			var complated:Boolean = currentTask.isComplate();
			if(!currentTask.isMnimoe && (model.test||model.currentLevel==1)){
				model.complateTask(complated);
				windowControl.writeAnswer(model.complated, model.taskID);
			}
			super.dispatchEvent(new Event(TASK_CHANGE));
		}
		public function get complated():Object{
			var outObject:Object = new Object();
			outObject.test = model.test;
			var numSuccess:int = 0;
			var i:int;
			var l:int;
			var num:int;
			var arrFinish:Array = new Array();
			var arrFail:Array = new Array();
			l = model.complated.length;
			num = 0;
			for(i=0;i<l;i++){
				if(model.complated[i]!=undefined) {
					++num;
					if(model.complated[i]){
						arrFinish.push(num);
						++numSuccess;
					}else{
						arrFail.push(num);
					}
				}
			}
			outObject.numTask = num;
			outObject.numSuccessTask = numSuccess;
			if(model.isNotFull()){
				outObject.success = [model.comment];
				outObject.fail = ['random test'];
			}else{
				outObject.success = arrFinish;
				outObject.fail = arrFail;
			}
			if(isOpenConsole) outObject.additional = 'Использовалась консоль! ';
			else outObject.additional = '';
			return outObject;
		}
		private function finalPackage():void{
			if(model.test){
				windowControl.finalTest(model.complated, model.complatedMnim);
				windowControl.addEventListener(WindowControl.SHOW_TASK, SHOW_REPORT_TASK);
			}
			TaskComplate = true;
			if(isAutoDelivery) {
				if(timerDelivery == 0) super.dispatchEvent(new Event(TASK_FULL_COMPLATE));
				else{
					var timDel:Timer = new Timer(1000*timerDelivery, 1);
					timDel.addEventListener(TimerEvent.TIMER, TIM_DEL);
					timDel.start();
				}
			}
		}
		private function TIM_DEL(event:TimerEvent):void{
			super.dispatchEvent(new Event(TASK_FULL_COMPLATE));
		}
		private function SHOW_REPORT_TASK(event:Event):void{
			startTask(model.gotoTask(windowControl.currentTask));
		}
		private function updateButton():void{
			isShowAnswer = false;
			trace(this + " UPDATE BUTTONS");
			var inObject:Object = TaskSettings.updateButton(model.arrLevels, model.taskID, model.test, model.check);
			if(inObject.rest){
				dispatchVisButton(SHOW_RESTART);
			}else{
				dispatchVisButton(HIDE_RESTART);
			}
			if(inObject.under){
				dispatchVisButton(SHOW_UNDERSTAND);
			}else{
				dispatchVisButton(HIDE_UNDERSTAND);
			}
			if(inObject.check){
				dispatchVisButton(SHOW_CHECK);
			}else{
				dispatchVisButton(HIDE_CHECK);
			}
			if(inObject.know){
				dispatchVisButton(SHOW_DONT_KNOW);
			}else{
				//dispatchVisButton(HIDE_DONT_KNOW);
				isShowAnswer = true;
				dispatchVisButton(SHOW_DONT_KNOW);
			}
			trace(this + " isShowAnswer = " + isShowAnswer);
		}
		private function dispatchVisButton(e:String):void{
			super.dispatchEvent(new Event(e));
		}
		private function clearContainer():void{
			if(currentTask!=null){
				currentTask.removeEventListener(SwfObject.CLOSE_RESTART, ON_CLOSE_RESTART);
				currentTask.removeEventListener(SwfObject.OPEN_RESTART, ON_OPEN_RESTART);
				if(windowControl.hasEventListener(WindowControl.SHOW_TASK))windowControl.removeEventListener(WindowControl.SHOW_TASK, SHOW_REPORT_TASK);
			}
			while(mainContainer.numChildren>0){
				mainContainer.removeChildAt(0);
			}
		}
		public function get numTask():int{
			return model.numberTask;
		}
		public function get isTaskComplate():Boolean{
			return TaskComplate;
		}
		
		
		/*
			Раздел работы с консолью
		*/
		private function CONSOLE_GET_AUTHOR(event:Event):void{
			console.writeInConsole(model.packageAuthor);
		}
		private function CONSOLE_GET_PACKAGE(event:Event):void{
			console.writeSimpleText(taskXML + '\n');
		}
		private function CONSOLE_GET_TASK(event:Event):void{
			console.writeSimpleText(model.getTaskForID(model.taskID) + '\n');
		}
		private function CONSOLE_GET_TREE(event:Event):void{
			console.writeInConsole(model.tree);
		}
		private function CONSOLE_SET_COMPLATE(event:Event):void{
			isOpenConsole = true;
			//console.writeInConsole('Задание № ' + (model.taskID+1).toString() + ' выполнено верно\n');
			if(!currentTask.isMnimoe && (model.test||model.currentLevel==1)){
				model.complateTask(true);
				windowControl.writeAnswer(model.complated, model.taskID);
			}
			super.dispatchEvent(new Event(TASK_CHANGE));
			currentXML = model.getTask(TaskModel.TASK_NEXT);
			changeTask(true);
		}
		private function CONSOLE_SET_FAIL(event:Event):void{
			//console.writeInConsole('Задание № ' + (model.taskID+1).toString() + ' выполнено не верно\n');
			dontKnow();
		}
		private function CONSOLE_GO_TO_TASK(event:Event):void{
			isOpenConsole = true;
			var taskXML:XMLList = model.gotoTask(console.taskID);
			if(taskXML.name().toString() == 'ERROR'){
				console.writeInConsole('Переход на задание № ' + (console.taskID+1).toString() + ' невозможен!\n');
				return;
			}
			//console.writeInConsole('Переход на задание № ' + (console.taskID+1).toString() + '!\n');
			currentXML = taskXML;
			if(!currentTask.isMnimoe && (model.test||model.currentLevel==1)){
				model.complateTask(false);
				windowControl.writeAnswer(model.complated, (model.taskID-1));
			}
			changeTask(false);
		}
		private function CONSOLE_SAVE_TASK(event:Event):void{
			var fileReference:FileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, FILE_SAVE_SELECT);
			fileReference.addEventListener(Event.CANCEL, FILE_SAVE_CANCEL);
			fileReference.save(taskXML, 'Position.txt');
		}
		private function FILE_SAVE_SELECT(event:Event):void{
			console.writeInConsole('Файл сохранён\n');
		}
		private function FILE_SAVE_CANCEL(event:Event):void{
			console.writeInConsole('Файл не сохранён\n');
		}
		
		private function ON_SHOW_ANSWER(event:Event):void{
			currentTask.showAnswer();
		}
		private function ON_BUG_REPORT(event:Event):void{
			super.dispatchEvent(new Event(Info.BUG_REPORT));
		}
	}
	
}
