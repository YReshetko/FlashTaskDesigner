package source.BlockOfTask.Task.TaskObjects.PictureTan {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class OnePictureTan extends BasePicture{
		private var xml:XMLList;
		public function OnePictureTan(xml:XMLList, colorCont:Sprite, blackCont:Sprite) {
			super(colorCont, blackCont);
			this.xml = xml;
			if(xml.IMAGE.toString()=='') return;
			super.name = xml.IMAGE.toString();
			super.addEventListener(BasePicture.GET_SETTINGS, SET_SETTINGS);
			var xBlack:Number = parseFloat(xml.BLACK.X);
			var yBlack:Number = parseFloat(xml.BLACK.Y);
			super.setBlackPosition(xBlack, yBlack)
			if(xml.BLACK.DELETE.toString() == '1'){
				super.deleteB = true;
				super.colorMouseEnabled();
			}
		}
		private function SET_SETTINGS(e:Event):void{
			var W:Number = parseFloat(xml.WIDTH);
			var H:Number = parseFloat(xml.HEIGHT);
			super.setSize(W, H);
			if(xml.ISDRAG.toString()!='') super.drag = xml.ISDRAG.toString()=='true';
			if(xml.ISROTATION.toString()!='') super.cRotation = xml.ISROTATION.toString()=='true';
			if(xml.ISDINAMYC.toString()!='') super.dinamyc = xml.ISDINAMYC.toString()=='true';
			if(xml.ISSTARTPOS.toString()!='') super.startPosition = xml.ISSTARTPOS.toString()=='true';
			if(xml.ISDROPBACK.toString()!='') super.dropBack = xml.ISDROPBACK.toString()=='true';
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
					super.setVanishing('color', parseInt(xml.VANISHING.BLOCK), parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
				}else{
					super.setVanishing('black', parseInt(xml.VANISHING.BLOCK), parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
				}
			}
			if(xml.SHOWING.toString()!=''){
				if(xml.SHOWING.TAN.toString() == 'COLOR'){
					super.setShowing('color', parseInt(xml.SHOWING.BLOCK), parseInt(xml.SHOWING.SHOW));
				}else{
					super.setShowing('black', parseInt(xml.SHOWING.BLOCK), parseInt(xml.SHOWING.SHOW));
				}
			}
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') super.animationToComplate = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') super.animationToDown = xml.STARTANIMATIONDOWN.toString();
			
			if(xml.COLOR.ANIMATION.toString()!='') super.setListColorAnimation(xml.COLOR.ANIMATION);
			if(xml.BLACK.ANIMATION.toString()!='') super.setListBlackAnimation(xml.BLACK.ANIMATION);
		}

	}
	
}
