local scaling = {}

function scaling.getScaleAndPosition(containerW, containerH, contentW, contentH, scaleFactor)
    local scale = math.min((containerW * scaleFactor) / contentW, (containerH * scaleFactor) / contentH)
    local x = (containerW / 2) - ((contentW * scale) / 2)
    local y = (containerH / 2) - ((contentH * scale) / 2)
    return x, y, scale
end

return scaling
