package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class NearBackground extends Sprite
    {
        [Embed(source="../images/nearBackground.png")]
        private var NearBackgroundImage:Class;
        private var _farBackground:DisplayObject = new NearBackgroundImage();
        
        public function NearBackground()
        {
            this.addChild(_farBackground);
        }
    }
}