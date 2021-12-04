package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '2.0'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['freeplay','options', 'plush', 'credits'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	//var fool:FlxSprite;
	//var vush:FlxSprite;
	var plush:FlxSprite;

	public var scoreText:FlxText;
	public var scoreBG:FlxSprite;
	public var type = false;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		//var tex2 = Paths.getSparrowAtlas('newMenu/foolhardy_menu_text', 'preload');
		//var tex3 = Paths.getSparrowAtlas('newMenu/bushvvhack', 'preload');
		var tex2 = Paths.getSparrowAtlas('newMenu/menu_credits');
		var tex4 = Paths.getSparrowAtlas('newMenu/plushie');

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			if (i == 0)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if(optionShit.length < 6) scr = 0;
				menuItem.scrollFactor.set(0, scr);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
				menuItem.updateHitbox();
			}
			if (i == 1)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if(optionShit.length < 6) scr = 0;
				menuItem.scrollFactor.set(0, scr);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
				menuItem.updateHitbox();
			}
			if (i == 2)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var plushie:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
				plushie.frames = tex4;
				plushie.animation.addByPrefix('idle', "plushieSmall", 24);
				plushie.animation.addByPrefix('selected', "plushieBig", 24);
				plushie.ID = i;
				plushie.animation.play('idle');
				plushie.screenCenter(X);
				menuItems.add(plushie);
				plushie.scrollFactor.set();
			}
			if (i == 3)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var credits:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
				credits.frames = tex2;
				credits.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				credits.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				credits.ID = i;
				credits.animation.play('idle');
				credits.screenCenter(X);
				menuItems.add(credits);
				credits.scrollFactor.set();
			}
			/*var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			*/
		}

	/*	fool = new FlxSprite(0, FlxG.height * 1.6);
		fool.frames = tex2;
		fool.animation.addByPrefix('idle', "foolhardy basic", 24);
		fool.animation.addByPrefix('selected', "foolhardy white", 24);
		fool.animation.play('idle');
		fool.ID = menuItems.length;
		fool.screenCenter(X);
		fool.x -= 100;
		fool.scrollFactor.set();
		fool.alpha = 0;
		

		vush = new FlxSprite(0, FlxG.height * 1.6);
		vush.frames = tex3;
		vush.animation.addByPrefix('idle', "BushwhackSmall", 24);
		vush.animation.addByPrefix('selected', "BushwhackBig", 24);
		vush.animation.play('idle');
		vush.ID = menuItems.length + 1;
		vush.screenCenter(X);
		vush.x += 125 ;
		vush.scrollFactor.set();
		vush.alpha = 0;
		
		
		add(vush);
		add(fool);
		*/

		scoreText = new FlxText(FlxG.width * 0.7, -15, 0, "", 32);
		//scoreText.autoSize = false;
		scoreText.alpha = 0;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		//scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 80, 0xFF000000);
		//scoreBG.alpha = 0.6;
		//add(scoreBG);

		add(scoreText);

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Zardy Port v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var lerpScore:Float = 0;
	var intendedScore:Float = 0;


	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		
		if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				if (type)
					{
						curSelected = 0;
						//goToState();
					}
					else
						FlxG.switchState(new TitleState());
				//selectedSomethin = true;
				//FlxG.sound.play(Paths.sound('cancelMenu'));
				//MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.ONE)
			{
				MusicBeatState.switchState(new FreeplayState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'plush')
					{
						CoolUtil.browserLoad("https://www.makeship.com/products/zardy-plush");
					}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								type = !type;

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
									/*	if (!type)
										{
											for(i in 0...menuItems.members.length)
												{
													var menu = menuItems.members[i];
													FlxTween.tween(menu,{y: FlxG.height * 1.6},1 + (i * 0.25) ,{ease: FlxEase.expoInOut});
												}
							
												FlxTween.tween(fool,{y: 60 },1  ,{ease: FlxEase.expoInOut});
												FlxTween.tween(vush,{y: 60 + 160},1 + 0.25 ,{ease: FlxEase.expoInOut});
												curSelected = menuItems.length;
												intendedScore = Highscore.getScore("Foolhardy", 1);
												FlxTween.tween(scoreBG,{y: 0},1,{ease: FlxEase.expoInOut});
												FlxTween.tween(scoreText,{y: 5},1,{ease: FlxEase.expoInOut});
							
												trace(curSelected);
										}
										else
										{
											for(i in 0...menuItems.members.length)
												{
													var menu = menuItems.members[i];
													FlxTween.tween(menu,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut});
												}
							
												FlxTween.tween(fool,{y: FlxG.height * 1.6 },1  ,{ease: FlxEase.expoInOut});
												FlxTween.tween(vush,{y: FlxG.height * 1.6},1 + 0.25 ,{ease: FlxEase.expoInOut});
												FlxTween.tween(scoreBG,{y: -200},1,{ease: FlxEase.expoInOut});
												FlxTween.tween(scoreText,{y: -200},1,{ease: FlxEase.expoInOut});
												curSelected = 0;
										}
										if (fool.ID == curSelected)
											{
												fool.animation.play('selected');
												camFollow.setPosition(fool.getGraphicMidpoint().x, fool.getGraphicMidpoint().y);
									
												fool.updateHitbox();
											}
							
											if (vush.ID == curSelected)
											{
												vush.animation.play('selected');
												camFollow.setPosition(vush.getGraphicMidpoint().x, vush.getGraphicMidpoint().y);
									
												vush.updateHitbox();
											}
										*/
										MusicBeatState.switchState(new FreeplayState());
									//case 'awards':
										//MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new OptionsState());
									case "foolhardy" | "bushwhack":
											trace("loading " + daChoice);
											var poop:String = Highscore.formatSong(daChoice, 1);
							
											PlayState.SONG = Song.loadFromJson(poop, daChoice);
											PlayState.isStoryMode = true;
											PlayState.storyDifficulty = 1;
							
											PlayState.storyWeek = 0;
											//PlayState.loadRep = false;
											LoadingState.loadAndSwitchState(new PlayState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		if (!type)
			{
				curSelected += huh;

				if (curSelected > menuItems.length - 1)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
			}
			else
			{
				curSelected += huh;

				if (curSelected > menuItems.length + 1)
					curSelected = menuItems.length;
				if (curSelected < menuItems.length)
					curSelected = menuItems.length + 1;
				trace(curSelected);
			}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}
