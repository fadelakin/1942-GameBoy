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
	end

	-- TODO: FIX THIS SO PLAYER COLLISION DETECTION FUCKING WORKS
	-- If a player gets too close to enemy
	--if game.dist(game.playerx,game.playery,ev.x,ev.y) < (12+8)*scale then
		--splash.load()
		--state = "splash"
	--end

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
end

function game.keypressed(key)
end

function game.dist(x1,y1,x2,y2)
	return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2)
end