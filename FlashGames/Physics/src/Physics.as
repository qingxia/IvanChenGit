package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]
    
    public class Physics extends Sprite
    {
        private var _character:Character = null;
        private var _nearBackground:NearBackground = null;
        private var _farBackground:FarBackground = null;
        
        private var _topInnerBoundary:uint = 0;
        private var _bottomInnerBoundary:uint = 0;
        private var _leftInnerBoundary:uint = 0;
        private var _rightInnerBoundary:uint = 0;
        
        private var _isJumping:Boolean = false;
        private var _isJumpingSecond:Boolean = false;
        
        private const ACCELERATION:Number = 0.2;
        private const STAGE_BOUNDARY:uint = 50;
        
        public function Physics()
        {
            _farBackground = new FarBackground(); 
            stage.addChild(_farBackground);
            _farBackground.x = - _farBackground.width / 2 + stage.stageWidth / 2;
            
            _nearBackground = new NearBackground(); 
            stage.addChild(_nearBackground);
            _nearBackground.x = - _nearBackground.width / 2 + stage.stageWidth / 2;
            
            _character = new Character(); 
            stage.addChild(_character);
            
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
            
            stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
            
            _topInnerBoundary = 0;
            _bottomInnerBoundary = stage.stageHeight - _character.height;
            _leftInnerBoundary = stage.stageWidth / 2 - stage.stageWidth / 4;
            _rightInnerBoundary = stage.stageWidth / 2 + stage.stageWidth / 4;
        }
        
        private function _onKeyDown(aEvent:KeyboardEvent):void
        {
            if (Keyboard.UP == aEvent.keyCode) 
            {
                //_character.accelerationY = - ACCELERATION;
            }
            else if (Keyboard.DOWN == aEvent.keyCode)
            {
                _character.accelerationY = ACCELERATION;
            }
            else if (Keyboard.LEFT == aEvent.keyCode)
            {
                _character.accelerationX = - ACCELERATION;
            }
            else if (Keyboard.RIGHT == aEvent.keyCode)
            {
                _character.accelerationX = ACCELERATION;
            }
            
            if (false == _isJumpingSecond && Keyboard.SPACE == aEvent.keyCode)
            {
                if (false == _isJumping)
                {
                    _isJumping = true;
                    _character.jump();
                }
                else
                {
                    _isJumpingSecond = true;
                    _character.jump();
                }
            }
        }
        
        private function _onKeyUp(aEvent:KeyboardEvent):void
        {
            if (Keyboard.UP == aEvent.keyCode || Keyboard.DOWN == aEvent.keyCode)
            {
                _character.accelerationY = 0;
            }
            else if (Keyboard.LEFT == aEvent.keyCode || Keyboard.RIGHT == aEvent.keyCode)
            {
                _character.accelerationX = 0;
            }
        }
        
        private function _onEnterFrame(aEvent:Event):void
        {
            _character.move();
            _checkCharacterInnerBoundary(_character);
            _checkNearBackgroundBoundary(); // Since we only move far background when near background can be moved, so we only need to check near BG
        }
        
        private function _checkCharacterInnerBoundary(aCharacter:Character):void
        {
            if (aCharacter.y < _topInnerBoundary)
            {
                aCharacter.y = _topInnerBoundary;
            }
            else if (aCharacter.y > _bottomInnerBoundary)
            {
                aCharacter.y = _bottomInnerBoundary;
                
                _isJumping = false;
                _isJumpingSecond = false;
            }
            
            var needMoveBG:Boolean = false;
            if (aCharacter.x < _leftInnerBoundary)
            {
                aCharacter.x = _leftInnerBoundary;
                _rightInnerBoundary = stage.stageWidth / 2 + stage.stageWidth / 4;
                
                needMoveBG = true;
            }
            else if (aCharacter.x + aCharacter.width > _rightInnerBoundary)
            {
                aCharacter.x = _rightInnerBoundary - aCharacter.width;
                _leftInnerBoundary = stage.stageWidth / 2 - stage.stageWidth / 4;
                
                needMoveBG = true;
            }
            
            if (needMoveBG)
            {
                _nearBackground.x -= aCharacter.vx;
                
                if (_nearBackground.x < 0 && _nearBackground.x > stage.stageWidth - _nearBackground.width)
                {
                    // Only move far background when near background can be moved
                    _farBackground.x -= aCharacter.vx / 2;
                }
            }
        }
        
        private function _checkNearBackgroundBoundary():void
        {
            if (_nearBackground.x > 0)
            {
                _nearBackground.x = 0;
                
                _leftInnerBoundary = 0;
            }
            else if (_nearBackground.x < stage.stageWidth - _nearBackground.width)
            {
                _nearBackground.x = stage.stageWidth - _nearBackground.width;
                
                _rightInnerBoundary = stage.stageWidth;
            }
        }
    }
}