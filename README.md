# Witcher-2-Auto-Loot-Mod
Fork of QuietusPlus EMC-Minimal Mod for Witcher 2 with only auto-loot and weightless ingredients

This is my first time ever creating something like this. I use the word "creating" loosely. This is mostly copy/pasted from QueitusPlus (https://github.com/QuietusPlus) and their work with Enhanced Mod Compilation. If this works, it's to their credit. If it doesn't, it's my fault.

This relies on two parts. The first is base_scripts.dzip. In this repo is the extracted set of scripts from base_scripts.dzip using Gibbed RED tools. The only thing that's modified is /game/gameplay/containerclass.ws. Everything else should be the same as the original version that comes with the game. If you want to combine this mod with other mods that change the base_scripts.dzip file, I recommending looking into Gibbed RED tools. It's technical, but not hard (https://forums.nexusmods.com/index.php?/topic/1100508-combining-mods/page-2).

The second part is an xml file that changes the weight of ingredients to zero. The auto-loot function is set to only pick up weightless items, so you don't get suddenly hit with the overencumbered status in the middle of a fight or something. I *think* this can be used as-is, just placed in /CookedPC/Items. We'll see!

Feel free to modify, just be sure to credit the original author, QuietusPlus (and me, too if you're feeling generous).
