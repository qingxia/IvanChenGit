package
{
    import flash.media.Sound;
    import flash.media.SoundChannel;
    
    public class SoundEffects extends Object
    {
        [Embed(source="../sounds/bounce.mp3")]
        private var Bounce:Class;
        private var _bounce:Sound = new Bounce();
        private var _bounceChannel:SoundChannel = new SoundChannel();
        
        public function SoundEffects()
        {
        }
        
        public function bounce():void
        {
            _bounceChannel = _bounce.play();
        }
    }
}