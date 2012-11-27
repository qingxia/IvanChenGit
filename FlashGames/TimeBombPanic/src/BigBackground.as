package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class BigBackground extends Sprite
    {
        [Embed(source="../images/bigBackground.png")] 
        public var GameObjectImage:Class;
        public var gameObjectImage:DisplayObject = new GameObjectImage();
        
        public function BigBackground()
        {
            this.addChild(gameObjectImage);
        }
    }
}