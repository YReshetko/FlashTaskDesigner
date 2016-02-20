package source.BlockOfTask {
	import source.utils.TaskSettings;
	import flash.events.EventDispatcher;
	import source.Counter.TestControl;
	
	public class TaskModel extends EventDispatcher{
		public static var TASK_NEXT:String = 'onTaskNe';
		public static var DONT_KNOW:String = 'onDontKnow';
		public static var UNDERSTAND:String = 'onUnderstand';
		public static var TASK_MISSTAKE:String = 'onTaskMisstake';
		public static var TASK_RESTART:String = 'onTaskRestart';
		
		private var arrLevel:Array;
		private var arrTask:Array = new Array();
		private var originalArray:Array = new Array();
		private var currentID:int;
		private var isTest:Boolean;
		private var complatedTask:Array = new Array();
		private var isCheck:Boolean = false;
		
		private var flashFiles:String = '';
		
		private var sWidth:Number = 742;
		private var sHeight:Number = 530;
		private var isAnimation:Boolean = true;
		private var TaskComplate:Boolean = false;
		private var numFunctionalTask:int = 0;
		private var noMoreTask:int = 0;
		private var author:String;
		private var group:String;
		private var date:String;
		
		private var isEquivalent:Boolean = false;
		private var numEquivalent:int = 0;
		private var isRandom:Boolean = false;
		private var cmtString:String;
		public function TaskModel() {
			super();
		}
		public function set data(value:XMLList):void{
			isAnimation = true;
			cmtString = '';
			arrLevel = TaskSettings.getArrLevel(value);
			if(value.@author!='') author = value.@author.toString();
			if(value.@group!='') group = value.@group.toString();
			if(value.@date!='') date = value.@date.toString();
			//trace(arrLevel);
			isTest = value.TEST.toString() == 'true';
			isCheck = value.CHECK.toString() == 'true';
			if(value.TESTANIMATION.toString() != '') isAnimation = value.TESTANIMATION.toString() == 'true';
			noMoreTask = 0;
			if(value.NOMORE.toString()!='') noMoreTask = parseInt(value.NOMORE.toString());
			clearTaskArray();
			for each(var task:XML in value.TASK){arrTask.push(new XMLList(task));}
			isEquivalent = false;
			numEquivalent = 0;
			isRandom = false;
			if(value.EQUIVALENT.toString()!='' && isTest && noMnimoe()) equivalent(parseInt(value.EQUIVALENT.toString()));
			if(value.RANDOM.toString()=='true' && isTest && noMnimoe()) random();
			currentID = -1;
			var i:int;
			var l:int = arrTask.length;
			numFunctionalTask = 0;
			for(i=0;i<l;i++){
				if(isTest){
					if(isMnimoe(i)){
						complatedTask.push(undefined)
					}else{
						complatedTask.push(false);
						++numFunctionalTask;
					}
				}else{
					if(arrLevel[i]==1){
						(isMnimoe(i))?complatedTask.push(undefined):complatedTask.push(false);
					}
				}
			}
		}
		public function get initObjectCounter():Object{
			var outObject:Object;
			switch(typePackage){
				case 'Тест':
					outObject = testObjectCounter;
					outObject.partition = numEquivalent
				break;
				case 'Гибридный':
					outObject = hybridObjectCounter
					outObject.partition = 0;
				break;
				case 'Обычный':
					outObject = new Object();
					outObject.type = TestControl.SIMPLE_TYPE;
				break;
			}
			return outObject;
		}
		public function get currentTaskObject():Object{
			var outObject:Object = new Object();
			switch(typePackage){
				case 'Тест':
					outObject.type = TestControl.TEST_TYPE;
					outObject.CurrentTask = arrTask[currentID].@id;
				break;
				case 'Гибридный':
					outObject.type = TestControl.HYBRID_TYPE;
					outObject.CurrentTask = arrTask[currentID].@id;
				break;
				case 'Обычный':
					outObject.type = TestControl.SIMPLE_TYPE;
					outObject.CurrentTask = arrTask[currentID].@id;
				break;
			}
			return outObject;
		}
		public function get currentTreePosition():Object{
			var outObject:Object = new Object();
			switch(typePackage){
				case 'Тест': outObject.type = TestControl.TEST_TYPE; break;
				case 'Гибридный': outObject.type = TestControl.HYBRID_TYPE; break;
				case 'Обычный': outObject.type = TestControl.SIMPLE_TYPE; break;
			}
			if(outObject.type != TestControl.TEST_TYPE) outObject.TreePosition = treePosition;
			outObject.NextTask = arrTask[currentID].@id;
			outObject.GoToNextTree = arrLevel[currentID]==1;
			return outObject;
		}
		private function get treePosition():String{
			var outString:String = '';
			var i:int;
			var num:int = 1;
			var currentLevel:int = arrLevel[currentID];
			var addString:String = '';
			for(i=currentID-1;i>=0;i--){
				if(arrLevel[i]<currentLevel){
					outString = num.toString()+addString+outString;
					num = 0;
					currentLevel = arrLevel[i];
					addString = '.';
				}
				if(arrLevel[i]==currentLevel){
					++num;
				}
			}
			if(outString.indexOf('.')!=-1) outString = num.toString()+addString+outString;
			else outString = '';
			return outString;
		}
		private function get hybridObjectCounter():Object{
			var outObject:Object = new Object();
			var outArr:Array = new Array();
			outObject.type = TestControl.HYBRID_TYPE;
			var i:int;
			var l:int;
			l = arrTask.length;
			for(i=0;i<l;i++){
				if(arrTask[i].@level == '1'){
					if(isMnimoe(i)){
						outArr.push({'num':arrTask[i].@id, 'type':'M'});
					}else{
						outArr.push({'num':arrTask[i].@id, 'type':'O'});
					}
				}
			}
			outObject.tasks = outArr;
			return outObject;
		}
		private function get testObjectCounter():Object{
			var outObject:Object = new Object();
			var outArr:Array = new Array();
			outObject.type = TestControl.TEST_TYPE;
			var i:int;
			var l:int;
			l = arrTask.length;
			for(i=0;i<l;i++){
				if(isMnimoe(i)){
					outArr.push({'num':arrTask[i].@id, 'type':'M'});
				}else{
					outArr.push({'num':arrTask[i].@id, 'type':'O'});
				}
			}
			outObject.tasks = outArr;
			return outObject;
		}
		public function get typePackage():String{
			if(isTest) return 'Тест';
			var i:int;
			var l:int;
			var num:int;
			l = arrTask.length;
			num = 0;
			for(i=0;i<l;i++){
				if(!isMnimoe(i) && arrTask[i].@level == '1') ++num;
			}
			if(num>1) return 'Гибридный';
			return 'Обычный';
		}
		public function get hasPodvod():Boolean{
			if(!isTest){
				var i:int;
				var l:int;
				l = arrTask.length
				for(i=0;i<l;i++){
					if(arrTask[i].@level != '1'){
						return true;
					}
				}
			}
			return false;
		}
		public function get typeDelevery():String{
			if(isRandom) return 'Случайный';
			return 'Прямой';
		}
		public function get typePart():String{
			if(numEquivalent==0) return 'Нет';
			return numEquivalent.toString();
		}
		public function get noMoreTaskSend():String{
			if(noMoreTask == 0) return 'Все';
			return noMoreTask.toString();
		}
		private function clearTaskArray():void{
			while(arrTask.length>0){
				arrTask.shift();
			}
			while(complatedTask.length>0){
				complatedTask.shift();
			}
		}
		
		public function setSize(width:Number, height:Number):void{
			sWidth = width;
			sHeight = height;
		}
		public function get height():Number{
			return sHeight;
		}
		public function get width():Number{
			return sWidth;
		}
		public function get path():String{
			return flashFiles;
		}
		public function set path(value:String):void{
			flashFiles = value;
		}
		public function get numberTask():int{
			return numFunctionalTask;
		}
		public function get test():Boolean{
			return isTest;
		}
		public function get check():Boolean{
			return isCheck;
		}
		public function getTaskForID(value:int):XMLList{
			return arrTask[value];
		}
		public function gotoTask(value:int):XMLList{
			if(value>=arrTask.length) return new XMLList('<ERROR>true</ERROR>');
			currentID = value;
			return arrTask[value];
		}
		public function get firstTask():XMLList{
			currentID = 0;
			return arrTask[0];
		}
		public function getTask(value:String):XMLList{
			var outXML:XMLList;
			if(noMoreTask>0){
				if(checkNoMoreComplate()) return packageComplate;
			}
			switch(value){
				case TASK_NEXT:
					outXML = nextTask;
				break;
				case DONT_KNOW:
					outXML = dontKnow;
				break;
				case UNDERSTAND:
					outXML = understand;
				break;
				case TASK_MISSTAKE:
					outXML = misstake;
				break;
				case TASK_RESTART:
					outXML = restart;
				break;
			}
			return outXML;
		}
		private function get nextTask():XMLList{
			var outXML:XMLList;
			if(test){
				if(isFinaly(currentID)){
					return packageComplate;
				}else{
					++currentID;
					return arrTask[currentID];
				}
			}else{
				trace(this + ' command = ' + getPositionInTree(currentID));
				switch(getPositionInTree(currentID)){
					case 'lastTask':
						return packageComplate;
					break;
					case 'midleVetv':
						trace(this + ' midle');
						currentID = getNext(currentID);
						return arrTask[currentID];
					break;
					case 'lastVetv':
						trace(this + ' kornevoe');
						currentID = getKornevoe(currentID);
						return arrTask[currentID];
					break;
				}
			}
			return packageComplate;
		}
		private function get dontKnow():XMLList{
			var i:int;
			var l:int;
			l = arrTask.length;
			if(test){
				if(isFinaly(currentID)){
					return packageComplate;
				}else{
					for(i=currentID+1;i<l;i++){
						if(!isMnimoe(i)&&!isMnimoe(i-1)){
							currentID = i;
							return arrTask[currentID];
						}
					}
				}
			}else{
				currentID = getPodvodjashee(currentID);
				return arrTask[currentID];
			}
			return packageComplate;
		}
		private function get understand():XMLList{
			var i:int;
			var l:int;
			l = arrTask.length;
			if(test){
				if(isMnimoe(currentID)){
					for(i=currentID+1;i<l;i++){
						if(!isMnimoe(i)){
							currentID = i;
							return arrTask[currentID];
						}
					}
				}
				return arrTask[currentID];
			}else{
				if(arrLevel[currentID]>1){
					for(i=currentID-1;i>=0;i--){
						if(arrLevel[i]<arrLevel[currentID]){
							currentID = i;
							return arrTask[currentID];
						}
					}
				}
				return arrTask[currentID];
			}
			return packageComplate;
		}
		private function get misstake():XMLList{
			if(test) return nextTask;
			currentID = getPodvodjashee(currentID);
			return arrTask[currentID];
		}
		private function get restart():XMLList{
			if(test){
				if(currentID == 0) return arrTask[0];
				var i:int;
				var l:int;
				l = arrTask.length;
				for(i=currentID-1;i>=0;i--){
					if(!isMnimoe(i)){
						currentID = i+1;
						return arrTask[currentID];
					}
				}
				currentID = 0;
				return arrTask[currentID];
			}
			currentID = getRestartDiffTree(currentID);
			return arrTask[currentID];
		}
		
		private function get packageComplate():XMLList{
			var outXml:XMLList = new XMLList('<COMPLATE>true</COMPLATE>');
			return outXml;
		}
		private function isMnimoe(id:int):Boolean{
			if(arrTask[id].MNIMOE.toString()=='true') return true;
			return false;
		}
		private function noMnimoe():Boolean{
			var i:int;
			var l:int;
			l = arrTask.length;
			for(i=0;i<l;i++){
				if(isMnimoe(i)) return false;
			}
			return  true;
		}
		private function isFinaly(value:int):Boolean{
			if(value >= arrTask.length-1) return true;
			return false;
		}
		private function getPositionInTree(value:int):String{
			var i:int;
			var l:int;
			l = arrLevel.length;
			if(arrLevel[value] == 1 && isFinaly(value)) return 'lastTask';
			if(arrLevel[value] != 1 && isFinaly(value)) return 'lastVetv';
			for(i=value+1;i<l;i++){
				if(arrLevel[value] == arrLevel[i]) return 'midleVetv';
				if(arrLevel[value] >  arrLevel[i]) return 'lastVetv';
			}
			if(arrLevel[value]==1) return 'lastTask';
			return 'lastVetv';
		}
		private function getKornevoe(value:int):int{
			var i:int;
			var l:int;
			l = arrLevel.length;
			for(i=value-1;i>=0;i--){
				if(arrLevel[value]>arrLevel[i]) return i;
			}
			return 0;
		}
		private function getNext(value:int):int{
			var i:int;
			var l:int;
			l = arrLevel.length;
			for(i=value+1;i<l;i++){
				trace(this + ' Analis number '+i +' arrLevel['+value+'] = ' + arrLevel[value] + ' and arrLevel['+i+'] = ' + arrLevel[i]);
				if(arrLevel[value] == arrLevel[i]) return i;
			}
			return value;
		}
		private function getRestartDiffTree(value:int):int{
			var i:int;
			var l:int;
			l = arrLevel.length;
			if(value==0) return 0;
			if(!isMnimoe(value-1) && arrLevel[value]==arrLevel[value-1]) return value;
			if(arrLevel[value]!=arrLevel[value-1]) return value;
			for(i=value-1;i>=0;i--){
				if(!isMnimoe(i) && arrLevel[i]==arrLevel[i+1]) return (i+1);
				if(arrLevel[i]!=arrLevel[i+1]) return (i+1)
			}
			return value;
		}
		private function getPodvodjashee(value:int):int{
			if(isFinaly(value)) return getRestartDiffTree(value);
			if(arrLevel[value+1]>arrLevel[value]) return (value+1);
			return getRestartDiffTree(value);
		}
		private function equivalent(value:int):void{
			isEquivalent = true
			var newArray:Array = new Array();
			var numPart:int = Math.floor(arrTask.length/value);
			var lastPart:int = arrTask.length-(numPart*value);
			var setNum:int;
			var i:int;
			numEquivalent = 0;
			for(i=0;i<numPart;i++){
				++numEquivalent;
				setNum = (value*i)+Math.floor(Math.random()*value);
				newArray.push(arrTask[setNum]);
			}
			if(lastPart!=0){
				++numEquivalent;
				setNum = (value*numPart)+Math.floor(Math.random()*lastPart);
				newArray.push(arrTask[setNum]);
			}
			while(arrTask.length>0) arrTask.shift();
			arrTask = newArray;
		}
		private function random():void{
			isRandom = true;
			var newArray:Array = new Array();
			var i:int;
			var index:int;
			while(arrTask.length>0){
				index = Math.floor(Math.random()*arrTask.length);
				newArray.push(arrTask[index]);
				arrTask.splice(index,1);
			}
			arrTask = newArray;
		}
		private function checkNoMoreComplate():Boolean{
			var i:int;
			var l:int;
			var numComplate:int = 0;
			l = complatedTask.length;
			for(i=0;i<l;i++){
				if(complatedTask[i] == true) ++numComplate;
			}
			if(numComplate>=noMoreTask) return true;
			return false;
		}
		public function complateTask(value:Boolean):void{
			complatedTask[currentID] = value;
		}
		public function get complated():Array{
			return complatedTask;
		}
		public function get complatedMnim():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrTask.length;
			for(i=0;i<l;i++){
				if(isMnimoe(i)){
					outArr.push(true);
				}else{
					outArr.push(false);
				}
			}
			return outArr;
		}
		public function get currentLevel():int{
			return arrLevel[currentID];
		}
		public function get arrLevels():Array{
			return arrLevel;
		}
		public function get taskID():int{
			return currentID;
		}
		public function get animation():Boolean{
			return isAnimation;
		}
		public function get mnimoe():Boolean{
			return isMnimoe(currentID);
		}
		
		public function get packageAuthor():String{
			if(author == '') return 'Автор неизвестен.\n';
			var outString:String = '';
			outString = 'Автор - ' + author + ', группа - ' + group + ', дата редактирования - ' + date + '\n';
			return outString;
		}
		public function get tree():String{
			var i:int;
			var l:int;
			var outString:String = '';
			l = arrTask.length;
			if(isTest){
				for(i=0;i<l;i++){
					outString += (i+1).toString()+'.\t';
					outString += "<a href='event:"+(i+1)+"'><font color='#EE0000'>"+arrTask[i].NAME.toString()+"</font></a>";
					if(isMnimoe(i)) outString += '(Мнимое)';
					outString += '\n';
				}
			}else{
				for(i=0;i<l;i++){
					outString += (i+1).toString()+'.\t';
					if(arrTask[i].@level.toString()!=''){
						outString += tab(parseInt(arrTask[i].@level.toString()));
					}
					outString += "<a href='event:"+(i+1)+"'><font color='#EE0000'>"+arrTask[i].NAME.toString()+"</font></a>";
					if(isMnimoe(i)) outString += '(Мнимое)';
					outString += '\n';
				}
			}
			return outString;
		}
		private function tab(value:int):String{
			var i:int;
			var l:int;
			var outString:String = '';
			l = value-1;
			for(i=0;i<l;i++){
				outString += '\t';
			}
			return outString;
		}
		
		public function isNotFull():Boolean{
			if(this.isRandom || this.isEquivalent || this.noMoreTask>0) return true;
			return false;
		}
		public function set comment(value:String):void{
			cmtString += arrTask[currentID].@id + value;
		}
		public function get comment():String{
			return cmtString;
		}
	}
}