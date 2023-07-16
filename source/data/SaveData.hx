package data;

import flixel.util.FlxSave;

class SaveData
{
	static var saveF:FlxSave = new FlxSave();

	// will create a new save path
	public static function createNewSave(saveName:String, ?path:String)
	{
		saveF.bind(saveName, path);
	}

	// will load a specific save system
	public static function load(saveName:String)
	{
		return saveF.data.options.contains(saveName);
	}

	// will save a specific save system
	public static function save(saveName:String)
	{
		return saveF.data.options.push(saveName);
	}

	// will remove a specific save system
	public static function remove(saveName:String)
	{
		return saveF.data.options.remove(saveName);
	}

	// will flush a save system
	public static function flush()
	{
		return saveF.flush();
	}
}