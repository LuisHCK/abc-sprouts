local SceneryInit = require('libs.scenery')
local scenery = SceneryInit({
    path = "scenes.menu",
    key = "menu",
    default = 'true'
}, {
    path = "scenes.gamescene",
    key = "gamescene"
})
-- Set the desired resolution 
local RESOLUTION = {
    width = 450,
    height = 450
}

function love.load()
    -- Called once at the start
    love.graphics.setBackgroundColor(250, 249, 233)
    love.window.setMode(RESOLUTION.width, RESOLUTION.height, {
        resizable = false
    })
    scenery:load()
end

function love.update(dt)
    -- Called every frame
    scenery:update(dt)
end

function love.draw()
    local overlay = love.graphics.newImage("assets/test-overlay.png")
    love.graphics.draw(overlay, 0, 0, 0, RESOLUTION.width / overlay:getWidth(), RESOLUTION.height / overlay:getHeight())

    -- Called every frame to draw on screen
    scenery:draw()

end
