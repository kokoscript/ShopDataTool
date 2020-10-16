import sys.FileSystem;
import sys.io.File;
import haxe.Exception;

typedef ShopItem = {
	itemName:String,
	itemID:String,
	itemCount:Int,
	emeraldValue:Int
}

class ShopDataTool {
	static var path:String;
	static var mode:Int = 0;
	static var shopItems:Array<ShopItem>;
	static var signCommandFromEmr:String = "/give @p minecraft:crimson_sign{BlockEntityTag: {Text1: \"{\\\"text\\\":\\\"EMRCOUNT Emerald\\\",\\\"italic\\\":true,\\\"color\\\":\\\"white\\\",\\\"clickEvent\\\":{\\\"action\\\":\\\"run_command\\\",\\\"value\\\":\\\"scoreboard players set @p SHOP SHOPNUM\\\"}}\", Text2: \"{\\\"text\\\":\\\"<-to->\\\",\\\"clickEvent\\\":{\\\"action\\\":\\\"run_command\\\",\\\"value\\\":\\\"/playsound ui.button.click master @a[r=10] ~ ~ ~ .4 1.7\\\"}}\", Text3:\"{\\\"text\\\":\\\"ITEMCOUNT ITEMNAME\\\",\\\"italic\\\":true,\\\"color\\\":\\\"white\\\"}\"}}";
	static var signCommandToEmr:String = "/give @p minecraft:crimson_sign{BlockEntityTag: {Text1: \"{\\\"text\\\":\\\"ITEMCOUNT ITEMNAME\\\",\\\"italic\\\":true,\\\"color\\\":\\\"white\\\",\\\"clickEvent\\\":{\\\"action\\\":\\\"run_command\\\",\\\"value\\\":\\\"scoreboard players set @p SHOP SHOPNUM\\\"}}\", Text2: \"{\\\"text\\\":\\\"<-to->\\\",\\\"clickEvent\\\":{\\\"action\\\":\\\"run_command\\\",\\\"value\\\":\\\"/playsound ui.button.click master @a[r=10] ~ ~ ~ .4 1.7\\\"}}\", Text3:\"{\\\"text\\\":\\\"EMRCOUNT Emerald\\\",\\\"italic\\\":true,\\\"color\\\":\\\"white\\\"}\"}}";
	static var cmdBlockRemEmr:String = "/execute as @a[scores={SHOP=SHOPNUM}] run clear @a[scores={SHOP=SHOPNUM}] emerald EMRCOUNT";
	static var cmdBlockGiveItem:String = "/execute as @a[scores={SHOP=SHOPNUM}] run give @a[scores={SHOP=SHOPNUM}] ITEMID ITEMCOUNT";
	static var cmdBlockRemItem:String = "/execute as @a[scores={SHOP=SHOPNUM}] run clear @a[scores={SHOP=SHOPNUM}] ITEMID ITEMCOUNT";
	static var cmdBlockGiveEmr:String = "/execute as @a[scores={SHOP=SHOPNUM}] run give @a[scores={SHOP=SHOPNUM}] emerald EMRCOUNT";
	
	public static function main():Void {
		Sys.println(Sys.args());
		if(Sys.args().length != 1){
			error("Invalid number of arguments");
		}
		path = Sys.args()[0];
		if(!FileSystem.exists(path)){
			error("Input file does not exist");
		}
		
		var data:Array<String> = File.getContent(path).split("\r\n");
		var tempRow:Array<String>;
		shopItems = new Array<ShopItem>();
		data.shift();
		
		for(i in 0...data.length - 1){
			tempRow = data[i].split("\t");
			shopItems.push({
				itemName: tempRow[0],
				itemID: tempRow[1],
				itemCount: Std.parseInt(tempRow[2]),
				emeraldValue: Std.parseInt(tempRow[3])
			});
		}
		
		var tempStr:String;
		var shopNum:Int = 0;
		
		for(item in shopItems){
			Sys.println("--- " + item.itemName.toUpperCase() + " ---");
			Sys.println("-- Signs --");
			shopNum++;
			tempStr = signCommandFromEmr;
			tempStr = StringTools.replace(tempStr, "EMRCOUNT", item.emeraldValue + "x");
			tempStr = StringTools.replace(tempStr, "SHOPNUM", ""+shopNum);
			tempStr = StringTools.replace(tempStr, "ITEMCOUNT", item.itemCount + "x");
			tempStr = StringTools.replace(tempStr, "ITEMNAME", ""+item.itemName);
			Sys.println(tempStr);
			shopNum++;
			tempStr = signCommandToEmr;
			tempStr = StringTools.replace(tempStr, "EMRCOUNT", item.emeraldValue + "x");
			tempStr = StringTools.replace(tempStr, "SHOPNUM", ""+shopNum);
			tempStr = StringTools.replace(tempStr, "ITEMCOUNT", item.itemCount + "x");
			tempStr = StringTools.replace(tempStr, "ITEMNAME", ""+item.itemName);
			Sys.println(tempStr);
			Sys.println("-- CommandBlocks --");
			shopNum--;
			tempStr = cmdBlockRemEmr;
			tempStr = StringTools.replace(tempStr, "SHOPNUM", ""+shopNum);
			tempStr = StringTools.replace(tempStr, "EMRCOUNT", ""+item.emeraldValue);
			Sys.println(tempStr);
			tempStr = cmdBlockGiveItem;
			tempStr = StringTools.replace(tempStr, "SHOPNUM", ""+shopNum);
			tempStr = StringTools.replace(tempStr, "ITEMID", item.itemID);
			tempStr = StringTools.replace(tempStr, "ITEMCOUNT", ""+item.itemCount);
			Sys.println(tempStr);
			shopNum++;
			tempStr = cmdBlockRemItem;
			tempStr = StringTools.replace(tempStr, "SHOPNUM", ""+shopNum);
			tempStr = StringTools.replace(tempStr, "ITEMID", item.itemID);
			tempStr = StringTools.replace(tempStr, "ITEMCOUNT", ""+item.itemCount);
			Sys.println(tempStr);
			tempStr = cmdBlockGiveEmr;
			tempStr = StringTools.replace(tempStr, "SHOPNUM", ""+shopNum);
			tempStr = StringTools.replace(tempStr, "EMRCOUNT", ""+item.emeraldValue);
			Sys.println(tempStr);
			Sys.println("");
		}
	}
	
	static function error(message:String){
		Sys.stderr().writeString(message + "\n");
		Sys.stderr().flush();
		Sys.stderr().close();
		Sys.exit(1);
	}
}
