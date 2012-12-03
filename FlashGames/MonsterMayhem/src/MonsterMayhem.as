package
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFFF", frameRate="60")] 
    
    public class MonsterMayhem extends Sprite
    {
        private var _levelOne:LevelOne = null;
        private var _levelTwo:LevelTwo = null;
        private var _levelThree:LevelThree = null;
        
        public function MonsterMayhem()
        {
            _levelOne = new LevelOne(stage);
            _levelTwo = new LevelTwo(stage);
            _levelThree = new LevelThree(stage);
            stage.addChild(_levelOne);
            
            stage.addEventListener("levelOneComplete", _switchLevel);
        }
        
        private function _switchLevel(aEvent:Event):void
        {
            if ("levelOneComplete" == aEvent.type)
            {
                stage.removeChild(_levelOne);
                _levelOne = null;
                stage.removeEventListener("levelOneComplete", _switchLevel);
                
                stage.addChild(_levelTwo);
                stage.addEventListener("levelTwoComplete", _switchLevel);
            }
            else if ("levelTwoComplete" == aEvent.type)
            {
                stage.removeChild(_levelTwo);
                _levelTwo = null;
                stage.removeEventListener("levelTwoComplete", _switchLevel);
                
                stage.addChild(_levelThree);
            }
        }
    }
}