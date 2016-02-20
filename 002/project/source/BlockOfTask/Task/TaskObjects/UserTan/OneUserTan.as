package source.BlockOfTask.Task.TaskObjects.UserTan {
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseLineTan;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import source.utils.CuterPict;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import source.utils.CutNormal;
	
	public class OneUserTan extends BaseLineTan{
		public var symmetry:int = 1;
		public function OneUserTan(inXml:XMLList, colorContainer:Sprite, blackContainer:Sprite, image:ByteArray = null) {
			super(colorContainer, blackContainer);
			if(inXml.POINTS.toString()=='') {
				super.stand = true;
				return;
			}
			var type:String = inXml.@type.toString();
			for each(var sample:XML in inXml.POINTS){
				addArrayPoint(sample);
			}
			switch(type){
				case 'line':
				drawLineTan();
				break;
				case 'curve':
				drawCurveTan();
				break;
				default:
				super.stand = true;
				return;
			}
			if(inXml.WIDTH.toString()!=''){
				super.setSize(parseFloat(inXml.WIDTH), parseFloat(inXml.HEIGHT));
			}else{
				super.rememberSize();
			}
			if(inXml.ISDRAG.toString()!='') super.drag = inXml.ISDRAG.toString()=='true';
			if(inXml.ISROTATION.toString()!='') super.cRotation = inXml.ISROTATION.toString()=='true';
			if(inXml.ISDINAMYC.toString()!='') super.dinamyc = inXml.ISDINAMYC.toString()=='true';
			if(inXml.ISSTARTPOS.toString()!='') super.startPosition = inXml.ISSTARTPOS.toString()=='true';
			if(inXml.ISDROPBACK.toString()!='') super.dropBack = inXml.ISDROPBACK.toString()=='true';
			super.setColorPosition(parseFloat(inXml.COLOR.X), parseFloat(inXml.COLOR.Y));
			super.setBlackPosition(parseFloat(inXml.BLACK.X), parseFloat(inXml.BLACK.Y));
			super.startColorR = super.colorR = parseInt(inXml.COLOR.R);
			super.blackR = parseInt(inXml.BLACK.R);
			super.color = inXml.COLOR.COLOR;
			super.line = inXml.COLOR.CONTOUR.toString() == '1' || inXml.COLOR.CONTOUR.toString() == '';
			super.fill = inXml.COLOR.FILL.toString() == '1' || inXml.COLOR.FILL.toString() == '';
			this.symmetry = parseInt(inXml.COLOR.SYMMETRY);
			
			if(inXml.COLOR.THICKLINE.toString()!='') super.tanLineThick = parseFloat(inXml.COLOR.THICKLINE.toString());
			if(inXml.COLOR.COLORLINE.toString()!='') super.tanLineColor = uint(inXml.COLOR.COLORLINE.toString());
			if(inXml.COLOR.ALPHA.toString()!='') super.tanAlphaColor = parseFloat(inXml.COLOR.ALPHA.toString());
			
			super.alphaB = inXml.BLACK.ALPHA.toString() == '1';
			super.alphaBGBlack = inXml.BLACK.ALPHABG.toString() == '1';
			super.deleteB = inXml.BLACK.DELETE.toString() == '1';
			super.deleteColorTan = inXml.COLOR.DELETE.toString() == '1';
			if(inXml.COLOR.TYPE.toString()!='') super.startTypeColor = super.typeC = parseInt(inXml.COLOR.TYPE.toString());
			if(inXml.BLACK.TYPE.toString()!='') super.typeB = parseInt(inXml.BLACK.TYPE.toString());
			
			if(inXml.COLOR.CLEENCOLOR.toString()!='') super.colorCleen = inXml.COLOR.CLEENCOLOR.toString() == 'true';
			
			if(inXml.COLOR.PAINT.toString()!='' && inXml.COLOR.PAINT.toString()!='0'){
				super.paintTan(parseInt(inXml.COLOR.PAINT));
			}
			
			if(inXml.CUT.toString()!=''){
				if(inXml.CUT.toString()=='true'){
					var cutArr:Array = CutNormal.getCutNormal(super.arrPoint);
					var p:int;
					var o:int;
					o = cutArr.length;
					for(p=0;p<o;p++){
						trace(this + cutArr[p]);
					}
					super.cutTan(cutArr, false, true, true);
				}
			}
			if(inXml.SHOWING.toString()!=''){
				if(inXml.SHOWING.TAN.toString() == 'COLOR'){
					super.setShowing('color', parseInt(inXml.SHOWING.BLOCK), parseInt(inXml.SHOWING.SHOW));
				}else{
					super.setShowing('black', parseInt(inXml.SHOWING.BLOCK), parseInt(inXml.SHOWING.SHOW));
				}
			}
			if(inXml.VANISHING.toString()!=''){
				if(inXml.VANISHING.TAN.toString() == 'COLOR'){
					super.setVanishing('color', parseInt(inXml.VANISHING.BLOCK), parseInt(inXml.VANISHING.SHOW), parseInt(inXml.VANISHING.VANISH));
				}else{
					super.setVanishing('black', parseInt(inXml.VANISHING.BLOCK), parseInt(inXml.VANISHING.SHOW), parseInt(inXml.VANISHING.VANISH));
				}
			}
			if(inXml.STARTANIMATIONCOMPLATE.toString()!='') super.animationToComplate = inXml.STARTANIMATIONCOMPLATE.toString();
			if(inXml.STARTANIMATIONDOWN.toString()!='') super.animationToDown = inXml.STARTANIMATIONDOWN.toString();
			
			if(inXml.IMAGE.@name.toString()!=''){
				loadPicture(inXml, image);
			}else{
				if(inXml.COLOR.ANIMATION.toString()) super.setListColorAnimation(inXml.COLOR.ANIMATION, super);
				if(inXml.BLACK.ANIMATION.toString()) super.setListBlackAnimation(inXml.BLACK.ANIMATION);
			}
		}
		private var remXml:XMLList;
		private function loadPicture(inXml:XMLList, ba:ByteArray):void{
			remXml = inXml;
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, IMAGE_LOAD_COMPLATE);
			loader.loadBytes(ba, context);
		}
		private function IMAGE_LOAD_COMPLATE(e:Event):void{
			var remRect:Rectangle = new Rectangle(parseFloat(remXml.IMAGE.@x), parseFloat(remXml.IMAGE.@y), parseFloat(remXml.IMAGE.@width), parseFloat(remXml.IMAGE.@height));
			super.image = CuterPict.cutSamplePict(e.target.content, remRect);
			if(remXml.COLOR.ANIMATION.toString()) super.setListColorAnimation(remXml.COLOR.ANIMATION);
			if(remXml.BLACK.ANIMATION.toString()) super.setListBlackAnimation(remXml.BLACK.ANIMATION);
		}
		
		override public function get isSpace():Boolean{
			if(!super.deleteB && super.isSpace) return true;
			return false;
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
	}
	
}
