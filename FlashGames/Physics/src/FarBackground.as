package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class FarBackground extends Sprite
    {
        [Embed(source="../images/farBackground.png")]
        private var FarBackgroundImage:Class;
        private var _farBackground:DisplayObject = new FarBackgroundImage();
        
        public function FarBackground()
        {
            this.addChild(_farBackground);
        }
    }
}