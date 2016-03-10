note
	description: "Summary description for {CORTINA_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:09:42 GMT (Wednesday 16th December 2015)"
	revision: "4"

class
	CORTINA_SET

inherit
	EL_ZSTRING_HASH_TABLE [EL_ARRAYED_LIST [RBOX_CORTINA_SONG]]
		rename
			make as make_string_table
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy, default_create
		end

	RHYTHMBOX_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_database: like database; a_config: like config; a_source_song: like source_song)
		local
			genre: ZSTRING
		do
			database := a_database; config := a_config; source_song := a_source_song
			make_equal (4)

			create tanda_type_counts.make (<<
				[Genre_tango, tango_count],
				[Genre_vals, vals_count],
				[Genre_milonga, vals_count],
				[Genre_other, vals_count],
				[Genre_foxtrot, (vals_count // 2).max (1)],
				[Tanda_type_the_end, 1]
			>>)

			across Tanda_types as tanda loop
				genre := tanda.item
				put (new_cortina_list (genre), genre)
			end
		end

feature -- Access

	end_song: RBOX_CORTINA_SONG
		do
			Result := item (Tanda_type_the_end).first
		end

	tango_count: INTEGER
		do
			Result := config.cortina_set.tango_count
		end

	vals_count: INTEGER
		do
			Result := tango_count // 4 + 1
		end

feature {NONE} -- Implementation

	new_cortina_list (genre: ZSTRING): like item
		local
			source_offset_secs, clip_duration: INTEGER; fade_in_duration, fade_out_duration: REAL
			cortina: RBOX_CORTINA_SONG
		do
			fade_in_duration := config.cortina_set.fade_in_duration
			fade_out_duration := config.cortina_set.fade_out_duration
			if genre ~ Tanda_type_the_end then
				clip_duration := source_song.duration
			else
				clip_duration := config.cortina_set.clip_duration
			end
			create Result.make (tanda_type_counts [genre])
			from until Result.full loop
				create cortina.make (database, source_song, genre, Result.count + 1, clip_duration)
				log_or_io.put_path_field ("Creating", cortina.mp3_path); log_or_io.put_new_line
				cortina.write_clip (source_offset_secs, fade_in_duration, fade_out_duration)
				Result.extend (cortina)
				source_offset_secs := source_offset_secs + clip_duration
 				if source_offset_secs + clip_duration > source_song.duration then
 					source_offset_secs := 0
 				end
			end
		end

feature {NONE} -- Implementation

	config: MANAGER_CONFIG

	source_song: RBOX_SONG

	database: RBOX_DATABASE

	tanda_type_counts: EL_ZSTRING_HASH_TABLE [INTEGER]

end
