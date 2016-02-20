package source.Task.TaskObjects.UserTan {
	import source.Task.TaskObjects.BaseTan.BaseLineTan;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import source.utils.CuterPict;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.events.Event;
	
	public class OneUserTan extends BaseLineTan{
		//public var symmetry:int = 1;
		private var typeTan:String;
		private var bitmapName:String = '';
		private var remBitmap:Bitmap;
		private var remRect:Rectangle;
		private var isSymmetry:Boolean = false;
		private var remXml:XMLList;
		public function OneUserTan(inXml:XMLList, colorContainer:Sprite, blackContainer:Sprite, bitmap:Bitmap = null, name:String = null, byteArray:ByteArray = null) {
			super(colorContainer, blackContainer);
			bitmapName = name;
			remBitmap = bitmap;
			remXml = inXml;
			//trace(this + ': BITMAP = ' + bitmap + ', NAME = ' + name);
			//trace(this + ': inXml = ' + inXml)
			typeTan = inXml.@type.toString();
			for each(var sample:XML in inXml.POINTS){
				addArrayPoint(sample);
			}
			switch(typeTan){
				case 'line':
				drawLineTan();
				break;
				case 'curve':
				drawCurveTan();
				break;
				default:
				//super.stand = true;
				return;
			}
			//if(inXml.WIDTH.toString()!=''){
				super.setSize(parseFloat(inXml.WIDTH), parseFloat(inXml.HEIGHT));
			//}else{
				//super.rememberSize();
			//}
			if(inXml.ISDRAG.toString()!='') super.drag = inXml.ISDRAG.toString()=='true';
			if(inXml.ISROTATION.toString()!='') super.cRotation = inXml.ISROTATION.toString()=='true';
			if(inXml.ISDINAMYC.toString()!='') super.dinamyc = inXml.ISDINAMYC.toString()=='true';
			
			if(inXml.ISDROPBACK.toString()!='') super.dropBack = inXml.ISDROPBACK.toString()=='true';
			if(inXml.ISSTARTPOS.toString()!='') super.startPosition = inXml.ISSTARTPOS.toString()=='true';
			
			if(inXml.CUT.toString()!='') super.cut = inXml.CUT.toString()=='true';
			super.setColorPosition(parseFloat(inXml.COLOR.X), parseFloat(inXml.COLOR.Y));
			super.setBlackPosition(parseFloat(inXml.BLACK.X), parseFloat(inXml.BLACK.Y));
			super.colorR = parseInt(inXml.COLOR.R);
			super.blackR = parseInt(inXml.BLACK.R);
			super.color = inXml.COLOR.COLOR;
			super.line = inXml.COLOR.CONTOUR.toString() == '1' || inXml.COLOR.CONTOUR.toString() == '';
			super.fill = inXml.COLOR.FILL.toString() == '1' || inXml.COLOR.FILL.toString() == '';
			if(inXml.COLOR.SYMMETRY.toString()!= '') super.isSymmetryTan = parseInt(inXml.COLOR.SYMMETRY);
			super.alphaB = inXml.BLACK.ALPHA.toString() == '1';
			super.alphaBGBlack = inXml.BLACK.ALPHABG.toString() == '1';
			
			if(inXml.BLACK.ALPHALINE.toString()!='') super.alphaLineBlack = inXml.BLACK.ALPHALINE.toString() == 'true';
			
			super.deleteB = inXml.BLACK.DELETE.toString() == '1';
			super.deleteC = inXml.COLOR.DELETE.toString() == '1';
			super.paint = inXml.COLOR.PAINT.toString() == '1';
			super.cleenColor = inXml.COLOR.CLEENCOLOR.toString() == 'true';
			
			if(inXml.ENABLEDCOLOR.toString()!='') super.activeEnabled = inXml.ENABLEDCOLOR.toString()=='true';
			
			if(inXml.COLOR.THICKLINE.toString()!='') super.tanLineThick = parseFloat(inXml.COLOR.THICKLINE.toString());
			if(inXml.COLOR.COLORLINE.toString()!='') super.tanLineColor = uint(inXml.COLOR.COLORLINE.toString());
			if(inXml.COLOR.ALPHA.toString()!='') super.tanAlphaColor = parseFloat(inXml.COLOR.ALPHA.toString());
			
			if(inXml.COLOR.ANIMATION.toString()!='') super.listAnimationColor = inXml.COLOR.ANIMATION;
			if(inXml.BLACK.ANIMATION.toString()!='') super.listAnimationBlack = inXml.BLACK.ANIMATION;
			if(inXml.COLOR.TYPE.toString()!='') super.typeC = parseInt(inXml.COLOR.TYPE.toString());
			if(inXml.BLACK.TYPE.toString()!='') super.typeB = parseInt(inXml.BLACK.TYPE.toString());
			if(inXml.STARTANIMATIONCOMPLATE.toString() != '') super.complateAnimation = inXml.STARTANIMATIONCOMPLATE.toString();
			if(inXml.STARTANIMATIONDOWN.toString() != '') super.downAnimation = inXml.STARTANIMATIONDOWN.toString();
			if(inXml.SHOWING.toString()!=''){
				if(inXml.SHOWING.TAN.toString() == 'BLACK'){
					super.setShowing('ЧЁРНЫЙ', parseInt(inXml.SHOWING.BLOCK.toString()), parseInt(inXml.SHOWING.SHOW.toString()));
				}else{
					super.setShowing('ЦВЕТНОЙ', parseInt(inXml.SHOWING.BLOCK.toString()), parseInt(inXml.SHOWING.SHOW.toString()));
				}
			}
			if(inXml.VANISHING.toString()!=''){
				if(inXml.VANISHING.TAN.toString() == 'BLACK'){
					super.setVanishing('ЧЁРНЫЙ', parseInt(inXml.VANISHING.BLOCK.toString()), parseInt(inXml.VANISHING.SHOW.toString()), parseInt(inXml.VANISHING.VANISH.toString()));
				}else{
					super.setVanishing('ЦВЕТНОЙ', parseInt(inXml.VANISHING.BLOCK.toString()), parseInt(inXml.VANISHING.SHOW.toString()), parseInt(inXml.VANISHING.VANISH.toString()));
				}
			}
			//trace(this + ': IMAGE XML = ' + inXml.IMAGE);
			//trace(this + ': IS IMAGE = ' + inXml.IMAGE.toString()!='');
			if(inXml.IMAGE.@x.toString()!=''){
				if(byteArray == null){
					//trace(this + ': IS IMAGE = ' + inXml.IMAGE.toString()!='');
					remRect = new Rectangle(parseFloat(inXml.IMAGE.@x), parseFloat(inXml.IMAGE.@y), parseFloat(inXml.IMAGE.@width), parseFloat(inXml.IMAGE.@height));
					//trace(this + ': RECTANGLE = ' + remRect);
					super.image = CuterPict.cutSamplePict(bitmap, remRect);
				}else{
					var loader:Loader = new Loader();
					var context:LoaderContext = new LoaderContext();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_PICTURE_COMPLATE);
					loader.loadBytes(byteArray, context);
				}
			}
			
		}
		public function get content():Bitmap{
			if(remBitmap == null) return null;
			return CuterPict.copyBitmap(remBitmap);
		}
		private function LOAD_PICTURE_COMPLATE(event:Event):void{
			remRect = new Rectangle(parseFloat(remXml.IMAGE.@x), parseFloat(remXml.IMAGE.@y), parseFloat(remXml.IMAGE.@width), parseFloat(remXml.IMAGE.@height));
			remBitmap =  event.target.content;
			super.image = CuterPict.cutSamplePict(remBitmap, remRect);
		}
		private var arrXmlPoint:Array = new Array();
		private function addArrayPoint(xml:XML):void{
			arrXmlPoint.push(xml);
		}
		private function drawLineTan():void{
			var outArr:Array = new Array();
			var str:String;
			var X:Number;
			var Y:Number;
			var i:int;
			var l:int;
			l = arrXmlPoint.length;
			for(i=0;i<l;i++){
				outArr.push(new Array());
				for each(var sample:XML in arrXmlPoint[i].elements()){
					str = sample.name().toString();
					if(str == 'POINT'){
						X = parseFloat(sample.@x);
						Y = parseFloat(sample.@y);
						outArr[i].push([X, Y]);
					}
				}
			}
			super.arrPoint = outArr;
		}
		private function drawCurveTan():void{
			var outArr:Array = new Array();
			var str:String;
			var X:Number;
			var Y:Number;
			var aX:Number;
			var aY:Number;
			var i:int;
			var l:int;
			l = arrXmlPoint.length;
			for(i=0;i<l;i++){
				outArr.push(new Array());
				for each(var sample:XML in arrXmlPoint[i].elements()){
					str = sample.name().toString();
					if(str == 'POINT'){
						X = parseFloat(sample.@x);
						Y = parseFloat(sample.@y);
						aX = parseFloat(sample.@anchorX);
						aY = parseFloat(sample.@anchorY);
						outArr[i].push([X, Y, aX, aY]);
					}
				}
			}
			super.arrPoint = outArr;
		}
		public function set symmetryTan(value:Boolean):void{
			isSymmetry = value;
			var i:int;
			var l:int;
			var arr:Array = new Array();
			var arr1:Array = new Array();
			var outArr:Array = new Array();
			l = super.arrPoint[0].length;
			if(value){
				for(i=0;i<l;i++){
					//trace(this + ': X = ' + super.arrPoint[0][i][0] + '; Y = ' + super.arrPoint[0][i][1]);
					if(typeTan == 'line'){
						arr.push([super.arrPoint[0][i][0], super.arrPoint[0][i][1]]);
						arr1.push([-1*super.arrPoint[0][i][0], super.arrPoint[0][i][1]]);
					}else{
						if(i==0){
							arr.push([super.arrPoint[0][i][0], super.arrPoint[0][i][1], 'NaN', 'NaN']);
							arr1.push([-1*super.arrPoint[0][i][0], super.arrPoint[0][i][1], 'NaN', 'NaN']);
						}else{
							arr.push([super.arrPoint[0][i][0], super.arrPoint[0][i][1], super.arrPoint[0][i][2], super.arrPoint[0][i][3]]);
							arr1.push([-1*super.arrPoint[0][i][0], super.arrPoint[0][i][1], -1*super.arrPoint[0][i][2], super.arrPoint[0][i][3]]);
						}
					}
				}
				outArr.push(arr);
				outArr.push(arr1);
			}else{
				for(i=0;i<l;i++){
					if(typeTan == 'line'){
						arr.push([super.arrPoint[0][i][0], super.arrPoint[0][i][1]]);
					}else{
						if(i==0){
							arr.push([super.arrPoint[0][i][0], super.arrPoint[0][i][1], 'NaN', 'NaN']);
						}else{
							arr.push([super.arrPoint[0][i][0], super.arrPoint[0][i][1], super.arrPoint[0][i][2], super.arrPoint[0][i][3]]);
						}
					}
				}
				outArr.push(arr);
			}
			super.arrPoint = outArr;
			super.typeC = 1;
			super.typeB = 1;
		}
		public function get symmetryTan():Boolean{
			return isSymmetry;
		}
		
		public function get listSettings():XMLList{
			var outXml:XMLList = super.listLineSettings;
			var symetryXml:XMLList = new XMLList('<MARK label="Симметричное отображение" variable="symmetryTan">'+this.symmetryTan.toString()+'</MARK>');
			outXml.BLOCK.(@label == "действия над танами").appendChild(symetryXml);
			outXml.@label = 'ПОЛЬЗОВАТЕЛЬСКИЙ ТАН';
			return outXml;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<USERTAN/>');
			outXml.@type = typeTan;
			
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			var inArrPoint:Array;
			var pointXml:XMLList
			//trace(this + 'POINT LIST 1');
			k = super.arrPoint.length;
			//trace(this + 'POINT LIST 2');
			for(j=0;j<k;j++){
				inArrPoint = super.arrPoint[j];
				//trace(this + 'POINT LIST 3');
				l = inArrPoint.length;
				//trace(this + 'POINT LIST 4');
				pointXml = new XMLList('<POINTS/>');
				var currentPoint:XMLList;
				//trace(this + 'POINT LIST 5');
				switch(typeTan){
					case 'line':
					//trace(this + 'POINT LIST 6 LINE');
					for(i=0;i<l;i++){
						currentPoint = new XMLList('<POINT/>');
						currentPoint.@id = i.toString();
						currentPoint.@x = inArrPoint[i][0];
						currentPoint.@y = inArrPoint[i][1];
						pointXml.appendChild(currentPoint);
					}
					break;
					case 'curve':
					//trace(this + 'POINT LIST 6 CURVE');
					for(i=0;i<l;i++){
						currentPoint = new XMLList('<POINT/>');
						currentPoint.@id = i.toString();
						currentPoint.@x = inArrPoint[i][0];
						currentPoint.@y = inArrPoint[i][1];
						currentPoint.@anchorX = inArrPoint[i][2];
						currentPoint.@anchorY = inArrPoint[i][3];
						pointXml.appendChild(currentPoint);
					}
					break;
				}
				//trace(this + 'POINT LIST 7');
				outXml.appendChild(pointXml);
			}
			
			
			
			
			//trace(this + 'POINT LIST 8');
			outXml.WIDTH = super.width;
			outXml.HEIGHT = super.height;
			outXml.ISDRAG = super.drag.toString();
			outXml.ISROTATION = super.cRotation.toString();
			outXml.ISDINAMYC = super.dinamyc.toString();
			outXml.ISDROPBACK = super.dropBack.toString();
			outXml.ISSTARTPOS = super.startPosition.toString();
			outXml.CUT = super.cut.toString();
			outXml.COLOR.X = super.colorX.toString();
			outXml.COLOR.Y = super.colorY.toString();
			outXml.COLOR.R = super.colorR.toString();
			outXml.COLOR.COLOR = super.color;
			
			//trace(this + 'POINT LIST 9');
			if(super.line){
				outXml.COLOR.CONTOUR = '1';
			}else{
				outXml.COLOR.CONTOUR = '0';
			}
			//trace(this + 'POINT LIST 10');
			if(super.fill){
				outXml.COLOR.FILL = '1';
			}else{
				outXml.COLOR.FILL = '0';
			}
			
			outXml.BLACK.ALPHALINE = super.alphaLineBlack;
			
			outXml.COLOR.THICKLINE = super.tanLineThick.toString();
			outXml.COLOR.COLORLINE = super.tanLineColor.toString();
			outXml.COLOR.ALPHA = super.tanAlphaColor.toString();
			if(super.deleteC){
				outXml.COLOR.DELETE = '1';
			}else{
				outXml.COLOR.DELETE = '0';
			}
			//trace(this + 'POINT LIST 11');
			if(super.arrPoint.length>1){
				outXml.COLOR.TYPE = super.typeC;
			}
			//trace(this + 'POINT LIST 12');
			outXml.COLOR.SYMMETRY = super.isSymmetryTan.toString();
			if(super.paint) outXml.COLOR.PAINT = '1';
			outXml.COLOR.CLEENCOLOR = super.cleenColor.toString();
			if(super.listAnimationColor!=null) outXml.COLOR.appendChild(super.listAnimationColor);
			outXml.BLACK.X = super.blackX.toString();
			outXml.BLACK.Y = super.blackY.toString();
			outXml.BLACK.R = super.blackR.toString();
			//trace(this + 'POINT LIST 13');
			
			outXml.ENABLEDCOLOR = super.activeEnabled.toString();
			
			if(super.alphaB){
				outXml.BLACK.ALPHA = '1';
			}else{
				outXml.BLACK.ALPHA = '0';
			}
			//trace(this + 'POINT LIST 14');
			if(super.alphaBGBlack){
				outXml.BLACK.ALPHABG = '1';
			}else{
				outXml.BLACK.ALPHABG = '0';
			}
			//trace(this + 'POINT LIST 15');
			if(super.deleteB){
				outXml.BLACK.DELETE = '1';
			}else{
				outXml.BLACK.DELETE = '0';
			}
			//trace(this + 'POINT LIST 16');
			if(super.arrPoint.length>1){
				outXml.BLACK.TYPE = super.typeB;
			}
			if(super.listAnimationBlack!=null) outXml.BLACK.appendChild(super.listAnimationBlack);
			if(super.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = super.complateAnimation;
			if(super.downAnimation != '') outXml.STARTANIMATIONDOWN = super.downAnimation;
			if(super.showTan != 'НЕТ'){
				if(super.showTan == 'ЦВЕТНОЙ') {
					outXml.SHOWING.TAN = 'COLOR';
				}else{
					outXml.SHOWING.TAN = 'BLACK';
				}
				outXml.SHOWING.BLOCK = super.showBlock;
				outXml.SHOWING.SHOW = super.showShow;
			}
			///trace(this + 'POINT LIST 17');
			if(super.vanishTan != 'НЕТ'){
				if(super.vanishTan == 'ЦВЕТНОЙ'){
					outXml.VANISHING.TAN = 'COLOR';
				}else{
					outXml.VANISHING.TAN = 'BLACK';
				}
				outXml.VANISHING.BLOCK = super.vanishBlock;
				outXml.VANISHING.SHOW = super.vanishShow;
				outXml.VANISHING.VANISH = super.vanishVanish;
			}
			///trace(this + 'POINT LIST 18');
			try{
				if(bitmapName!=null && bitmapName!=''){
					var imageXml:XMLList = new XMLList('<IMAGE/>');
					imageXml.@name = bitmapName;
					imageXml.@x = remRect.x;
					imageXml.@y = remRect.y;
					imageXml.@width = remRect.width;
					imageXml.@height = remRect.height;
					outXml.appendChild(imageXml);
				}
			}catch(error:TypeError){};
			//trace(this + 'POINT LIST 19');
			return outXml;
		}
		/*public function get content():Bitmap{
			return this.remBitmap;
		}*/
		public function get fileName():String{
			return bitmapName
		}
		
		public function get imageTanSettings():Object{
			if(bitmapName == '') return null;
			var outObject:Object = new Object();
			outObject.name = bitmapName;
			outObject.rectangle = remRect;
			return outObject;
		}
	}
	
}
