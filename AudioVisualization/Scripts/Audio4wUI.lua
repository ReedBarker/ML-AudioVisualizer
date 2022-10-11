do -- script Audio4wUI 
		-- get reference to the script
		local Audio4wUI = LUA.script;

	--variables
		local musicPlayer = SerializedField("Music Player source", AudioSource);
	
		local spectrum = {};
		local SAMPLE_SIZE = nil;
	
		local timelineLocationText = SerializedField("Timeline Location Text", TextMesh);
		local graphLocationText = SerializedField("Graph Location Text", TextMesh);
		local rangeText = SerializedField("Range Text", TextMesh);
		local sensitivityText = SerializedField("Sensitivity Text", TextMesh);
	
		local timelineButton1 = SerializedField("timelineButton1", GameObject);
		local timelineButton2 = SerializedField("timelineButton2", GameObject);
		local timelineButton3 = SerializedField("timelineButton3", GameObject);
		local timelineButton4 = SerializedField("timelineButton4", GameObject);
		local timelineButton5 = SerializedField("timelineButton5", GameObject);
		local timelineButton6 = SerializedField("timelineButton6", GameObject);
		local timelineButton7 = SerializedField("timelineButton7", GameObject);
		local timelineButton8 = SerializedField("timelineButton8", GameObject);
	
		local graphButton1 = SerializedField("graphButton1", GameObject);
		local graphButton2 = SerializedField("graphButton2", GameObject);
		local graphButton3 = SerializedField("graphButton3", GameObject);
		local graphButton4 = SerializedField("graphButton4", GameObject);
		local graphButton5 = SerializedField("graphButton5", GameObject);
		local graphButton6 = SerializedField("graphButton6", GameObject);
		local graphButton7 = SerializedField("graphButton7", GameObject);
		local graphButton8 = SerializedField("graphButton8", GameObject);

		local timelineObject = SerializedField("timelineObject", GameObject);
		local timelineSpawnLocation = SerializedField("timelineSpawnLocation", GameObject);

		local timelineLineIncrementor = 0;
		local timelineCubeDistance = 0.00763; -- 0.0087
	
		local x = {};
		local y = {};
		local timelineList = {};
	
		local songNumber = 1;
		local timelineLocation = 1;
		local graphLocation = 1;

		local timelength = 150; 

		local flag1 = false;
		local flag2 = false;
		local seconds1 = 0;
		local seconds2 = 0;
		local forwardBool = false;
		local reverseBool = false;

		local graphValue1 = 762.5;


	--zone
		--=========================================================================
		--determines if events will trigger
		--=========================================================================
		local function zone(location, range, sensitivity, index, array) --zone(graph location, +/- graph location, sensitivity, index, array containing bools (true: event will happen, false: event won't happen))
			local forIncrement = 0;
			local sum = 0;
			local average = 0;

			--creates the range based around the graph location
			local rangeMin = location - range;
			local rangeMax = location + range;
	
			--the minimum range value cannot go lower than 1
			if (rangeMin <= 1) then
				rangeMin = 1;
			end
	
			--averages the values within the range
			for i = rangeMin, rangeMax, 1 do
				sum = sum + spectrum[i];
				forIncrement = forIncrement + 1;
			end
			
			average = (sum / forIncrement) * 100;
			
			--if the average is above the sensitivity, then run through which event will be triggered for that graph location
			for o=1, 8 do
				if (average >= sensitivity and index == o) then --if the 
					if (flag) then 
						flag = false;
						Debug.Log("Event");
						if (array[1]) then
							LuaEvents.InvokeForAll("scale1Event");
						end
						if (array[2]) then
							LuaEvents.InvokeForAll("scale2Event");
						end
						if (array[3]) then
							LuaEvents.InvokeForAll("jump1Event");
						end
						if (array[4]) then
							LuaEvents.InvokeForAll("jump2Event");
						end
						if (array[5]) then
							LuaEvents.InvokeForAll("changeColor1Event");
						end
						if (array[6]) then
							LuaEvents.InvokeForAll("changeColor2Event");
						end
						if (array[7]) then
							LuaEvents.InvokeForAll("vanish1Event");
						end
						if (array[8]) then
							LuaEvents.InvokeForAll("vanish2Event");
						end
					end
				elseif (average < sensitivity and index == o) then
					flag = true;
				end
			end

			average = 0;
			sum = 0;
			forIncrement = 0;
		end
	
	
	--ranges
		--=========================================================================
		--looks at how long the song has been playing and what timeline location it will pull information from. 
		--The information being pulled is the graph location, range, and sensitivity. That information is then sent to zone(). 
		--If the timeline value is 9999, it will be excluded.
		--If the graph value is 9999, the graph location, range, and sensitivty will be excluded.
		--=========================================================================
		local function AudioRanges()

			for m=1,8 do
				for n=1,8 do
					if (x[songNumber][m][1][8] ~= 9999) then
						if (Mathf.Floor(musicPlayer.time) >= x[songNumber][m][1][8] and Mathf.Floor(musicPlayer.time) < x[songNumber][m+1][1][8]) then --if the song time falls between 0s and 30s for example
							if (x[songNumber][m][n][9] ~= 9999) then

								audioRangeInc = 1;
								for o=14, 25 do
									y[audioRangeInc]=(x[songNumber][m][n][o]);
									audioRangeInc = audioRangeInc + 1;
								end

								zone(x[songNumber][m][n][9], x[songNumber][m][n][10], x[songNumber][m][n][11], n, y);
							end
						end
					end
				end
			end
		end

	--Song Events
		--=========================================================================
		--updateTexts updates the text displayed on the console
		--SongXEvent is activated when a button that changes the song is pressed
		--the SongXEvent changes the values of the multidimensional array to allow access to all songs from the current song
		--Song1Event corresponds to song 1, and so on
		--=========================================================================
		function updateTexts(songNumber, timelineLocation, graphLocation)
			timelineLocationText.text = x[songNumber][timelineLocation][graphLocation][8];
			graphLocationText.text = x[songNumber][timelineLocation][graphLocation][9];
			rangeText.text = x[songNumber][timelineLocation][graphLocation][10];
			sensitivityText.text = x[songNumber][timelineLocation][graphLocation][11];

			timelineObject.transform.localScale = Vector3(remap(0, timelength, 0, 1.17, 1), 0.09575645, 0.062787);
			timelineCubeDistance = remap(0, timelength, 0, 1.145, 1); --1.3687

		end

		function Song1Event()
			songNumber = 1;
			timelineLocation = 1;
			graphLocation = 1;
			timelength = x[songNumber][timelineLocation][graphLocation][2];
	
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		function Song2Event()
			songNumber = 2;
			timelineLocation = 1;
			graphLocation = 1;
			timelength = x[songNumber][timelineLocation][graphLocation][2];
		
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		function Song3Event()
			songNumber = 3;
			timelineLocation = 1;
			graphLocation = 1;
			timelength = x[songNumber][timelineLocation][graphLocation][2];
	
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		function Song4Event()
			songNumber = 4;
			timelineLocation = 1;
			graphLocation = 1;
			timelength = x[songNumber][timelineLocation][graphLocation][2];
	
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		function Song5Event()
			songNumber = 5;
			timelineLocation = 1;
			graphLocation = 1;
			timelength = x[songNumber][timelineLocation][graphLocation][2];
	
			updateTexts(songNumber, timelineLocation, graphLocation);
		end

	--Timeline Buttons
		--=========================================================================
		--the following events are triggered when a button on the timeline is pressed
		--this change the dimension to the corresponding multidimensional array index
		--=========================================================================
		local function TLLocation1()
			timelineLocation = 1;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function TLLocation2()
			timelineLocation = 2;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function TLLocation3()
			timelineLocation = 3;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function TLLocation4()
			timelineLocation = 4;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end

		local function TLLocation5()
			timelineLocation = 5;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function TLLocation6()
			timelineLocation = 6;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function TLLocation7()
			timelineLocation = 7;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function TLLocation8()
			timelineLocation = 8;
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
	--Graph Buttons
		--=========================================================================
		--the following events are triggered when a button on the graph is pressed
		--this change the dimension to the corresponding multidimensional array index
		--=========================================================================
		local function GLocation1()
			graphLocation = 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function GLocation2()
			graphLocation = 2;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function GLocation3()
			graphLocation = 3;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function GLocation4()
			graphLocation = 4;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end

		local function GLocation5()
			graphLocation = 5;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function GLocation6()
			graphLocation = 6;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function GLocation7()
			graphLocation = 7;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function GLocation8()
			graphLocation = 8;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
	--TimelineLocation, Location, Range, and Sensitivity Buttons
		--=========================================================================
		--the following events are triggered when a plus or minus button is pressed
		--this will change the values of the multidimensional index array rather than changing the dimension like the song, timeline, and graph buttons
		--=========================================================================
	
		local function ZLIncrease()
			x[songNumber][timelineLocation][graphLocation][8] = x[songNumber][timelineLocation][graphLocation][8] + 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function ZLDecrease()
			x[songNumber][timelineLocation][graphLocation][8] = x[songNumber][timelineLocation][graphLocation][8] - 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function LocIncrease()
			x[songNumber][timelineLocation][graphLocation][9] = x[songNumber][timelineLocation][graphLocation][9] + 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function LocDecrease()
			x[songNumber][timelineLocation][graphLocation][9] = x[songNumber][timelineLocation][graphLocation][9] - 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function RanIncrease()
			x[songNumber][timelineLocation][graphLocation][10] = x[songNumber][timelineLocation][graphLocation][10] + 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function RanDecrease()
			x[songNumber][timelineLocation][graphLocation][10] = x[songNumber][timelineLocation][graphLocation][10] - 1;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function SenIncrease()
			x[songNumber][timelineLocation][graphLocation][11] = x[songNumber][timelineLocation][graphLocation][11] + 0.25;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
		local function SenDecrease()
			x[songNumber][timelineLocation][graphLocation][11] = x[songNumber][timelineLocation][graphLocation][11] - 0.25;
			updateTexts(songNumber, timelineLocation, graphLocation);
		end
	
	--Add location buttons
		--=========================================================================
		--the following events are triggered when a plus or minus button at the end of the timeline or graph is pressed
		--these will turn values from 9999 to a given value or a given value to 9999, thus making it not able to be used
		--=========================================================================

		local function AddTLLocation()
			---[[
				local addTLnum1 = 1;

				for p=1, 8 do
					if (x[songNumber][p][1][8] == 9999) then
						addTLnum1 = addTLnum1 - 1;
					end
					addTLnum1 = addTLnum1 + 1;
				end 
			--]]

			for q=1, 8 do
				x[songNumber][addTLnum1][q][5] = 1024;
				x[songNumber][addTLnum1][q][8] = 60;
			end

			---[[
				if (addTLnum1 == 2) then
					LuaEvents.InvokeForAll("TLLocation2");
				end
				if (addTLnum1 == 3) then
					LuaEvents.InvokeForAll("TLLocation3");
				end
				if (addTLnum1 == 4) then
					LuaEvents.InvokeForAll("TLLocation4");
				end
				if (addTLnum1 == 5) then
					LuaEvents.InvokeForAll("TLLocation5");
				end
				if (addTLnum1 == 6) then
					LuaEvents.InvokeForAll("TLLocation6");
				end
				if (addTLnum1 == 7) then
					LuaEvents.InvokeForAll("TLLocation7");
				end
				if (addTLnum1 == 8) then
					LuaEvents.InvokeForAll("TLLocation8");
				end
			--]]

			LuaEvents.InvokeForAll("AddGLocation");
		end

		local function SubTLLocation()
			local subTLnum1 = 1;

			for p=1, 8 do
				if (x[songNumber][p][1][8] == 9999) then
					subTLnum1 = subTLnum1 - 1;
				end
				subTLnum1 = subTLnum1 + 1;
			end 
			subTLnum1 = subTLnum1 - 1

			Debug.Log(subTLnum1);

			for q=1, 8 do
				x[songNumber][subTLnum1][q][5] = 9999;
				x[songNumber][subTLnum1][q][8] = 9999;
				x[songNumber][subTLnum1][q][9] = 9999;
				x[songNumber][subTLnum1][q][10] = 9999;
				x[songNumber][subTLnum1][q][11] = 9999;
			end

			---[[
				if (subTLnum1 == 2) then
					LuaEvents.InvokeForAll("TLLocation1");
				end
				if (subTLnum1 == 3) then
					LuaEvents.InvokeForAll("TLLocation2");
				end
				if (subTLnum1 == 4) then
					LuaEvents.InvokeForAll("TLLocation3");
				end
				if (subTLnum1 == 5) then
					LuaEvents.InvokeForAll("TLLocation4");
				end
				if (subTLnum1 == 6) then
					LuaEvents.InvokeForAll("TLLocation5");
				end
				if (subTLnum1 == 7) then
					LuaEvents.InvokeForAll("TLLocation6");
				end
				if (subTLnum1 == 8) then
					LuaEvents.InvokeForAll("TLLocation7");
				end
			--]]
				
		end

		local function AddGLocation()
			---[[
				local addGnum1 = 1;

				for q=1, 8 do
					if (x[songNumber][timelineLocation][q][9] == 9999) then
						addGnum1 = addGnum1 - 1;
					end
					addGnum1 = addGnum1 + 1;

				end 
			--]]

			x[songNumber][timelineLocation][addGnum1][9] = 15;
			x[songNumber][timelineLocation][addGnum1][10] = 0;
			x[songNumber][timelineLocation][addGnum1][11] = 1.1;

			---[[
				if (addGnum1 == 2) then
					LuaEvents.InvokeForAll("GLocation2");
				end
				if (addGnum1 == 3) then
					LuaEvents.InvokeForAll("GLocation3");
				end
				if (addGnum1 == 4) then
					LuaEvents.InvokeForAll("GLocation4");
				end
				if (addGnum1 == 5) then
					LuaEvents.InvokeForAll("GLocation5");
				end
				if (addGnum1 == 6) then
					LuaEvents.InvokeForAll("GLocation6");
				end
				if (addGnum1 == 7) then
					LuaEvents.InvokeForAll("GLocation7");
				end
				if (addGnum1 == 8) then
					LuaEvents.InvokeForAll("GLocation8");
				end
			--]]
		end

		local function SubGLocation()

			local subGnum1 = 1;

			for p=1, 8 do
				if (x[songNumber][timelineLocation][subGnum1][9] == 9999) then
					subGnum1 = subGnum1 - 1;
				end
				subGnum1 = subGnum1 + 1;
			end 
			subGnum1 = subGnum1 - 1

			Debug.Log(subGnum1);

			x[songNumber][timelineLocation][subGnum1][9] = 9999;
			x[songNumber][timelineLocation][subGnum1][10] = 9999;
			x[songNumber][timelineLocation][subGnum1][11] = 9999;

			---[[
				if (subGnum1 == 2) then
					LuaEvents.InvokeForAll("GLocation1");
				end
				if (subGnum1 == 3) then
					LuaEvents.InvokeForAll("GLocation2");
				end
				if (subGnum1 == 4) then
					LuaEvents.InvokeForAll("GLocation3");
				end
				if (subGnum1 == 5) then
					LuaEvents.InvokeForAll("GLocation4");
				end
				if (subGnum1 == 6) then
					LuaEvents.InvokeForAll("GLocation5");
				end
				if (subGnum1 == 7) then
					LuaEvents.InvokeForAll("GLocation6");
				end
				if (subGnum1 == 8) then
					LuaEvents.InvokeForAll("GLocation7");
				end
			--]]
		end

	--Forward and Reverse

		local function forwardEvent()
			forwardBool = true;
			Debug.Log("Forward");

		end

		local function reverseEvent()
			reverseBool = true;
			Debug.Log("Reverse");

		end
		
	--remap
		--=========================================================================
		--function used to map one range of values to another range
		--used to set the locations of the timeline buttons and graph buttons to the correct location above the timeline and graph
		--=========================================================================
		local function remap(from1, to1, from2, to2, value)
			return (value - from1) / (to1 - from1) * (to2 - from2) + from2 
		end


	
	--Graph zoom in/out
		--=========================================================================
		--scales the graph location to be relative to the buttons that zoom in on the graph
		--there are known bugs with this feature
		--=========================================================================
		local function IncreaseUI()
			if (x[songNumber][timelineLocation][graphLocation][5] < 8192) then
				x[songNumber][timelineLocation][graphLocation][5] = x[songNumber][timelineLocation][graphLocation][5] * 2;
				graphValue1 = graphValue1 * 2;
			end
		end
	
		local function DecreaseUI()
			if (x[songNumber][timelineLocation][graphLocation][5] > 512) then
				x[songNumber][timelineLocation][graphLocation][5] = x[songNumber][timelineLocation][graphLocation][5] / 2;
				graphValue1 = graphValue1 / 2;
			end
		end



	
	--start
		--=========================================================================
		--Start()
		--=========================================================================
		function Audio4wUI.Start()
		--Events
			LuaEvents.Add("Song1Event", Song1Event);
			LuaEvents.Add("Song2Event", Song2Event);
			LuaEvents.Add("Song3Event", Song3Event);
			LuaEvents.Add("Song4Event", Song4Event);
			LuaEvents.Add("Song5Event", Song5Event);
	
			LuaEvents.Add("TLLocation1", TLLocation1);
			LuaEvents.Add("TLLocation2", TLLocation2);
			LuaEvents.Add("TLLocation3", TLLocation3);
			LuaEvents.Add("TLLocation4", TLLocation4);
			LuaEvents.Add("TLLocation5", TLLocation5);
			LuaEvents.Add("TLLocation6", TLLocation6);
			LuaEvents.Add("TLLocation7", TLLocation7);
			LuaEvents.Add("TLLocation8", TLLocation8);
	
			LuaEvents.Add("GLocation1", GLocation1);
			LuaEvents.Add("GLocation2", GLocation2);
			LuaEvents.Add("GLocation3", GLocation3);
			LuaEvents.Add("GLocation4", GLocation4);
			LuaEvents.Add("GLocation5", GLocation5);
			LuaEvents.Add("GLocation6", GLocation6);
			LuaEvents.Add("GLocation7", GLocation7);
			LuaEvents.Add("GLocation8", GLocation8);
	
			LuaEvents.Add("ZLIncrease", ZLIncrease);
			LuaEvents.Add("ZLDecrease", ZLDecrease);
			LuaEvents.Add("LocIncrease", LocIncrease);
			LuaEvents.Add("LocDecrease", LocDecrease);
			LuaEvents.Add("RanIncrease", RanIncrease);
			LuaEvents.Add("RanDecrease", RanDecrease);
			LuaEvents.Add("SenIncrease", SenIncrease);
			LuaEvents.Add("SenDecrease", SenDecrease);

			LuaEvents.Add("AddTLLocation", AddTLLocation);
			LuaEvents.Add("SubTLLocation", SubTLLocation);
			LuaEvents.Add("AddGLocation", AddGLocation);
			LuaEvents.Add("SubGLocation", SubGLocation);
	
			LuaEvents.Add("IncreaseUI", IncreaseUI);
			LuaEvents.Add("DecreaseUI", DecreaseUI);

			LuaEvents.Add("forwardEvent", forwardEvent);
			LuaEvents.Add("reverseEvent", reverseEvent);
		
			SAMPLE_SIZE = 2048; --64 128 256 512 1024 2048 -- the larger the number, the higher the sensitivity of the graphLocations
	
		--enable the following to set the values to default, easier to edit and easier to start from scratch, values rather than them all being zero
				--Reccomended: use this to find the values that are 
			---[[
				for i=1,8 do --maximum number of songs #songs
					x[i] = {}
					for j=1,8 do --maximum number of timeline locations
						x[i][j] = {}
						for k=1,8 do --maximum number of graph locations
							x[i][j][k] = {}
	
						--notes
							--i is changes depending on song buttons
							--j is changes depending on timeline location buttons
							--k is changes depending on graph location buttons
							--l is the index that is assigned the values

						-- 1,2
							if (i == 1) then --first song
								x[i][j][k][1] = 1;
								x[i][j][k][2] = 150;
							elseif (i == 2) then --second song
								x[i][j][k][1] = 2;
								x[i][j][k][2] = 161;
							elseif (i == 3) then
								x[i][j][k][1] = 3;
								x[i][j][k][2] = 156;
							elseif (i == 4) then
								x[i][j][k][1] = 4;
								x[i][j][k][2] = 166;
							elseif (i == 5) then
								x[i][j][k][1] = 5;
								x[i][j][k][2] = 214;
							elseif (i == 6) then
								x[i][j][k][1] = 9999; --do not register
								x[i][j][k][2] = 9999;
							elseif (i == 7) then
								x[i][j][k][1] = 9999;
								x[i][j][k][2] = 9999;
							elseif (i == 8) then
								x[i][j][k][1] = 9999;
								x[i][j][k][2] = 9999;
							end


						-- 5,8
							if (j == 1) then --first timeline location
								x[i][j][k][5] = 1024; --graph sensitivity
								x[i][j][k][8] = 0; --location of timeline
							elseif (j == 2) then --second timeline location
								x[i][j][k][5] = 8192; --graph sensitivity
								x[i][j][k][8] = 30;
							elseif (j == 3) then --third timeline location
								x[i][j][k][5] = 9999; --graph sensitivity
								x[i][j][k][8] = 9999;
							elseif (j == 4) then --third timeline location
								x[i][j][k][5] = 9999; --do not register
								x[i][j][k][8] = 9999;
							elseif (j == 5) then --third timeline location
								x[i][j][k][5] = 9999; --do not register
								x[i][j][k][8] = 9999;
							elseif (j == 6) then --third timeline location
								x[i][j][k][5] = 9999; --do not register
								x[i][j][k][8] = 9999;
							elseif (j == 7) then --third timeline location
								x[i][j][k][5] = 9999; --do not register
								x[i][j][k][8] = 9999;
							elseif (j == 8) then --third timeline location
								x[i][j][k][5] = 9999; --do not register
								x[i][j][k][8] = 9999;
							elseif (j == 9) then --this is a placeholder for AudioRanges()
								x[i][j][k][8] = 9999;--don't change this value
							end
													
						-- 9,10,11
							if (k == 1) then --first graph location
								x[i][j][k][9] = 4; --location on graph
								x[i][j][k][10] = 0; --range (+-)
								x[i][j][k][11] = 2.2; --sensitivity
							elseif (k == 2) then --second graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							elseif (k == 3) then --third graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							elseif (k == 4) then --fourth graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							elseif (k == 5) then --fifth graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							elseif (k == 6) then --sixth graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							elseif (k == 7) then --seventh graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							elseif (k == 8) then --eighth graph location
								x[i][j][k][9] = 9999;
								x[i][j][k][10] = 9999;
								x[i][j][k][11] = 9999;
							end

							
							x[i][j][k][14] = true;
							x[i][j][k][15] = true;
							x[i][j][k][16] = true;
							x[i][j][k][17] = true;
							x[i][j][k][18] = true;
							x[i][j][k][19] = true;
							x[i][j][k][20] = true;
							x[i][j][k][21] = true;
							x[i][j][k][22] = true;
							x[i][j][k][23] = true;
							x[i][j][k][24] = true;
							x[i][j][k][25] = true;
						end
					end
				end
	
				---[[ song1
					x[1][1][1][9] = 4; --location on graph
					x[1][1][1][10] = 0; --range (+-)
					x[1][1][1][11] = 6; --sensitivity
					x[1][1][1][14] = true;
					x[1][1][1][15] = true;
					x[1][1][1][16] = true;
					x[1][1][1][17] = true;
					x[1][1][1][18] = true;
					x[1][1][1][19] = true;
					x[1][1][1][20] = true;
					x[1][1][1][21] = true;

					x[1][1][2][9] = 9999; --location on graph
					x[1][1][2][10] = 9999; --range (+-)
					x[1][1][2][11] = 9999; --sensitivity
					x[1][1][2][14] = true;
					x[1][1][2][15] = true;
					x[1][1][2][16] = true;
					x[1][1][2][17] = true;
					x[1][1][2][18] = true;
					x[1][1][2][19] = true;
					x[1][1][2][20] = true;
					x[1][1][2][21] = true;

					x[1][2][1][9] = 4; --location on graph
					x[1][2][1][10] = 0; --range (+-)
					x[1][2][1][11] = 6; --sensitivity
					x[1][2][1][14] = true;
					x[1][2][1][15] = true;
					x[1][2][1][16] = true;
					x[1][2][1][17] = true;
					x[1][2][1][18] = true;
					x[1][2][1][19] = true;
					x[1][2][1][20] = true;
					x[1][2][1][21] = true;

					x[1][2][2][9] = 9999; --location on graph
					x[1][2][2][10] = 9999; --range (+-)
					x[1][2][2][11] = 9999; --sensitivity
					x[1][2][2][14] = true;
					x[1][2][2][15] = true;
					x[1][2][2][16] = true;
					x[1][2][2][17] = true;
					x[1][2][2][18] = true;
					x[1][2][2][19] = true;
					x[1][2][2][20] = true;
					x[1][2][2][21] = true;

					x[1][3][1][9] = 4; --location on graph
					x[1][3][1][10] = 0; --range (+-)
					x[1][3][1][11] = 6; --sensitivity
					x[1][3][1][14] = true;
					x[1][3][1][15] = true;
					x[1][3][1][16] = true;
					x[1][3][1][17] = true;
					x[1][3][1][18] = true;
					x[1][3][1][19] = true;
					x[1][3][1][20] = true;
					x[1][3][1][21] = true;

					x[1][3][2][9] = 9999; --location on graph
					x[1][3][2][10] = 9999; --range (+-)
					x[1][3][2][11] = 9999; --sensitivity
					x[1][3][2][14] = true;
					x[1][3][2][15] = true;
					x[1][3][2][16] = true;
					x[1][3][2][17] = true;
					x[1][3][2][18] = true;
					x[1][3][2][19] = true;
					x[1][3][2][20] = true;
					x[1][3][2][21] = true;

					x[1][4][1][9] = 4; --location on graph
					x[1][4][1][10] = 0; --range (+-)
					x[1][4][1][11] = 6; --sensitivity
					x[1][4][1][14] = true;
					x[1][4][1][15] = true;
					x[1][4][1][16] = true;
					x[1][4][1][17] = true;
					x[1][4][1][18] = true;
					x[1][4][1][19] = true;
					x[1][4][1][20] = true;
					x[1][4][1][21] = true;
				--]]

				---[[ song2
					x[2][1][1][9] = 7; --location on graph
					x[2][1][1][10] = 0; --range (+-)
					x[2][1][1][11] = 10.45; --sensitivity
					x[2][1][1][14] = true;
					x[2][1][1][15] = true;
					x[2][1][1][16] = true;
					x[2][1][1][17] = true;
					x[2][1][1][18] = true;
					x[2][1][1][19] = true;
					x[2][1][1][20] = true;
					x[2][1][1][21] = true;

					x[2][1][2][9] = 9999; --location on graph
					x[2][1][2][10] = 9999; --range (+-)
					x[2][1][2][11] = 9999; --sensitivity
					x[2][1][2][14] = true;
					x[2][1][2][15] = true;
					x[2][1][2][16] = true;
					x[2][1][2][17] = true;
					x[2][1][2][18] = true;
					x[2][1][2][19] = true;
					x[2][1][2][20] = true;
					x[2][1][2][21] = true;

					x[2][2][1][9] = 7; --location on graph
					x[2][2][1][10] = 0; --range (+-)
					x[2][2][1][11] = 10.45; --sensitivity
					x[2][2][1][14] = true;
					x[2][2][1][15] = true;
					x[2][2][1][16] = true;
					x[2][2][1][17] = true;
					x[2][2][1][18] = true;
					x[2][2][1][19] = true;
					x[2][2][1][20] = true;
					x[2][2][1][21] = true;

					x[2][2][2][9] = 9999; --location on graph
					x[2][2][2][10] = 9999; --range (+-)
					x[2][2][2][11] = 9999; --sensitivity
					x[2][2][2][14] = true;
					x[2][2][2][15] = true;
					x[2][2][2][16] = true;
					x[2][2][2][17] = true;
					x[2][2][2][18] = true;
					x[2][2][2][19] = true;
					x[2][2][2][20] = true;
					x[2][2][2][21] = true;

					x[2][3][1][9] = 7; --location on graph
					x[2][3][1][10] = 0; --range (+-)
					x[2][3][1][11] = 10.45; --sensitivity
					x[2][3][1][14] = true;
					x[2][3][1][15] = true;
					x[2][3][1][16] = true;
					x[2][3][1][17] = true;
					x[2][3][1][18] = true;
					x[2][3][1][19] = true;
					x[2][3][1][20] = true;
					x[2][3][1][21] = true;

					x[2][3][2][9] = 9999; --location on graph
					x[2][3][2][10] = 9999; --range (+-)
					x[2][3][2][11] = 9999; --sensitivity
					x[2][3][2][14] = true;
					x[2][3][2][15] = true;
					x[2][3][2][16] = true;
					x[2][3][2][17] = true;
					x[2][3][2][18] = true;
					x[2][3][2][19] = true;
					x[2][3][2][20] = true;
					x[2][3][2][21] = true;
				--]]

				---[[ song3
					x[3][1][1][9] = 7; --location on graph
					x[3][1][1][10] = 0; --range (+-)
					x[3][1][1][11] = 2.2; --sensitivity
					x[3][1][1][14] = true;
					x[3][1][1][15] = true;
					x[3][1][1][16] = true;
					x[3][1][1][17] = true;
					x[3][1][1][18] = true;
					x[3][1][1][19] = true;
					x[3][1][1][20] = true;
					x[3][1][1][21] = true;

					x[3][1][2][9] = 9999; --location on graph
					x[3][1][2][10] = 9999; --range (+-)
					x[3][1][2][11] = 9999; --sensitivity
					x[3][1][2][14] = true;
					x[3][1][2][15] = true;
					x[3][1][2][16] = true;
					x[3][1][2][17] = true;
					x[3][1][2][18] = true;
					x[3][1][2][19] = true;
					x[3][1][2][20] = true;
					x[3][1][2][21] = true;

					x[3][2][1][9] = 7; --location on graph
					x[3][2][1][10] = 0; --range (+-)
					x[3][2][1][11] = 2.2; --sensitivity
					x[3][2][1][14] = true;
					x[3][2][1][15] = true;
					x[3][2][1][16] = true;
					x[3][2][1][17] = true;
					x[3][2][1][18] = true;
					x[3][2][1][19] = true;
					x[3][2][1][20] = true;
					x[3][2][1][21] = true;

					x[3][2][2][9] = 9999; --location on graph
					x[3][2][2][10] = 9999; --range (+-)
					x[3][2][2][11] = 9999; --sensitivity
					x[3][2][2][14] = true;
					x[3][2][2][15] = true;
					x[3][2][2][16] = true;
					x[3][2][2][17] = true;
					x[3][2][2][18] = true;
					x[3][2][2][19] = true;
					x[3][2][2][20] = true;
					x[3][2][2][21] = true;

					x[3][3][1][9] = 7; --location on graph
					x[3][3][1][10] = 0; --range (+-)
					x[3][3][1][11] = 2.2; --sensitivity
					x[3][3][1][14] = true;
					x[3][3][1][15] = true;
					x[3][3][1][16] = true;
					x[3][3][1][17] = true;
					x[3][3][1][18] = true;
					x[3][3][1][19] = true;
					x[3][3][1][20] = true;
					x[3][3][1][21] = true;

					x[3][3][2][9] = 9999; --location on graph
					x[3][3][2][10] = 9999; --range (+-)
					x[3][3][2][11] = 9999; --sensitivity
					x[3][3][2][14] = true;
					x[3][3][2][15] = true;
					x[3][3][2][16] = true;
					x[3][3][2][17] = true;
					x[3][3][2][18] = true;
					x[3][3][2][19] = true;
					x[3][3][2][20] = true;
					x[3][3][2][21] = true;
				--]]
				
				---[[ song4
					x[4][1][1][9] = 1; --location on graph
					x[4][1][1][10] = 0; --range (+-)
					x[4][1][1][11] = 8.45; --sensitivity
					x[4][1][1][14] = true;
					x[4][1][1][15] = true;
					x[4][1][1][16] = true;
					x[4][1][1][17] = true;
					x[4][1][1][18] = true;
					x[4][1][1][19] = true;
					x[4][1][1][20] = true;
					x[4][1][1][21] = true;

					x[4][1][2][9] = 9999; --location on graph
					x[4][1][2][10] = 9999; --range (+-)
					x[4][1][2][11] = 9999; --sensitivity
					x[4][1][2][14] = true;
					x[4][1][2][15] = true;
					x[4][1][2][16] = true;
					x[4][1][2][17] = true;
					x[4][1][2][18] = true;
					x[4][1][2][19] = true;
					x[4][1][2][20] = true;
					x[4][1][2][21] = true;

					x[4][2][1][9] = 1; --location on graph
					x[4][2][1][10] = 0; --range (+-)
					x[4][2][1][11] = 8.45; --sensitivity
					x[4][2][1][14] = true;
					x[4][2][1][15] = true;
					x[4][2][1][16] = true;
					x[4][2][1][17] = true;
					x[4][2][1][18] = true;
					x[4][2][1][19] = true;
					x[4][2][1][20] = true;
					x[4][2][1][21] = true;

					x[4][2][2][9] = 9999; --location on graph
					x[4][2][2][10] = 9999; --range (+-)
					x[4][2][2][11] = 9999; --sensitivity
					x[4][2][2][14] = true;
					x[4][2][2][15] = true;
					x[4][2][2][16] = true;
					x[4][2][2][17] = true;
					x[4][2][2][18] = true;
					x[4][2][2][19] = true;
					x[4][2][2][20] = true;
					x[4][2][2][21] = true;

					x[4][3][1][9] = 1; --location on graph
					x[4][3][1][10] = 0; --range (+-)
					x[4][3][1][11] = 8.45; --sensitivity
					x[4][3][1][14] = true;
					x[4][3][1][15] = true;
					x[4][3][1][16] = true;
					x[4][3][1][17] = true;
					x[4][3][1][18] = true;
					x[4][3][1][19] = true;
					x[4][3][1][20] = true;
					x[4][3][1][21] = true;

					x[4][3][2][9] = 9999; --location on graph
					x[4][3][2][10] = 9999; --range (+-)
					x[4][3][2][11] = 9999; --sensitivity
					x[4][3][2][14] = true;
					x[4][3][2][15] = true;
					x[4][3][2][16] = true;
					x[4][3][2][17] = true;
					x[4][3][2][18] = true;
					x[4][3][2][19] = true;
					x[4][3][2][20] = true;
					x[4][3][2][21] = true;
				--]]

				---[[ song5
					x[5][1][1][9] = 4; --location on graph
					x[5][1][1][10] = 0; --range (+-)
					x[5][1][1][11] = 10.2; --sensitivity
					x[5][1][1][14] = true;
					x[5][1][1][15] = true;
					x[5][1][1][16] = true;
					x[5][1][1][17] = true;
					x[5][1][1][18] = true;
					x[5][1][1][19] = true;
					x[5][1][1][20] = true;
					x[5][1][1][21] = true;

					x[5][1][2][9] = 9999; --location on graph
					x[5][1][2][10] = 9999; --range (+-)
					x[5][1][2][11] = 9999; --sensitivity
					x[5][1][2][14] = true;
					x[5][1][2][15] = true;
					x[5][1][2][16] = true;
					x[5][1][2][17] = true;
					x[5][1][2][18] = true;
					x[5][1][2][19] = true;
					x[5][1][2][20] = true;
					x[5][1][2][21] = true;

					x[5][2][1][9] = 4; --location on graph
					x[5][2][1][10] = 0; --range (+-)
					x[5][2][1][11] = 10.2; --sensitivity
					x[5][2][1][14] = true;
					x[5][2][1][15] = true;
					x[5][2][1][16] = true;
					x[5][2][1][17] = true;
					x[5][2][1][18] = true;
					x[5][2][1][19] = true;
					x[5][2][1][20] = true;
					x[5][2][1][21] = true;

					x[5][2][2][9] = 9999; --location on graph
					x[5][2][2][10] = 9999; --range (+-)
					x[5][2][2][11] = 9999; --sensitivity
					x[5][2][2][14] = true;
					x[5][2][2][15] = true;
					x[5][2][2][16] = true;
					x[5][2][2][17] = true;
					x[5][2][2][18] = true;
					x[5][2][2][19] = true;
					x[5][2][2][20] = true;
					x[5][2][2][21] = true;

					x[5][3][1][9] = 4; --location on graph
					x[5][3][1][10] = 0; --range (+-)
					x[5][3][1][11] = 10.2; --sensitivity
					x[5][3][1][14] = true;
					x[5][3][1][15] = true;
					x[5][3][1][16] = true;
					x[5][3][1][17] = true;
					x[5][3][1][18] = true;
					x[5][3][1][19] = true;
					x[5][3][1][20] = true;
					x[5][3][1][21] = true;

					x[5][3][2][9] = 9999; --location on graph
					x[5][3][2][10] = 9999; --range (+-)
					x[5][3][2][11] = 9999; --sensitivity
					x[5][3][2][14] = true;
					x[5][3][2][15] = true;
					x[5][3][2][16] = true;
					x[5][3][2][17] = true;
					x[5][3][2][18] = true;
					x[5][3][2][19] = true;
					x[5][3][2][20] = true;
					x[5][3][2][21] = true;
				--]]
			--]]

			
			for t=1, 1000 do
				timelineList[t] = Object.Instantiate(timelineObject, Vector3(timelineSpawnLocation.transform.position.x + timelineLineIncrementor, timelineSpawnLocation.transform.position.y, timelineSpawnLocation.transform.position.z), timelineSpawnLocation.transform.rotation);
				timelineLineIncrementor = timelineLineIncrementor + timelineCubeDistance;

				timelineList[t].SetActive(false);
			end

		end

	--update
		--=========================================================================
		--Update() - called every frame
		--=========================================================================
		function Audio4wUI.Update()
			SAMPLE_SIZE = x[songNumber][timelineLocation][graphLocation][5] * 2; --Displays the sample size
			spectrum = musicPlayer.GetSpectrumData(SAMPLE_SIZE, 0, FFTWindow.Hamming);
			AudioRanges();

			LuaEvents.InvokeForAll("currentGVal", x[songNumber][timelineLocation][graphLocation][5]);


			if (x[songNumber][timelineLocation][graphLocation][5] == 1024) then
				graphValue1 = 762.5;
			elseif (x[songNumber][timelineLocation][graphLocation][5] == 2048) then
				graphValue1 = 1525;
			elseif (x[songNumber][timelineLocation][graphLocation][5] == 4096) then
				graphValue1 = 3050;
			elseif (x[songNumber][timelineLocation][graphLocation][5] == 8192) then
				graphValue1 = 6100;
			elseif (x[songNumber][timelineLocation][graphLocation][5] == 512) then
				graphValue1 = 381.25;
			elseif (x[songNumber][timelineLocation][graphLocation][5] == 256) then
				graphValue1 = 190.625;
			end
			
			seconds1 = Mathf.Floor(musicPlayer.time); -- 1
			if (seconds1 == 0) then
				for u = 1, 1000 do
					timelineList[u].SetActive(false);
				end
			end
			if (seconds1 <= timelength and seconds1 > 0) then
				seconds2 = 0;
				if (seconds2 <= seconds1) then -- 0 ~= 1
					seconds2 = seconds1;
					timelineList[seconds1].SetActive(true);

					--Debug.Log("AUDIO " .. SAMPLE_SIZE .. " _ " .. graphValue1);



					
					--[[ --reverse back
						local reverseSeconds = 5; --"reverse by {reverseSeconds} seconds."
						if (reverseBool == true) then -- if setseconds is reached

							musicPlayer.time = seconds2 - reverseSeconds;
							
							
							for r=seconds2, reverseSeconds, -1 do
								Object.Destroy(timelineList[r], 0);
								timelineList[r] = nil;
								timelineLineIncrementor = timelineLineIncrementor - timelineCubeDistance;
							end

							seconds2 = seconds2 - reverseSeconds; -- 5

							reverseBool = false;
						end
					--]]

					--[[ --forward
						local forwardSeconds = 5; --"reverse by {reverseSeconds} seconds."
						if (forwardBool == true) then -- if setseconds is reached

							musicPlayer.time = seconds2 + forwardSeconds;
							
							
							for s=seconds2, seconds2+forwardSeconds-1 do
								timelineList[s] = Object.Instantiate(timelineObject, Vector3(timelineSpawnLocation.transform.position.x + timelineLineIncrementor, timelineSpawnLocation.transform.position.y, timelineSpawnLocation.transform.position.z), timelineSpawnLocation.transform.rotation);
								timelineLineIncrementor = timelineLineIncrementor + timelineCubeDistance;
							end

							seconds2 = seconds2 + forwardSeconds; -- 5

							--5?

							forwardBool = false;
						end
					--]]
				end
			end
			
			
		---[[
			if (x[songNumber][1][graphLocation][8] ~= 9999) then
				timelineButton1.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][1][graphLocation][8]), 0, 0);
			elseif(x[songNumber][1][graphLocation][8] == 9999) then
				timelineButton1.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][2][graphLocation][8] ~= 9999) then
				timelineButton2.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][2][graphLocation][8]), 0, 0);
			elseif(x[songNumber][2][graphLocation][8] == 9999) then
				timelineButton2.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][3][graphLocation][8] ~= 9999) then
				timelineButton3.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][3][graphLocation][8]), 0, 0);
			elseif(x[songNumber][3][graphLocation][8] == 9999) then
				timelineButton3.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][4][graphLocation][8] ~= 9999) then
				timelineButton4.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][4][graphLocation][8]), 0, 0);
			elseif(x[songNumber][4][graphLocation][8] == 9999) then
				timelineButton4.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][5][graphLocation][8] ~= 9999) then
				timelineButton5.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][5][graphLocation][8]), 0, 0);
			elseif(x[songNumber][5][graphLocation][8] == 9999) then
				timelineButton5.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][6][graphLocation][8] ~= 9999) then
				timelineButton6.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][6][graphLocation][8]), 0, 0);
			elseif(x[songNumber][6][graphLocation][8] == 9999) then
				timelineButton6.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][7][graphLocation][8] ~= 9999) then
				timelineButton7.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][7][graphLocation][8]), 0, 0);
			elseif(x[songNumber][7][graphLocation][8] == 9999) then
				timelineButton7.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][8][graphLocation][8] ~= 9999) then
				timelineButton8.transform.localPosition = Vector3(remap(0, timelength, 0, 762.5, x[songNumber][8][graphLocation][8]), 0, 0);
			elseif(x[songNumber][8][graphLocation][8] == 9999) then
				timelineButton8.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			--]]

		--
			if (x[songNumber][timelineLocation][1][9] ~= 9999) then
				graphButton1.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][1][9]), 0, 0); --when visualizer SAMPLE_SIZE is 1024
			elseif (x[songNumber][timelineLocation][1][9] == 9999) then
				graphButton1.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][2][9] ~= 9999) then
				graphButton2.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][2][9]), 0, 0);
			elseif (x[songNumber][timelineLocation][2][9] == 9999) then
				graphButton2.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][3][9] ~= 9999) then
				graphButton3.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][3][9]), 0, 0);
			elseif (x[songNumber][timelineLocation][3][9] == 9999) then
				graphButton3.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][4][9] ~= 9999) then
				graphButton4.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][4][9]), 0, 0);
			elseif (x[songNumber][timelineLocation][4][9] == 9999) then
				graphButton4.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][5][9] ~= 9999) then
				graphButton5.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][5][9]), 0, 0); --when visualizer SAMPLE_SIZE is 1024
			elseif (x[songNumber][timelineLocation][5][9] == 9999) then
				graphButton5.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][6][9] ~= 9999) then
				graphButton6.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][6][9]), 0, 0);
			elseif (x[songNumber][timelineLocation][6][9] == 9999) then
				graphButton6.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][7][9] ~= 9999) then
				graphButton7.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][7][9]), 0, 0);
			elseif (x[songNumber][timelineLocation][7][9] == 9999) then
				graphButton7.transform.localPosition = Vector3(798.6666, 0, 0);
			end
			if (x[songNumber][timelineLocation][8][9] ~= 9999) then
				graphButton8.transform.localPosition = Vector3(remap(0, 270, 0, graphValue1, x[songNumber][timelineLocation][8][9]), 0, 0);
			elseif (x[songNumber][timelineLocation][8][9] == 9999) then
				graphButton8.transform.localPosition = Vector3(798.6666, 0, 0);
			end
		end
	end
