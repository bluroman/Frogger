package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTileSpecial;
import flixel.addons.tile.FlxTilemapExt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import haxe.io.Path;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
#if shaders_supported
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
#end

/**
 * @author Samuel Batista
 */
class TiledLevel1 extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var objectsLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;

	private var collidableTileLayers:Array<FlxTilemap>;

	// Sprites of images layers
	public var imagesLayer:FlxGroup;

	var bonusFrog:Bool = false;

	public function new(tiledLevel:Dynamic, state:PlayState)
	{
		// var filters:Array<BitmapFilter> = [];
		super(tiledLevel);

		imagesLayer = new FlxGroup();
		foregroundTiles = new FlxGroup();
		objectsLayer = new FlxGroup();
		backgroundLayer = new FlxGroup();

		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		trace("Full Width:" + fullWidth + " Full Height:" + fullHeight);
		var grayscaleMatrix:Array<Float> = [
			0.5, 0.5, 0.5, 0, 0,
			0.5, 0.5, 0.5, 0, 0,
			0.5, 0.5, 0.5, 0, 0,
			  0,   0,   0, 1, 0,
		];
		var tritanopiaMatrix:Array<Float> = [
			0.97, 0.11, -.08, 0, 0,
			0.02, 0.82, 0.16, 0, 0,
			0.06, 0.88, 0.18, 0, 0,
			   0,    0,    0, 1, 0,
		];
		var invertMatrix:Array<Float> = [
			-1,  0,  0, 0, 255,
			 0, -1,  0, 0, 255,
			 0,  0, -1, 0, 255,
			 0,  0,  0, 1,   0,
		];
		var protanopiaMatrix:Array<Float> = [
			0.20, 0.99, -.19, 0, 0,
			0.16, 0.79, 0.04, 0, 0,
			0.01, -.01,    1, 0, 0,
			   0,    0,    0, 1, 0,
		];
		var deuteranopiaMatrix:Array<Float> = [
			0.43, 0.72, -.15, 0, 0,
			0.34, 0.57, 0.09, 0, 0,
			-.02, 0.03,    1, 0, 0,
			   0,    0,    0, 1, 0,
		];
		// var colorFilter = new ColorMatrixFilter(FlxG.random.getObject([grayscaleMatrix, tritanopiaMatrix,protanopiaMatrix,deuteranopiaMatrix]));
		// var scanlineFilter = new ShaderFilter(new Scanline());
		// FlxG.camera.setFilters([colorFilter, scanlineFilter]);

		loadImages();
		loadObjects(state);

		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE)
				continue;
			var tileLayer:TiledTileLayer = cast layer;

			var tileSheetName:String = tileLayer.properties.get("tileset");

			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}

			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";

			var imagePath = new Path(tileSet.imageSource);
			var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tileSize = FlxPoint.get(tileWidth, tileHeight);
			var tileFrames:FlxTileFrames = FlxTileFrames.fromBitmapAddSpacesAndBorders(processedPath, tileSize, FlxPoint.get(0, 0), FlxPoint.get(2, 2));
			// var tileFrames:FlxTileFrames = FlxTileFrames.fromRectangle(processedPath, tileSize);
			tileSize.put();

			// could be a regular FlxTilemap if there are no animated tiles
			var tilemap = new FlxTilemapExt();
			// tilemap.loadMapFromArray(tileLayer.tileArray, width, height, tileFrames, 16, 16, 1);
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, tileFrames, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
			// tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
			//	tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

			if (tileLayer.properties.contains("animated"))
			{
				var tileset = tilesets["frogger_atlas_01"];
				var specialTiles:Map<Int, TiledTilePropertySet> = new Map();
				for (tileProp in tileset.tileProps)
				{
					if (tileProp != null && tileProp.animationFrames.length > 0)
					{
						specialTiles[tileProp.tileID + tileset.firstGID] = tileProp;
					}
				}
				var tileLayer:TiledTileLayer = cast layer;
				tilemap.setSpecialTiles([
					for (tile in tileLayer.tiles)
						if (tile != null && specialTiles.exists(tile.tileID)) getAnimatedTile(specialTiles[tile.tileID], tileset) else null
				]);
			}

			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundLayer.add(tilemap);
			}
			else
			{
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();

				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
			}
		}
	}

	private function getAnimatedTile(props:TiledTilePropertySet, tileset:TiledTileSet):FlxTileSpecial
	{
		var special = new FlxTileSpecial(1, false, false, 0);
		var n:Int = props.animationFrames.length;
		var offset = Std.random(n);
		special.addAnimation([
			for (i in 0...n)
				props.animationFrames[(i + offset) % n].tileID + tileset.firstGID
		], (1000 / props.animationFrames[0].duration));
		return special;
	}

	public function loadObjects(state:PlayState)
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			// collection of images layer
			if (layer.name == "images")
			{
				for (o in objectLayer.objects)
				{
					loadImageObject(o);
				}
			}

			// objects layer
			if (layer.name == "objects")
			{
				for (o in objectLayer.objects)
				{
					loadObject(state, o, objectLayer, objectsLayer);
				}
			}
		}
	}

	private function loadImageObject(object:TiledObject)
	{
		var tilesImageCollection:TiledTileSet = this.getTileSet("imageCollection");
		var tileImagesSource:TiledImageTile = tilesImageCollection.getImageSourceByGid(object.gid);

		// decorative sprites
		var levelsDir:String = "assets/tiled/";

		var decoSprite:FlxSprite = new FlxSprite(0, 0, levelsDir + tileImagesSource.source);
		if (decoSprite.width != object.width || decoSprite.height != object.height)
		{
			decoSprite.antialiasing = true;
			decoSprite.setGraphicSize(object.width, object.height);
		}
		if (object.flippedHorizontally)
		{
			decoSprite.flipX = true;
		}
		if (object.flippedVertically)
		{
			decoSprite.flipY = true;
		}
		decoSprite.setPosition(object.x, object.y - decoSprite.height);
		decoSprite.origin.set(0, decoSprite.height);
		if (object.angle != 0)
		{
			decoSprite.angle = object.angle;
			decoSprite.antialiasing = true;
		}

		// Custom Properties
		if (object.properties.contains("depth"))
		{
			var depth = Std.parseFloat(object.properties.get("depth"));
			decoSprite.scrollFactor.set(depth, depth);
		}

		backgroundLayer.add(decoSprite);
	}

	private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer, group:FlxGroup)
	{
		var x:Int = o.x;
		var y:Int = o.y;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		switch (o.name.toLowerCase())
		{
			case "start":
				var frog = new Frog(x, y);
				state.player = frog;
				FlxG.camera.follow(frog);
				group.add(frog);
			case "car":
				trace("Car Position x: " + x + "y: " + y + "type: " + o.type + "direction: " + o.properties.get("direction"));
				var car = new Car1(x, y, Std.parseInt(o.type), Std.parseInt(o.properties.get("direction")), 1);
				// group.add(car);
				state.carGroupNew.add(car);
			case "truck":
				// var sprite = new FlxSprite(x, y);
				// sprite.makeGraphic(40, 40, FlxColor.RED);
				// sprite.screenCenter();
				var truck = new Truck(x, y, Std.parseInt(o.properties.get("direction")), 1, null);
				state.carGroupNew.add(truck);
			// state.carGroupNew.add(sprite);

			case "stone":
				var stone = new SafeStone(x, y, Std.parseInt(o.properties.get("hideTimer")), Std.parseInt(o.properties.get("startTime")), 0x01, 0);
				state.safeStoneGroup.add(stone);
			case "turtle":
				if (o.type == "A")
				{
					var turtleA = new TurtlesA(x, y, Std.parseInt(o.properties.get("hideTimer")), Std.parseInt(o.properties.get("startTime")),
						Std.parseInt(o.properties.get("direction")), 1);
					state.turtleGroupNew.add(turtleA);
				}
				else if (o.type == "B")
				{
					var turtleB = new TurtlesB(x, y, Std.parseInt(o.properties.get("hideTimer")), Std.parseInt(o.properties.get("startTime")),
						Std.parseInt(o.properties.get("direction")), 1);
					state.turtleGroupNew.add(turtleB);
				}
				else
				{
					trace("something wrong with turtles");
				}
			case "log":
				var rand2:Bool = FlxG.random.bool(20);
				if (o.type == "0")
				{
					if (rand2 && !bonusFrog)
					{
						var blueFroggy = new BlueFrog(x, y, 0xffffff);
						var logMoving = new Log(x, y, 0, Std.parseInt(o.properties.get("direction")), 1, blueFroggy);
						state.logGroupNew.add(logMoving);
						state.blueFrog = blueFroggy;
						// state.logGroupNew.add(blueFroggy);
						bonusFrog = true;
					}
					else
					{
						var logMoving = new Log(x, y, 0, Std.parseInt(o.properties.get("direction")), 1, null);
						state.logGroupNew.add(logMoving);
					}
				}
				else if (o.type == "1")
				{
					if (rand2 && !bonusFrog)
					{
						var blueFroggy = new BlueFrog(x, y, 0xffffff);
						var logMoving = new Log(x, y, 1, Std.parseInt(o.properties.get("direction")), 1, blueFroggy);
						state.logGroupNew.add(logMoving);
						state.blueFrog = blueFroggy;
						// state.logGroupNew.add(blueFroggy);
						bonusFrog = true;
					}
					else
					{
						var logMoving = new Log(x, y, 1, Std.parseInt(o.properties.get("direction")), 1, null);
						state.logGroupNew.add(logMoving);
					}
				}
				else if (o.type == "2")
				{
					if (rand2 && !bonusFrog)
					{
						var blueFroggy = new BlueFrog(x, y, 0xffffff);
						var logMoving = new Log(x, y, 2, Std.parseInt(o.properties.get("direction")), 1, blueFroggy);
						state.logGroupNew.add(logMoving);
						state.blueFrog = blueFroggy;
						// state.logGroupNew.add(blueFroggy);
						bonusFrog = true;
					}
					else
					{
						var logMoving = new Log(x, y, 2, Std.parseInt(o.properties.get("direction")), 1, null);
						state.logGroupNew.add(logMoving);
					}
				}
				else
				{
					trace("Wrong Log Wrapping sprite type");
				}
			// var logMoving = new LogMoving(x, y, Std.parseInt(o.type), Std.parseInt(o.properties.get("direction")), 1);
			// state.logGroupNew.add(logMoving);
			case "alligator":
				var alligator = new Alligator(x, y, Std.parseInt(o.properties.get("direction")), 1);
				state.alligatorGroup.add(alligator);
			case "snake":
				var snake = new Snake(x, y, Std.parseInt(o.properties.get("direction")), 1);
				state.snake = snake;
			case "home":
				var home = new Home(x, y, Std.parseInt(o.properties.get("hideTimer")), Std.parseInt(o.properties.get("startTime")), 10);
				state.homeGroup.add(home);
			case "water":
				var water = new FlxObject(x, y, o.width, o.height);
				state.water = water;
				state.water.ID = 0;
			case "swamp":
				var swamp = new FlxObject(x, y, o.width, o.height);
				state.swamp = swamp;
				state.swamp.ID = 1;
			case "lava":
				var lava = new FlxObject(x, y, o.width, o.height);
				state.lava = lava;
				state.lava.ID = 2;
			case "road":
				var road = new FlxObject(x, y, o.width, o.height);
				state.road = road;
		}

		/*switch (o.type.toLowerCase())
			{
				case "player_start":
					var frog = new Frog(x, y);
					state.player = frog;
					FlxG.camera.follow(frog);
					group.add(frog);
					trace("Frog Position x: " + x +" y: " + y);
			//				var player = new FlxSprite(x, y);
			//				player.makeGraphic(32, 32, 0xffaa1111);
			//				player.maxVelocity.x = 160;
			//				player.maxVelocity.y = 400;
			//				//player.acceleration.y = 50;
			//				player.drag.x = player.maxVelocity.x * 4;
			//				FlxG.camera.follow(player);
			//				state.player = player;
			//				group.add(player);
					
				case "floor":
					var floor = new FlxObject(x, y, o.width, o.height);
					//state.floor = floor;
					
				case "coin":
					var tileset = g.map.getGidOwner(o.gid);
					var coin = new FlxSprite(x, y, c_PATH_LEVEL_TILESHEETS + tileset.imageSource);
					//state.coins.add(coin);
					
				case "exit":
					// Create the level exit
					var exit = new FlxSprite(x, y);
					exit.makeGraphic(32, 32, 0xff3f3f3f);
					exit.exists = false;
					//state.exit = exit;
					group.add(exit);
		}*/
	}

	public function loadImages()
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.IMAGE)
				continue;

			var image:TiledImageLayer = cast layer;
			var sprite = new FlxSprite(image.x, image.y, c_PATH_LEVEL_TILESHEETS + image.imagePath);
			imagesLayer.add(sprite);
		}
	}

	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers == null)
			return false;

		for (map in collidableTileLayers)
		{
			// IMPORTANT: Always collide the map with objects, not the other way around.
			//            This prevents odd collision errors (collision separation code off by 1 px).
			if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate))
			{
				return true;
			}
		}
		return false;
	}
}
