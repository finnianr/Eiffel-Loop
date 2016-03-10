note
	description: "Summary description for {PLAYLIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYLIST

inherit
	EL_ARRAYED_LIST [RBOX_SONG]
		rename
			item as song
		end

	RHYTHMBOX_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal, copy
		end

create
	make

feature -- Access

	cortina_tanda_type: ASTRING
		require
			song_item_is_cortina: song.is_cortina
		local
			match_found: BOOLEAN; next_genre: ASTRING
		do
			if islast then
				Result := Tanda_type_the_end
			else
				next_genre := i_th (index + 1).genre
				across Tanda_types as type until match_found loop
					if next_genre.starts_with (type.item) then
						Result := type.item
						match_found := True
					end
				end
				if not match_found then
					Result := Genre_other
				end
			end
		end

feature -- Element change

	replace_cortinas (cortina_set: CORTINA_SET)
		local
			tanda_type: ASTRING; was_removed: BOOLEAN
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
						if tanda_type ~ Tanda_type_the_end then
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
			tanda_type: ASTRING
			i: INTEGER; cortina_list: ARRAYED_LIST [RBOX_CORTINA_SONG]
		do
			from start until after loop
				if song.title ~ Tanda_type_the_end then
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
