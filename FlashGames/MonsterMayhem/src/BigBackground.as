package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class BigBackground extends Sprite
    {
        //Embed the gameObject image
        [Embed(source="../images/bigBackground.png")]
        private var BigBackgroundImage:Class;
        private var _bigBackgroundImage:DisplayObject = new BigBackgroundImage();
        private var _bigBackground:Sprite = new Sprite();
        
        public function BigBackground()
        {
            _bigBackground.addChild(_bigBackgroundImage);
            this.addChild(_bigBackground);
        }
    }
}