package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
    public class LevelOne extends Sprite
    {
        // The game objects
        private var _character:Character = null;
        private var _background:Background = null;
        private var _gameOver:GameOver = null;
        private var _monster1:Monster = null;
        private var _monster2:Monster = null;
        private var _star:Star = null;
        private var _levelWinner:String = null;
        
        // The timers
        private var _monsterTimer:Timer;
        private var _gameOverTimer:Timer;
        
        // Reference to the stage from the application class
        private var _stage:Object;
        
        private const STAGE_BOUNDARY:uint = 50; 
        
        public function LevelOne(aStage:Object)
        {
            _stage = aStage;
            
            this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
        }
        
        private function _onAddedToStage(aEvent:Event):void
        {
            _startGame();
            
            this.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
        }
        
        private function _startGame():void
        {
            // Create the game objects
            _character = new Character();
            _star = new Star();
            _background = new Background();
            _monster1 = new Monster();
            _monster2 = new Monster();
            _gameOver = new GameOver();
            
            // Add game ojbects to stage
            _addGameObjectToLevel(_background, 0, 0);
            _addGameObjectToLevel(_monster1, 400, 150);
            _addGameObjectToLevel(_monster2, 150, 150);
            _addGameObjectToLevel(_character, 250, 300);
            _addGameObjectToLevel(_star, 250, 300);
            _star.visible = false;
            _addGameObjectToLevel(_gameOver, 140, 130);
            
            // Initialize the monster timer
            _monsterTimer = new Timer(1000);
            _monsterTimer.addEventListener(TimerEvent.TIMER, _onMonsterTimer);
            _monsterTimer.start();
            
            // Event listeners
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            _stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
            this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        }
        
        private function _onEnterFrame(aEvent:Event):void
        {
            // Move the character and check the stage boundaries
            _character.move();
            _checkStageBoundaries(_character);
            
            // Move the monsters and check the stage boundaries
            if (_monster1.visible)
            {
                _monster1.move();
                _checkStageBoundaries(_monster1);
            }
            
            if (_monster2.visible)
            {
                _monster2.move();
                _checkStageBoundaries(_monster2);
            }
            
            // If the star has been launched, move it, check its stage
            // boundaries and collisions with the monsters 
            if (_star.launched)
            {
                // If it has been launched, make it visible
                _star.visible = true;
                
                // Move it and check the stage boundaries
                _star.move();
                _checkStarStageBoundaries(_star);
                
                // Check for collisions with the monsters
                _starVsMonsterCollision(_star, _monster1);
                _starVsMonsterCollision(_star, _monster2);
            }
            else
            {
                _star.visible = false;
            }
            
            // Collision detection between the character and monsters
            {
                _characterVsMonsterCollision(_character, _monster1);
                _characterVsMonsterCollision(_character, _monster2);
            }
        }
        
        private function _characterVsMonsterCollision(aCharacter:Character, aMonster:Monster):void
        {
            if (aMonster.visible && aCharacter.hitTestObject(aMonster))
            {
                aCharacter.timesHit ++;
                _checkGameOver();
            }
        }
        
        private function _starVsMonsterCollision(aStar:Star, aMonster:Monster):void
        {
            if (aMonster.visible && aStar.hitTestObject(aMonster))
            {
                // Call the monster's openMouth method to make it open its mouth
                aMonster.openMouth();
                
                // Deactivate the star
                aStar.launched = false;
                
                // Increase the hit number
                aMonster.timesHit ++;
                
                // Check hit number
                if (aMonster.isDead()) 
                {
                    // Kill the monster
                    _killMonster(aMonster);
                    
                    _checkGameOver();
                }
            }
        }
        
        private function _killMonster(aMonster:Monster):void
        {
            // Make the monster invisible
            aMonster.visible = false;
            
            // Create a new explosion object
            var explosion:Explosion = new Explosion();
            this.addChild(explosion);
            
            // Center the explosion over the monster
            explosion.x = aMonster.x - 21;
            explosion.y = aMonster.y - 18;
            
            explosion.explode(); 
        }
        
        private function _checkGameOver():void
        {
            var isGameOver:Boolean = false;
            
            if (_monster1.isDead() && _monster2.isDead())
            {
                isGameOver = true;
                _levelWinner = "character";
            }
            
            if (_character.isDead())
            {
                isGameOver = true;
                _levelWinner = "monsters"
            }
            
            if (isGameOver)
            {
                _gameOverTimer = new Timer(2000);
                _gameOverTimer.addEventListener(TimerEvent.TIMER, _onGameOverTimer);
                _gameOverTimer.start();
                
                _monsterTimer.removeEventListener(TimerEvent.TIMER, _onMonsterTimer);
                this.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
            }
        }
        
        private function _checkStageBoundaries(aSprite:Sprite):void
        {
            aSprite.x = aSprite.x < STAGE_BOUNDARY ? STAGE_BOUNDARY : aSprite.x;
            aSprite.y = aSprite.y < STAGE_BOUNDARY ? STAGE_BOUNDARY : aSprite.y;
            
            aSprite.x = aSprite.x + aSprite.width > _stage.stageWidth - STAGE_BOUNDARY ? _stage.stageWidth - aSprite.width - STAGE_BOUNDARY : aSprite.x;
            aSprite.y = aSprite.y + aSprite.height > _stage.stageHeight - STAGE_BOUNDARY ? _stage.stageHeight - aSprite.height - STAGE_BOUNDARY : aSprite.y;
            
        }
        
        private function _checkStarStageBoundaries(aStar:Star):void
        {
            if (aStar.y < STAGE_BOUNDARY + aStar.height)
            {
                aStar.launched = false;
            }
        }
        
        private function _onMonsterTimer(aEvent:TimerEvent):void
        {
            _changeMonsterDirection(_monster1);
            _changeMonsterDirection(_monster2);
        }
        
        private function _changeMonsterDirection(aMonster:Monster):void
        {
            var randomNumber:int = Math.ceil(Math.random() * 4);
            
            if (1 == randomNumber)
            {
                // Right
                aMonster.vx = 1;
                aMonster.vy = 0;
            }
            else if (2 == randomNumber)
            {
                // Left
                aMonster.vx = -1;
                aMonster.vy = 0;
            }
            else if (3 == randomNumber)
            {
                // Up
                aMonster.vx = 0;
                aMonster.vy = -1;
            }
            else
            {
                // Down
                aMonster.vx = 0;
                aMonster.vy = 1;
            }
        }
        
        private function _onGameOverTimer(aEvent:TimerEvent):void
        {
            if ("character" == _levelWinner)
            {
                if (1 == _gameOverTimer.currentCount)
                {
                    _gameOver.levelComplete.visible = true;
                }
                
                if (2 == _gameOverTimer.currentCount)
                {
                    _gameOverTimer.reset();
                    _gameOverTimer.removeEventListener(TimerEvent.TIMER, _onGameOverTimer);
                    dispatchEvent(new Event("levelOneComplete", true));
                }
            }
            
            if ("monsters" == _levelWinner)
            {
                _gameOver.youLost.visible = true;
                _gameOverTimer.removeEventListener(TimerEvent.TIMER, _onGameOverTimer);
            }
        }
        
        private function _onKeyDown(aEvent:KeyboardEvent):void
        {
            if (Keyboard.LEFT == aEvent.keyCode)
            {
                _character.vx = -5;
            }
            else if (Keyboard.RIGHT == aEvent.keyCode)
            {
                _character.vx = 5;
            }
            else if (Keyboard.UP == aEvent.keyCode)
            {
                _character.vy = -5;
            }
            else if (Keyboard.DOWN == aEvent.keyCode)
            {
                _character.vy = 5;
            }
            
            if (Keyboard.SPACE == aEvent.keyCode)
            {
                if (!_star.launched)
                {
                    _star.x = _character.x + _character.width / 2;
                    _star.y = _character.y + _character.width / 2;
                    
                    _star.launched = true;
                }
            }
        }
        
        private function _onKeyUp(aEvent:KeyboardEvent):void
        {
            if (Keyboard.LEFT == aEvent.keyCode || Keyboard.RIGHT == aEvent.keyCode)
            {
                _character.vx = 0;
            }
            else if (Keyboard.DOWN == aEvent.keyCode || Keyboard.UP == aEvent.keyCode)
            {
                _character.vy = 0;
            }
        }
        
        private function _addGameObjectToLevel(aSprite:Sprite, x:int, y:int):void
        {
            this.addChild(aSprite);
            aSprite.x = x;
            aSprite.y = y;
        }
    }
}