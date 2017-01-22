package source.Task.TaskObjects.Swf {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import flash.geom.Matrix;
	import source.DesignerMain;

	public class SwfObject extends EventDispatcher{
        public static const GET_MODULE_SETTINGS:String = "onGetModuleSettings";
		public static var GET_SETTINGS:String = 'onGetSettings';
		private var swfContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var swfSpr:Sprite = new Sprite;
		private var colorTan:Sprite = new Sprite;
		private var blackTan:Sprite = new Sprite;
		
		private var colorObj:Bitmap;
		private var blackObj:Bitmap;
		private var simpleObj:*;
		//	4 - типа объекта :
		//	- SimpleSWF -- просто ролик не влияющий на выполнение
		//	- TanSWF    -- ролик превращённый в тан
		//	- TaskSWF   -- возвращает код выполненности
		//	- ModulSWF  -- Модульное задание
		private var swfType:String/* = "SimpleSWF"*/;
		
		private var swfStopFrame:int = 0;
		private var swfPlayAfterPos:Boolean = false;
		private var swfPlayAfterTask:Boolean = false;
		private var swfMethodAfterPos:String = "";
		private var swfMethodAfterTask:String = "";
		
		private var fileName:String;
		
		private var pojavl:int;
		private var pojavl_block:int;
		private var pojavl_show:int;
		private var ischezn:int;
		private var ischezn_block:int;
		private var ischezn_show:int;
		private var ischezn_timeShow:int;

		public function SwfObject(swfCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			swfContainer = swfCont;
			colorContainer = colorCont;
			blackContainer = blackCont;
		}
		
		public function addObject(obj:*,n:String):void{
			simpleObj = obj;
			try{
				if(simpleObj.getType() == 'Modul'){
					simpleObj.setEnvironment("Designer");
					type = 'ModulSWF'
				}
			}catch(e:Error){trace(this + ': ERROR = ' + e)}
			swfSpr.addChild(simpleObj);
			if(n!=""){
				fileName = n;
			}
			try{
				colorObj = duplicateObject(swfSpr);
				blackObj = duplicateObject(swfSpr);
				colorTan.addChild(colorObj);
				blackTan.addChild(blackObj);
				var color:ColorTransform = blackTan.transform.colorTransform; 
				color.color = 0x000000;
				blackTan.transform.colorTransform = color;
			}catch(e:ArgumentError){
				trace(this + ': TAN WAS NOT CREATED. ERROR = ' + e);
			}
			swfContainer.addChild(swfSpr);
		}
		public function set type(value:String):void{
			if(value != swfType){
				if(value == "TanSWF"){
					blackContainer.addChild(blackTan);
					colorContainer.addChild(colorTan);
					blackTan.x = colorTan.x = swfSpr.x;
					blackTan.y = colorTan.y = swfSpr.y;
					swfContainer.removeChild(swfSpr);
				}else{
					if(swfType == "TanSWF"){
						swfContainer.addChild(swfSpr);
						swfSpr.x = colorTan.x;
						swfSpr.y = colorTan.y;
						blackContainer.removeChild(blackTan);
						colorContainer.removeChild(colorTan);
					}
					if(swfType == 'ModulSWF'){
                        trace(this + " Init swf module, set type and add GET_MODULE_SETTINGS listener");
						simpleObj.setEnvironment("Designer");
					}
				}
				swfType = value;
				super.dispatchEvent(new Event(GET_SETTINGS));
			}
		}
		public function set image(value:Object):void{
			simpleObj.setContent([value]);
			trace(this + ': Контент добавлен');
			simpleObj.putContent();
			trace(this + ': Метод установки контента в объекте прошёл')
		}
		public function get X():Number{
			return swfSpr.x;
		}
		public function get Y():Number{
			return swfSpr.y;
		}
		public function get colorX():Number{
			return colorTan.x;
		}
		public function get colorY():Number{
			return colorTan.y;
		}
		public function get blackX():Number{
			return blackTan.x;
		}
		public function get blackY():Number{
			return blackTan.y;
		}
		public function get type():String{
			return swfType;
		}
		public function get width():Number{
			return colorTan.width;
		}
		public function get height():Number{
			return colorTan.height;
		}
		public function get isDragAndDrop():Boolean{
			if(swfType == 'TanSWF') return true;
			return false;
		}
		public function set stopFrame(value:int):void{
			swfStopFrame = value;
		}
		public function get stopFrame():int{
			return swfStopFrame;
		}
		public function set playAfterPos(value:Boolean):void{
			swfPlayAfterPos = value;
		}
		public function get playAfterPos():Boolean{
			return swfPlayAfterPos;
		}
		public function set playAfterTask(value:Boolean):void{
			swfPlayAfterTask = value;
		}
		public function get playAfterTask():Boolean{
			return swfPlayAfterTask;
		}
		public function set methodAfterPos(value:String):void{
			swfMethodAfterPos = value;
		}
		public function get methodAfterPos():String{
			return swfMethodAfterPos;
		}
		public function set methodAfterTask(value:String):void{
			swfMethodAfterTask = value;
		}
		public function get methodAfterTask():String{
			return swfMethodAfterTask;
		}
		public function set Alpha(q:Boolean):void{
			if(!q){
				blackTan.alpha = 0.2;
			}else{
				blackTan.alpha = 1;
			}
		}
		public function get Alpha():Boolean{
			if(blackTan.alpha == 1) return true;
			return false;
		}
		public function get modulSettings():String{
			return simpleObj.getSettings();
		}
		public function getPojavl():Array{
			var arr:Array = new Array();
			arr.push(pojavl);
			arr.push(pojavl_block);
			arr.push(pojavl_show);
			return arr;
		}
		private function setPojavl(arr:Array):void{
			pojavl = arr[0];
			pojavl_block =arr[1];
			pojavl_show = arr[2];
		}
		public function getIschezn():Array{
			var arr:Array = new Array();
			arr.push(ischezn);
			arr.push(ischezn_block);
			arr.push(ischezn_show);
			arr.push(ischezn_timeShow);
			return arr;
		}
		private function setIschezn(arr:Array):void{
			ischezn = arr[0];
			ischezn_block =arr[1];
			ischezn_show = arr[2];
			ischezn_timeShow = arr[3];
		}
		public function setParametrs(paramXML:XMLList):void{
			if(type!='ModulSWF') type = paramXML.TYPE.toString();
			trace(this + ': inXml = ' + paramXML);
			if(type == "TanSWF"){
				blackTan.x = parseInt(paramXML.XBLACK);
				blackTan.y = parseInt(paramXML.YBLACK);
				colorTan.x = parseInt(paramXML.XCOLOR);
				colorTan.y = parseInt(paramXML.YCOLOR);
			}else{
				swfSpr.x = parseInt(paramXML.X);
				swfSpr.y = parseInt(paramXML.Y);
			}
			if(paramXML.SHOWING.@action == "true"){
				if(paramXML.SHOWING.TAN == "BlackTan"){
					setPojavl([1,parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME)]);
				}else{
					setPojavl([2,parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME)]);
				}
			}
			if(paramXML.VANISHING.@action == "true"){
				if(paramXML.VANISHING.TAN == "BlackTan"){
					setIschezn([1,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW)]);
				}else{
					setIschezn([2,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW)]);
				}
			}
			if(type == "TanSWF"){
				stopFrame = parseInt(paramXML.STOP);
				playAfterPos = paramXML.PLAYAFTERPOS.toString() == "true";
				playAfterTask = paramXML.PLAYAFTERTASK.toString() == "true";
				methodAfterPos = paramXML.METHODAFTERPOS.toString();
				methodAfterTask = paramXML.METHODAFTERTASK.toString();
				Alpha = paramXML.ALPHA.toString() == "true";
				blackTan.height = parseInt(paramXML.HEIGHT);
				blackTan.width = parseInt(paramXML.WIDTH);
				colorTan.height = parseInt(paramXML.HEIGHT);
				colorTan.width = parseInt(paramXML.WIDTH);
			}
			if(type == "ModulSWF"){
				trace(this + " OUT XML = " + paramXML.SETTINGS);
                (simpleObj as Sprite).addEventListener(GET_MODULE_SETTINGS, ON_MODULE_SETTINGS);
				swfSpr.x = 6;
				swfSpr.y = 6;
			}else{
				initObject();
			}
		}
		public function setDessigned(xml:XMLList, content:Array):void{
//			try{
				simpleObj.setDessigned(xml, content);
			/*}catch(error:Error){
				trace(this + ': error load content to swf ' + error);
			} */
		}
		private function duplicateObject(exemplar:Sprite):Bitmap {
			var bmpData:BitmapData = new BitmapData(exemplar.width, exemplar.height);
			bmpData.draw(exemplar, new Matrix());
			var outBmp:Bitmap = new Bitmap(bmpData);
			return outBmp;
		}
		private function initObject():void{
			colorTan.addEventListener(MouseEvent.MOUSE_DOWN,colorTan_MOUSE_DOWN);
			blackTan.addEventListener(MouseEvent.MOUSE_DOWN,blackTan_MOUSE_DOWN);
			swfSpr.addEventListener(MouseEvent.MOUSE_DOWN,SIMPLE_MOUSE_DOWN);
		}

		private function colorTan_MOUSE_DOWN(e:MouseEvent):void{
			colorTan.startDrag();
			colorTan.parent.setChildIndex(colorTan, colorTan.parent.numChildren - 1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, colorTan_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function blackTan_MOUSE_DOWN(e:MouseEvent):void{
			blackTan.startDrag();
			blackTan.parent.setChildIndex(blackTan, blackTan.parent.numChildren - 1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, colorTan_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function SIMPLE_MOUSE_DOWN(e:MouseEvent):void{
			swfSpr.startDrag();
			swfSpr.parent.setChildIndex(swfSpr, swfSpr.parent.numChildren - 1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, colorTan_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function colorTan_MOUSE_UP(e:MouseEvent):void{
			swfSpr.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, colorTan_MOUSE_UP);
		}
		public function get simpleList():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'SWF ОБЪЕКТ';
			var additionalXml:XMLList = new XMLList('<CHECK/>');
			additionalXml.@variable = 'type';
			//	- SimpleSWF -- просто ролик не влияющий на выполнение
			//	- TanSWF    -- ролик превращённый в тан
			//	- TaskSWF   -- возвращает код выполненности
			//	- ModulSWF  -- Модульное задание
			additionalXml.appendChild(new XML('<DATA>SimpleSWF</DATA>'));
			additionalXml.appendChild(new XML('<DATA>TanSWF</DATA>'));
			additionalXml.appendChild(new XML('<DATA>TaskSWF</DATA>'));
			additionalXml.appendChild(new XML('<DATA>ModulSWF</DATA>'));
			additionalXml.appendChild(new XML('<CURRENTDATA>' + type + '</CURRENTDATA>'));
			var blockList:XMLList = new XMLList('<BLOCK label="тип объекта"/>');
			blockList.appendChild(additionalXml);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get hardList():XMLList{
			var outXml:XMLList = simpleList;
			var blockList:XMLList = new XMLList('<BLOCK label="настройка тана"/>');
			blockList.appendChild(new XML('<FIELD label="номер кадра остановки" type="intager" variable="stopFrame" width="40">' + this.stopFrame.toString() + '</FIELD>'));
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="методы после..."/>');
			blockList.appendChild(new XML('<FIELD label="установки" type="string" variable="methodAfterPos" width="200">' + this.methodAfterPos + '</FIELD>'));
			blockList.appendChild(new XML('<FIELD label="выполнения задания" type="string" variable="methodAfterTask" width="200">' + this.methodAfterTask + '</FIELD>'));
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="проигрывать после"/>');
			blockList.appendChild(new XML('<MARK label="установки" variable="playAfterPos">' + this.playAfterPos.toString() + '</MARK>'));
			blockList.appendChild(new XML('<MARK label="выполнения задания" variable="playAfterTask">' + this.playAfterTask.toString() + '</MARK>'));
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="прозрачность"/>');
			blockList.appendChild(new XML('<MARK label="чёрный тан" variable="Alpha">' + this.Alpha.toString() + '</MARK>'));
			outXml.appendChild(blockList);
			return outXml;
		}

        public function get innerObject():*{
            var out:*;
            try{
                out = simpleObj.objectToSettings;
                return out;
            }
            catch (error:Error)
            {
                trace(this + " Can't take object to settings in this swf module");
            }

        }
        private function ON_MODULE_SETTINGS(event:Event):void{
            //trace(this + " Getting inner module settings ");
            super.dispatchEvent(new Event(GET_MODULE_SETTINGS));
        }
	} 
}