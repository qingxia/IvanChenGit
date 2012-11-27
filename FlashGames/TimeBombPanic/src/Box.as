package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class Box extends Sprite
    {
        [Embed(source="../images/box.png")] 
        public var GameObjectImage:Class;
        public var gameObjectImage:DisplayObject = new GameObjectImage();
        
        public function Box()
        {
            this.addChild(gameObjectImage);
        }
    }
}