note
	description: "Playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 13:13:06 GMT (Wednesday 16th April 2025)"
	revision: "12"

deferred class
	PLAYLIST

inherit
	EL_ARRAYED_LIST [RBOX_SONG]
		rename
			item as song
		end

	RHYTHMBOX_CONSTANTS

	SHARED_DATABASE

feature -- Access

	cortina_tanda_type: ZSTRING
		require
			song_item_is_cortina: song.is_cortina
		local
			i: INTEGER
		do
			if islast then
				Result := Tanda.the_end
			else
				i := index + 1
				if valid_index (i) and then attached i_th (i).genre as genre then
					Tanda_types.find_first_true (agent genre.starts_with_zstring)
					if Tanda_types.after then
						Result := Tanda.other
					else
						Result := Tanda_types.item
					end
				else
					Result := Tanda.other
				end
			end
		end

	name: ZSTRING
		deferred
		end

feature -- Element change

	replace_cortinas (cortina_set: CORTINA_SET)
		local
			tanda_type: ZSTRING; was_removed: BOOLEAN
		do
			if is_template then
				replace_template (cortina_set)
			else
				across cortina_set as genre loop
					genre.item.start
				end
				from start until after loop
					was_removed := False
					if song.is_cortina then
						tanda_type := cortina_tanda_type
						if tanda_type ~ Tanda.the_end then
							replace (cortina_set.end_song)
						else
							if cortina_set.item (tanda_type).after then
								remove; was_removed := True
							else
								replace (cortina_set.item (tanda_type).item)
								cortina_set.item (tanda_type).forth
							end
						end
					end
					if not was_removed then
						forth
					end
				end
			end
		end

	replace_song (a_song, replacement_song: RBOX_SONG)
			-- Replace song item with alternative
		do
			from start until after loop
				if song = a_song then
					replace (replacement_song)
				end
				forth
			end
		end

feature -- Status query

	is_template: BOOLEAN
			-- true if playlist is template consisting only of cortinas
		do
			Result := across Current as l_song all l_song.item.is_cortina end
		end

feature {NONE} -- Implementation

	replace_template (cortina_set: CORTINA_SET)
		local
			i: INTEGER; cortina_list: ARRAYED_LIST [RBOX_CORTINA_SONG]; tanda_type: ZSTRING
		do
			from start until after loop
				if song.title ~ Tanda.the_end then
					replace (cortina_set.end_song)
					forth
				else
					tanda_type := song.title.substring (4, song.title.index_of (' ', 4) - 1)
					if cortina_set.has (tanda_type) then
						cortina_list := cortina_set [tanda_type]
						i := (song.title.item (1).natural_32_code - ('A').natural_32_code).to_integer_32 + 1
						if cortina_list.valid_index (i) then
							replace (cortina_list [i])
							forth
						else
							remove
						end
					else
						remove
					end
				end
			end
		end

end