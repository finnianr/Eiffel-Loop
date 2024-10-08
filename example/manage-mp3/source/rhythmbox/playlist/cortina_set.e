note
	description: "Cortina set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:01:50 GMT (Sunday 22nd September 2024)"
	revision: "15"

class
	CORTINA_SET

inherit
	EL_ZSTRING_HASH_TABLE [EL_ARRAYED_LIST [RBOX_CORTINA_SONG]]
		rename
			make as make_sized
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
		do
			cortina := a_cortina; source_song := a_source_song
			create tanda_type_counts.make_assignments (<<
				[Tango_genre.tango,	 tango_count],
				[Tango_genre.vals,	 vals_count],
				[Tango_genre.milonga, vals_count],
				[Extra_genre.other,	 vals_count],
				[Tango_genre.foxtrot, (vals_count // 2).max (1)],
				[Tanda.the_end,		 1]
			>>)

			make_sized (Tanda_types.count)
			across Tanda_types as type loop
				if attached type.item as genre then
					put (new_cortina_list (genre), genre)
				end
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