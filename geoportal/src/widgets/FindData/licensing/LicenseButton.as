package widgets.FindData.licensing
{
	import mx.controls.LinkButton;
	
	public class LicenseButton extends LinkButton
	{
		private var _license:Object;
		
		public function LicenseButton()
		{
			super();
			_license = null;
		}
		
		public function get license():Object {
			return _license;
		}
		
		public function set license(license:Object):void {
			_license = license;
		}
		
	}
}