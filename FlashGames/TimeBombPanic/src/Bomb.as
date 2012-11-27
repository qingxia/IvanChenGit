package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class Bomb extends Sprite
    {
        [Embed(source="../images/bomb.png")] 
        public var GameObjectImage:Class;
        public var gameObjectImage:DisplayObject = new GameObjectImage();
        
        public function Bomb()
        {
            this.addChild(gameObjectImage);
        }
    }
}