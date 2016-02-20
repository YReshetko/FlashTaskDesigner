/*
	Класс авторизации на DL
	1. Создаёт форму авторизации с полями ввода:
	  - Login/ID - поле ввода логина пользователя;
	  - password - поле воода пароля пользователя;
	2. Проверяет введённые данные и в статическом объекте класса DLConnection
	   устанавливает cookies;
	3. После авторизации обращается к странице idesk.asp 
	   для получения номеров курсов доступных пользователю;
	4. После получения номеров курсов обращается к базе DL
	   для получения имён соответствующих курсов;
	5. При завершении получения имён курсов отправляетс событие COURSE_LOAD;
	
	На выходе получается объект courseNames имеющий следующую структуру
	courseNames[cid] = 'name';
	
	Например courseNames['168'] = 'Новые задачи';
	
	Получение данных объекта проходит через метод get data
*/

package source.WindowInterface {
	import flash.display.Sprite;
	import source.Components.Complicated;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import source.Components.Button;
	import source.Components.COEvent;
	import flash.events.Event;
	import source.WindowInterface.MainTaskDownloader;
	import flash.net.URLVariables;
	import source.utils.DataBaseUpdate.DLConnection;
	import flash.events.MouseEvent;
	
	public class Logon extends Sprite{
		public static var COURSE_LOAD:String = 'onCourseLoad';
		private static const loginFaild:String = 'Login Failed';
		private var login:Complicated = new Complicated('Логин/ID');
		private var pass:Complicated = new Complicated('Пароль');
		private var sprBG:Sprite = new Sprite();
		private var bgPanel:Bitmap;
		private var butLogin:Button = new Button('Авторизация');
		private var coursArray:Array;
		private var currentID:int;
		private var courseNames:Object;
		private var dlConnectin:DLConnection;
		private var loginIndicate:LoginIndicate = new LoginIndicate();
		public function Logon() {
			super();
			dlConnectin = MainTaskDownloader.dlConnection;
			initBackGrount();
			super.addChild(bgPanel);
			bgPanel.x = (-1) * bgPanel.width/2;
			super.addChild(login);
			super.addChild(pass);
			login.y = 15;
			pass.y = 15 + login.height+10;
			pass.isPassword();
			super.addChild(butLogin);

			var w:Number = butLogin.width ;

			butLogin.x = -w/2;
			butLogin.y = pass.y + pass.height + 10;
			login.restrict = '0-9a-z';
			pass.restrict = '0-9a-zA-Z';
			butLogin.addEventListener(COEvent.CLICK, LOG_CLICK);
			login.addEventListener(COEvent.PRESS_ENTER, LOGIN_PRESS_ENTER);
			pass.addEventListener(COEvent.PRESS_ENTER, PASS_PRESS_ENTER);
			login.addEventListener(COEvent.FIELD_FOCUS, LOGIN_MOUSE_CLICK);
			pass.addEventListener(COEvent.FIELD_FOCUS, PASS_MOUSE_CLICK);
		}
		private function initBackGrount():void{
			sprBG.graphics.lineStyle(1, 0xA9A9A9, 1);
			sprBG.graphics.beginFill(0xF0F0F0, 1);
			sprBG.graphics.drawRoundRect(0, 0, 240, 120, 6, 6);
			sprBG.graphics.endFill();
			var bmpData:BitmapData = new BitmapData(sprBG.width, sprBG.height);
			bmpData.draw(sprBG, new Matrix());
			bgPanel = new Bitmap(bmpData);
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(), new BlurFilter());
		}
		private function LOGIN_PRESS_ENTER(event:Event):void{
			if(login.text == '') return;
			if(pass.text == '') {
				pass.setFocus();
				return;
			}
			LOG_CLICK();
		}
		private function PASS_PRESS_ENTER(event:Event):void{
			if(pass.text == '') return;
			if(login.text == '') {
				login.setFocus();
				return;
			}
			LOG_CLICK();
		}
		private function LOGIN_MOUSE_CLICK(event:Event):void{
			login.color = 0xD0D0D0;
		}
		private function PASS_MOUSE_CLICK(event:Event):void{
			pass.color = 0xD0D0D0;
		}
		private function LOG_CLICK(event:Event = null):void{
			super.addChild(loginIndicate);
			loginIndicate.x = butLogin.x + butLogin.width;
			loginIndicate.y = butLogin.y - (loginIndicate.height - butLogin.height)/2;
			var urlVariable:URLVariables = new URLVariables();
			urlVariable['lng'] = 'ru';
			urlVariable['id'] = login.text;
			urlVariable['password'] = pass.text;
			urlVariable['logon'] = 'submit';
			dlConnectin.addEventListener(DLConnection.CONNECTION_COMPLATE, AUTHORIZATION_COMPLATE);
			dlConnectin.login(urlVariable);
		}
		private function AUTHORIZATION_COMPLATE(event:Event):void{
			dlConnectin.removeEventListener(DLConnection.CONNECTION_COMPLATE, AUTHORIZATION_COMPLATE);
			if(dlConnectin.data.data.indexOf(loginFaild)==-1){
				dlConnectin.addEventListener(DLConnection.CONNECTION_COMPLATE, LOAD_DESK);
				dlConnectin.getMyCourse();
			}else{
				super.removeChild(loginIndicate);
				login.color = 0xAA0000;
				pass.color = 0xAA0000;
			}
		}
		private function LOAD_DESK(event:Event):void{
			dlConnectin.removeEventListener(DLConnection.CONNECTION_COMPLATE, LOAD_DESK);
			//trace(this + ': LOAD DESK = ' + dlConnectin.data.data);
			coursArray = getCourses(dlConnectin.data.data);
			courseNames = new Object();
			currentID = -1;
			startFormCourses();
		}
		private function startFormCourses():void{
			if(currentID == coursArray.length-1){
				for(var key:Object in courseNames){
					trace(this + ': id = ' + key + ', name = ' + courseNames[key]);
				}
				super.dispatchEvent(new Event(COURSE_LOAD));
				super.removeChild(loginIndicate);
			}else{
				++currentID;
				dlConnectin.addEventListener(DLConnection.CONNECTION_COMPLATE, GET_NAME_OF_COURSE);
				dlConnectin.getCourseName(coursArray[currentID]);
			}
		}
		private function GET_NAME_OF_COURSE(event:Event):void{
			dlConnectin.removeEventListener(DLConnection.CONNECTION_COMPLATE, GET_NAME_OF_COURSE);
			var inObject:Object = dlConnectin.data;
			courseNames[coursArray[currentID]] = inObject.data.name;
			startFormCourses();
		}
		
		
		
		private function getCourses(value:String):Array{
			var regExp:RegExp = new RegExp('<a href="cdesk.asp\\?id=[0-9]{3,}">','g');
			var linkExp:RegExp = new RegExp('[0-9]{3,}');
			var result:Array;
			var outArr:Array = new Array();
			var link:String;
			//trace('Result:');
			while((result = regExp.exec(value))!=null){
				link = result[0];
				outArr.push(linkExp.exec(link)[0]);
			}
			return outArr;
		}
		public function get listAuthorization():XMLList{
			var outXml:XMLList = new XMLList('<AUTHORIZATION/>');
			outXml.LOGIN = login.text;
			outXml.PASSWORD = pass.text;
			return outXml;
		}
		
		public function get data():Object{
			return courseNames;
		}
	}
	
}
