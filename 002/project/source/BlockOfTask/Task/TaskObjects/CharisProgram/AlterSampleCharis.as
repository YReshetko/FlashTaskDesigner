/**
 * Created with IntelliJ IDEA.
 * User: Yurchik
 * Date: 04.04.16
 * Time: 19:45
 * To change this template use File | Settings | File Templates.
 */
package source.BlockOfTask.Task.TaskObjects.CharisProgram {
import flash.display.Sprite;
import flash.utils.ByteArray;

import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.CharisProgramParser;

public class AlterSampleCharis extends Sprite{
        private static const EXAMPLE_PROGRAM:int = 1;
        private static const EXAMPLE_PICTURE:int = 2;
        private static const EXAMPLE_SCHEMA:int = 3;

        private static const TASK_PICTURE:int = 1;
        private static const TASK_SCHEMA:int = 2;
        private static const TASK_PROGRAM:int = 3;

        private var fileName:String;
        private var ceilSize:Number;
        private var cols:int;
        private var rows:int;

        private var ceilSizeSchem:Number;
        private var colsSchem:int;
        private var rowsSchem:int;

        private var taskType:int;
        private var exampleType:int;

        private var brashColor:uint;
        private var fillColor:uint;
        private var labelXml:XMLList;

        private var container:Sprite;

        private var xmlTaskEntity:XMLList;
        private var xmlExampleEntity:XMLList;

        private var taskFieldXml:XMLList;

        private var donotknowSimulation:Boolean;
        private var isSimulation:Boolean;
        private var checkBySchem:Boolean;
        private var checkByPicture:Boolean;
        private var showMisstakes:Boolean;
        private var otherImplimentation:Boolean;


        private var isUseButtons:Boolean;
        private var isCheckAutomaticly:Boolean;
        private var isUseShortCommands:Boolean;
        private var isUseFullCommand:Boolean;
        public function AlterSampleCharis(xml:XMLList, text:ByteArray, container:Sprite) {

        }
        private function parse(xml:XMLList):void{
           /* fileName = xml.@content;
            ceilSize = parseFloat(xml.@ceil_size);
            cols = parseInt(xml.@cols);
            rows = parseInt(xml.@rows);
            ceilSizeSchem = parseFloat(xml.@ceilSizeSchem);
            colsSchem = parseInt(xml.@colsSchem);
            rowsSchem = parseInt(xml.@rowsSchem);
            taskType = parseInt(xml.@taskType);
            exampleType = parseInt(xml.@exampleType);
            brashColor = xml.@brash_color;
            fillColor = xml.@fill_color;
            labelXml = xml.LABEL;

            donotknowSimulation = (xml.@donotknowSimulation.toString() == "true")?true:false;
            isSimulation = (xml.@isSimulation.toString() == "true")?true:false;
            checkBySchem = (xml.@checkBySchem.toString() == "true")?true:false;
            checkByPicture = (xml.@checkByPicture.toString() == "true")?true:false;
            showMisstakes = (xml.@showMisstakes.toString() == "true")?true:false;
            otherImplimentation = (xml.@otherImplimentation.toString() == "true")?true:false;

            if(xml.@isUseButtons.toString() != ""){
                if(xml.@isUseButtons.toString() == "true") isUseButtons = true else isUseButtons = false;
            }else{
                isUseButtons = true;
            }
            if(xml.@isCheckAutomaticly.toString()!= ""){
                if(xml.@isCheckAutomaticly.toString() == "true") isCheckAutomaticly = true else isCheckAutomaticly = false;
            }else{
                isCheckAutomaticly = true;
            }


            if(xml.@isUseShortCommands.toString()!= ""){
                if(xml.@isUseShortCommands.toString() == "true") isUseShortCommands = true else isUseShortCommands = false;
            }else{
                isUseShortCommands = true;
            }

            if(xml.@isUseFullCommand.toString()!= ""){
                if(xml.@isUseFullCommand.toString() == "true") isUseFullCommand = true else isUseFullCommand = false;
            }else{
                isUseFullCommand = true;
            }


            if(xml.TASKLABEL.toString()!="") taskFieldXml = xml.TASKLABEL.LABEL;

            var parser:CharisProgramParser = new CharisProgramParser()
            labelXml.appendChild(new XML('<TEXT><![CDATA['+engine.text+']]></TEXT>'));

            for each(var samp:XML in xml.ENTITY){
                if(samp.@isExample.toString() == "true"){
                    xmlExampleEntity = new XMLList(samp);
                }else{
                    xmlTaskEntity = new XMLList(samp);
                }
            }

            var i:int;
            var l:int;
            l = buttons.length;
            for(i=0;i<l;i++){
                (buttons[i].object as CharisButton).button = buttons[i].clip;
                (buttons[i].object as CharisButton).name = buttons[i].name;
                (buttons[i].object as CharisButton).x = buttons[i].x;
                (buttons[i].object as CharisButton).y = buttons[i].y;
                if(buttons[i].name == "CharisSimulationButton"){
                    simulationButton = (buttons[i].object as CharisButton);
                }
            }
            for each(var but:XML in xml.BUTTON){
                for(i=0;i<l;i++){
                    if(buttons[i].name == but.@name){
                        (buttons[i].object as CharisButton).x = parseFloat(but.@x);
                        (buttons[i].object as CharisButton).y = parseFloat(but.@y);
                        if(but.@alpha.toString()!=""){
                            (buttons[i].object as CharisButton).setAlpha(parseFloat(but.@alpha.toString()));
                        }
                        /*if(but.@alpha.toString()!=""){
                         (buttons[i].object as CharisButton).setAlpha(parseFloat(but.@alpha.toString()));
                         }*/
                   /* }
                }
            }
            simulationButton.visible = isSimulation;      */
        }
    }
}
