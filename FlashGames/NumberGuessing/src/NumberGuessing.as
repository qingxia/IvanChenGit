package
{
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.text.*;
    import flash.ui.Keyboard;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]
    
    public class NumberGuessing extends Sprite
    {
        private var format:TextFormat = null;
        private var output:TextField = null;
        private var input:TextField = null;
        
        private var msg:String = null;
        private var mysteryNumber:uint = 0;
        private var currentGuess:uint = 0;
        
        private var guessesRemaining:uint = 0;
        private var guessesMade:uint = 0;
        private var gameStatus:String = null;
        private var gameWon:Boolean = false;
        
        private var loaderButtonDown:Loader = null;
        private var loaderButtonOver:Loader = null;
        private var loaderButtonUp:Loader = null;
        private var _spriteButton:Sprite = null; 
        
        private const BUTTON_UP:uint = 0;
        private const BUTTON_OVER:uint = 1;
        private const BUTTON_DOWN:uint = 2;
        
        public function NumberGuessing()
        {
            setupTextFields();
            setupButton();
            startGame();
        }
        
        private function setupButton():void
        {
            var urlButtonDown:URLRequest = new URLRequest("../images/buttonDown.png");
            loaderButtonDown = new Loader();
            loaderButtonDown.load(urlButtonDown); 
            
            var urlButtonOver:URLRequest = new URLRequest("../images/buttonOver.png");
            loaderButtonOver = new Loader();
            loaderButtonOver.load(urlButtonOver); 
            
            var urlButtonUp:URLRequest = new URLRequest("../images/buttonUp.png");
            loaderButtonUp = new Loader();
            loaderButtonUp.load(urlButtonUp); 
            
            _spriteButton = new Sprite();
            _spriteButton.addChild(loaderButtonDown);
            _spriteButton.addChild(loaderButtonOver);
            _spriteButton.addChild(loaderButtonUp);
            
            // Set the sprite's button properties
            _spriteButton.buttonMode = true;
            _spriteButton.mouseEnabled = true;
            _spriteButton.useHandCursor = true;
            _spriteButton.mouseChildren = false;
            
            setButtonStatus(BUTTON_UP);
            
            stage.addChild(_spriteButton);
            _spriteButton.x = 200;
            _spriteButton.y = 150;
            
            // Add the button event listeners
            _spriteButton.addEventListener(MouseEvent.ROLL_OVER, buttonRollOverHandler);
            _spriteButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownHandler);
            _spriteButton.addEventListener(MouseEvent.ROLL_OUT, buttonRollOutHandler);
            _spriteButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
        }
        
        private function buttonRollOverHandler(aEvent:MouseEvent):void 
        {
           setButtonStatus(BUTTON_OVER);
        }
        
        private function buttonDownHandler(aEvent:MouseEvent):void 
        {
           setButtonStatus(BUTTON_DOWN);
        }
        
        private function buttonRollOutHandler(aEvent:MouseEvent):void 
        {
           setButtonStatus(BUTTON_UP);
        }
        
        private function buttonClickHandler(aEvent:MouseEvent):void 
        {
           setButtonStatus(BUTTON_UP);
           playGame();
        }
        
        private function setButtonStatus(aStatus:uint):void
        {
            if (BUTTON_UP == aStatus)
            {
                loaderButtonUp.visible = true;
                loaderButtonOver.visible = false;
                loaderButtonDown.visible = false;
            }
            else if (BUTTON_OVER == aStatus)
            {
                loaderButtonUp.visible = false;
                loaderButtonOver.visible = true;
                loaderButtonDown.visible = false;
            }
            else if (BUTTON_DOWN == aStatus)
            {
                loaderButtonUp.visible = false;
                loaderButtonOver.visible = false;
                loaderButtonDown.visible = true;
            }
        }
        
        private function setupTextFields():void
        {
            // Set the text format object
            format = new TextFormat();
            format.font = "Helvetica"; 
            format.size = 32;
            format.color = 0xFF0000;
            format.align = TextFormatAlign.LEFT;
            
            // Configure the output text field
            output = new TextField();
            output.defaultTextFormat = format;
            output.width = 400;
            output.height = 70;
            output.border = true;
            output.wordWrap = true;
            output.text = "This it the output text field!";
            
            // Display and position the output text field.
            stage.addChild(output);
            output.x = 70;
            output.y = 65;
            
            // Configure the input text field.
            input = new TextField();
            format.size = 60;
            input.defaultTextFormat = format;
            input.width = 80;
            input.height = 60;
            input.border = true;
            input.type = "input";
            input.maxChars = 2;
            input.restrict = "0-9";
            input.background = true;
            input.backgroundColor = 0xCCCCCC;
            input.text = "";
            
            // Display and position the input text field.
            stage.addChild(input);
            input.x = 70;
            input.y = 150;
            stage.focus = input;
        }
        
        private function startGame():void
        {
            msg = "I am thinking about a number between 0 to 99!";
            mysteryNumber = Math.floor(Math.random() * 100); // Use Math.floor to get 0 - 99
            
            output.text = msg;
            input.text = "";
            
            guessesRemaining = 10;
            guessesMade = 0;
            gameStatus = "";
            gameWon = false;
            
            enableGame(true);
            
            trace(mysteryNumber);
        }
        
        private function keyPressHandler(_event:KeyboardEvent):void
        {
            if (Keyboard.ENTER == _event.keyCode)
            {
                playGame();
            }
        }
        
        private function playGame():void
        {
            guessesRemaining --;
            guessesMade ++;
            gameStatus = "Guess: " + guessesMade + ", Remaining: " + guessesRemaining;
            currentGuess = uint(input.text);
            
            if (currentGuess > mysteryNumber)
            {
                msg = "That's too high!\n" + gameStatus; 
                
                checkGameOver();
            }
            else if(currentGuess < mysteryNumber)
            {
                msg = "That's too low!\n" + gameStatus;
                
                checkGameOver();
            }
            else
            {
                gameWon = true;
                
                endGame();
            }
            
            output.text = msg;
        }
        
        private function checkGameOver():void
        {
            if (guessesRemaining < 1)
            {
                endGame();
            }
        }
        
        private function endGame():void
        {
            if (gameWon)
            {
                msg = "Yes, it's " + mysteryNumber + "!\n" + "It only took you " + guessesMade + " guess(es).";
            }
            else
            {
                msg = "No more guesses left!\nThe number was: " + mysteryNumber + ".";
            }
            
            enableGame(false);
        }
        
        private function enableGame(aEnable:Boolean):void
        {
            if (aEnable)
            {
                input.addEventListener(KeyboardEvent.KEY_DOWN, keyPressHandler);
                input.type = "input";
                input.alpha = 1;
                
                _spriteButton.addEventListener(MouseEvent.ROLL_OVER, buttonRollOverHandler);
                _spriteButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownHandler);
                _spriteButton.addEventListener(MouseEvent.ROLL_OUT, buttonRollOutHandler);
                _spriteButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
                _spriteButton.alpha = 1;
                _spriteButton.mouseEnabled = true;
            }
            else 
            {
                input.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressHandler);
                input.type = "dynamic";
                input.alpha = 0.5;
                
                _spriteButton.removeEventListener(MouseEvent.ROLL_OVER, buttonRollOverHandler);
                _spriteButton.removeEventListener(MouseEvent.MOUSE_DOWN, buttonDownHandler);
                _spriteButton.removeEventListener(MouseEvent.ROLL_OUT, buttonRollOutHandler);
                _spriteButton.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
                _spriteButton.alpha = 0.5;
                _spriteButton.mouseEnabled = false;
            }
        }
        
    }
}