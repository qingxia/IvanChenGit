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
        private const STAGE_BOUNDARY:uint = 50;
        private const BOMB_TIME:uint = 100;                
        
        // Text objects
        private var _format:TextFormat = new TextFormat();
        private var _output:TextField = new TextField();
        private var _input:TextField = new TextField();
        private var _gameResult:TextField = new TextField();
        
        // Game objects
        private var _character:Character = new Character();
        private var _background:Background = new Background();
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
        
        public function TimeBombPanic()
        {
            _setupGameObjects();
            _setupTextFields();
            _setupEventListeners();
        }
        
        private function _setupGameObjects():void
        {
            // Add BG and character
            _addToStage(_background, 0, 0);
            _addToStage(_character, 50, 50);
            
            // Add the boxes
            _addToStage(_box1, 100, 100);
            _addToStage(_box2, 150, 100);
            _addToStage(_box3, 200, 100);
            _addToStage(_box4, 150, 150);
            _addToStage(_box5, 100, 250);
            _addToStage(_box6, 200, 250);
            _addToStage(_box7, 250, 250);
            _addToStage(_box8, 250, 200);
            _addToStage(_box9, 300, 100);
            _addToStage(_box10, 300, 300);
            _addToStage(_box11, 350, 250);
            _addToStage(_box12, 400, 100);
            _addToStage(_box13, 400, 200);
            _addToStage(_box14, 400, 250);
            
            // Add the bombs
            _addToStage(_bomb1, 105, 160);
            _addToStage(_bomb2, 205, 310);
            _addToStage(_bomb3, 305, 160);
            _addToStage(_bomb4, 355, 310);
            _addToStage(_bomb5, 455, 110);
            
            // Game Over
            _addToStage(_gameOver, 125, 50);
            _gameOver.visible = false;
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
            // Move the player
            _character.x += _vx;
            _character.y += _vy;
            
            // Stage boundaries
            // This is used to make the boxes on the background image to seem like real boxes.
            if (_character.x < STAGE_BOUNDARY)
            {
                _character.x = STAGE_BOUNDARY;
            }
            
            if (_character.y < STAGE_BOUNDARY)
            {
                _character.y = STAGE_BOUNDARY; 
            }
            
            if (_character.x + _character.width > stage.stageWidth - STAGE_BOUNDARY)
            {
                _character.x = stage.stageWidth - _character.width - STAGE_BOUNDARY;
            } 
            
            if (_character.y + _character.height > stage.stageHeight - STAGE_BOUNDARY) 
            {
                _character.y = stage.stageHeight - _character.height - STAGE_BOUNDARY;
            }
            
            // Box collision code 
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
            
            // Bomb collision code
            _defuseBomb(_bomb1);
            _defuseBomb(_bomb2);
            _defuseBomb(_bomb3);
            _defuseBomb(_bomb4);
            _defuseBomb(_bomb5);
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