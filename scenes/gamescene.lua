local game = {}

-- Imports
local Animation = require("libs.animation")

-- Constants
local LETTER_DELAY = 1.5
local FADE_DURATION = 1.0
local LETTER_SPRITE_WIDTH = 390
local LETTER_SPRITE_HEIGHT = 320
local FLOWER_SCALE = 0.8
local ALPHABET_SCALE = 0.5
local ALPHABET_IMAGE_PATH = "assets/alphabet.png"

function game:load()
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    print("This is the game scene")
    -- Initialize flower animation: 200x170 frames (fits 1600x170 image), 0.1s duration, looping
    self.flower = Animation.new("assets/flower-1.png", 200, 170, 0.1, false)
    self.flower:setScale(FLOWER_SCALE)
    self.flower:setSpeed(0.5)

    -- Initialize alphabet using Animation lib (treated as a static sprite sheet)
    self.alphabet = Animation.new(ALPHABET_IMAGE_PATH, LETTER_SPRITE_WIDTH, LETTER_SPRITE_HEIGHT, 1, false)
    self.alphabet:stop() -- We control frames manually
    self.alphabet.currentFrame = 1 -- 'A'
    self.alphabet:setScale(ALPHABET_SCALE)

    -- State
    self.animationEnded = false
    self.timer = 0
    self.letterAlpha = 0
end

function game:draw()
    -- Draw the flower animation at position (400, 300)
    if self.flower then
        local flowerWidth = self.flower:getWidth()
        local flowerHeight = self.flower:getHeight()
        local x = (self.screenWidth - flowerWidth) / 2
        local y = (self.screenHeight - flowerHeight) / 2
        self.flower:draw(x, y)
    end

    -- Draw the letter 'A' (index 1) at the top center
    if self.letterAlpha > 0 then
        love.graphics.setColor(1, 1, 1, self.letterAlpha)
        
        local width = self.alphabet:getWidth()
        local height = self.alphabet:getHeight()
        local x = (self.screenWidth - width) / 2
        local y = (self.screenHeight - height) / 2
        
        self.alphabet:draw(x, y)
        
        love.graphics.setColor(1, 1, 1) -- Reset color to white
    end
end

function game:update(dt)
    self.timer = self.timer + dt

    if self.flower then
        self.flower:update(dt)
        if self.flower:hasEnded() then
            self.animationEnded = true
        end
    end
    
    if self.timer > LETTER_DELAY then
        local fadeProgress = (self.timer - LETTER_DELAY) / FADE_DURATION
        self.letterAlpha = math.min(1, fadeProgress)
    end

    -- Handle click to advance
    local isDown = love.mouse.isDown(1)
    if isDown and not self.wasDown and self.animationEnded then
        -- Check if we are at the last letter (Z)
        if self.alphabet.currentFrame >= self.alphabet.totalFrames then
            self.setScene("menu")
        else
            -- Reset flower
            self.flower:stop()
            self.flower:play()
            self.animationEnded = false
            
            -- Reset fade
            self.timer = 0
            self.letterAlpha = 0
            
            -- Next letter
            self.alphabet.currentFrame = self.alphabet.currentFrame + 1
        end
    end
    self.wasDown = isDown
end

function game:keyreleased(key)
    if key == "escape" then
        self.setScene("menu")
    end
end

return game
