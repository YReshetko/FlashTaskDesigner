package source.Task.TaskSettings {
	import flash.display.Sprite;
	import flash.display.GradientType;
	import source.Task.TaskSettings.SamplePanel.PanelLabel;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import source.utils.Figure;
	import source.Task.TaskSettings.SamplePanel.PanelField;
	import flash.events.Event;
	import source.Task.TaskSettings.SamplePanel.PanelMark;
	import source.Task.TaskSettings.SamplePanel.PanelLine;
	import source.Task.TaskSettings.SamplePanel.PanelChoise.MyCheckBox;
	import flash.events.MouseEvent;
	import source.Task.TaskSettings.SamplePanel.PanelLock;
	import source.Task.TaskSettings.SamplePanel.SetAnimation.PanelAnimation;
	
	public class SampleSettings extends Sprite{
		public static var SAMPLE_SELECT:String = 'onSampleSelect';
		public static var CHANGE_LIST:String = 'onChangeList';
		public static const hPanel:Number = 18;
		
		private var label:PanelLabel;
		private var panelName:String;
		private var backgroundLabel:Sprite;
		private var arrowLabel:Sprite = new Sprite();
		private var settingsContainer:Sprite = new Sprite();
		private var ID:int = -1;
		
		private var remObjects:Array;
		private var arrElements:Array;
		
		private var isSelect:Boolean = false;
		public function SampleSettings() {
			super();
			drawBackground();
			drawArrowLabel(false);
			super.addChild(backgroundLabel);
			backgroundLabel.x = -1;
			super.addChild(arrowLabel);
			arrowLabel.x = 5;
			arrowLabel.y = (hPanel - 10)/2;
			arrowLabel.mouseEnabled = false;
			settingsContainer.y = hPanel;
			backgroundLabel.addEventListener(MouseEvent.CLICK, BG_MOUSE_CLICK);
		}
		private function drawBackground():void{
			backgroundLabel = new Sprite();
			backgroundLabel.graphics.lineStyle(1, 0x969696, 1);
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xEFEFEF, 0x8F8F8F, 0x8F8F8F, 0xE0E0E0];
			var alphas:Array = [1, 1, 1, 1];
			var ratios:Array = [0, 75, 225, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(2000, hPanel, Math.PI/2, 0, 0);
			var spreadMethod:String = SpreadMethod.REFLECT;
			backgroundLabel.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			backgroundLabel.graphics.drawRect(0, 0 , 2000, hPanel);
			backgroundLabel.graphics.endFill();
			
		}
		private function drawArrowLabel(value:Boolean):void{
			arrowLabel.graphics.clear();
			if(value){
				Figure.insertCurve(arrowLabel, [[0, 0],[5, 10],[10, 0]], 1, 0.1, 0x4B4B4B, 1, 0xEEEEEE);
			}else{
				Figure.insertCurve(arrowLabel, [[0, 0],[10, 5],[0, 10]], 1, 0.1, 0x4B4B4B, 1, 0xEEEEEE);
			}
		}
		private function insertLabel(value:String):void{
			panelName = value;
			label = new PanelLabel(value);
			super.addChild(label);
			label.x = 20;
			label.mouseChildren = false;
			label.mouseEnabled = false;
			label.size = 11;
			label.textColor = 0x303030;
		}
		override public function get name():String{
			return panelName;
		}
		public function set select(value:Boolean):void{
			isSelect = value;
			drawArrowLabel(value);
			if(value){
				super.addChild(settingsContainer);
			}else{
				if(super.contains(settingsContainer)) super.removeChild(settingsContainer);
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		public function set id(value:int):void{
			ID = value;
		}
		public function get id():int{
			return ID;
		}
		private function BG_MOUSE_CLICK(event:MouseEvent):void{
			this.select = !this.select;
			super.dispatchEvent(new Event(SAMPLE_SELECT));
		}
		
		
		
		public function createPanel(inXml:XMLList, arrObj:Array):void{
			clear();
			remObjects = arrObj;
			insertLabel(inXml.@label);
			arrElements = new Array();
			var ID:int = -1;
			var id:int;
			var str:String;
			for each(var block:XML in inXml.elements()){
				++ID
				arrElements[ID] = new Array();
				arrElements[ID][0] = new PanelLine(block.@label.toString());
				++ID;
				arrElements[ID] = new Array();
				id = -1;
				for each(var element:XML in block.elements()){
					str = element.name().toString();
					++id;
					switch(str){
						case 'FIELD':
							arrElements[ID].push(new PanelField(element));
							arrElements[ID][id].addEventListener(PanelField.GET_TEXT_PROPERTY, SET_TEXT_PROPERTY);
						break;
						case 'MARK':
							arrElements[ID].push(new PanelMark(element));
							arrElements[ID][id].addEventListener(PanelMark.GET_MARK_PROPERTY, SET_MARK_PROPERTY);
						break;
						case 'CHECK':
							arrElements[ID].push(new MyCheckBox(element));
							arrElements[ID][id].addEventListener(MyCheckBox.CHECK_BOX_CHANGED, SET_CHECK_PROPERTY);
						break;
						case 'LOCK':
							arrElements[ID].push(new PanelLock(element));
							arrElements[ID][id].addEventListener(PanelLock.GET_LOCK_PROPERTY, SET_MARK_PROPERTY);
						break;
						case 'ANIMATION':
							if(remObjects.length == 1){
								arrElements[ID].push(new PanelAnimation(arrObj[0], element));
							}else{
								arrElements.pop()
								arrElements.pop();
								ID-=2;
							}
						break;
					}
				}
			}
			var i:int;
			var j:int;
			for(i=0;i<arrElements.length;i++){
				for(j=0;j<arrElements[i].length;j++){
					if(arrElements[i][j]!=undefined){
						settingsContainer.addChild(arrElements[i][j]);
						settingsContainer.setChildIndex(arrElements[i][j], 0);
						/*if(j==0)*/ arrElements[i][j].x = 0;
						//else arrElements[i][j].x = arrElements[i][j-1].x + arrElements[i][j-1].width;
						try{
							if(i==0) arrElements[i][j].y = 0;
							else arrElements[i][j].y = settingsContainer.height + 10//arrElements[i-1][0].y + arrElements[i-1][0].height + 10;
						}catch(e:TypeError){}
					}
				}
			}
			Figure.insertRect(settingsContainer, settingsContainer.width, settingsContainer.height, 1, 0, 0, 0);
			remObjects[0].addEventListener(CHANGE_LIST, OBJECTS_CHANGE_LIST);
		}
		private function clear():void{
			if(arrElements == null) return;
			while(settingsContainer.numChildren>0){
				settingsContainer.removeChildAt(0);
			}
			var i:int;
			var j:int;
			while(arrElements.length>0){
				while(arrElements[0].length>0){
					arrElements[0].shift();
				}
				arrElements.shift();
			}
		}
		private function SET_TEXT_PROPERTY(e:Event):void{
			var tVar:String = e.target.variable;
			var data:String = e.target.property;
			var i:int;
			var l:int;
			l = remObjects.length;
			switch(e.target.type){
				case 'number':
				if(data.indexOf('.') == data.length-1) return;
				if(data.indexOf('-') == data.length-1) return;
				for(i=0;i<l;i++){
					remObjects[i][tVar] = parseFloat(data);
				}
				break;
				case 'intager':
				if(data.indexOf('-') == data.length-1) return;
				for(i=0;i<l;i++){
					remObjects[i][tVar] = parseInt(data);
				}
				break;
				default:
				for(i=0;i<l;i++){
					remObjects[i][tVar] = data;
				}
			}
			fillProperty();
		}
		private function SET_MARK_PROPERTY(e:Event):void{
			var tVar:String = e.target.variable;
			var data:Boolean = e.target.property;
			var i:int;
			var l:int;
			l = remObjects.length;
			for(i=0;i<l;i++){
				remObjects[i][tVar] = data;
			}
			fillProperty();
		}
		private function SET_CHECK_PROPERTY(e:Event):void{
			var tVar:String = e.target.variable;
			var data:String = e.target.property;
			var i:int;
			var l:int;
			l = remObjects.length;
			for(i=0;i<l;i++){
				remObjects[i][tVar] = data;
			}
			fillProperty();
		}
		
		private function fillProperty():void{
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var tVar:String;
			var value:*;
			l = arrElements.length;
			for(i=0;i<l;i++){
				k = arrElements[i].length;
				for(j=0;j<k;j++){
					tVar = arrElements[i][j].variable;
					if(tVar!='none'){
						value = remObjects[0][tVar];
						arrElements[i][j].property = value;
					}
				}
			}
		}
		
		private function OBJECTS_CHANGE_LIST(event:Event):void{
			var xml:XMLList = remObjects[0].listSettings;
			clearSettings();
			createPanel(xml, remObjects);
			super.dispatchEvent(new Event(SAMPLE_SELECT));
		}
		private function clearSettings():void{
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			l = arrElements.length;
			while(arrElements.length>0){
				while(arrElements[0].length>0){
					settingsContainer.removeChild(arrElements[0][0]);
					if(arrElements[0][0].hasEventListener(PanelField.GET_TEXT_PROPERTY)) arrElements[0][0].removeEventListener(PanelField.GET_TEXT_PROPERTY, SET_TEXT_PROPERTY);
					if(arrElements[0][0].hasEventListener(PanelMark.GET_MARK_PROPERTY)) arrElements[0][0].removeEventListener(PanelMark.GET_MARK_PROPERTY, SET_MARK_PROPERTY);
					if(arrElements[0][0].hasEventListener(MyCheckBox.CHECK_BOX_CHANGED)) arrElements[0][0].removeEventListener(MyCheckBox.CHECK_BOX_CHANGED, SET_CHECK_PROPERTY);
					arrElements[0].shift();
				}
				arrElements.shift();
			}
			remObjects[0].removeEventListener(CHANGE_LIST, OBJECTS_CHANGE_LIST);
		}
	}
	
}
