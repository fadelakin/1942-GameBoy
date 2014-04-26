debug = false

function love.load()

	-- Load images (global assets)
	img_fn = {"bullet", "enemy", "player", "title", "background"}
	imgs = {}
	for _,v in ipairs(img_fn) do
		imgs[v]=love.graphics.newImage("assets/"..v..".gif")
	end

	-- Set filter to nearest
	for _,v in pairs(imgs) do
		v:setFilter("nearest", "nearest")
	end

	-- Play music and loop it.
	music = love.audio.newSource( "assets/music.ogg", "stream")
	music:setLooping(true)
	love.audio.play(music)

	-- load shoot sound
	shoot = love.audio.newSource( "assets/shoot.ogg", "static")

	-- Initialize font, and set it.
	font = love.graphics.newFont("assets/font.ttf", 14*scale)
	love.graphics.setFont(font)

	-- define colors (global assets)
	bgcolor = { r=148, g=191, b=19 }
	fontcolor = { r=46, g=115, b=46 }

	-- initial state
	state = "splash"

end

function love.draw()

	-- Set color
	love.graphics.setColor(bgcolor.r, bgcolor.g, bgcolor.b)

	-- Draw rectangle for background
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	-- Return the color back to normal
	love.graphics.setColor(255, 255, 255)

end

function love.update(dt)

end

function love.keypressed(key)
	if key == "`" then
		debug = not debug
	end

end