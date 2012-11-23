package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import flashx.textLayout.formats.BackgroundColor;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]
    
    public class ParallaxScrolling extends Sprite
    {
        private var _vx:int = 0;
        
        private const VELOCITY:int = 5;
        
        [Embed(source="../images/farBackground.png")] 
        private var FarBackgroundImage:Class;
        private var _farBackground:Sprite = null;
        
        [Embed(source="../images/nearBackground.png")] 
        private var NearBackgroundImage:Class;
        private var _nearBackground:Sprite = null;
        
        [Embed(source="../images/character.png")] 
        private var CharacterImage:Class;
        private var _character:Sprite = null; 
        
        public function ParallaxScrolling()
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
            var farBackgroundImage:DisplayObject = new FarBackgroundImage();
            _farBackground = new Sprite();
            _farBackground.addChild(farBackgroundImage);
            stage.addChild(_farBackground);
            _farBackground.x = - _farBackground.width / 2;
            _farBackground.y = 0;
            
            var nearBackgroundImage:DisplayObject = new NearBackgroundImage();
            _nearBackground = new Sprite();
            _nearBackground.addChild(nearBackgroundImage);
            stage.addChild(_nearBackground);
            _nearBackground.x = - _nearBackground.width / 2;
            _nearBackground.y = 0;
            
            var characterImage:DisplayObject = new CharacterImage();
            _character = new Sprite();
            _character.addChild(characterImage);
            stage.addChild(_character);
            _character.x = stage.stageWidth / 2 - _character.width / 2;
            _character.y = stage.stageHeight  - _character.height; // Put the character on the ground
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
        }
        
        private function keyUpHandler(aEvent:KeyboardEvent):void
        {
            if (Keyboard.LEFT == aEvent.keyCode || Keyboard.RIGHT == aEvent.keyCode) 
            {
                _vx = 0;
            }
        }
        
        private function isNeedScrollHorionzital():Boolean
        {
            if ((_character.x <= 0 && _vx < 0)
                || (_character.x >= stage.stageWidth - _character.width && _vx > 0))
                return true;
            
            return false;
        }
        
        private function enterFrameHandler(aEvent:Event):void
        {
            // Move the background, with -=
            if (isNeedScrollHorionzital())
            {
                _farBackground.x -= _vx / 2;
                
                // Check the stage boundaries
                if (_farBackground.x > 0)
                {
                    _farBackground.x = 0;
                }
                
                if (_farBackground.x < stage.stageWidth - _farBackground.width)
                {
                    _farBackground.x = stage.stageWidth - _farBackground.width;
                }
                
                _nearBackground.x -= _vx;
                
                // Check the stage boundaries
                if (_nearBackground.x > 0)
                {
                    _nearBackground.x = 0;
                }
                
                if (_nearBackground.x < stage.stageWidth - _nearBackground.width)
                {
                    _nearBackground.x = stage.stageWidth - _nearBackground.width;
                }
            }
            else
            {
                // Move the character, with +=
                _character.x += _vx;
                
                // Stage edging
                _character.x = _character.x < 0 ? 0 : _character.x;
                _character.x = _character.x > stage.stageWidth - _character.width ? stage.stageWidth - _character.width : _character.x;
            }
        }
    }
}