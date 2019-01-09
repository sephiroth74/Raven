package com.aviary.utils
{	
	import com.aviary.raven.io.ServerFile;
	
	import it.sephiroth.gettext._;
	
	public class RookeryUtils
	{
		
		public static const EGG_FILE_WIDTH:String  = "vfs:width";
		public static const EGG_FILE_HEIGHT:String = "vfs:height";
		public static const EGG_FILE_TITLE:String  = "title";
		public static const EGG_FILE_GUID:String   = "fileguid";
		public static const EGG_FILE_VERSION_GUID:String   = "fileversionguid";
		public static const EGG_BMP_WIDTH:String   = "bmp:width";
		public static const EGG_BMP_HEIGHT:String  = "bmp:height";
		public static const EGG_TEXT_VALUE:String  = "text:text";
		public static const EGG_TEXT_FORMAT:String = "text:format";
		public static const EGG_NODE_MATRIX:String = "item:matrix";
		
		/**
		 * Given a xml response like the one below return the file at the 
		 * specified index, throw an error if no valid file is present into the
		 * <files> tag
		 * 
		 * <?xml version="1.0" encoding="UTF-8"?>
		 * <response>
		 * 	<files>
		 * 	<file id="350609">
		 * 		<fileid>350609</fileid>
		 * 		<name>284541843_b77b917989[1].jpg</name>
		 * 		<fileguid>2875ba16-acce-102a-973d-0030488e168c</fileguid>
		 * 		<fileversionid>348533</fileversionid>
		 * 		<fileversionguid>287679d8-acce-102a-973d-0030488e168c</fileversionguid>
		 * 		<tutorialguid></tutorialguid>
		 * 		<createdon>9/5/2007 3:03:12 AM</createdon>
		 * 		<url>http://rookery1.plime.com/storage/348500/348533_7e6e.jpg</url>
		 * 		<extension>jpg</extension>
		 * 		<filehash>7e6e</filehash>
		 * 		<thumbnailhash>405b</thumbnailhash>
		 * 		<size>143430</size>
		 * 		<tags><![CDATA[]]></tags>
		 * 	</file>
		 * 	</files>
		 * 	<failedfiles>
		 * 	</failedfiles>
		 * </response>
		 * 
		 */
		public static function GetFileAt(result:XML, index:uint): ServerFile
		{
			if(result.files.file.length())
			{
				var xmlDocument:XML  = result.files.file[index];
				return ServerFile.fromXML(xmlDocument);
			} else {
				throw new Error( _("Invalid Files"));
			}
		}
		
		/**
		 * Parse a result xml given after importing a remote file
		 * 
		 * example:
		 * <result>
		 *   <error code="0">
		 *     <message><![CDATA[]]></message>
		 *   </error>
		 *   <data>
		 *     <metadata>
		 *       <originalurl><![CDATA[http://farm2.static.flickr.com/1113/1325105786_373c642bfc.jpg?v=0]]></originalurl>
		 *     </metadata>
		 *     <filename><![CDATA[http://rookery.plime.com/storage/workspace/_206d855e-b4cc-4e86-9335-9de676c1e547.jpg]]></filename>
		 *   </data>
		 * </result>		
		 * 
		 */
		public static function GetImportedFile(result:XML):ServerFile
		{
			if(result.error.@code == 0)
			{
				var sf:ServerFile = new ServerFile();
				sf.url  = result.data.filename.text();
				sf.originalURL = result.data.metadata.originalurl.text();
				return sf;
			} else {
				throw new Error(result.error.message.text());
			}
			throw new Error(_("Invalid File"));
		}
	}
}