do -- script Events 
	
	-- get reference to the script
	local Events = LUA.script;

	--variables
		local scale1 = SerializedField("scale1", GameObject, 3);
		local scale2 = SerializedField("scale2", GameObject, 3);
		local jump1 = SerializedField("jump1", GameObject, 3);
		local jump2 = SerializedField("jump2", GameObject, 3);
		local vanish1 = SerializedField("vanish1", GameObject, 3);
		local vanish1Time = SerializedField("vanish1 Goes Away After X Seconds", Number);
		local vanish2 = SerializedField("vanish2", GameObject, 3);	
		local vanish1Time = SerializedField("vanish2 Goes Away After X Seconds", Number);


		local color1 = SerializedField("color1", Color);
		local color2 = SerializedField("color2", Color);
		local color3 = SerializedField("color3", Color);
		local color4 = SerializedField("color4", Color);
		local color5 = SerializedField("color5", Color);
		local color6 = SerializedField("color6", Color);
		local color7 = SerializedField("color7", Color);
		local color8 = SerializedField("color8", Color);

		local mat1 = SerializedField("mat1", Material);
		local mat2 = SerializedField("mat2", Material);
		local mat3 = SerializedField("mat3", Material);
		local mat4 = SerializedField("mat4", Material);
		local mat5 = SerializedField("mat5", Material);
		local mat6 = SerializedField("mat6", Material);
		local mat7 = SerializedField("mat7", Material);


		local totalHeight = 1;
		local steps1 = 1; -- 1
		local steps2 = 5; --should be greater than steps1 - 5
		local individualHeight1 = totalHeight / steps1;
		local stepDiv = steps1/steps2;

		local lerpnum = 0;
		local flag1 = false;
		local flag2 = false;

		local colorNum = 0;

		x = {};


	---[[translation events
		local function scale1Decrease()
			x[1][7] = 0;
		end

		local function scale1Event()
			x[1][7] = 1;
		end

		local function scale2Decrease()
			x[2][7] = 0;
		end

		local function scale2Event()
			x[2][7] = 1;
		end

		local function Jump1Decrease()
			x[3][7] = 0;
		end

		local function jump1Event()
			x[3][7] = 1;
		end

		local function Jump2Decrease()
			x[4][7] = 0;
		end

		local function jump2Event()
			x[4][7] = 1;
		end
	--]]
		
	---[[color changing events
		local function changeColor1Event()
			

			colorNum = colorNum + 1;
			if colorNum == 8 then
				colorNum = 1;
			end
			--Debug.Log(colorNum);

			---[[

				if colorNum == 1 then
					mat1.SetColor("_Color", color1);
					mat2.SetColor("_Color", color2);
					mat3.SetColor("_Color", color3);
					mat4.SetColor("_Color", color4);
					mat5.SetColor("_Color", color5);
					mat6.SetColor("_Color", color6);
					mat7.SetColor("_Color", color7);
				elseif colorNum == 2 then
					mat1.SetColor("_Color", color7);
					mat2.SetColor("_Color", color1);
					mat3.SetColor("_Color", color2);
					mat4.SetColor("_Color", color3);
					mat5.SetColor("_Color", color4);
					mat6.SetColor("_Color", color5);
					mat7.SetColor("_Color", color6);
				elseif colorNum == 3 then
					mat1.SetColor("_Color", color6);
					mat2.SetColor("_Color", color7);
					mat3.SetColor("_Color", color1);
					mat4.SetColor("_Color", color2);
					mat5.SetColor("_Color", color3);
					mat6.SetColor("_Color", color4);
					mat7.SetColor("_Color", color5);
				elseif colorNum == 4 then
					mat1.SetColor("_Color", color5);
					mat2.SetColor("_Color", color6);
					mat3.SetColor("_Color", color7);
					mat4.SetColor("_Color", color1);
					mat5.SetColor("_Color", color2);
					mat6.SetColor("_Color", color3);
					mat7.SetColor("_Color", color4);
				elseif colorNum == 5 then
					mat1.SetColor("_Color", color4);
					mat2.SetColor("_Color", color5);
					mat3.SetColor("_Color", color6);
					mat4.SetColor("_Color", color7);
					mat5.SetColor("_Color", color1);
					mat6.SetColor("_Color", color2);
					mat7.SetColor("_Color", color3);
				elseif colorNum == 6 then
					mat1.SetColor("_Color", color3);
					mat2.SetColor("_Color", color4);
					mat3.SetColor("_Color", color5);
					mat4.SetColor("_Color", color6);
					mat5.SetColor("_Color", color7);
					mat6.SetColor("_Color", color1);
					mat7.SetColor("_Color", color2);
				elseif colorNum == 7 then
					mat1.SetColor("_Color", color2);
					mat2.SetColor("_Color", color3);
					mat3.SetColor("_Color", color4);
					mat4.SetColor("_Color", color5);
					mat5.SetColor("_Color", color6);
					mat6.SetColor("_Color", color7);
					mat7.SetColor("_Color", color1);
				end
			--]]
		end

		local function changeColor2Event()
			--Debug.Log("stepDiv");
			--thing = true;
		end
	--]]

	---[[vanish events
		function vanish1Event()

		end

		function vanish1OFF()

		end

		function vanish2Event()

		end

		function vanish2OFF()

		end
	--]]

	--start
		function Events.Start()
		
			---[[ --events
				LuaEvents.Add("scale1Event", scale1Event);
				LuaEvents.Add("scale1Decrease", scale1Decrease);
				LuaEvents.Add("scale2Event", scale2Event);
				LuaEvents.Add("scale2Decrease", scale2Decrease);
				LuaEvents.Add("jump1Event", jump1Event);
				LuaEvents.Add("Jump1Decrease", Jump1Decrease);
				LuaEvents.Add("jump2Event", jump2Event);
				LuaEvents.Add("Jump2Decrease", Jump2Decrease);

				LuaEvents.Add("changeColor1Event", changeColor1Event);
				LuaEvents.Add("changeColor2Event", changeColor2Event);	

				LuaEvents.Add("vanish1Event", vanish1Event);
				LuaEvents.Add("vanish1OFF", vanish1OFF);
				LuaEvents.Add("vanish2Event", vanish2Event);
				LuaEvents.Add("vanish2OFF", vanish2OFF);
			--]]

			---[[
				for j=1,8 do --maximum number of songs #songs
					x[j] = {};

					x[j][1] = 1; -- totalHeight
					x[j][2] = 1; -- steps1
					x[j][3] = 1; -- steps2

					if (j == 1) then --scale1
						x[j][1] = 1; -- totalHeight
						x[j][2] = 1; -- steps1
						x[j][3] = 5; -- steps2
					end

					if (j == 2) then --scale2
						x[j][1] = 1; -- totalHeight
						x[j][2] = 10; -- steps1
						x[j][3] = 50; -- steps2
					end

					if (j == 3) then --jump1
						x[j][1] = 1; -- totalHeight
						x[j][2] = 1; -- steps1
						x[j][3] = 5; -- steps2
					end

					if (j == 4) then --jump2
						x[j][1] = 1; -- totalHeight
						x[j][2] = 10; -- steps1
						x[j][3] = 50; -- steps2
					end

					Debug.Log(x[j][1] .. " _ " .. x[j][2] .. " _ " .. x[j][3]);
					x[j][4] = (x[j][2] / x[j][3]); -- individualHeight1
					x[j][5] = (x[j][1] / x[j][2]); -- stepDiv
					x[j][6] = 0; -- lerpnum
					x[j][7] = 0; -- flag1
					x[j][8] = 0; -- flag2

				end
			--]]

			--for m = 1, #vanish1 do
				--Object.Destroy(vanish1, 0);
				--vanish1.SetActive(false);
				--vanish1.SetActive(true);

				--testMATT1.SetColor("_Color", color8);
				--testMATT1.SetColor("_Color", Color(1, 0, 0, 1));

				--testMATT1.SetColor("_EmissionColor", Color(180, 100, 100, 5));
				--Material.shaderKeywords
			--end
				--Object.Instantiate(vanish1, Vector3(particle1Location.transform.position.x, particle1Location.transform.position.y, particle1Location.transform.position.z), particle1Location.transform.rotation);

		end

		
	--update
		function Events.Update()

			---[[vertical jump
				for k = 3, 4 do
					if (x[k][7] == 1) then
						--Debug.Log(x[k][6]);
						if (x[k][8] == 0) then

							if (k == 3) then
								x[k][6] = x[k][6] + 1;

								for l=1,#jump1 do
									jump1[l].transform.position = Vector3(jump1[l].transform.position.x, jump1[l].transform.position.y + x[k][4], jump1[l].transform.position.z);
								end

								if (x[k][6] == x[k][2]) then
									x[k][8] = 1;
									x[k][6] = x[k][6] - x[k][5];
								end
							end

							if (k == 4) then
								x[k][6] = x[k][6] + 1;

								for l=1,#jump2 do
									jump2[l].transform.position = Vector3(jump2[l].transform.position.x, jump2[l].transform.position.y + x[k][4], jump2[l].transform.position.z);
								end

								if (x[k][6] == x[k][2]) then
									x[k][8] = 1;
									x[k][6] = x[k][6] - x[k][5];
								end	
							end

						elseif(x[k][8] == 1) then

							if (k == 3) then
								x[k][6] = x[k][6] - 1*x[k][5];

								for l=1,#jump1 do
									jump1[l].transform.position = Vector3(jump1[l].transform.position.x, jump1[l].transform.position.y - x[k][4]*x[k][5], jump1[l].transform.position.z);
								end

								if (x[k][6] <= 0) then
									LuaEvents.InvokeForAll("Jump1Decrease");
									x[k][8] = 0;
									x[k][7] = 0;
									x[k][6] = 0;
								end
							end

							if (k == 4) then
								x[k][6] = x[k][6] - 1*x[k][5];

								for l=1,#jump2 do
									jump2[l].transform.position = Vector3(jump2[l].transform.position.x, jump2[l].transform.position.y - x[k][4]*x[k][5], jump2[l].transform.position.z);
								end

								if (x[k][6] <= 0) then
									LuaEvents.InvokeForAll("Jump2Decrease");
									x[k][8] = 0;
									x[k][7] = 0;
									x[k][6] = 0;
								end
							end
						end
					end
				end
			--]]

			---[[vertical scale
				for k = 1, 2 do
					if (x[k][7] == 1) then
						--Debug.Log(x[k][6]);
						if (x[k][8] == 0) then

							if (k == 1) then
								x[k][6] = x[k][6] + 1;

								for l=1,#scale1 do
									scale1[l].transform.localScale = Vector3(scale1[l].transform.localScale.x, scale1[l].transform.localScale.y + x[k][4], scale1[l].transform.localScale.z);
								end

								if (x[k][6] == x[k][2]) then
									x[k][8] = 1;
									x[k][6] = x[k][6] - x[k][5];
								end
							end

							if (k == 2) then
								x[k][6] = x[k][6] + 1;

								for l=1,#scale2 do
									scale2[l].transform.localScale = Vector3(scale2[l].transform.localScale.x, scale2[l].transform.localScale.y + x[k][4], scale2[l].transform.localScale.z);
								end

								if (x[k][6] == x[k][2]) then
									x[k][8] = 1;
									x[k][6] = x[k][6] - x[k][5];
								end	
							end

						elseif(x[k][8] == 1) then

							if (k == 1) then
								x[k][6] = x[k][6] - 1*x[k][5];

								for l=1,#scale1 do
									scale1[l].transform.localScale = Vector3(scale1[l].transform.localScale.x, scale1[l].transform.localScale.y - x[k][4]*x[k][5], scale1[l].transform.localScale.z);
								end

								if (x[k][6] <= 0) then
									LuaEvents.InvokeForAll("scale1Decrease");
									x[k][8] = 0;
									x[k][7] = 0;
									x[k][6] = 0;
								end
							end

							if (k == 2) then
								x[k][6] = x[k][6] - 1*x[k][5];

								for l=1,#scale2 do
									scale2[l].transform.localScale = Vector3(scale2[l].transform.localScale.x, scale2[l].transform.localScale.y - x[k][4]*x[k][5], scale2[l].transform.localScale.z);
								end

								if (x[k][6] <= 0) then
									LuaEvents.InvokeForAll("scale2Decrease");
									x[k][8] = 0;
									x[k][7] = 0;
									x[k][6] = 0;
								end
							end
						end
					end
				end
			--]]


			
		end
	end