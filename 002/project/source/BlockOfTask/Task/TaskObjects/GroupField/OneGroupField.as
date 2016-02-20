package source.BlockOfTask.Task.TaskObjects.GroupField {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import source.BlockOfTask.Task.TaskObjects.UserTan.OneUserTan;
	import source.BlockOfTask.Task.TaskObjects.PictureTan.OnePictureTan;
	import flash.utils.ByteArray;
	import source.PlayerLib.Library;
	import source.BlockOfTask.Task.TaskObjects.Label.LabelClass;
	
	public class OneGroupField extends GroupFieldModel{

		public function OneGroupField(inXml:XMLList, colorContainer:Sprite, blackContainer:Sprite, lib:Library) {
			super(colorContainer, blackContainer);
			super.width = (inXml.WIDTH);
			super.height = (inXml.HEIGHT);
			
			super.blackX = parseFloat(inXml.BLACK.X)
			super.colorX = parseFloat(inXml.COLOR.X)
			super.blackY = parseFloat(inXml.BLACK.Y)
			super.colorY = parseFloat(inXml.COLOR.Y)
			
			if(inXml.COLOR.R.toString()!='')super.colorR = parseInt(inXml.COLOR.R);
			if(inXml.BLACK.R.toString()!='')super.blackR = parseInt(inXml.BLACK.R);
			
			if(inXml.TAN.toString()!='') super.tan = inXml.TAN.toString() == 'true';
			if(inXml.FIELD.toString()!='') super.field = inXml.FIELD.toString() == 'true';
			
			if(inXml.STARTANIMATIONCOMPLATE.toString()!='') super.animationToComplate = inXml.STARTANIMATIONCOMPLATE.toString();
			if(inXml.STARTANIMATIONDOWN.toString()!='') super.animationToDown = inXml.STARTANIMATIONDOWN.toString();
			
			if(inXml.CONTENT.toString()!=''){
				var imgName:String;
				var i:int;
				var l:int;
				var valXml:XMLList;
				for each(var sample:XML in inXml.CONTENT.elements()){
					trace(this + ': SAMPLE = ' + sample);
					switch (sample.name().toString()){
						case 'USERTAN':
							valXml = new XMLList(sample.toString());
							valXml.COLOR.X = valXml.BLACK.X = parseFloat(valXml.COLOR.X)-super.width/2;
							valXml.COLOR.Y = valXml.BLACK.Y = parseFloat(valXml.COLOR.Y)-super.height/2;
							imgName = sample.IMAGE.@name.toString();
							if(imgName == ''){
								xml(valXml);
							}else{
								xml(valXml, lib.getFile(imgName), imgName);
							}
						break;
						case 'PICTURETAN':
							valXml = new XMLList(sample.toString());
							valXml.COLOR.X = valXml.BLACK.X = parseFloat(valXml.COLOR.X)-super.width/2;
							valXml.COLOR.Y = valXml.BLACK.Y = parseFloat(valXml.COLOR.Y)-super.height/2;
							imgName = sample.IMAGE.toString();
							xml(valXml, lib.getFile(imgName), imgName);
						break;
						case 'LABEL':
							
							valXml = new XMLList(sample.toString());
							valXml.X = parseFloat(valXml.X)-super.width/2;
							valXml.Y = parseFloat(valXml.Y)-super.height/2;
							xml(valXml);
						break;
						case 'ELEMENT':
							for each(var element:XML in sample.elements()){
								trace(this + ': SAMPLE = ' + element);
								switch (element.name().toString()){
									case 'USERTAN':
										valXml = new XMLList(element.toString());
										valXml.COLOR.X = valXml.BLACK.X = parseFloat(valXml.COLOR.X)-super.width/2;
										valXml.COLOR.Y = valXml.BLACK.Y = parseFloat(valXml.COLOR.Y)-super.height/2;
										imgName = element.IMAGE.@name.toString();
										if(imgName == ''){
											xml(valXml);
										}else{
											xml(valXml, lib.getFile(imgName), imgName);
										}
									break;
									case 'PICTURETAN':
										valXml = new XMLList(element.toString());
										valXml.COLOR.X = valXml.BLACK.X = parseFloat(valXml.COLOR.X)-super.width/2;
										valXml.COLOR.Y = valXml.BLACK.Y = parseFloat(valXml.COLOR.Y)-super.height/2;
										imgName = element.IMAGE.toString();
										xml(valXml, lib.getFile(imgName), imgName);
									break;
									case 'LABEL':
										
										valXml = new XMLList(element.toString());
										valXml.X = parseFloat(valXml.X)-super.width/2;
										valXml.Y = parseFloat(valXml.Y)-super.height/2;
										xml(valXml);
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
					
					super.addObject(new OneUserTan(value, super.colorContainer, super.blackContainer, content as ByteArray), 1, vis);
				break;
				case 'PICTURETAN':
					trace(this + ': ADD PICTURE TAN');
					var pictTan:OnePictureTan = new OnePictureTan(value, super.colorContainer, super.blackContainer);
					pictTan.image = content as ByteArray;
					super.addObject(pictTan, 2, vis);
				break;
				case 'LABEL':
					var label:LabelClass = new LabelClass(value, super.colorContainer, new Sprite(), new Sprite());
					super.addObject(label, 3, vis);
					super.colorContainer.mouseEnabled = true;
				break;
			}
		}
		
		
	}
	
}
