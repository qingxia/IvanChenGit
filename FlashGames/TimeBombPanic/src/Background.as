package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class Background extends Sprite
    {
        [Embed(source="../images/background.png")] 
        public var GameObjectImage:Class;
        public var gameObjectImage:DisplayObject = new GameObjectImage();
        
        public function Background()
        {
            this.addChild(gameObjectImage);
        }
    }
}