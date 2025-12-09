local Animation = {}
Animation.__index = Animation

function Animation.new(imagePath, frameWidth, frameHeight, duration, loop)
    local self = setmetatable({}, Animation)
    self.image = love.graphics.newImage(imagePath)
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.duration = duration or 0.1
    self.loop = loop
    if self.loop == nil then self.loop = true end
    
    self.scaleX = 1
    self.scaleY = 1
    
    self.quads = {}
    local imgWidth = self.image:getWidth()
    local imgHeight = self.image:getHeight()
    
    -- Calculate rows and columns
    local cols = math.floor(imgWidth / frameWidth)
    local rows = math.floor(imgHeight / frameHeight)
    
    -- Create quads for each frame
    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            table.insert(self.quads, love.graphics.newQuad(x * frameWidth, y * frameHeight, frameWidth, frameHeight, imgWidth, imgHeight))
        end
    end
    
    if #self.quads == 0 then
        print("Warning: No frames generated for " .. imagePath)
        print("Image size: " .. imgWidth .. "x" .. imgHeight)
        print("Frame size: " .. frameWidth .. "x" .. frameHeight)
    end
    
    self.currentFrame = 1
    self.timer = 0
    self.isPlaying = true
    self.totalFrames = #self.quads
    
    return self
end

function Animation:update(dt)
    if not self.isPlaying then return end
    
    self.timer = self.timer + dt
    if self.timer >= self.duration then
        self.timer = self.timer - self.duration
        self.currentFrame = self.currentFrame + 1
        
        if self.currentFrame > self.totalFrames then
            if self.loop then
                self.currentFrame = 1
            else
                self.currentFrame = self.totalFrames
                self.isPlaying = false
            end
        end
    end
end

function Animation:draw(x, y, r, sx, sy, ox, oy, kx, ky)
    if self.quads[self.currentFrame] then
        local scaleX = sx or self.scaleX
        local scaleY = sy or self.scaleY
        love.graphics.draw(self.image, self.quads[self.currentFrame], x, y, r, scaleX, scaleY, ox, oy, kx, ky)
    else
        print("Error: Frame " .. tostring(self.currentFrame) .. " not found. Total frames: " .. #self.quads)
    end
end

function Animation:setScale(sx, sy)
    self.scaleX = sx
    self.scaleY = sy or sx
end

function Animation:play()
    self.isPlaying = true
end

function Animation:stop()
    self.isPlaying = false
    self.currentFrame = 1
    self.timer = 0
end

function Animation:setSpeed(duration)
    self.duration = duration
end

function Animation:setLoop(loop)
    self.loop = loop
end

function Animation:getWidth()
    return self.frameWidth * self.scaleX
end

function Animation:getHeight()
    return self.frameHeight * self.scaleY
end

function Animation:hasEnded()
    return not self.loop and not self.isPlaying and self.currentFrame == self.totalFrames
end

return Animation
