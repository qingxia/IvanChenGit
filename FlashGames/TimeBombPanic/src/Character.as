package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class Character extends Sprite
    {
        [Embed(source="../images/character.png")] 
        public var GameObjectImage:Class;
        public var gameObjectImage:DisplayObject = new GameObjectImage();
        
        public function Character()
        {
            this.addChild(gameObjectImage);
        }
    }
}