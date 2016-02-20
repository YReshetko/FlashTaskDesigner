package source.EnvKonstraktion.PictLibrary {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.media.Sound;
	import flash.events.SampleDataEvent;
	
	public class MP3Sample extends Sample{
		private var imgLabel:FlashSound = new FlashSound();
		private var soundBA:ByteArray;
		private var sound:Sound;
		public function MP3Sample(inLabel:String, inBitmap:Loader, inByteArray:ByteArray) {
			/*var lblBmpData:BitmapData = new BitmapData(imgLabel.width, imgLabel.height);
			lblBmpData.draw(imgLabel, new Matrix());
			var lblBmp:Bitmap = new Bitmap(lblBmpData);
			super(inLabel, lblBmp, inByteArray);
			trace("MP3 Byte Array" + inByteArray.toString());
			//swfObject = inBitmap;
			soundBA = inByteArray;
			soundBA.position = 0;
			
			sound.loadCompressedDataFromByteArray(soundBA, soundBA.length);
			
			sound.play();*/
			
			/*sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, ON_SAMPLE_DATA);
			sound.play();*/
		}
		private function ON_SAMPLE_DATA(event:SampleDataEvent):void{
			for(var i:int=0; i<8192 && soundBA.bytesAvailable >0; i++){
				var left:Number = soundBA.readFloat();
				var right:Number = soundBA.readFloat();
				event.data.writeFloat(left);
				event.data.writeFloat(right);
				
			}
			
		}

	}
	
}
