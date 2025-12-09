local game = {}

-- Import scaling library for responsive layout
local scaling = require("libs.scaling")

-- Constants for visual configuration
local ICON_SCALE = 0.6 -- Base scale of the icon relative to screen
local PULSE_SPEED = 1.5 -- Speed of the pulsating animation
local TITLE = "ABC Sprouts" -- Game title text
local CTA = "Touch to Start" -- Call to action text

-- Initialize the scene
function game:load()
    print("This is the Main menu")
    -- Load the main icon image
    self.icon = love.graphics.newImage("assets/icon.png")
    -- Initialize animation timer
    self.timer = 0
end

-- Draw the scene contents
function game:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Draw the Title
    local font = love.graphics.newFont("assets/fredoka-bold.ttf", 42)
    love.graphics.setColor(love.math.colorFromBytes(140, 168, 201)) -- Light blue color
    love.graphics.setFont(font)
    local textWidth = font:getWidth(TITLE)
    love.graphics.printf(TITLE, 0, 30, screenWidth, "center")
    love.graphics.setColor(1, 1, 1) -- Reset color to white

    -- Draw the "Touch to Start" text at the bottom
    local ctaFont = love.graphics.newFont("assets/fredoka-bold.ttf", 28)
    love.graphics.setFont(ctaFont)
    local ctaTextWidth = ctaFont:getWidth(CTA)
    local ctaTextHeight = ctaFont:getHeight()
    love.graphics.setColor(love.math.colorFromBytes(237, 203, 185)) -- Beige color
    love.graphics.printf(CTA, 0, screenHeight - ctaTextHeight - 48, screenWidth, "center")
    love.graphics.setColor(1, 1, 1) -- Reset color

    -- Load UI sprite if not already loaded (lazy loading)
    if not self.uiSprite then
        self.uiSprite = love.graphics.newImage("assets/ui.png")
    end

    -- Draw the pulsating icon in the center
    if self.icon then
        local iconWidth = self.icon:getWidth()
        local iconHeight = self.icon:getHeight()

        -- Calculate pulse effect based on time
        local pulse = 1 + math.sin(self.timer * PULSE_SPEED) * 0.05
        -- Calculate position and scale to center the icon
        local x, y, scale = scaling.getScaleAndPosition(screenWidth, screenHeight, iconWidth, iconHeight,
            ICON_SCALE * pulse)

        love.graphics.draw(self.icon, x, y, 0, scale, scale)
    end
end

-- Update game logic
function game:update(dt)
    -- Update timer for animations
    self.timer = (self.timer or 0) + dt

    -- Handle mouse/touch input
    local isDown = love.mouse.isDown(1)
    if isDown and not self.wasDown then
        local mx, my = love.mouse.getPosition()

        -- Check if the icon was clicked
        if self.icon then
            local screenWidth = love.graphics.getWidth()
            local screenHeight = love.graphics.getHeight()
            local iconWidth = self.icon:getWidth()
            local iconHeight = self.icon:getHeight()

            -- Recalculate current icon position and size (including pulse) for accurate hit detection
            local pulse = 1 + math.sin(self.timer * PULSE_SPEED) * 0.05
            local x, y, scale = scaling.getScaleAndPosition(screenWidth, screenHeight, iconWidth, iconHeight,
                ICON_SCALE * pulse)
            local w = iconWidth * scale
            local h = iconHeight * scale

            -- Check collision between mouse and icon
            if mx >= x and mx <= x + w and my >= y and my <= y + h then
                self:switchScene()
            end
        end
    end
    -- Store input state for next frame to detect "just pressed" events
    self.wasDown = isDown
end

function game:switchScene()
    self.setScene("gamescene")
end

return game
