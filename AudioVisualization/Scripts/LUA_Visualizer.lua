do -- script LUA_Visualizer
	
	-- get reference to the script
	local LUA_Visualizer = LUA.script;

--Variables
	local musicPlayer = SerializedField("Music Player source", AudioSource);
	local objectThing = SerializedField("Clonable Object", GameObject);
	local spawnLocation = SerializedField("Spawn Location", GameObject);

	local graphSensitivityText = SerializedField("Graph Sensitivity Text", TextMesh);

	local spectrum = {};
	local SAMPLE_SIZE = nil; --2048

	local visualList = {};
	local visualScale = {};
	local amnVisual = 131;

	local cubeDistance = 0.0087;
	local lineIncrementor = 0;

	local maxVisualScale = nil;
	local visualModifier = nil;
	local smoothSpeed = nil;
	local keepPercentage = nil;

	local enableScale = true;
	local addScaleMode = false;

	local importedSample = 0;


--Button functions
	local function enableScaleButton() --normal graph
		enableScale = true;
		addScaleMode = false;

	end

	local function enableAdditionMode() --adding mode

		enableScale = true;
		addScaleMode = true;

		LuaEvents.InvokeForAll("restartAdditionMode");

	end

	local function disableScaleButton() --no graph movement
		enableScale = false;
		addScaleMode = false;

	end

	--[[
		local function disableAdditionMode() --no graph movement
			enableScale = false;
			addScaleMode = false;

		end
	]]

	local function restartAdditionMode()
		for i=1, amnVisual do
			visualList[i].transform.localScale = Vector3(0.01, 0.01, 0.01);
		end

	end

	local function currentGVal(yo)
		importedSample = yo;
		
		graphSensitivityText.text = tostring(SAMPLE_SIZE);

		
	end

	local function IncreaseVisualizer()
		--[[if (SAMPLE_SIZE < 8192) then
			--SAMPLE_SIZE = SAMPLE_SIZE * 2;
			keepPercentage = keepPercentage / 2;
		end]]
	end

	local function DecreaseVisualizer()
		--[[if (SAMPLE_SIZE > 512) then
			--SAMPLE_SIZE = SAMPLE_SIZE / 2;
			keepPercentage = keepPercentage * 2;
		end]]
	end

	local function PlaySong()
		--SAMPLE_SIZE = 1024;
		keepPercentage = 0.128;
		graphSensitivityText.text = tostring(SAMPLE_SIZE);
	end




--SpawnLine()
	--=========================================================================
	--SpawnLine() - Spawns a line of amnVisual cubes and moves each cube over by cubeDistance.
	--=========================================================================
	local function SpawnLine()
		for i=1, amnVisual, 1 do
			visualList[i] = Object.Instantiate(objectThing, Vector3(spawnLocation.transform.position.x + lineIncrementor, spawnLocation.transform.position.y, spawnLocation.transform.position.z), spawnLocation.transform.rotation);
			lineIncrementor = lineIncrementor + cubeDistance;
		end
	end

--UpdateVisual()
	--=========================================================================
	--UpdateVisual() - Calculates the scaling and scales each cube from SpawnLine() to visualize the spectrum data
	--visualIndex = index of cubes
	--visualScale = scale
	--visualList = cubes
	--=========================================================================
	local function UpdateVisual()
		if (enableScale == true) then
			local averageSize = (SAMPLE_SIZE * keepPercentage) / amnVisual; --1.00055 = 1024 * 0.128 / 131
			local visualIndex = 1;
			local spectrumIndex = 1;

			while (visualIndex <= amnVisual) do --repeats 131 times per frame
				local j = 1;
				local sum = 0;
				while (j < averageSize) do -- once per parent while loop
					sum = sum + spectrum[spectrumIndex]; --spectrum value at the index = 0 + spectrum value at the index
					spectrumIndex = spectrumIndex + 1;
					j = j + 1;
				end

				local scaleY = sum / averageSize * visualModifier; --0.01199 = spectrum value at the index / 1.00055 * 250   - if spectrum value at the index = 3
					--i probably need to change the visualModifier to fix the problems

				visualScale[visualIndex] = visualScale[visualIndex] - Time.deltaTime * smoothSpeed; --having this keeps the scale from going up and down and "flickering" each frame
				
				if (visualScale[visualIndex] < scaleY) then --if (-50 < 0.01199) 
					visualScale[visualIndex] = scaleY; --minimum scale
				elseif (visualScale[visualIndex] > maxVisualScale) then --if threshold reached


					visualScale[visualIndex] = maxVisualScale;

					if (addScaleMode == true) then
						maxVisualScale = 0.75;
						visualScale[visualIndex] = visualScale[visualIndex] * 0.0025;
						visualList[visualIndex].transform.localScale = visualList[visualIndex].transform.localScale + Vector3(0, 0, visualScale[visualIndex]);
						
					elseif (addScaleMode == false) then
						maxVisualScale = 0.0001;

					end

				end
				

				if (addScaleMode == false) then
					visualList[visualIndex].transform.localScale = Vector3(0.01, 0.01, 0.01*visualScale[visualIndex] * 0.5);

				end
				
				visualIndex = visualIndex + 1;
			end
		end

		
	end



--Start
	--=========================================================================
	--Start()
	--=========================================================================
	function LUA_Visualizer.Start()

		LuaEvents.Add("IncreaseVisualizer", IncreaseVisualizer);
		LuaEvents.Add("DecreaseVisualizer", DecreaseVisualizer);
		LuaEvents.Add("PlaySong", PlaySong);


		LuaEvents.Add("enableScaleButton", enableScaleButton);
		LuaEvents.Add("disableScaleButton", disableScaleButton);
		LuaEvents.Add("enableAdditionMode", enableAdditionMode);
		--LuaEvents.Add("disableAdditionMode", disableAdditionMode);
		LuaEvents.Add("restartAdditionMode", restartAdditionMode);

		LuaEvents.Add("currentGVal", currentGVal);

		maxVisualScale = 0.0001; --chopsticks = 400    -- real songs: 0.0001
		visualModifier = 250; --chopsticks = 750    -- real songs: 250
		smoothSpeed = 500;
		keepPercentage = 0.128;

		SAMPLE_SIZE = 1024; --64 128 256 512 1024  2048

		graphSensitivityText.text = tostring(SAMPLE_SIZE);

		for i=1, SAMPLE_SIZE do
			spectrum[i] = 0.0;
		end

		for j=1, amnVisual do
			visualScale[j] = 0.0;
			visualList[j] = 0.0;
		end

		SpawnLine();
	end

--Update
	--=========================================================================
	--Update() - called every frame
	--=========================================================================
	function LUA_Visualizer.Update()
		SAMPLE_SIZE = importedSample;

		if (SAMPLE_SIZE == 1024) then
			keepPercentage = 0.128;
			graphSensitivityText.text = tostring(1);
		elseif (SAMPLE_SIZE == 2048) then
			keepPercentage = 0.064;
			graphSensitivityText.text = tostring(2);
		elseif (SAMPLE_SIZE == 4096) then
			keepPercentage = 0.032;
			graphSensitivityText.text = tostring(3);
		elseif (SAMPLE_SIZE == 8192) then
			keepPercentage = 0.016;
			graphSensitivityText.text = tostring(4);
		elseif (SAMPLE_SIZE == 512) then
			keepPercentage = 0.256;
			graphSensitivityText.text = tostring(0.5);
		end

		spectrum = musicPlayer.GetSpectrumData(SAMPLE_SIZE, 0, FFTWindow.Hamming);
		UpdateVisual();
		
		graphSensitivityText.text = tostring(SAMPLE_SIZE);
		--Debug.Log("VISUAL " .. SAMPLE_SIZE .. " _ " .. keepPercentage);
	end
end
