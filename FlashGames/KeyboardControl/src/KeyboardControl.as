package
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.net.URLRequest;
    import flash.ui.Keyboard;
    
    import flashx.textLayout.formats.BackgroundColor;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]
      
    public class KeyboardControl extends Sprite
    {
        private var _vx:int = 0;
        private var _vy:int = 0;
        
        private const VELOCITY:int = 5;
        
        [Embed(source="../images/background.png")] 
        private var BackgroundImage:Class;
        private var _background:Sprite = null;
         
        
        [Embed(source="../images/character.png")] 
        private var CharacterImage:Class;
        private var _character:Sprite = null; 
        
        public function KeyboardControl()
        {
            init();
        }
        
        private function init():void
        {
            initResources();
            initEvents();
        }
        
        private function initResources():void
        {
            var backgroundImage:DisplayObject = new BackgroundImage();
            _background = new Sprite();
            _background.addChild(backgroundImage);
            stage.addChild(_background);
            _background.x = - _background.width / 2;
            _background.y = - _background.height / 2;
            
            var characterImage:DisplayObject = new CharacterImage();
            _character = new Sprite();
            _character.addChild(characterImage);
            stage.addChild(_character);
            _character.x = stage.stageWidth / 2 - _character.width / 2;
            _character.y = stage.stageHeight / 2 - _character.height / 2;
        }
        
        private function initEvents():void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler); 
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler); 
            
            // This will attach the event to the current Class, which is KeyboardControl
            addEventListener(Event.ENTER_FRAME, enterFrameHandler); 
        }
        
        private function keyDownHandler(aEvent:KeyboardEvent):void
        {
            if (Keyboard.LEFT == aEvent.keyCode) 
            {
                _vx = -VELOCITY;
            }
            else if (Keyboard.RIGHT == aEvent.keyCode) 
            {
                _vx = VELOCITY;
            }
            else if (Keyboard.UP == aEvent.keyCode)
            {
                _vy = -VELOCITY;
            }
            else if (Keyboard.DOWN == aEvent.keyCode)
            {
                _vy = VELOCITY;
            }      
        }
        
        private function keyUpHandler(aEvent:KeyboardEvent):void
        {
            if (Keyboard.LEFT == aEvent.keyCode || Keyboard.RIGHT == aEvent.keyCode) 
            {
                _vx = 0;
            }
            else if (Keyboard.UP == aEvent.keyCode || Keyboard.DOWN == aEvent.keyCode)
            {
                _vy = 0;
            }
        }
        
        private function isNeedScrollHorionzital():Boolean
        {
            if ((_character.x <= 0 && _vx < 0)
                || (_character.x >= stage.stageWidth - _character.width && _vx > 0))
                return true;
            
            return false;
        }
        
        private function isNeedScrollVertical():Boolean 
        {
            if ((_character.y <= 0 && _vy < 0)
                || (_character.y >= stage.stageHeight - _character.height && _vy > 0))
                return true;
            
            return false;
        }
        
        private function enterFrameHandler(aEvent:Event):void
        {
            // Move the background, with -=
            if (isNeedScrollHorionzital())
            {
                _background.x -= _vx;
                
                // Check the stage boundaries
                if (_background.x > 0)
                {
                    _background.x = 0;
                }
                
                if (_background.x < stage.stageWidth - _background.width)
                {
                    _background.x = stage.stageWidth - _background.width;
                }
            }
            else
            {
                // Move the character, with +=
                _character.x += _vx;
            
                // Stage edging
                _character.x = _character.x < 0 ? 0 : _character.x;
                _character.x = _character.x > stage.stageWidth - _character.width ? stage.stageWidth - _character.width : _character.x;
            
                // Screen wrapping
                //_character.x = _character.x + _character.width < 0 ? stage.stageWidth : _character.x;
                //_character.y = _character.y + _character.height < 0 ? stage.stageHeight : _character.y;
                //_character.x = _character.x > stage.stageWidth ? 0 - _character.width : _character.x;
                //_character.y = _character.y > stage.stageHeight ? 0 - _character.height : _character.y;
            }
            
            if (isNeedScrollVertical())
            {
                _background.y -= _vy;
                
                // Check the stage boundaries
                if (_background.y > 0)
                {
                    _background.y = 0;
                }
                
                if (_background.y < stage.stageHeight - _background.height) 
                {
                    _background.y = stage.stageHeight - _background.height;    
                }
            }
            else
            {
                // Move the character, with +=
                _character.y += _vy;
                
                // Stage edging
                _character.y = _character.y < 0 ? 0 : _character.y;
                _character.y = _character.y > stage.stageHeight - _character.height ? stage.stageHeight - _character.height : _character.y;
                
                // Screen wrapping
                //_character.x = _character.x + _character.width < 0 ? stage.stageWidth : _character.x;
                //_character.y = _character.y + _character.height < 0 ? stage.stageHeight : _character.y;
                //_character.x = _character.x > stage.stageWidth ? 0 - _character.width : _character.x;
                //_character.y = _character.y > stage.stageHeight ? 0 - _character.height : _character.y;
            }
        }
    }
}