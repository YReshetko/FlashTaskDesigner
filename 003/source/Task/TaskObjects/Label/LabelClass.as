package source.Task.TaskObjects.Label {
	import flash.display.Sprite;
	public class LabelClass extends ExtendLabel {
		
		public function LabelClass(lblXML:XMLList, lblCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			super(lblXML,lblCont, colorCont, blackCont);
			trace(this + ': in XML = ' + lblXML);
			lblCont.mouseEnabled = false;
		}
		public function get listSettings():XMLList{
			switch(super.typeField){
				case 'STATIC': return super.staticSettings; break;
				case 'DINAMIC': return super.dynamicSettings; break;
				case 'INPUT': return super.inputSettings; break;
			}
			return null;
		}
		public function get colorSettings():XMLList{
			if(super.typeField == 'INPUT') return super.otherColorSettings;
			else return super.baseColorList;
			return null;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<LABEL/>');
			outXml.X = super.colorX;
			outXml.Y = super.colorY;
			outXml.WIDTH = super.width;
			outXml.HEIGHT = super.height;
			outXml.ASPASCAL = super.pascal.toString();
			outXml.BORDER = super.border;
			outXml.BORDERCOLOR = '0x' + super.borderColor.toString(16);
			outXml.BACKGROUND = super.background;
			outXml.BACKGROUNDCOLOR = '0x' + super.backgroundColor.toString(16);
			outXml.SIZE = super.size;
			outXml.BOLD = super.bold;
       		outXml.ITALIC = super.italic;
			outXml.TEXTCOLOR = '0x' + super.color.toString(16);
			outXml.ALIGN = super.align;
        	outXml.FONT = super.font;
			
			outXml.VARIABLE = super.variable;
			outXml.RANDOM = super.random;
			outXml.FORMULA = super.formula;
			
			var typeXml:XMLList = new XMLList('<TYPE/>');
			typeXml.@name = super.typeField;
			if(super.listAnimationColor!=null) typeXml.appendChild(super.listAnimationColor);
			switch(super.typeField){
				case 'STATIC':
					typeXml.DRAGANDDROP.@tan = super.dragAndDrop;
					if(super.dragAndDrop){
						typeXml.DRAGANDDROP.X = super.blackX
						typeXml.DRAGANDDROP.Y = super.blackY;
						if(super.alpha)	typeXml.DRAGANDDROP.ALPHA = '0';
						else typeXml.DRAGANDDROP.ALPHA = '1';
						typeXml.DRAGANDDROP.ISDINAMYC = super.dinamyc.toString();
						typeXml.DRAGANDDROP.ISDROPBACK = super.dropBack.toString();
						typeXml.DRAGANDDROP.ISSTARTPOS = super.startPosition.toString();
						if(super.listAnimationBlack!=null) typeXml.DRAGANDDROP.appendChild(super.listAnimationBlack);
					}
				break;
				case 'INPUT':
					typeXml.TYPEINPUT = super.typeInput;
					typeXml.CORRECTCOLOR = '0x' + super.correctColor.toString(16);
					typeXml.INCORRECTCOLOR = '0x' + super.inCorrectColor.toString(16);
					typeXml.REGISTR = super.registr;
					typeXml.appendChild(new XML('<DEFAULTTEXT><![CDATA['+super.defaultText+']]></DEFAULTTEXT>'));
					typeXml.MAXLENGTH = super.maxChars;
					typeXml.RESTRICT = super.restrict;
					typeXml.MULTILINE = super.multiline;
					typeXml.LASTSPACE = super.lastSpace.toString();
				break;
			}
			outXml.appendChild(typeXml);
			//outXml.appendChild(new XML('<SHOWING action="false" />'));
			//outXml.appendChild(new XML('<VANISHING action="false" />'));
			
			if(super.showTan != 'НЕТ'){
				outXml.SHOWING.@action = true;
				if(super.showTan == 'ЦВЕТНОЙ') {
					outXml.SHOWING.TAN = 'ColorTan';
				}else{
					outXml.SHOWING.TAN = 'BlackTan';
				}
				outXml.SHOWING.BLOCKTIME = super.showBlock;
				outXml.SHOWING.SHOWTIME = super.showShow;
			}else{
				outXml.SHOWING.@action = false;
			}
			if(super.vanishTan != 'НЕТ'){
				if(super.vanishTan == 'ЦВЕТНОЙ'){
					outXml.VANISHING.TAN = 'ColorTan';
				}else{
					outXml.VANISHING.TAN = 'BlackTan';
				}
				outXml.VANISHING.BLOCKTIME = super.vanishBlock;
				outXml.VANISHING.SHOWFROM = super.vanishShow;
				outXml.VANISHING.SHOWHOW = super.vanishVanish;
			}
			if(this.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = this.complateAnimation;
			if(this.downAnimation != '') outXml.STARTANIMATIONDOWN = this.downAnimation;
			outXml.appendChild(new XML('<ADDITIONAL_PARAMETERS number="0"/>'));
			outXml.appendChild(new XML('<TEXT><![CDATA['+super.text+']]></TEXT>'));
			if(super.useDefault) outXml.appendChild(new XML('<CORRECTTEXT isUse="true"><![CDATA['+super.trueDefText+']]></CORRECTTEXT>'));
			return outXml;
		}
	}
}