package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class TimeDisplay extends Sprite
    {
        [Embed(source="../images/timeDisplay.png")] 
        public var GameObjectImage:Class;
        public var gameObjectImage:DisplayObject = new GameObjectImage();
        
        public function TimeDisplay()
        {
            this.addChild(gameObjectImage);
        }
    }
}