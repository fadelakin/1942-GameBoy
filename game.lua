game = {}

function game.load()
	--background init
	game.clock = 0

	-- enemy init
	game.enemy_size = imgs["enemy"]:getWidth()
	game.enemies = {}
	game.enemy_dt = 0
	game.enemy_rate = 2

	-- player init
	game.player_size = imgs["player"]:getWidth()
	game.playerx = (160/2)*scale
	game.playery = (144-12)*scale

	-- bullet init
	game.ammo = 10
	game.recharge_dt = 0
	game.recharge_rate = 1
	game.bullet_size = imgs["bullet"]:getWidth()
	game.bullets = {}

	-- info init
	game.score = 0
end

function game.draw()
	-- Draw moving background
	for i = 0, 6 do
		for j = -1, 6 do
			love.graphics.draw(imgs["background"],
								i*32*scale,
								(j+game.clock%1)*32*scale,
								0,scale,scale)
		end
	end

	-- Draw enemies
	for _,v in ipairs(game.enemies) do
		love.graphics.draw(imgs["enemy"],
			v.x,v.y,
			0,scale,scale,
			game.enemy_size/2, game.enemy_size/2)
		if debug then love.graphics.circle("line", v.x, v.y, game.enemy_size/2*scale) end
	end

	-- Draw player
	love.graphics.draw(imgs["player"],
		game.playerx, game.playery,
		0, scale, scale,
		game.player_size/2, game.player_size/2)
	if debug then
		love.graphics.circle("line", game.playerx, game.playery, game.player_size/2*scale)
	end

	-- Draw game bullets
	for _,v in ipairs(game.bullets) do
		love.graphics.draw(imgs["bullet"], v.x, v.y, 0, scale, scale, game.bullet_size/2, game.bullet_size/2)
		if debug then love.graphics.circle("line", v.x, v.y, game.bullet_size/2*scale) end
	end

	-- Draw game info
	love.graphics.setColor(fontcolor.r, fontcolor.g, fontcolor.b)
	love.graphics.printf("score:"..game.score..
						" ammo:"..game.ammo,0,0,love.graphics.getWidth(),"center")
	if debug then love.graphics.print("enemies: "..#game.enemies.."\nbullets:"..#game.bullets.."\nenemy_rate:"..game.enemy_rate.."\nFPS:"..love.timer.getFPS(),0,14*scale) end
	love.graphics.setColor(255,255,255)
end

function game.update(dt)
	-- clock for background
	game.clock = game.clock + dt

	-- Update game.enemies
	game.enemy_dt = game.enemy_dt + dt

	-- Enemy spawn
	if game.enemy_dt > game.enemy_rate then
		game.enemy_dt = game.enemy_dt - game.enemy_rate
		game.enemy_rate = game.enemy_rate - 0.01 * game.enemy_rate
		local enemy = {}
		enemy.x = math.random((8)*scale,(160-8)*scale)
		enemy.y = -game.enemy_size
		table.insert(game.enemies,enemy)
	end

	-- Update enemy
	for ei, ev in ipairs(game.enemies) do
		ev.y = ev.y + 70*dt*scale
		if ev.y > 144*scale then
			table.remove(game.enemies, ei)
		end

		-- If a player gets too close to an enemy
		if game.dist(game.playerx, game.playery, ev.x, ev.y)<(12+8)*scale then
			splash.load()
			state = "splash"
		end
	end

	-- Update player movement
	if love.keyboard.isDown("right") then
		game.playerx = game.playerx + 100*dt*scale
	end
	if love.keyboard.isDown("left") then
		game.playerx = game.playerx - 100*dt*scale
	end

	-- keep the player on the map
	if game.playerx > 160*scale then
		game.playerx = 160*scale
	end
	if game.playerx < 0 then
		game.playerx = 0
	end

	-- Update bullets
	for bi, bv in ipairs(game.bullets) do
		bv.y = bv.y - 100*dt*scale
		if bv.y < 0 then
			table.remove(game.bullets, bi)
		end
		-- Update bullets with game.enemies
		for ei, ev in ipairs(game.enemies) do
			if game.dist(bv.x, bv.y, ev.x, ev.y) < (2+8) * scale then
				game.score = game.score + 1
				table.remove(game.enemies, ei)
				table.remove(game.bullets, bi)
			end
		end
	end

	-- Update player ammunition
	game.recharge_dt = game.recharge_dt + dt
	if game.recharge_dt > game.recharge_rate then
		game.recharge_dt = game.recharge_dt - game.recharge_rate
		game.ammo = game.ammo + 1
		if game.ammo > 10 then
			game.ammo = 10
		end
	end
end

function game.keypressed(key)
	-- Shoot a bullet
	if key == " " and game.ammo > 0 then
		love.audio.play(shoot)
		game.ammo = game.ammo - 1
		local bullet = {}
		bullet.x = game.playerx
		bullet.y = game.playery
		table.insert(game.bullets, bullet)
	end
end

-- Distance formula
function game.dist(x1,y1,x2,y2)
	return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2)
end