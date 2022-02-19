note
	description: "Cortina set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 12:02:27 GMT (Saturday 19th February 2022)"
	revision: "11"

class
	CORTINA_SET

inherit
	EL_ZSTRING_HASH_TABLE [EL_ARRAYED_LIST [RBOX_CORTINA_SONG]]
		rename
			make as make_string_table
		end

	RHYTHMBOX_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_LOG

	SHARED_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_cortina: like cortina; a_source_song: like source_song)
		local
			genre: ZSTRING
		do
			cortina := a_cortina; source_song := a_source_song
			make_equal (4)

			create tanda_type_counts.make (<<
				[Tango_genre.tango, tango_count],
				[Tango_genre.vals, vals_count],
				[Tango_genre.milonga, vals_count],
				[Extra_genre.other, vals_count],
				[Tango_genre.foxtrot, (vals_count // 2).max (1)],
				[Tanda.the_end, 1]
			>>)

			across Tanda_types as l_tanda loop
				genre := l_tanda.item
				put (new_cortina_list (genre), genre)
			end
		end

feature -- Access

	end_song: RBOX_CORTINA_SONG
		do
			if has_key (Tanda.the_end) then
				Result := found_item.first
			else
				create Result.make (source_song, Tanda.the_end, 1, 5)
			end
		end

	tango_count: INTEGER
		do
			Result := cortina.tango_count
		end

	vals_count: INTEGER
		do
			Result := tango_count // 4 + 1
		end

feature {NONE} -- Implementation

	new_cortina_list (genre: ZSTRING): like item
		local
			source_offset_secs, clip_duration: INTEGER
			cortina_song: RBOX_CORTINA_SONG
		do
			if genre ~ Tanda.the_end then
				clip_duration := source_song.duration
			else
				clip_duration := cortina.clip_duration
			end
			create Result.make (tanda_type_counts [genre])
			from until Result.full loop
				cortina_song := Database.new_cortina (source_song, genre, Result.count + 1, clip_duration)
				lio.put_path_field ("Creating %S", cortina_song.relative_mp3_path); lio.put_new_line
				cortina_song.write_clip (source_offset_secs, cortina.fade_in, cortina.fade_out)
				Result.extend (cortina_song)
				source_offset_secs := source_offset_secs + clip_duration
 				if source_offset_secs + clip_duration > source_song.duration then
 					source_offset_secs := 0
 				end
			end
		end

feature {NONE} -- Implementation

	cortina: CORTINA_SET_INFO

	source_song: RBOX_SONG

	tanda_type_counts: EL_ZSTRING_HASH_TABLE [INTEGER]

end