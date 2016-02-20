package source.utils.xmlPrimitive {
	
	public class XmlSet {

		public static function get xml():Array {
			var outArr:Array = new Array();
			outArr.push(XmlSquare.xml);
			outArr.push(XmlSmalTriangle.xml);
			outArr.push(XmlSmalTriangle.xml);
			
			outArr.push(XmlRectangle.xml);
			outArr.push(XmlLargeTriangle.xml);
			outArr.push(XmlLargeTriangle.xml);
			
			outArr.push(XmlRound.xml);
			outArr.push(XmlHexagon.xml);
			
			outArr.push(XmlStick.xml);
			
			
			outArr[2].COLOR.Y = 150;
			outArr[2].BLACK.Y = 150;
			
			outArr[2].COLOR.R = 8;
			outArr[2].BLACK.R = 8;
			
			outArr[5].COLOR.X = 187;
			outArr[5].COLOR.Y = 145;
			outArr[5].COLOR.R = 12;
			outArr[5].COLOR.TYPE = 2;
			
			outArr[5].BLACK.X = 187;
			outArr[5].BLACK.Y = 145;
			outArr[5].BLACK.R = 12;
			outArr[5].BLACK.TYPE = 2;
			
			return outArr;
		}

	}
	
}
