package source.utils {
	
	public class Color {

		public static function getRGB(value:uint):Object{
			var colorString:String = value.toString(16);
			if(colorString.length>6){
				return {'error':'Not Color'};
			}
			while(colorString.length<6){
				colorString = '0'+colorString;
			}
			var rString:String = colorString.substring(0, 2);
			var gString:String = colorString.substring(2, 4);
			var bString:String = colorString.substring(4, 6);
			var red:Number = uint('0x'+rString);
			var green:Number = uint('0x'+gString);
			var blue:Number = uint('0x'+bString);
			var outObject:Object = {'red': red,
									'green': green,
									'blue': blue,
									'error': ''};
			return outObject;
		}
		public static function getColor(value:Object):uint{
			var red:Number = Math.round(value.red);
			var green:Number = Math.round(value.green);
			var blue:Number = Math.round(value.blue);
			var rString:String = red.toString(16);
			var gString:String = green.toString(16);
			var bString:String = blue.toString(16);
			if(rString.length == 1) rString = '0' + rString;
			if(gString.length == 1) gString = '0' + gString;
			if(bString.length == 1) bString = '0' + bString;
			var colorString:String = rString + gString + bString;
			var outColor:uint = uint('0x'+colorString);
			return outColor;
		}

	}
	
}
