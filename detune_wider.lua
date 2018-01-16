function get_selected_takes()
  takes = {}
  
  for index = 0, reaper.CountSelectedMediaItems() - 1 do
    item = reaper.GetSelectedMediaItem(0, index)
    take = reaper.GetActiveTake(item)
    table.insert(takes, take)
  end
  
  return takes
end

--distance between lowest-tuned and highest-tuned
function get_pitch_range(takes)
  min = 0.0
  max = 0.0
  for _, take in ipairs(takes) do
    pitch = reaper.GetMediaItemTakeInfo_Value(take, "D_PITCH")
    max = math.max(max, pitch)
    min = math.min(min, pitch)
  end
  
  return max - min
end


function pitch_to_zero(takes)
  for _, take in ipairs(takes) do
    reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", 0.0)
  end
end

function random_between(a, b)
  towards_one = math.sqrt(math.random())
  towards_half = towards_one / 2
  directions = {-1, 1}

  skewed_towards_limits = 0.5 + directions[math.random(1,2)] * towards_half

  return a + (b - a) * skewed_towards_limits
end

function pitch_distribute(takes, pitch_range)
  max = (pitch_range / 2)
  min = -max
  
  for _, take in ipairs(takes) do
    pitch = random_between(min, max)
    reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", pitch)
  end
end


takes = get_selected_takes()
new_pitch_range = get_pitch_range(takes) + 0.2

if new_pitch_range >= 1.0 or #takes == 1 then
  pitch_to_zero(takes)
else
  pitch_distribute(takes, new_pitch_range)
end


