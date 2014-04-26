game = {}

function game.load()
	--background init
	game.clock = 0
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
end

function game.update(dt)
	-- clock for background
	game.clock = game.clock + dt
end

function game.keypressed(key)
end