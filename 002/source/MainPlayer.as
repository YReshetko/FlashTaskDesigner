package source {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.PlayerLib.Library;
	import source.utils.GetOutFileName;
	import source.utils.TaskLoader.LoadTask;
	import Converter;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.system.fscommand;
	import source.BlockOfTask.TaskController;
	import flash.display.Stage;
	import source.utils.DataBaseUpdate.SetLinkOnFile;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.external.ExternalInterface;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import source.BlockOfTask.PackageInfo.Info;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	// Параметры SWF-файла
	[SWF(width="742", height="530")]
	public class MainPlayer extends InitScene {
		public static var STAGE:Stage;
		
		private var libContent:Library = new Library();
		private var loadTask:LoadTask;
		private var taskController:TaskController;
		
		private var flashFile:String = '';
		private var baseImageURL:String = '';
		
		private var xmlTask:XMLList;
		private var delivery:Boolean = false;
		
		private var setLinkOnFile:SetLinkOnFile;
		public function MainPlayer() {
			super();
			initController();
			initHandlerScene();
			imageUrl = GetOutFileName.getBaseUrl()+'images/tangram/DBstandartElement/';
			if(this.loaderInfo.parameters["flashfiles"]!=undefined){
				url = this.loaderInfo.parameters["flashfiles"];
			}
			startLoadingTask();
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		private function onAdd(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			STAGE = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, STAGE_KEY_DOWN);
		}
		public function set url(value:String):void{
			flashFile = value;
			taskController.path = value;
			new SetLinkOnFile(value, super.container);
		}
		public function set imageUrl(value:String):void{
			baseImageURL = value;
		}
		private function initController():void{
			taskController = new TaskController(super.container, libContent, super.controlContainer, super.butContainer, super.console);
			taskController.addEventListener(TaskController.SHOW_UNDERSTAND, showUnderstand);
			taskController.addEventListener(TaskController.HIDE_UNDERSTAND, hideUnderstand);
			taskController.addEventListener(TaskController.SHOW_RESTART, showRestart);
			taskController.addEventListener(TaskController.HIDE_RESTART, hideRestart);
			taskController.addEventListener(TaskController.SHOW_DONT_KNOW, showDontKnow);
			taskController.addEventListener(TaskController.HIDE_DONT_KNOW, hideDontKnow);
			taskController.addEventListener(TaskController.SHOW_CHECK, showCheck);
			taskController.addEventListener(TaskController.HIDE_CHECK, hideCheck);
			taskController.addEventListener(TaskController.TASK_COMPLATE_AUTO, ON_TASK_COMPLATE);
			taskController.addEventListener(TaskController.TASK_FULL_COMPLATE, TASK_FULL);
			taskController.addEventListener(Info.BUG_REPORT, ON_BUG_REPORT);
		}
		private function initHandlerScene():void{
			super.addEventListener(InitScene.RELOAD_TASK, RELOAD_TASK);
			super.addEventListener(InitScene.NEXT_IN_TREE, NEXT_IN_TREE);
			super.addEventListener(InitScene.BACK_IN_TREE, BACK_IN_TREE);
			super.addEventListener(InitScene.CHECK_TASK, CHECK_TASK);
			super.addEventListener(InitScene.CLICK_MISS, CLICK_MISS);
		}
		public function startLoadingTask():void{
			loadTask = new LoadTask(libContent, super.container, flashFile, baseImageURL);
			loadTask.addEventListener(LoadTask.TASK_LOAD_COMPLATE, TASK_LOADED);
		}
		private function TASK_LOADED(e:Event):void{
			loadTask.removeEventListener(LoadTask.TASK_LOAD_COMPLATE, TASK_LOADED);
			task = loadTask.task;
			loadTask = null;
		}
		public function setTaskFromDesigner(tsk:String, lib:Array):void{
			libContent.clearLib();
			var i:int;
			var l:int = lib.length;
			for(i=0;i<l;i++){
				libContent.setFile(lib[i][0], lib[i][1]);
			}
			task = Converter.getXMLTask(tsk);
		}
		private function set task(value:XMLList):void{
			super.setSize('742', '530');
			taskController.setSize('742', '530');
			xmlTask = value;
			super.setSize(xmlTask.WIDTH.toString(), xmlTask.HEIGHT.toString());
			taskController.setSize(xmlTask.WIDTH.toString(), xmlTask.HEIGHT.toString());
			taskController.task = xmlTask;
			if(xmlTask.TEST.toString() == 'true') {
				super.isNextTaskButton = true;
			}else{
				super.isNextTaskButton = false;
			}
			if(xmlTask.DELIVERY.toString() == 'true') delivery = true;
			else delivery = false;
			taskController.addEventListener(TaskController.TASK_CHANGE, TASK_CHANGE);
			TASK_CHANGE(null);
		}
		private function TASK_CHANGE(e:Event):void{
			var inObject:Object = taskController.complated;
			var num:int = inObject.numSuccessTask;
			var str:String = '';
			trace(this + 'inObject.numSuccessTask = ' + inObject.numSuccessTask + '; \ntaskController.complated = ' + taskController.complated + '; \ninObject.success = ' + inObject.success + '; \ninObject.fail = ' + inObject.fail + '; \ninObject.additional = ' + inObject.additional);
			if(inObject.fail.length==0){
				str = 'Все задания выполнены';
			}else{
				if(inObject.fail[0]!='random test'){
					str += 'Номера не выполненных заданий - ' + inObject.fail.join(',');
					str += '\nНомера выполненных заданий - ' + inObject.success.join(',');
				}else{
					str += 'Ход теста - ' + inObject.success.join(',');
				}
			}
			str = inObject.additional + str;
			if(inObject.test){
				if(delivery){
					if(inObject.numSuccessTask == inObject.numTask){
						if(inObject.additional != ''){
							setResultAns(0);
						}else{
							setResultAns(1);
						}
					}else{
						setResultAns(0);
					}
				}else{
					if(inObject.additional != ''){
						setResultRes(0, str);
					}else{
						setResultRes(num, str);
					}
				}
			}else{
				if(inObject.numTask == 1){
					if(inObject.additional != ''){
						setResultAns(0);
					}else{
						setResultAns(num);
					}
				}else{
					if(inObject.additional != ''){
						setResultRes(0, str);
					}else{
						setResultRes(num, str);
					}
				}
			}
			//trace(this + ':\n ЧИСЛО ЗАДАНИЙ = ' + inObject.numTask +';\n' + str);
		}
		private var remLastAns:int;
		private function setResultAns(ans:int):void{
			trace(this + ': TASK COMPLATE ANS = ' + ans);
			remLastAns = ans;
			//fscommand("ans1",ans.toString());
			try{
				ExternalInterface.call('flash0_DoFSCommand', 'ans1', ans.toString());
			}catch(error:Error){}
		}
		private function setResultRes(res:int, str:String):void{
			trace(this + ': TASK COMPLATE RES = ' + res);
			trace(this + ': COMMENT = ' + str);
			remLastAns = res;
			//fscommand("res",res.toString());
			//fscommand("cmt",str);
			try{
				if(delivery){
					if(getNumTask() == res){
						ExternalInterface.call('flash0_DoFSCommand', 'ans1', "1");
					}
				}
				ExternalInterface.call('flash0_DoFSCommand', 'res', res.toString());
				ExternalInterface.call('flash0_DoFSCommand', 'cmt', str);
			}catch(error:Error){}
		}
		public function getLastAns():int{
			return remLastAns;
		}
		public function getNumTask():int{
			return taskController.numTask;
		}
		public function isTaskComplate():Boolean{
			return taskController.isTaskComplate;
		}
		private function TASK_FULL(event:Event):void{
			ExternalInterface.call("parent.testLocal");
			super.dispatchEvent(new Event('onTaskComplate'));
		}
		private function RELOAD_TASK(e:Event):void{
			taskController.restart();
		}
		private function NEXT_IN_TREE(e:Event):void{
			taskController.dontKnow();
		}
		private function BACK_IN_TREE(e:Event):void{
			taskController.undersatnd();
		}
		private function CHECK_TASK(e:Event):void{
			taskController.checkTask();
		}
		private function CLICK_MISS(e:Event):void{
			taskController.missClick();
		}
		//	методы визуализации главных кнопок плеера
		private function showUnderstand(e:Event):void{
			super.understand = true;
		}
		private function hideUnderstand(e:Event):void{
			super.understand = false;
		}
		private function showRestart(e:Event):void{
			super.restart = true;
		}
		private function hideRestart(e:Event):void{
			super.restart = false;
		}
		private function showDontKnow(e:Event):void{
			super.dontknow = true;
		}
		private function hideDontKnow(e:Event):void{
			super.dontknow = false;
		}
		private function showCheck(e:Event):void{
			super.check = true;
		}
		private function hideCheck(e:Event):void{
			super.check = false;
		}
		
		
		private function ON_TASK_COMPLATE(event:Event):void{
			trace(this + ': AUTO COMPLATE TASK FROM EXTERNAL INTERFACE');
			try{
				ExternalInterface.call('testLocal');
			}catch(error:Error){}
		}
		private function STAGE_KEY_DOWN(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.F12 && event.shiftKey){
				if(taskController!=null) taskController.openConsole();
			}
			if(event.keyCode == Keyboard.D && event.ctrlKey){
				STAGE.displayState = StageDisplayState.FULL_SCREEN;
			}
		}	
		private function ON_BUG_REPORT(event:Event):void{
			var file:String = (flashFile!="")?flashFile.substr(1, flashFile.length-1):"";
			
			var pattern1:RegExp = new RegExp("(?<=\/cid\/)\\d+");
			var pattern2:RegExp = new RegExp("(?<=\/nid\/)\\d+");
			
			var cid:String = pattern1.exec(file);
			var nid:String = pattern2.exec(file);
			
			var message:String = "[b]Ошибка[/b]\n";
			message += (nid != null && cid != null)?(GetOutFileName.getBaseUrl() + "task.jsp?nid="+nid+"&cid="+cid + "\n"):"Unknown url";
			message += "\n[u]Описание[/u]\n";
			
			
			var request:URLRequest = new URLRequest("http://dl.gsu.by/NForum/newpost/reply/16.dl");
			request.method = URLRequestMethod.GET;
			var variables:URLVariables = new URLVariables();
			variables["topicid"] = 1209;
			variables["message"] = message;
			request.data = variables;
			navigateToURL(request, "_blank");
		}
	}
	
}
