package source.Task.TaskObjects.GroupField {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import source.Task.TaskObjects.UserTan.OneUserTan;
	import source.Task.TaskObjects.PictureTan.OnePictureTan;
	import flash.utils.ByteArray;
	import source.Task.TaskObjects.Label.LabelClass;
	
	public class OneGroupField extends GroupFieldModel{

		public function OneGroupField(inXml:XMLList, colorContainer:Sprite, blackContainer:Sprite, content:Array = null) {
			super(colorContainer, blackContainer);
			super.width = parseFloat(inXml.WIDTH);
			super.height = parseFloat(inXml.HEIGHT);
			super.blackX = parseFloat(inXml.BLACK.X);
			super.colorX = parseFloat(inXml.COLOR.X);
			super.blackY = parseFloat(inXml.BLACK.Y);
			super.colorY = parseFloat(inXml.COLOR.Y);
			
			if(inXml.COLOR.R.toString()!='')super.colorR = parseInt(inXml.COLOR.R);
			if(inXml.BLACK.R.toString()!='')super.blackR = parseInt(inXml.BLACK.R);
			
			if(inXml.TAN.toString()!='') super.tan = inXml.TAN.toString() == 'true';
			if(inXml.FIELD.toString()!='') super.field = inXml.FIELD.toString() == 'true';
			
			if(inXml.STARTANIMATIONCOMPLATE.toString()!='') super.complateAnimation = inXml.STARTANIMATIONCOMPLATE.toString();
			if(inXml.STARTANIMATIONDOWN.toString()!='') super.downAnimation = inXml.STARTANIMATIONDOWN.toString();
			
			if(inXml.CONTENT.toString()!='' && content!=null){
				var imgName:String;
				var i:int;
				var l:int;
				l = content.length;
				for each(var sample:XML in inXml.CONTENT.elements()){
					trace(this + ': SAMPLE = ' + sample);
					switch (sample.name().toString()){
						case 'USERTAN':
							xml(new XMLList(sample));
						break;
						case 'PICTURETAN':
							imgName = sample.IMAGE.toString();
							for(i=0;i<l;i++){
								if(content[i][0]==imgName){
									xml(new XMLList(sample), content[i][1], imgName);
									break;
								}
							}
						break;
						case 'LABEL':
							xml(new XMLList(sample));
						break;
						case 'ELEMENT':
							for each(var element:XML in sample.elements()){
								trace(this + ': SAMPLE = ' + element);
								switch (element.name().toString()){
									case 'USERTAN':
										xml(new XMLList(element));
									break;
									case 'PICTURETAN':
										imgName = element.IMAGE.toString();
										for(i=0;i<l;i++){
											if(content[i][0]==imgName){
												xml(new XMLList(element), content[i][1], imgName);
												break;
											}
										}
									break;
									case 'LABEL':
										xml(new XMLList(sample));
									break;
								}
							}
						break;
					}
				}
			}
		}
		public function xml(value:XMLList, content:* = null, name:String = ''):void{
			trace(this + ': NAME XML = ' + value.name());
			var vis:Boolean = true;
			if(value.@visible!='') vis = value.@visible.toString()=='true';
			switch(value.name().toString()){
				case 'USERTAN':
					trace(this + ': ADD USER TAN');
					
					super.addObject(new OneUserTan(value, super.objectContainer, super.blackObjectContainer, content as Bitmap, name), 1, vis);
				break;
				case 'PICTURETAN':
					trace(this + ': ADD PICTURE TAN');
					var pictTan:OnePictureTan = new OnePictureTan(value, super.objectContainer, super.blackObjectContainer);
					pictTan.image = content as ByteArray;
					super.addObject(pictTan, 2, vis);
				break;
				case 'LABEL':
					var label:LabelClass = new LabelClass(value, super.objectContainer, new Sprite(), new Sprite());
					super.addObject(label,3);
					label.reset();
				break;
			}
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<GROUPFIELD/>');
			outXml.WIDTH = super.width.toString();
			outXml.HEIGHT = super.height.toString();
			outXml.COLOR.X = super.colorX.toString();
			outXml.COLOR.Y = super.colorY.toString();
			outXml.COLOR.R = super.colorR.toString();
			
			outXml.BLACK.X = super.blackX.toString();
			outXml.BLACK.Y = super.blackY.toString();
			outXml.BLACK.R = super.blackR.toString();
			outXml.BLACK.ALPHA = super.blackAlpha.toString();
			
			outXml.TAN = super.tan.toString();
			outXml.FIELD = super.field.toString();
			if(super.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = super.complateAnimation;
			if(super.downAnimation != '') outXml.STARTANIMATIONDOWN = super.downAnimation;
			var objArrList:Array = super.objectLists;
			var contentList:XMLList = new XMLList('<CONTENT/>');
			var i:int;
			var l:int;
			var fieldList:XMLList;
			l = objArrList.length;
			for(i=0;i<l;i++){
				fieldList = new XMLList('<ELEMENT/>');
				fieldList.@id = (i+1).toString();
				fieldList.appendChild(objArrList[i]);
				contentList.appendChild(fieldList);
			}
			outXml.appendChild(contentList);
			return outXml;
		}

	}
	
}
