package source.EnvKonstraktion.ImageDataBase {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.EnvUtils.EnvDraw.Figure;
	
	public class FolderImage extends Sprite{
		public static var FOLDER_CHANGE:String = 'onFolderChange';
		
		private var cFolder:closeFolder = new closeFolder();
		private var oFolder:opFold = new opFold();
		
		private var treeContainer:Sprite = new Sprite();
		private var labelRect:Sprite = new Sprite();
		private var lFolder:TextField = new TextField();
		
		private var arrFolder:Array;
		private var arrFile:Array;
		
		private var currentFile:String;
		private var currentName:String;
		private var folderName:String;
		public function FolderImage(inXML:XML) {
			super();
			initFolder();
			addLabel(inXML.@name.toString());
			initHandler();
			this.list = inXML;
		}
		private function initHandler():void{
			labelRect.addEventListener(MouseEvent.CLICK, FOLDER_CLICK);
		}
		private function addLabel(name:String):void{
			folderName = name;
			lFolder.text = name;
			Figure.insertRect(labelRect, super.width, super.height);
			labelRect.alpha = 0;
			super.addChild(labelRect);
		}
		private function initFolder():void{
			super.addChild(cFolder);
			super.addChild(oFolder);
			super.addChild(lFolder);
			treeContainer.y = oFolder.height + 5;
			treeContainer.x = lFolder.x = oFolder.width + 5;
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.size = 14;
			lFolder.defaultTextFormat = format;
			lFolder.autoSize = TextFieldAutoSize.LEFT;
			lFolder.mouseEnabled = false;
			oFolder.visible = false;
		}
		
		public function set list(value:XML):void{
			arrFolder = new Array();
			arrFile = new Array();
			var name:String;
			for each(var sample:XML in value.elements()){
				name = sample.name();
				if(name == 'DIR'){
					arrFolder.push(new FolderImage(sample));
				}
				if(name == 'FILE'){
					arrFile.push(new FileImage(sample));
				}
			}
			var i:int;
			var l:int;
			var k:int;
			var startFileX:Number = 0;
			l = arrFolder.length;
			for(i=0;i<l;i++){
				treeContainer.addChild(arrFolder[i]);
				arrFolder[i].y = i*arrFolder[i].height;
				arrFolder[i].addEventListener(FolderImage.FOLDER_CHANGE, FOLDER_CHANGE);
				arrFolder[i].addEventListener(FileImage.FILE_SELECT, ON_FILE_SELECT);
				startFileX = (i+1)*arrFolder[i].height
			}
			k = arrFile.length;
			for(i=0;i<k;i++){
				treeContainer.addChild(arrFile[i]);
				arrFile[i].y = startFileX + i*arrFile[i].height;
				arrFile[i].addEventListener(FileImage.FILE_SELECT, ON_FILE_SELECT);
			}
		}
		
		private function ON_FILE_SELECT(e:Event):void{
			currentFile = folderName + '/' + e.target.path;
			currentName = e.target.bdName;
			super.dispatchEvent(new Event(FileImage.FILE_SELECT));
		}
		public function get path():String{
			return currentFile;
		}
		public function get bdName():String{
			return currentName;
		}
		
		
		
		
		
		
		
		
		
		
		
		private function correctPosition():void{
			var i:int;
			var l:int;
			var k:int;
			l = arrFolder.length;
			var startFileX:Number = 0;
			if(l!=0) startFileX = arrFolder[0].y + arrFolder[0].height;
			for(i=1;i<l;i++){
				arrFolder[i].y = arrFolder[i-1].y + arrFolder[i-1].height;
				startFileX = arrFolder[i].y + arrFolder[i].height;
			}
			k = arrFile.length;
			for(i=0;i<k;i++){
				arrFile[i].y = startFileX + i*arrFile[i].height;
			}
		}
		
		private function FOLDER_CHANGE(e:Event):void{
			correctPosition();
			super.dispatchEvent(new Event(FolderImage.FOLDER_CHANGE));
		}
		private function FOLDER_CLICK(e:MouseEvent):void{
			if(isOpen)this.close();
			else this.open();
			super.dispatchEvent(new Event(FolderImage.FOLDER_CHANGE));
		}
		
		public function close():void{
			super.removeChild(treeContainer);
			oFolder.visible = false;
			cFolder.visible = true;
			//super.dispatchEvent(new Event(FolderImage.FOLDER_CHANGE));
		}
		public function open():void{
			super.addChild(treeContainer);
			oFolder.visible = true;
			cFolder.visible = false;
			//super.dispatchEvent(new Event(FolderImage.FOLDER_CHANGE));
		}
		public function get isOpen():Boolean{
			return oFolder.visible;
		}

	}
	
}
