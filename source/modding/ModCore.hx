package modding;

import polymod.Polymod;

class ModCore
{
    public function new()
    {
        // super();
    }

    public static function pathFolders(modRoot:String, dirs:Array<String>)
    {
        trace("root folder: " + modRoot, "\nlist folder: " + dirs);
        Polymod.init({
            modRoot: modRoot,
            dirs: dirs
        });
    }
}