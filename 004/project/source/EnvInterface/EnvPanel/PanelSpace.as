package source.EnvInterface.EnvPanel {
	import flash.display.Sprite;
	import source.EnvEvents.Events;
	import flash.events.Event;
	import flash.net.SharedObject;

	public class PanelSpace extends Sprite{
		
		private var arrPanel:Array = new Array();
		private var arrBlock:Array = new Array();
		private var panelSO:SharedObject;
		private var currentXml:XMLList;
		private var isProgramPos:Boolean = false;
		public function PanelSpace(panelContainer:Sprite) {
			super();
			panelContainer.addChild(super);
			panelSO = SharedObject.getLocal('Panels');
			//panelSO.clear();
		}
		public function addPanel(namePanel:String):Panel{
			var ID:int = arrPanel.length;
			arrPanel.push(new Panel(namePanel));
			super.addChild(arrPanel[ID]);
			arrPanel[ID].y = 20;
			writeSettingsInPanel(ID);
			arrPanel[ID].addEventListener(Events.PANEL_IS_CHANGE, PANEL_IS_CHANGE);
			arrPanel[ID].addEventListener(Panel.PANEL_IS_DRAG, PANEL_IS_DRAG);
			arrPanel[ID].addEventListener(Panel.PANEL_DRAG_COMPLATE, PANEL_DRAG_COMPLATE);
			return arrPanel[ID];
		}
		private function PANEL_IS_DRAG(e:Event):void{
			var panel:Panel = e.target as Panel;
			var x:Number = panel.cursor.stageX;
			var y:Number = panel.cursor.stageY;
			var i:int;
			var l:int;
			var label:String = panel.label;
			
			var currentBlock:BlockPanels;
			var remBlock:BlockPanels;
			l = arrBlock.length;
			for(i=0;i<l;i++){
				currentBlock = arrBlock[i] as BlockPanels;
				if(x>currentBlock.x && x<currentBlock.x+currentBlock.WIDTH &&
				   y>currentBlock.y && y<currentBlock.y+currentBlock.HEIGHT){
					   if(remBlock!=null){
						   if(super.getChildIndex(remBlock)<super.getChildIndex(currentBlock)){
							   remBlock = currentBlock;
						   }
					   }else{
						   remBlock = currentBlock;
					   }
				   }
				   currentBlock.select = false;
			}
			
			if(remBlock!=null)remBlock.select = true;
			
			var currentPanel:Panel;
			var remPanel:Panel;
			l = arrPanel.length;
			for(i=0;i<l;i++){
				currentPanel = arrPanel[i] as Panel;
				if(currentPanel.label != label && currentPanel.visible && super.contains(currentPanel) && !currentPanel.isInBlock){
					if(x>currentPanel.x && x<currentPanel.x+currentPanel.WIDTH &&
					   y>currentPanel.y && y<currentPanel.y+currentPanel.HEIGHT){
						   if(currentPanel != remPanel){
							   if(remPanel != null){
								   if(super.getChildIndex(remPanel)<super.getChildIndex(currentPanel)){
									   remPanel = currentPanel;
								   }
							   }else{
								   remPanel = currentPanel;
							   }
						   }
					   }
				}
				currentPanel.select = false;
			}
			if(remPanel!=null && remBlock==null) remPanel.select = true;
		}
		private function PANEL_DRAG_COMPLATE(e:Event):void{
			var panel:Panel = e.target as Panel;
			var i:int;
			var l:int;
			l = arrBlock.length;
			for(i=0;i<l;i++){
				if(arrBlock[i].select){
					arrBlock[i].addPanel(panel);
					arrBlock[i].select = false;
					PANEL_IS_CHANGE();
					return;
				}
			}
			var selectPanel:Panel;
			l = arrPanel.length;
			for(i=0;i<l;i++){
				if(arrPanel[i].select){
					selectPanel = arrPanel[i] as Panel;
				}
			}
			if(selectPanel == null) return;
			var currentBlock:BlockPanels = new BlockPanels();
			super.addChild(currentBlock);
			currentBlock.x = selectPanel.x;
			currentBlock.y = selectPanel.y;
			var size:Object = selectPanel.getSizeSettings();
			currentBlock.setSize(size.width, size.height);
			currentBlock.addPanel(selectPanel);
			currentBlock.addPanel(panel);
			currentBlock.addEventListener(BlockPanels.REMOVE_BLOCK, ON_REMOVE_BLOCK);
			currentBlock.addEventListener(Events.PANEL_IS_CHANGE, PANEL_IS_CHANGE);
			arrBlock.push(currentBlock);
			PANEL_IS_CHANGE();
		}
		private function ON_REMOVE_BLOCK(e:Event):void{
			var i:int;
			var l:int;
			l = arrBlock.length;
			for(i=0;i<l;i++){
				if(arrBlock[i].isRemove){
					super.removeChild(arrBlock[i]);
					arrBlock[i].addEventListener(BlockPanels.REMOVE_BLOCK, ON_REMOVE_BLOCK);
					arrBlock.splice(i,1);
					return;
				}
			}
		}
		
		private function PANEL_IS_CHANGE(e:Event = null):void{
			var outXml:XMLList = new XMLList('<PANELS/>')
			var sample:XMLList;
			var panelXml:XMLList;
			var i:int;
			var l:int;
			var k:int;
			var j:int;
			var labelArr:Array;
			l = arrPanel.length;
			for(i=0;i<l;i++){
				if(!arrPanel[i].isInBlock){
					sample = new XMLList('<PANEL/>');
					sample.@id = i.toString();
					sample.@label = arrPanel[i].label;
					sample.@x = arrPanel[i].x;
					sample.@y = arrPanel[i].y;
					sample.@width = arrPanel[i].WIDTH;
					sample.@height = arrPanel[i].HEIGHT;
					sample.@visible = arrPanel[i].visible;
					outXml.appendChild(sample);
				}
			}
			l = arrBlock.length;
			for(i=0;i<l;i++){
				try{
					sample = new XMLList('<BLOCK/>');
					sample.@id = i.toString();
					sample.@x = arrBlock[i].x;
					sample.@y = arrBlock[i].y;
					sample.@width = arrBlock[i].WIDTH;
					sample.@height = arrBlock[i].HEIGHT;
					labelArr = arrBlock[i].allPanelLabel;
					k = labelArr.length;
					for(j=0;j<k;j++){
						panelXml = new XMLList('<PANEL/>');
						panelXml.@label = labelArr[j][0];
						panelXml.@width = labelArr[j][1];
						panelXml.@height = labelArr[j][2];
						sample.appendChild(panelXml);
					}
					outXml.appendChild(sample);
				}catch(error:TypeError){}
			}
			//trace(this + ': PANEL XML = \n' + outXml);
			delete panelSO.data.settings;
			panelSO.data.settings = outXml.toString();
			try{
				panelSO.flush();
			}catch(e:Error){}
		}
		
		public function applySetPanel(value:String):void{
			isProgramPos = true;
			getPanelFromBlock();
			switch(value){
				case 'STANDART':
				currentXml = BasePositionPanel.standartPosition;
				break;
			}
			var i:int;
			var l:int;
			l = arrPanel.length;
			for(i=0;i<l;i++){
				writeSettingsInPanel(i);
			}
			PANEL_IS_CHANGE();
		}
		private function getPanelFromBlock():void{
			while(arrBlock.length>0){
				arrBlock[0].removeBlock();
			}
			super.stopDrag();
		}
		private function writeSettingsInPanel(ID:int):void{
			var inXml:XMLList;
			if(isProgramPos){
				inXml = currentXml;
			}else{
				inXml = new XMLList(panelSO.data.settings)
			}
			if(inXml == null) return;
			//trace(this + ': IN XML PANEL = ' + inXml);
			var label:String = arrPanel[ID].label;
			//trace(this + ': PANEL NAME = ' + label);
			var sample:XMLList = inXml.PANEL.(@label == label);
			var name:XMLList;
			var blockID:int;
			var blockX:Number;
			var blockY:Number;
			var blockW:Number;
			var blockH:Number;
			if(sample.@id.toString()==''){
				for each(var block:XML in inXml.BLOCK){
					name = block.PANEL.(@label == label);
					//trace(this + ': BLOCK ID = ' + block.@id);
					//trace(this + ': PANEL XML IN BLOCK = ' + name.attributes());
					blockID = parseInt(block.@id)
					blockX = parseFloat(block.@x);
					blockY = parseFloat(block.@y);
					blockW = parseFloat(block.@width);
					blockH = parseFloat(block.@height);
					if(name.@label.toString() != ''){
						var w:Number = parseFloat(name.@width);
						var h:Number = parseFloat(name.@height);
						arrPanel[ID].setSizePanel(w, h);
						//trace(this + ': BLOCK ?= ' + arrBlock[blockID])
						if(arrBlock[blockID] == undefined){
							var currentBlock:BlockPanels = new BlockPanels();
							super.addChild(currentBlock);
							currentBlock.x = blockX;
							currentBlock.y = blockY;
							currentBlock.setSize(blockW, blockH);
							currentBlock.addEventListener(BlockPanels.REMOVE_BLOCK, ON_REMOVE_BLOCK);
							currentBlock.addEventListener(Events.PANEL_IS_CHANGE, PANEL_IS_CHANGE);
							arrBlock[blockID] = currentBlock;
						}
						arrBlock[blockID].addPanel(arrPanel[ID]);
						return;
					}
				}
			}else{
				arrPanel[ID].x = parseFloat(sample.@x.toString());
				arrPanel[ID].y = parseFloat(sample.@y.toString());
				arrPanel[ID].setSizePanel(parseFloat(sample.@width.toString()), parseFloat(sample.@height.toString()));
				arrPanel[ID].visible = sample.@visible.toString() == 'true';
			}
		}
	}
	
}
