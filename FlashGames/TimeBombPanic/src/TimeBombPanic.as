package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]
    
    public class TimeBombPanic extends Sprite
    {
        private const CHARACTER_STAGE_BOUNDARY:uint = 50;
        private const BOMB_TIME:uint = 100;                
        
        // Text objects
        private var _format:TextFormat = new TextFormat();
        private var _output:TextField = new TextField();
        private var _input:TextField = new TextField();
        private var _gameResult:TextField = new TextField();
        
        // Game objects
        private var _character:Character = new Character();
        private var _timeDisplay:TimeDisplay = new TimeDisplay();
        private var _background:BigBackground = new BigBackground();
        private var _gameOver:GameOver = new GameOver();
        
        // The bombs
        private var _bomb1:Bomb = new Bomb();
        private var _bomb2:Bomb = new Bomb();
        private var _bomb3:Bomb = new Bomb();
        private var _bomb4:Bomb = new Bomb();
        private var _bomb5:Bomb = new Bomb();
        
        // The boxes
        private var _box1:Box = new Box();
        private var _box2:Box = new Box();
        private var _box3:Box = new Box();
        private var _box4:Box = new Box();
        private var _box5:Box = new Box();
        private var _box6:Box = new Box();
        private var _box7:Box = new Box();
        private var _box8:Box = new Box();
        private var _box9:Box = new Box();
        private var _box10:Box = new Box();
        private var _box11:Box = new Box();
        private var _box12:Box = new Box();
        private var _box13:Box = new Box();
        private var _box14:Box = new Box();
        
        // Timer
        private var _timer:Timer = null;
        
        // Velocity
        private var _vx:int = 0;
        private var _vy:int = 0;
        
        private var _bombsDefused:uint = 0;
        
        // Inner boundaries
        private var _leftInnerBoundary:uint = 0;
        private var _rightInnerBoundary:uint = 0;
        private var _topInnerBoundary:uint = 0;
        private var _bottomInnerBoundary:uint = 0;
        
        public function TimeBombPanic()
        {
            _setupGameObjects();
            _setupTextFields();
            _setupEventListeners();
        }
        
        private function _setupGameObjects():void
        {
            // Add BG and character
            _addToStage(_background, -(_background.width - stage.stageWidth) / 2, -(_background.height - stage.stageHeight) / 2);
            _addToStage(_character, 100, 150);
            
            // Add the boxes
            _addToStage(_box1, _background.x + 100, _background.y + 100);
            _addToStage(_box2, _background.x + 200, _background.y + 300);
            _addToStage(_box3, _background.x + 400, _background.y + 450);
            _addToStage(_box4, _background.x + 100, _background.y + 600);
            _addToStage(_box5, _background.x + 300, _background.y + 700);
            _addToStage(_box6, _background.x + 500, _background.y + 200);
            _addToStage(_box7, _background.x + 600, _background.y + 600);
            _addToStage(_box8, _background.x + 500, _background.y + 500);
            _addToStage(_box9, _background.x + 700, _background.y + 200);
            _addToStage(_box10, _background.x + 700, _background.y + 400);
            _addToStage(_box11, _background.x + 800, _background.y + 500);
            _addToStage(_box12, _background.x + 100, _background.y + 700);
            _addToStage(_box13, _background.x + 900, _background.y + 300);
            _addToStage(_box14, _background.x + 800, _background.y + 200);
            
            // Add the bombs
            _addToStage(_bomb1, _background.x + 55, _background.y + 710);
            _addToStage(_bomb2, _background.x + 255, _background.y + 310);
            _addToStage(_bomb3, _background.x + 355, _background.y + 160);
            _addToStage(_bomb4, _background.x + 855, _background.y + 510);
            _addToStage(_bomb5, _background.x + 755, _background.y + 610);
            
            // Game Over
            _addToStage(_gameOver, 125, 50);
            _gameOver.visible = false;
            
            _addToStage(_timeDisplay, 200, 5); // May need to add this last ...
            
            //Define the inner boundary variables
            _rightInnerBoundary = (stage.stageWidth / 2) + (stage.stageWidth / 4);
            _leftInnerBoundary = (stage.stageWidth / 2) - (stage.stageWidth / 4); 
            _topInnerBoundary = (stage.stageHeight / 2) - (stage.stageHeight / 4); 
            _bottomInnerBoundary = (stage.stageHeight / 2) + (stage.stageHeight / 4);
        }
        
        private function _setupTextFields():void
        {
            _format.font = "Helvetica";
            _format.size = 38;
            _format.color = 0xFFFFFF;
            _format.align = TextFormatAlign.CENTER;
            
            _output.defaultTextFormat = _format;
            _output.autoSize = TextFieldAutoSize.CENTER;
            _output.border = false;
            _output.text = "0";
            stage.addChild(_output);
            _output.x = 265;
            _output.y = 7;
            
            _format.color = 0x000000;
            _format.size = 32;
            _gameResult.defaultTextFormat = _format;
            _gameResult.autoSize = TextFieldAutoSize.CENTER;
            _gameResult.text = "You Won!";
            
            _gameOver.addChild(_gameResult); 
            _gameResult.x = 145;
            _gameResult.y = 160;
        }
        
        private function _setupEventListeners():void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown); 
            stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
            stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
            
            // Init the timer
            _timer = new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, _onTimer);
            _timer.start();
        }
        
        private function _onTimer(aEvent:TimerEvent):void
        {
            _output.text = String(_timer.currentCount);
            
            // Stop the timer when it reaches 10
            if (BOMB_TIME == _timer.currentCount)
            {
                _checkGameOver(); 
            }
        }
        
        private function _onEnterFrame(aEvent:Event):void
        {
            //Move the player 
            _character.x += _vx; 
            _character.y += _vy; 
            
            //Box Collision code
            Collision.block(_character, _box1);
            Collision.block(_character, _box2);
            Collision.block(_character, _box3);
            Collision.block(_character, _box4);
            Collision.block(_character, _box5);
            Collision.block(_character, _box6);
            Collision.block(_character, _box7);
            Collision.block(_character, _box8);
            Collision.block(_character, _box9);
            Collision.block(_character, _box10);
            Collision.block(_character, _box11);
            Collision.block(_character, _box12);
            Collision.block(_character, _box13);
            Collision.block(_character, _box14);
            
            //Bomb collision code
            if(_character.hitTestObject(_bomb1) && _bomb1.visible == true)
            {
                _bomb1.visible = false;
                _bombsDefused++;
                _checkGameOver();
            }
            if(_character.hitTestObject(_bomb2) && _bomb2.visible == true)
            {
                _bomb2.visible = false;
                _bombsDefused++;
                _checkGameOver();
            }
            if(_character.hitTestObject(_bomb3) && _bomb3.visible == true)
            {
                _bomb3.visible = false;
                _bombsDefused++;
                _checkGameOver();
            }
            if(_character.hitTestObject(_bomb4) && _bomb4.visible == true)
            {
                _bomb4.visible = false;
                _bombsDefused++;
                _checkGameOver();
            }
            if(_character.hitTestObject(_bomb5) && _bomb5.visible == true)
            {
                _bomb5.visible = false;
                _bombsDefused++;
                _checkGameOver();
            }
            
            // Calculate the scroll velocity
            var temporaryX:int = _background.x;
            var temporaryY:int = _background.y;
            
            //  Inner boundaries
            if (_character.x < _leftInnerBoundary)
            {
                _character.x = _leftInnerBoundary;
                _rightInnerBoundary = (stage.stageWidth / 2) + (stage.stageWidth / 4);
                
                _background.x -= _vx;
            }
            else if (_character.x + _character.width > _rightInnerBoundary)
            {
                _character.x = _rightInnerBoundary - _character.width;
                _leftInnerBoundary = (stage.stageWidth / 2) - (stage.stageWidth / 4);
                
                _background.x -= _vx;
            }
            
            if (_character.y < _topInnerBoundary)
            {
                _character.y = _topInnerBoundary;
                _bottomInnerBoundary = (stage.stageHeight / 2) + (stage.stageHeight / 4);
                
                _background.y -= _vy;
            }
            else if (_character.y + _character.height > _bottomInnerBoundary)
            {
                _character.y = _bottomInnerBoundary - _character.height;
                _topInnerBoundary = (stage.stageHeight / 2) - (stage.stageHeight / 4);
                
                _background.y -= _vy;
            }
            
            // Background stage boundaries
            if (_background.x > 0)
            {
                _background.x = 0;
                _leftInnerBoundary = 0;
            }
            
            if (_background.y > 0)
            {
                _background.y = 0;
                _topInnerBoundary = 0;
            }
            
            if (_background.x < stage.stageWidth - _background.width)
            {
                _background.x = stage.stageWidth - _background.width;
                _rightInnerBoundary = stage.stageWidth;
            }
            
            if (_background.y < stage.stageHeight - _background.height)
            {
                _background.y = stage.stageHeight - _background.height; 
                _bottomInnerBoundary = stage.stageHeight;
            }
            
            // Character stage boundaries
            if (_character.x < CHARACTER_STAGE_BOUNDARY)
            {
                _character.x = CHARACTER_STAGE_BOUNDARY;
            }
            
            if (_character.y < CHARACTER_STAGE_BOUNDARY)
            {
                _character.y = CHARACTER_STAGE_BOUNDARY;
            }
            
            if (_character.x + _character.width > stage.stageWidth - CHARACTER_STAGE_BOUNDARY)
            {
                _character.x = stage.stageWidth - _character.width - CHARACTER_STAGE_BOUNDARY;
            }
            
            if (_character.y + _character.height > stage.stageHeight - CHARACTER_STAGE_BOUNDARY)
            {
                _character.y = stage.stageHeight - _character.height - CHARACTER_STAGE_BOUNDARY;
            }
            
            // Calculate the scroll velocity
            var vxScroll:int = _background.x - temporaryX;
            var vyScroll:int = _background.y - temporaryY;
            
            // Use the scroll velocity to move the game objects
            _scroll(_box1, vxScroll, vyScroll);
            _scroll(_box2, vxScroll, vyScroll);
            _scroll(_box3, vxScroll, vyScroll);
            _scroll(_box4, vxScroll, vyScroll);
            _scroll(_box5, vxScroll, vyScroll);
            _scroll(_box6, vxScroll, vyScroll);
            _scroll(_box7, vxScroll, vyScroll);
            _scroll(_box8, vxScroll, vyScroll);
            _scroll(_box9, vxScroll, vyScroll);
            _scroll(_box10, vxScroll, vyScroll);
            _scroll(_box11, vxScroll, vyScroll);
            _scroll(_box12, vxScroll, vyScroll);
            _scroll(_box13, vxScroll, vyScroll);
            _scroll(_box14, vxScroll, vyScroll);
            
            _scroll(_bomb1, vxScroll, vyScroll);
            _scroll(_bomb2, vxScroll, vyScroll);
            _scroll(_bomb3, vxScroll, vyScroll);
            _scroll(_bomb4, vxScroll, vyScroll);
            _scroll(_bomb5, vxScroll, vyScroll);
        }
        
        private function _scroll(sprite:Sprite, vx:int, vy:int):void
        {
            sprite.x += vx;
            sprite.y += vy;
        }
        
        private function _defuseBomb(aBomb:Bomb):void
        {
            if (_character.hitTestObject(aBomb) && true == aBomb.visible)
            {
                aBomb.visible = false;
                _bombsDefused ++;
                
                _checkGameOver();
            }
        }
        
        private function _checkGameOver():void
        {
            var isGameOver:Boolean = false; 
            
            if (5 == _bombsDefused)
            {
                _gameResult.text = "You Won!";
                isGameOver = true;
            }
            else if (BOMB_TIME == _timer.currentCount)
            {
                _gameResult.text = "You Lost!";
                isGameOver = true;
            }
            
            if (isGameOver)
            {
                _gameOver.visible = true;
                _character.alpha = 0.5;
                _background.alpha = 0.5;
                
                _timer.removeEventListener(TimerEvent.TIMER, _onTimer);
                stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
            }
        }
        
        private function _addToStage(aSprite:Sprite, aX:int, aY:int):void
        {
            stage.addChild(aSprite);
            aSprite.x = aX;
            aSprite.y = aY;
        }
        
        private function _onKeyDown(aEvent:KeyboardEvent):void
        {
            if (Keyboard.LEFT == aEvent.keyCode)
            {
                _vx = -5;
            }
            else if(Keyboard.RIGHT == aEvent.keyCode)
            {
                _vx = 5;
            }
            else if (Keyboard.UP == aEvent.keyCode)
            {
                _vy = - 5;
            }
            else if (Keyboard.DOWN == aEvent.keyCode)
            {
                _vy = 5;
            }
        }
        
        private function _onKeyUp(aEvent:KeyboardEvent):void
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
    } 
}