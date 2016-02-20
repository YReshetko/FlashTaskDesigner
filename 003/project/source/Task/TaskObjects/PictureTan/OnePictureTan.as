package source.Task.TaskObjects.PictureTan {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class OnePictureTan extends BasePicture{
		private var xml:XMLList;
		public function OnePictureTan(xml:XMLList, colorCont:Sprite, blackCont:Sprite) {
			super(colorCont, blackCont);
			this.xml = xml;
			if(xml.IMAGE.toString()=='') return;
			super.name = xml.IMAGE.toString();
			super.addEventListener(BasePicture.GET_XML_SETTINGS, SET_SETTINGS);
		}
		private function SET_SETTINGS(e:Event):void{
			var W:Number = parseFloat(xml.WIDTH);
			var H:Number = parseFloat(xml.HEIGHT);
			super.setSize(W, H);
			if(xml.ISDRAG.toString()!='') super.drag = xml.ISDRAG.toString()=='true';
			if(xml.ISROTATION.toString()!='') super.cRotation = xml.ISROTATION.toString()=='true';
			if(xml.ISDINAMYC.toString()!='') super.dinamyc = xml.ISDINAMYC.toString()=='true';
			if(xml.ISDROPBACK.toString()!='') super.dropBack = xml.ISDROPBACK.toString()=='true';
			if(xml.ISSTARTPOS.toString()!='') super.startPosition = xml.ISSTARTPOS.toString()=='true';
			var xColor:Number = parseFloat(xml.COLOR.X);
			var yColor:Number = parseFloat(xml.COLOR.Y);
			var rColor:Number = parseFloat(xml.COLOR.R);
			super.setColorPosition(xColor, yColor)
			super.colorR = rColor;
			
			var xBlack:Number = parseFloat(xml.BLACK.X);
			var yBlack:Number = parseFloat(xml.BLACK.Y);
			var rBlack:Number = parseFloat(xml.BLACK.R);
			super.setBlackPosition(xBlack, yBlack)
			super.blackR = rBlack;
			
			if(xml.BLACK.DELETE.toString() == '1'){
				super.deleteB = true;
				super.colorMouseEnabled();
			}
			if(xml.BLACK.ALPHA.toString() == '1')super.alphaB = true;
			if(xml.VANISHING.toString()!=''){
				if(xml.VANISHING.TAN.toString() == 'COLOR'){
					super.setVanishing('ЦВЕТНОЙ', parseInt(xml.VANISHING.BLOCK), parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
				}else{
					super.setVanishing('ЧЁРНЫЙ', parseInt(xml.VANISHING.BLOCK), parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
				}
			}
			if(xml.SHOWING.toString()!=''){
				if(xml.SHOWING.TAN.toString() == 'COLOR'){
					super.setShowing('ЦВЕТНОЙ', parseInt(xml.SHOWING.BLOCK), parseInt(xml.SHOWING.SHOW));
				}else{
					super.setShowing('ЧЁРНЫЙ', parseInt(xml.SHOWING.BLOCK), parseInt(xml.SHOWING.SHOW));
				}
			}
			if(xml.STARTANIMATIONCOMPLATE.toString() != '') super.complateAnimation = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString() != '') super.downAnimation = xml.STARTANIMATIONDOWN.toString();
			
			if(xml.COLOR.ANIMATION.toString()) super.listAnimationColor = xml.COLOR.ANIMATION;
			if(xml.BLACK.ANIMATION.toString()) super.listAnimationBlack = xml.BLACK.ANIMATION;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = super.baseSettings;
			outXml.@label = 'ТАН КАРТИНКА';
			return outXml;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<PICTURETAN/>');
			outXml.IMAGE = super.name;
			outXml.WIDTH = super.width;
			outXml.HEIGHT = super.height;
			outXml.ISDRAG = super.drag.toString();
			outXml.ISROTATION = super.cRotation.toString();
			outXml.ISDINAMYC = super.dinamyc.toString();
			outXml.ISDROPBACK = super.dropBack.toString();
			outXml.ISSTARTPOS = super.startPosition.toString();
			outXml.COLOR.X = super.colorX;
			outXml.COLOR.Y = super.colorY;
			outXml.COLOR.R = super.colorR;
			
			outXml.BLACK.X = super.blackX;
			outXml.BLACK.Y = super.blackY;
			outXml.BLACK.R = super.blackR;
			
			if(super.showTan != 'НЕТ'){
				if(super.showTan == 'ЦВЕТНОЙ') {
					outXml.SHOWING.TAN = 'COLOR';
				}else{
					outXml.SHOWING.TAN = 'BLACK';
				}
				outXml.SHOWING.BLOCK = super.showBlock;
				outXml.SHOWING.SHOW = super.showShow;
			}
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
			
			if(super.deleteB) outXml.BLACK.DELETE = '1';
			else outXml.BLACK.DELETE = '0';
			
			if(super.alphaB) outXml.BLACK.ALPHA = '1';
			else outXml.BLACK.ALPHA = '0';
			if(super.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = super.complateAnimation;
			if(super.downAnimation != '') outXml.STARTANIMATIONDOWN = super.downAnimation;
			if(super.listAnimationColor!=null) outXml.COLOR.appendChild(super.listAnimationColor);
			if(super.listAnimationBlack!=null) outXml.BLACK.appendChild(super.listAnimationBlack);
			
			return outXml;
		}

	}
	
}
