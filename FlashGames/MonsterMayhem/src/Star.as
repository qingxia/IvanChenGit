package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Star extends Sprite
	{
		//Embed the gameObject image
		[Embed(source="../images/star.png")]
		private var StarImage:Class;
		
		//Private properties
		private var _starImage:DisplayObject = new StarImage();
		private var _star:Sprite = new Sprite();
		
		//Public properties
		public var vx:int = 0;
		public var vy:int = -3; // Star has a constant volecity
		public var launched:Boolean = false;
        
        private const ROTATION_STAR:int = 5;
		
		public function Star()
		{
			_star.addChild(_starImage);
			
			//Center the star image in the sprite
			_starImage.x = -(_starImage.width / 2);
			_starImage.y = -(_starImage.height / 2);
			
			//Add the star game object to this class
			this.addChild(_star);	
		}
        
        public function move():void
        {
            this.x += vx;
            this.y += vy;
            
            this.rotation += ROTATION_STAR;
        }
        
        public function moveWithDirection(aDirection:String):void
        {
            if ("left" == aDirection)
            {
                this.vx = -3;
                this.vy = 0;
            }
            else if ("right" == aDirection)
            {
                this.vx = 3;
                this.vy = 0;
            }
            else if ("up" == aDirection)
            {
                this.vx = 0;
                this.vy = -3;
            }
            else if ("down" == aDirection)
            {
                this.vx = 0;
                this.vy = 3;
            }
            
            move();
        }
	}
}