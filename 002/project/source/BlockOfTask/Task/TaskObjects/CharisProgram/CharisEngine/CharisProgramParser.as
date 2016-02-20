﻿package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine {
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.*;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.ICharisRobot;
	
	public class CharisProgramParser {
		private var programText:String;
		private var oneLineProgram:String;
		private var simpleCommands:Array = [{pattern:"left", 			altPattern:"l",   command:new LeftRC()			},
											{pattern:"right", 			altPattern:"r",   command:new RightRC()			},
											{pattern:"up", 				altPattern:"u",   command:new UpRC()			},
											{pattern:"down", 			altPattern:"d",   command:new DownRC()			},
											{pattern:"jump", 			altPattern:"j",   command:new JumpRightRC()		},
											{pattern:"jumpdown", 		altPattern:"jd",  command:new JumpDownRC()		},
											{pattern:"jumpleft", 		altPattern:"jl",  command:new JumpLeftRC()		},
											{pattern:"jumpup", 			altPattern:"ju",  command:new JumpUpRC()		},
											{pattern:"circle", 			altPattern:"c",   command:new CircleRC()		},
											{pattern:"leftdown", 		altPattern:"ld",  command:new LeftDownRC()		},
											{pattern:"leftup", 			altPattern:"lu",  command:new LeftUpRC()		},
											{pattern:"rightdown", 		altPattern:"rd",  command:new RightDownRC()		},
											{pattern:"rightup", 		altPattern:"ru",  command:new RightUpRC()		},
											{pattern:"jumpleftdown", 	altPattern:"jld", command:new JumpLeftDownRC()	},
											{pattern:"jumpleftup", 		altPattern:"jlu", command:new JumpLeftUpRC()	},
											{pattern:"jumprightdown", 	altPattern:"jrd", command:new JumpRightDownRC()	},
											{pattern:"jumprightup", 	altPattern:"jru", command:new JumpRightUpRC()	},
											{pattern:"jumpzero", 		altPattern:"jz",  command:new JumpZeroRC()		},
											{pattern:"bar", 			altPattern:"b",   command:new BarRC()			},
											{pattern:"worm", 			altPattern:"w",   command:new WormRC()			},
											{pattern:"turtle", 			altPattern:"t",   command:new TurtleRC()		}];
		
		public function CharisProgramParser(input:String) {
			programText = input;
			parse();
		}
		public function get text():String{
			return programText;
		}
		public function get array():Vector.<String>{
			var out:Vector.<String> = new Vector.<String>();
			var arr:Array = oneLineProgram.split(";");
			var i:int;
			var l:int;
			var left:RegExp = new RegExp("$\\s*", "m");
			var right:RegExp = new RegExp("\\s*^", "m");
			l = arr.length;
			for(i=0;i<l;i++){
				out.push(arr[i]);
				out[i].replace(left, "");
				out[i].replace(right, "");
			}
			return out;
		}
		public function getCommands(robot:ICharisRobot):Vector.<IRobotCommand>{
			// TODO: Продебажить анализ команд
			var out:Vector.<IRobotCommand> = new Vector.<IRobotCommand>();
			var stringCommands:Vector.<String> = array;
			var currentCommand:IRobotCommand;
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var pattern:RegExp;
			var altPattern:RegExp;
			var sPattern:RegExp;
			var sAltPattern:RegExp;
			var flag:Boolean;
			k = stringCommands.length;
			l = simpleCommands.length;
			trace(this + "stringCommands.length = " + k);
			trace(this + "simpleCommands.length = " + l);
			for(j=0;j<k;j++){
				trace(this + " Current command = " + stringCommands[j]);
				for(i=0;i<l;i++){
					pattern = new RegExp("\\b"+simpleCommands[i].pattern+"\\b", "gi");
					sPattern = new RegExp("\\b"+simpleCommands[i].pattern+"S\\b", "gi");
					altPattern = new RegExp("\\b"+simpleCommands[i].altPattern+"\\b", "gi");
					sAltPattern = new RegExp("\\b"+simpleCommands[i].altPattern+"S\\b", "gi");
					flag = pattern.test(stringCommands[j]) || altPattern.test(stringCommands[j])||
					       sPattern.test(stringCommands[j]) || sAltPattern.test(stringCommands[j]);
					if(flag){
						trace(this + " flag = true");
						var cmd:Vector.<IRobotCommand> = getCommandsByString(stringCommands[j], simpleCommands[i].command as IRobotCommand);
						while(cmd.length>0){
							currentCommand = cmd.pop();
							trace(this + " current commnad = " + currentCommand);
							currentCommand.robot = robot;
							out.push(currentCommand);
						}
						break;
					}
				}
			}
			return out;
		}
		
		private function getCommandsByString(str:String, command:IRobotCommand):Vector.<IRobotCommand>{
			var out:Vector.<IRobotCommand> = new Vector.<IRobotCommand>();
			var l:int;
			if(str.indexOf("(")!=-1 && str.indexOf(")")!=-1){
				var str:String = getSubString("(",")",str);
				trace(this + " num commands = " + str);
				l = parseInt(cutSubString("(",")",str));
			}else{
				l = 1;
			}
			var i:int;
			for(i=0;i<l;i++){
				out.push(command);
			}
			return out;
		}
		private function parse():void{
			programText = replaceAll(programText, "[\r\n]+", "\n");
			programText = replaceAll(programText, "\{.*\}", "");
			programText = replaceAll(programText, "//.*\n", "\n");
			
			//programText = replaceAll(programText, "\/\*[\n\w\d\s\r\b;:\*\+@\$#йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ-]*\*\/", "\n");
			while(programText.indexOf("/*")!=-1){
				programText = cutSubString("/*", "*/", programText)
			}
			oneLineProgram = replaceAll(programText, "\\s+", " ");
			oneLineProgram = getSubString("begin", "end.", oneLineProgram);
			
			trace(oneLineProgram);
		}
		
		private function replaceAll(input:String, reg:String, repl:String, flag:String = "g"):String{
			var comment:RegExp = new RegExp(reg, flag);
			trace(this + " " + comment.toString());
			return input.replace(comment, repl);
		}
		private function cutSubString(from:String, to:String, str:String):String{
			var firstInd:int;
			var lastInd:int;
			var out:String = "";
			firstInd = programText.indexOf(from)-from.length;
			lastInd = programText.indexOf(to)+to.length;
			if(lastInd==-1 || firstInd==-1){
				return "";
			}
			out = str.substring(0, firstInd);
			out += str.substring(lastInd, str.length);
			return out;
		}
		private function getSubString(from:String, to:String, str:String):String{
			var out:String;
			out = str.substring(str.indexOf(from)+from.length, str.lastIndexOf(to));
			return out;
		}

	}
	
}
