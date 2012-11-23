package
{
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    
    import flashx.textLayout.formats.Float;
    
    [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]
    
    public class GameWorld extends Sprite
    {
        public const MAX_WIDTH:int = 550;
        public const MAX_HEIGHT:int = 400;
        public const CHARACTER_WIDTH:int = 100;
        public const CHARACTER_HEIGHT:int = 100;
        
        public const CHARACTER_STRIDE:int = 15;
        public const SCALE:Number = 0.1;
        public const ROTATION:int = 20;
        
        public var characterSprite:Sprite = null;
        
        public function GameWorld()
        {
            var bgSprite:Sprite = LoadSprite("../images/background.png");
            stage.addChild(bgSprite);
            
            // Load character without using LoadSprite, as we need to adjust the loader coordinate for it
            var characterURL:URLRequest = new URLRequest("../images/character.png");
            
            var characterLoader:Loader = new Loader();
            characterLoader.load(characterURL);
            characterLoader.x = - (CHARACTER_WIDTH / 2);
            characterLoader.y = - (CHARACTER_HEIGHT / 2);
            
            characterSprite = new Sprite();
            characterSprite.addChild(characterLoader);
            
            stage.addChild(characterSprite);
            characterSprite.x = MAX_WIDTH / 2;
            characterSprite.y = MAX_HEIGHT / 2;
            
            var upButtonSprite:Sprite = LoadSprite("../images/up.png");
            stage.addChild(upButtonSprite);
            upButtonSprite.x = 25;
            upButtonSprite.y = 25;
            upButtonSprite.addEventListener(MouseEvent.CLICK, upButtonHandler);
            
            var downButtonSprite:Sprite = LoadSprite("../images/down.png");
            stage.addChild(downButtonSprite);
            downButtonSprite.x = 25;
            downButtonSprite.y = 85;
            downButtonSprite.addEventListener(MouseEvent.CLICK, downButtonHandler);
            
            var growButtonSprite:Sprite = LoadSprite("../images/grow.png");
            stage.addChild(growButtonSprite);
            growButtonSprite.x = 25;
            growButtonSprite.y = 145;
            growButtonSprite.addEventListener(MouseEvent.CLICK, growButtonHandler);
            
            var shrinkButtonSprite:Sprite = LoadSprite("../images/shrink.png");
            stage.addChild(shrinkButtonSprite);
            shrinkButtonSprite.x = 25;
            shrinkButtonSprite.y = 205;
            shrinkButtonSprite.addEventListener(MouseEvent.CLICK, shrinkButtonHandler);
            
            var vanishButtonSprite:Sprite = LoadSprite("../images/vanish.png");
            stage.addChild(vanishButtonSprite);
            vanishButtonSprite.x = 25;
            vanishButtonSprite.y = 265;
            vanishButtonSprite.addEventListener(MouseEvent.CLICK, vanishButtonHandler);
            
            var spinButtonSprite:Sprite = LoadSprite("../images/spin.png");
            stage.addChild(spinButtonSprite);
            spinButtonSprite.x = 25;
            spinButtonSprite.y = 325;
            spinButtonSprite.addEventListener(MouseEvent.CLICK, spinButtonHandler);
        }
        
        private function upButtonHandler(_event:MouseEvent):void
        {
            characterSprite.x = characterSprite.x;
            characterSprite.y -= CHARACTER_STRIDE;
            
            if (characterSprite.y < 0)
                characterSprite.y = 0;
        }
        
        private function downButtonHandler(_event:MouseEvent):void
        {
            characterSprite.x = characterSprite.x;
            characterSprite.y += CHARACTER_STRIDE;
            
            if (characterSprite.y > (MAX_HEIGHT - CHARACTER_HEIGHT))
                characterSprite.y = MAX_HEIGHT - CHARACTER_HEIGHT;
        }
        
        private function growButtonHandler(_event:MouseEvent):void
        {
            characterSprite.scaleX += SCALE;
            characterSprite.scaleY += SCALE;
        }
        
        private function shrinkButtonHandler(_event:MouseEvent):void
        {
            characterSprite.scaleX -= SCALE;
            characterSprite.scaleY -= SCALE;
        }
        
        private function vanishButtonHandler(_event:MouseEvent):void
        {
            characterSprite.visible = !characterSprite.visible;  
        }
        
        private function spinButtonHandler(_event:MouseEvent):void
        {
            characterSprite.rotation += ROTATION;
        }
        
        private function LoadSprite(_url:String):Sprite
        {
            var url:URLRequest = new URLRequest(_url);
            
            var loader:Loader = new Loader();
            loader.load(url);
            
            var sprite:Sprite = new Sprite();
            sprite.addChild(loader);
            
            return sprite;
        }
    }
}