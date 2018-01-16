editor = reaper.MIDIEditor_GetActive()
take = reaper.MIDIEditor_GetTake(editor)

notes = {}

note_index = -1
note_index = reaper.MIDI_EnumSelNotes(take, note_index)
while note_index ~= -1 do
	table.insert(notes, note_index)
	note_index = reaper.MIDI_EnumSelNotes(take, note_index)
end

note_positions = {1, 3, 5}

MAJOR = 1
MINOR = 2
chord_types = {MAJOR, MINOR}

chords = {}
for _, note_index in ipairs(notes) do
	table.insert(chords, {
		note_index = note_index,
		note_position = note_positions[math.random(1, 3)],
		chord_type = chord_types[math.random(1, 2)]
	})
end

results = {
	[MAJOR] = {
		[1] = {4, 7},
		[3] = {-4, 3},
		[5] = {-7, -3}
	},
	[MINOR] = {
		[1] = {3, 7},
		[3] = {-3, 4},
		[5] = {-7, -4}
	}
}

function add_notes_at(original_index, relative_pitches, take)
	_, _, _, start_pos, end_pos, channel, pitch, velocity = reaper.MIDI_GetNote(take, original_index)
	for _, relative_pitch in ipairs(relative_pitches) do
		reaper.MIDI_InsertNote(take, false, false, start_pos, end_pos, channel, pitch + relative_pitch, velocity, true)
	end
end

for _, chord in ipairs(chords) do
	new_notes = results[chord.chord_type][chord.note_position]
	add_notes_at(chord.note_index, new_notes, take)
end

reaper.MIDI_Sort(take)


