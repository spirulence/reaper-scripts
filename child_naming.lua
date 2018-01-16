function get_selected_tracks()
  tracks = {}
  
  for index = 0, reaper.CountSelectedTracks() do
    track = reaper.GetSelectedTrack(0, index)
    table.insert(tracks, track)
  end
  
  return tracks
end

tracks = get_selected_tracks()

if #tracks > 0 then
  track = tracks[1]

  parent_name = "Autonamed Track                                               "
  noerror, parent_name = reaper.GetTrackName(reaper.GetParentTrack(track), parent_name)
  
  parent_name = parent_name:gsub("\\s+$", "") .. " %u"
  
  for index, track in ipairs(tracks) do
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", parent_name:format(index), true)
  end
end