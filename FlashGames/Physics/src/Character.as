package
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class Character extends Sprite
    {
        [Embed(source="../images/character.png")]
        private var CharacterImage:Class;
        private var _character:DisplayObject = new CharacterImage();
        
        // Public properties
        public var accelerationX:Number = 0;
        public var accelerationY:Number = 0;
        public var vx:Number = 0;
        public var vy:Number = 0;
        
        private var _speedLimitUp:Number = 6;
        private var _speedLimitDown:Number = 0.1;   // To reduce the character slide time when stopping
        private var _friction:Number = 0.98; // The firction need to cooperate with the acceleration and speedLimit ( A / S >= 1 - F )
        private var _bounce:Number = -0.7;
        private var _gravity:Number = 0.3;
        private var _isOnGround:Boolean = undefined;
        private var _jumpForce:Number = -10;
        
        private var _soundEffects:SoundEffects = null;
        
        public function Character()
        {
            this.addChild(_character);
            
            _soundEffects = new SoundEffects();
        }
        
        public function move():void
        {
            vx += accelerationX;
            vy += accelerationY + _gravity;
            
            vx *= _friction;
            vy *= _friction;
            
            if (vx >= _speedLimitUp)
            {
                vx = _speedLimitUp;
            }
            else if (vx <= - _speedLimitUp)
            {
                vx = - _speedLimitUp;
            }
            
            if (vx <= _speedLimitDown && vx >= _speedLimitDown) 
            {
                vx = 0;
            }
                
            
            this.x += vx;
            this.y += vy;
        }
        
        public function bounceWithDirection(aDirection:String):void
        {
            if ("left" == aDirection || "right" == aDirection)
            {
                vx *= _bounce;
            }
            else if ("top" == aDirection || "bottom" == aDirection)
            {
                vy *= _bounce;
            }
        }
        
        public function jump():void
        {
            vy = _jumpForce;
            
            _soundEffects.bounce();
        }
    }
}