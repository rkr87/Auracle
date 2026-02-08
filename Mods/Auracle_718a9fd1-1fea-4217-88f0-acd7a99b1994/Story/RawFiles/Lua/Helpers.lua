local timer = 0

function WaitForSeconds(interval)
    timer = timer + 0.016
    if timer < interval then
        return true
    end
    timer = 0
    return false
end
