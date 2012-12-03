package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
    public class LevelThree extends Sprite
    {
        // The game objects
        private var _character:Character = null;
        private var _bigBackground:BigBackground = null;
        private var _gameOver:GameOver = null;
        private var _monster1:Monster = null;
        private var _monster2:Monster = null;
        private var _monster3:Monster = null;
        private var _monster4:Monster = null;
        private var _star:Star = null;
        private var _levelWinner:String = null;
        
        // The timers
        private var _monsterTimer:Timer = null;
        private var _gameOverTimer:Timer = null;
        
        // Reference to the stage from the application class
        private var _stage:Object = null;
        
        private var _direction:String = null;
        
        private const STAGE_BOUNDARY:uint = 50; 
        private const MONSTER_SPEED:uint = 1;
        private const USE_AI:Boolean = true;
        
        // Inner boundaries
        private var _leftInnerBoundary:uint = 0;
        private var _rightInnerBoundary:uint = 0;
        private var _topInnerBoundary:uint = 0;
        private var _bottomInnerBoundary:uint = 0;
        
        // Reference to explostion instance
        private var _explosion:Explosion = null;
        
        public function LevelThree(aStage:Object)
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
            _bigBackground = new BigBackground();
            _monster1 = new Monster();
            _monster2 = new Monster();
            _monster3 = new Monster();
            _monster4 = new Monster();
            _gameOver = new GameOver();
            
            // Add game ojbects to stage
            _addGameObjectToLevel(_bigBackground, - _bigBackground.width / 2, - _bigBackground.height / 2);
            _addGameObjectToLevel(_monster1, 400, 150);
            _addGameObjectToLevel(_monster2, 150, 150);
            _addGameObjectToLevel(_monster3, 50, 250);
            _addGameObjectToLevel(_monster4, 350, 350);
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
            
            _leftInnerBoundary = _stage.stageWidth / 2 - _stage.stageWidth / 4;
            _rightInnerBoundary = _stage.stageWidth / 2 + _stage.stageWidth / 4;
            _topInnerBoundary = _stage.stageHeight / 2 - _stage.stageHeight / 4;
            _bottomInnerBoundary = _stage.stageHeight / 2 + _stage.stageHeight / 4;
        }
        
        private function _onEnterFrame(aEvent:Event):void
        {
            // Move the character
            _character.move();
            
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
            
            if (_monster3.visible)
            {
                _monster3.move();
                _checkStageBoundaries(_monster3);
            }
            
            if (_monster4.visible)
            {
                _monster4.move();
                _checkStageBoundaries(_monster4);
            }
            
            // Collision detection between the character and monsters
            // After move the character and monsters
            _characterVsMonsterCollision(_character, _monster1);
            _characterVsMonsterCollision(_character, _monster2);
            _characterVsMonsterCollision(_character, _monster3);
            _characterVsMonsterCollision(_character, _monster4);
            
            // If the star has been launched, move it, check its stage
            // boundaries and collisions with the monsters 
            if (_star.launched)
            {
                // If it has been launched, make it visible
                _star.visible = true;
                
                // Move it and check the stage boundaries
                _star.moveWithDirection(_direction);
                _checkStarStageBoundaries(_star);
                
                // Check for collisions with the monsters
                _starVsMonsterCollision(_star, _monster1);
                _starVsMonsterCollision(_star, _monster2);
                _starVsMonsterCollision(_star, _monster3);
                _starVsMonsterCollision(_star, _monster4);
            }
            else
            {
                _star.visible = false;
            }
            
            // Save current background.x and background.y
            // Used to calculate the background volecity after move the background
            var xbTemp:int = _bigBackground.x;
            var ybTemp:int = _bigBackground.y;
            
            // Check character inner boundary
            if (_character.x < _leftInnerBoundary)
            {
                _character.x = _leftInnerBoundary;
                
                // Restore the right inner boundary when character hit the left innner bounday
                // Boundary will be expand when character moving closely to the edge (close enough to cross the inner boundary)
                _rightInnerBoundary = _stage.stageWidth / 2 + _stage.stageWidth / 4;
                
                _bigBackground.x -= _character.vx; // Compensate the background since we block the character in the inner boundary
            }
            else if (_character.x > _rightInnerBoundary)
            {
                _character.x = _rightInnerBoundary;
                _leftInnerBoundary = _stage.stageWidth / 2 - _stage.stageWidth / 4;
                
                _bigBackground.x -= _character.vx;
            }
            
            if (_character.y < _topInnerBoundary)
            {
                _character.y = _topInnerBoundary;
                _bottomInnerBoundary = _stage.stageHeight / 2 + _stage.stageHeight / 4; 
                
                _bigBackground.y -= _character.vy;
            }
            else if (_character.y > _bottomInnerBoundary)
            {
                _character.y = _bottomInnerBoundary;
                _topInnerBoundary = _stage.stageHeight / 2 - _stage.stageHeight / 4;
                
                _bigBackground.y -= _character.vy;
            }
            
            // Check the background boundary
            if (_bigBackground.x > 0) 
            {
                _bigBackground.x = 0;
                
                _leftInnerBoundary = STAGE_BOUNDARY;
            }
            else if (_bigBackground.x < stage.stageWidth - _bigBackground.width )
            {
                _bigBackground.x = stage.stageWidth - _bigBackground.width;
                
                _rightInnerBoundary = _stage.stageWidth - _character.width - STAGE_BOUNDARY;
            }
            
            if (_bigBackground.y > 0)
            {
                _bigBackground.y = 0;
                
                _topInnerBoundary = STAGE_BOUNDARY;
            }
            else if (_bigBackground.y < stage.stageHeight - _bigBackground.height)
            {
                _bigBackground.y = stage.stageHeight - _bigBackground.height;
                
                _bottomInnerBoundary = _stage.stageHeight - _character.height - STAGE_BOUNDARY;
            }
            
            // Check the character stage boundary
            // Since we already give the inner boundary, seems no need for character stage boundary.
            
            // Scroll objects
            var vxScroll:int = _bigBackground.x - xbTemp;
            var vyScroll:int = _bigBackground.y - ybTemp;
            
            _scroll(_star, vxScroll, vyScroll);
            _scroll(_monster1, vxScroll, vyScroll);
            _scroll(_monster2, vxScroll, vyScroll);
            _scroll(_monster3, vxScroll, vyScroll);
            _scroll(_monster4, vxScroll, vyScroll);
            
            if (_explosion && _explosion.visible)
            {
                _scroll(_explosion, vxScroll, vyScroll);
            }
        }
        
        private function _scroll(aSprite:Sprite, aVX:int, aVY:int):void
        {
            aSprite.x += aVX;
            aSprite.y += aVY;
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
            
            _explosion = explosion;
        }
        
        private function _checkGameOver():void
        {
            var isGameOver:Boolean = false;
            
            if (_monster1.isDead() && _monster2.isDead() && _monster3.isDead() && _monster4.isDead())
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
        
        // This is only used by the monsters in big background
        private function _checkStageBoundaries(aSprite:Sprite):void
        {
            aSprite.x = aSprite.x < _bigBackground.x + STAGE_BOUNDARY ? _bigBackground.x + STAGE_BOUNDARY : aSprite.x;
            aSprite.y = aSprite.y < _bigBackground.y + STAGE_BOUNDARY ? _bigBackground.y + STAGE_BOUNDARY : aSprite.y;
            
            aSprite.x = aSprite.x + aSprite.width > _bigBackground.x + _bigBackground.width - STAGE_BOUNDARY ? _bigBackground.x + _bigBackground.width - aSprite.width - STAGE_BOUNDARY : aSprite.x;
            aSprite.y = aSprite.y + aSprite.height > _bigBackground.y + _bigBackground.height - STAGE_BOUNDARY ? _bigBackground.y + _bigBackground.height - aSprite.height - STAGE_BOUNDARY : aSprite.y;
        }
        
        private function _checkStarStageBoundaries(aStar:Star):void
        {
            if (aStar.x < STAGE_BOUNDARY
                || aStar.y < STAGE_BOUNDARY
                || aStar.x > _stage.stageWidth - STAGE_BOUNDARY
                || aStar.y > _stage.stageHeight - STAGE_BOUNDARY)
            {
                aStar.launched = false;
            }
        }
        
        private function _onMonsterTimer(aEvent:TimerEvent):void
        {
            _changeMonsterDirection(_monster1);
            _changeMonsterDirection(_monster2);
            _changeMonsterDirection(_monster3);
            _changeMonsterDirection(_monster4);
        }
        
        private function _changeMonsterDirection(aMonster:Monster):void
        {
            if (USE_AI)
            {
                if (Math.abs(_character.x - aMonster.x) >= Math.abs(_character.y - aMonster.y))
                {
                    if (_character.x > aMonster.x) 
                    {
                        aMonster.vx = MONSTER_SPEED;
                    }
                    else if (_character.x < aMonster.x)
                    {
                        aMonster.vx = - MONSTER_SPEED;
                    }
                    else
                    {
                        aMonster.vx = 0;
                    }
                }
                else
                {
                    if (_character.y > aMonster.y)
                    {
                        aMonster.vy = MONSTER_SPEED;
                    }
                    else if (_character.y < aMonster.y)
                    {
                        aMonster.vy = - MONSTER_SPEED;
                    }
                    else
                    {
                        aMonster.vy = 0;
                    }
                }
            }
            else
            {
                var randomNumber:int = Math.ceil(Math.random() * 4);
                
                if (1 == randomNumber)
                {
                    // Right
                    aMonster.vx = MONSTER_SPEED;
                    aMonster.vy = 0;
                }
                else if (2 == randomNumber)
                {
                    // Left
                    aMonster.vx = - MONSTER_SPEED;
                    aMonster.vy = 0;
                }
                else if (3 == randomNumber)
                {
                    // Up
                    aMonster.vx = 0;
                    aMonster.vy = - MONSTER_SPEED;
                }
                else
                {
                    // Down
                    aMonster.vx = 0;
                    aMonster.vy = MONSTER_SPEED;
                }
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
                _direction = "left";
                _character.vx = -5;
            }
            else if (Keyboard.RIGHT == aEvent.keyCode)
            {
                _direction = "right";
                _character.vx = 5;
            }
            else if (Keyboard.UP == aEvent.keyCode)
            {
                _direction = "up";
                _character.vy = -5;
            }
            else if (Keyboard.DOWN == aEvent.keyCode)
            {
                _direction = "down";
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