package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
import flash.utils.getQualifiedClassName;

import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisButton;

public class CharisCommandFactory {
        private static const simpleCommands:Array = [
            {pattern:["left","l"]                        , buttonName:"CharisLeftButton"            , className:"LeftRC"},
            {pattern:["right","r"]                       , buttonName:"CharisRightButton"           , className:"RightRC"},
            {pattern:["up","u"]                          , buttonName:"CharisUpButton"              , className:"UpRC"},
            {pattern:["down","d"]                        , buttonName:"CharisDownButton"            , className:"DownRC"},
            {pattern:["jump","j"]                        , buttonName:"CharisJumpRightButton"       , className:"JumpRightRC"},
            {pattern:["jumpdown","downjump","jd","dj"]   , buttonName:"CharisJumpDownButton"        , className:"JumpDownRC"},
            {pattern:["jumpleft","leftjump","jl","lj"]   , buttonName:"CharisJumpLeftButton"        , className:"JumpLeftRC"},
            {pattern:["jumpup","upjump","ju","uj"]       , buttonName:"CharisJumpUpButton"          , className:"JumpUpRC"},
            {pattern:["circle","c"]                      , buttonName:"CharisCircleButton"          , className:"CircleRC"},
            {pattern:["leftdown","downleft","ld","dl"]   , buttonName:"CharisLeftDownButton"        , className:"LeftDownRC"},
            {pattern:["leftup","upleft","lu","ul"]       , buttonName:"CharisLeftUpButton"          , className:"LeftUpRC"},
            {pattern:["rightdown","downright","rd","dr"] , buttonName:"CharisRightDownButton"       , className:"RightDownRC"},
            {pattern:["rightup","upright","ru","ur"]     , buttonName:"CharisRightUpButton"         , className:"RightUpRC"},
            {pattern:["jumpleftdown","jld"]              , buttonName:"CharisJumpLeftDownButton"    , className:"JumpLeftDownRC"},
            {pattern:["jumpleftup","jlu"]                , buttonName:"CharisJumpLeftUpButton"      , className:"JumpLeftUpRC"},
            {pattern:["jumprightdown","jrd"]             , buttonName:"CharisJumpRightDownButton"   , className:"JumpRightDownRC"},
            {pattern:["jumprightup","jru"]               , buttonName:"CharisJumpRightUpButton"     , className:"JumpRightUpRC"},
            {pattern:["jumpzero","jz"]                   , buttonName:"CharisJumpZeroButton"        , className:"JumpZeroRC"},
            {pattern:["bar","b","p"]                     , buttonName:"CharisFillButton"            , className:"BarRC"},
            {pattern:["worm","w"]                        , buttonName:"CharisWormTortue"            , className:"WormRC"},
            {pattern:["turtle","t"]                      , buttonName:"CharisWormTortue"            , className:"TurtleRC"}
        ];
        public function CharisCommandFactory() {
        }

        public static function getCommandByPattern(value:String):IRobotCommand{
            var i:int;
            var j:int;
            var l:int;
            var k:int;
            var pattern:RegExp;
            l = simpleCommands.length;
            for(i=0;i<l;i++){
                k = simpleCommands[i].pattern.length;
                for(j=0;j<k;j++){
                    pattern = new RegExp("\\b"+simpleCommands[i].pattern[j]+"\\b", "gi");
                    if(pattern.test(value)){
                        return getCommandByClassName(simpleCommands[i].className);
                    }
                }
            }
            return null;
        }
        public static function getCommandByButtonName(value:String):IRobotCommand{
            var i:int;
            var l:int = simpleCommands.length;
            for(i=0;i<l;i++){
                if(simpleCommands[i].buttonName == value){
                    return getCommandByClassName(simpleCommands[i].className);
                }
            }
            return null;
        }
        public static function getCommandByButton(value:CharisButton):IRobotCommand{
            var className:String = getQualifiedClassName(value.button);
            return getCommandByButtonName(className);
        }
        public static function getCommandClassName(value:CharisButton):String{
            var className:String = getQualifiedClassName(value.button);
            var i:int;
            var l:int = simpleCommands.length;
            for(i=0;i<l;i++){
                if(simpleCommands[i].buttonName == className){
                    return simpleCommands[i].className;
                }
            }
            return null;
        }
        public static function getCommandByClassName(value:String):IRobotCommand{
            var out:IRobotCommand;
            switch (value){
                case "LeftRC": out = new LeftRC(); break;
                case "RightRC": out = new RightRC(); break;
                case "UpRC": out = new UpRC();break;
                case "DownRC": out = new DownRC(); break;
                case "JumpRightRC": out = new  JumpRightRC(); break;
                case "JumpDownRC": out = new JumpDownRC(); break;
                case "JumpLeftRC": out = new JumpLeftRC(); break;
                case "JumpUpRC": out = new JumpUpRC(); break;
                case "CircleRC": out = new CircleRC(); break;
                case "LeftDownRC": out = new LeftDownRC(); break;
                case "LeftUpRC": out = new LeftUpRC(); break;
                case "RightDownRC": out = new RightDownRC(); break;
                case "RightUpRC": out = new RightUpRC(); break;
                case "JumpLeftDownRC": out = new JumpLeftDownRC(); break;
                case "JumpLeftUpRC": out = new JumpLeftUpRC(); break;
                case "JumpRightDownRC": out = new JumpRightDownRC(); break;
                case "JumpRightUpRC": out = new JumpRightUpRC(); break;
                case "JumpZeroRC": out = new JumpZeroRC(); break;
                case "BarRC": out = new BarRC(); break;
                case "WormRC": out = new WormRC(); break;
                case "TurtleRC": out = new TurtleRC(); break;
            }
            trace(" Out command = " +out);
            return out;
        }
    }
}
