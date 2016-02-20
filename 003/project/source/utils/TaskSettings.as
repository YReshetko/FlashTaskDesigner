package source.utils {
	
	public class TaskSettings {

		public static function getArrLevel(xml:XMLList):Array {
			var outArray:Array = new Array();
			var str:String;
			var level:String;
			for each(var sample:XML in xml.elements()){
				str = sample.name().toString();
				if(str == 'TASK'){
					level = sample.@level.toString();
					if(parseInt(level)<=0) level = '1';
					outArray.push(parseInt(level));
				}
			}
			return outArray;
		}
		public static function updateButton(arrLevel:Array, ID:int, test:Boolean, isCheck:Boolean = false):Object{
			var rest:Boolean = true;
			var under:Boolean = true;
			var know:Boolean = true;
			var check:Boolean = false;
			if(arrLevel.length == 1){
				rest = true;
				under = false;
				know = false;
				check = false;
			}else{
				if(test){
					check = isCheck;
					know = !isCheck;
				}else{
					if(arrLevel[ID] == 1) under = false;
					if(ID == arrLevel.length-1) {
						know = false;
					}
				}
			}
			var outObject:Object = new Object();
			outObject.rest = rest;
			outObject.under = under;
			outObject.know = know;
			outObject.check = check;
			return outObject;
		}
		public static function getDefaultLabelXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<LABEL/>');
			outXml.X = rect.x.toString();
			outXml.Y = rect.y.toString();
			outXml.WIDTH = rect.width.toString();
			outXml.HEIGHT = rect.height.toString();
			outXml.BORDER = 'true';
			outXml.BORDERCOLOR = '0';
			outXml.BACKGROUND = 'true';
			outXml.BACKGROUNDCOLOR = '16777215'
			outXml.SIZE = '16';
			outXml.BOLD = 'false';
			outXml.ITALIC = 'false';
			outXml.TEXTCOLOR = '0';
			outXml.ALIGN = 'left'
			outXml.FONT = 'Times New Roman';
			outXml.TYPE.@name="DINAMIC";
			return outXml;
		}
		public static function getDefaultMarkXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<MARK/>');
			outXml.X = rect.x.toString();
			outXml.Y = rect.y.toString();
			outXml.WIDTH = rect.width.toString();
			outXml.HEIGHT = rect.height.toString();
			return outXml;
		}
		public static function getDefaultPointDrawXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<POINTDRAW/>');
			outXml.X = rect.x.toString();
			outXml.Y = rect.y.toString();
			var dist:XMLList = new XMLList('<DISTANCE/>')
			dist.@type = 'horizontal'
			dist.setChildren('30');
			outXml.appendChild(dist);
			dist = new XMLList('<DISTANCE/>')
			dist.@type = 'vertical'
			dist.setChildren('30');
			outXml.appendChild(dist);
			var num:XMLList = new XMLList('<NUMBERPOINT/>');
			num.@type = 'horizontal'
			num.setChildren(Math.round(rect.width/30).toString());
			outXml.appendChild(num);
			num = new XMLList('<NUMBERPOINT/>');
			num.@type = 'vertical'
			num.setChildren(Math.round(rect.height/30).toString());
			outXml.appendChild(num);
			outXml.appendChild(new XML('<THICK>2</THICK>'));
			outXml.appendChild(new XML('<COLOR>0xFF0000</COLOR>'));
			return outXml;
		}
		public static function getDefaultTableXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<TABLE/>');
			outXml.X = rect.x.toString();
			outXml.Y = rect.y.toString();
			outXml.WIDTH = rect.width.toString();
			outXml.HEIGHT = rect.height.toString();
			return outXml;
		}
		public static function getDefaultFieldXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<FIELD/>');
			outXml.X = rect.x.toString();
			outXml.Y = rect.y.toString();
			outXml.WIDTH = rect.width.toString();
			outXml.HEIGHT = rect.height.toString();
			return outXml;
		}
		public static function getDefaultLineXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<LINE/>');
			outXml.SPRITE_X = rect.x.toString();
			outXml.SPRITE_Y = rect.y.toString();
			outXml.POINT_X = rect.width.toString();
			outXml.POINT_Y = rect.height.toString();
			outXml.THICK = '2';
			outXml.COLOR = '0';
			return outXml;
		}
		
		public static function getDefaultPictureXML(name:String, x:Number, y:Number):XMLList{
			var outXml:XMLList = new XMLList('<PICTURETAN/>');
			outXml.IMAGE = name;
			outXml.COLOR.X = x.toString();
			outXml.COLOR.Y = y.toString();
			outXml.COLOR.R = '0';
			
			outXml.BLACK.X = x.toString();
			outXml.BLACK.Y = y.toString();
			outXml.BLACK.R = '0';
			return outXml;
		}
		
		public static function getDefaultSWFXML(name:String, x:Number, y:Number):XMLList{
			var outXml:XMLList = new XMLList('<SWFOBJECT/>');
			outXml.NAME = name;
			outXml.TYPE = 'SimpleSWF'
			outXml.X = x.toString();
			outXml.Y = y.toString();
			return outXml;
		}
		
		public static function getDefaultCheckBoxXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<CHECKBOX/>');
			var i:int;
			var j:int;
			var w:int = Math.ceil(rect.width/100);
			var h:int = Math.ceil(rect.height/30);
			var sample:XMLList;
			for(i=0;i<h;i++){
				for(j=0;j<w;j++){
					sample = new XMLList('<BOX/>');
					sample.@y = i*30;
					sample.@x = j*100;
					outXml.appendChild(sample);
				}
			}
			outXml.@x = rect.x.toString();
			outXml.@y = rect.y.toString();
			return outXml;
		}
		public static function getDefaultGroupFieldXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<GROUPFIELD/>');
			
			outXml.BLACK.X = outXml.COLOR.X = (rect.x + rect.width/2).toString();
			outXml.BLACK.Y = outXml.COLOR.Y = (rect.y + rect.height/2).toString();
			outXml.WIDTH = rect.width.toString();
			outXml.HEIGHT = rect.height.toString();
			return outXml;
		}
		public static function getDefaultButtonXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<BUTTON/>');
			outXml.@x = rect.x.toString();
			outXml.@y = rect.y.toString();
			outXml.@width = rect.width.toString();
			outXml.@height = rect.height.toString();
			return outXml;
		}
		public static function getDefaultShiftField(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<SHIFTFIELD/>');
			outXml.@x = rect.x.toString();
			outXml.@y = rect.y.toString();
			outXml.@width = rect.width.toString();
			outXml.@height = rect.height.toString();
			return outXml;
		}
		
		public static function getDefaultCharisSettings(fileName:String, stageWidth:Number, stageHeight:Number):XMLList{
			var out:XMLList = new XMLList('<CHARIS/>');
			out.@content = fileName;
			out.@ceil_size = 30;
			out.@ceilSizeSchem = 30;
			var maxWidth:int = Math.round((stageWidth/2-10)-20);
			out.@colsSchem = out.@cols = Math.round(maxWidth/30);
			out.@rowsSchem = out.@rows = Math.round(maxWidth/30);
			
			out.@taskType = 1;
			out.@exampleType = 1;
			out.@brash_color = 0x0000FF;
			out.@fill_color = 0x0000FF;
			var sample:XMLList;
			sample = new XMLList('<DEFAULTBUTTONS/>');
			out.appendChild(sample);
			
			sample = new XMLList('<ENTITY isExample="true" x="10" y="40"/>');
			out.appendChild(sample);
			
			
			var labelRect:Object = new Object();
			labelRect.x = 10;
			labelRect.y = 40;
			
			sample = new XMLList('<ENTITY isExample="false" x="'+(stageWidth/2 + 20)+'" y="'+40+'"/>');
			out.appendChild(sample);
			
			labelRect.width = Math.round(maxWidth/30)*30;
			labelRect.height = Math.round(maxWidth/30)*30;
			sample = getDefaultLabelXML(labelRect);
			sample.BACKGROUNDCOLOR = '0xcc';
			sample.SIZE = '24';
			sample.BOLD = 'true';
			sample.TEXTCOLOR = '0xffff00';
			sample.FONT = 'Lucida Console';
			sample.ASPASCAL = true;
			out.appendChild(sample);
			return out;
		}
		
		
		
		public static function getUserTan(value:Object, x:Number, y:Number):XMLList{
			var outXml:XMLList = new XMLList('<USERTAN/>');
			outXml.@type = value.type;
			var pointXml:XMLList = new XMLList('<POINTS/>');
			var pointArr:Array = value.data;
			var i:int;
			var l:int;
			l = pointArr.length;
			if(value.type == 'line'){
				for(i=0;i<l;i++){
					pointXml.appendChild(new XMLList('<POINT id="'+i+'" x="'+pointArr[i][0]+'" y="'+pointArr[i][1]+'"/>'));
				}
			}
			if(value.type == 'curve'){
				for(i=0;i<l;i++){
					pointXml.appendChild(new XMLList('<POINT id="'+i+'" x="'+pointArr[i][0]+'" y="'+pointArr[i][1]+'" anchorX="'+pointArr[i][2]+'" anchorY="'+pointArr[i][3]+'"/>'));
				}
			}
			outXml.appendChild(pointXml);
			var colorXml:XMLList = new XMLList('<COLOR/>');
			var blackXml:XMLList = new XMLList('<BLACK/>');
			colorXml.X = blackXml.X = x.toString();
			colorXml.Y = blackXml.Y = y.toString();
			colorXml.R = blackXml.R = '0';
			colorXml.COLOR = blackXml.COLOR = '0x00EEAA';
			outXml.appendChild(colorXml);
			outXml.appendChild(blackXml);
			return outXml;
		}
		
		public static function getCoordinateXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<COORDINATE/>');
			outXml.@x = rect.x.toString();
			outXml.@y = rect.y.toString();
			outXml.@width = rect.width.toString();
			outXml.@height = rect.height.toString();
			return outXml;
		}
		
		public static function getPaintXML(rect:Object):XMLList{
			var outXml:XMLList = new XMLList('<PAINT/>');
			outXml.X = rect.x.toString();
			outXml.Y = rect.y.toString();
			outXml.WIDTH = rect.width.toString();
			outXml.HEIGHT = rect.height.toString();
			return outXml;
		}
	}
	
}
