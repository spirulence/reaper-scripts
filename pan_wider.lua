function get_selected_tracks()
  tracks = {}
  
  for index = 0, reaper.CountSelectedTracks() do
    track = reaper.GetSelectedTrack(0, index)
    table.insert(tracks, track)
  end
  
  return tracks
end

--effectively, distance between leftmost-panned and rightmost
--remember that 0.0 is center, -1.0 is 100% left etc
function get_pan_range(tracks)
  min = 0.0
  max = 0.0
  for _, track in ipairs(tracks) do
    noerror, _, pan = reaper.GetTrackUIVolPan(track)
    max = math.max(max, pan)
    min = math.min(min, pan)
  end
  
  return max - min
end


function pan_all_center(tracks)
  for _, track in ipairs(tracks) do
    reaper.SetMediaTrackInfo_Value(track, "D_PAN", 0.0)
  end
end

function lerp(a, b, our_index, max_index)
  t = (our_index - 1) / (max_index - 1)
  return a + (b - a) * t
end

function pan_distribute(tracks, pan_range)
  rightmost = (pan_range / 2)
  leftmost = -rightmost
  
  for index, track in ipairs(tracks) do
    pan = lerp(leftmost, rightmost, index, #tracks)
    reaper.SetMediaTrackInfo_Value(track, "D_PAN", pan)
  end
end


tracks = get_selected_tracks()
new_pan_range = get_pan_range(tracks) + 0.2

if new_pan_range >= 2.0 or #tracks == 1 then
  pan_all_center(tracks)
else
  pan_distribute(tracks, new_pan_range)
end


