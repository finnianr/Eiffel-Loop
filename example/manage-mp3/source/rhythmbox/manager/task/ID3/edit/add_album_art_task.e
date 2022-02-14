note
	description: "[
		Add album art from folder `album_art_dir' and organized in sub-folders matching
		{[$source TL_PICTURE_TYPE_ENUM]}.name for all enumeration types.
	]"
	notes: "[
		If `create_folders' is true, create sub-folders for all picture types.

		Song fields are mapped to picture types according to mapping specified in `Picture_to_field_map'
		
			Picture_to_field_map: EL_ARRAYED_MAP_LIST [FUNCTION [RBOX_SONG, ZSTRING], ARRAY [NATURAL_8]]
				once
					create Result.make_from_array (<<
						[agent {RBOX_SONG}.lead_artist, Lead_artist_picture_types],
						[agent {RBOX_SONG}.album, Album_picture_types],
						[agent {RBOX_SONG}.composer, << p.composer >>],
						[agent {RBOX_SONG}.title_and_album, << p.movie_screen_capture, p.illustration, p.other >>]
					>>)
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:31:14 GMT (Monday 14th February 2022)"
	revision: "19"

class
	ADD_ALBUM_ART_TASK

inherit
	ID3_TASK
		redefine
			make
		end

	DATABASE_UPDATE_TASK

	TL_SHARED_PICTURE_TYPE_ENUM

	EL_MODULE_FILE_SYSTEM

	RHYTHMBOX_CONSTANTS

	EL_ITERATION_OUTPUT

create
	make

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: FILE_PATH)
		local
			picture_list: like new_picture_list
			picture_table: like picture_group_table.found_item
			picture: TL_ID3_PICTURE
		do
			Precursor (a_file_path)
			if album_art_dir.exists then
				picture_list := new_picture_list (OS.file_list (album_art_dir, "*.jpeg"))
			else
				create picture_list.make_empty
			end
			create picture_group_table.make (picture_list.count // 3)
			across picture_list as list loop
				picture := list.item
				if picture_group_table.has_key (picture.type_enum) then
					picture_table := picture_group_table.found_item
				else
					create picture_table.make (7)
					picture_group_table.extend (picture_table, picture.type_enum)
				end
				picture_table.put (picture, picture.description)
			end
		end

feature -- Access

	album_art_dir: DIR_PATH

feature -- Basic operations

	apply
		local
			picture_dir: DIR_PATH
		do
			if create_folders then
				across Picture_type.list as type loop
					picture_dir := album_art_dir #+ Picture_type.name (type.item)
					if not picture_dir.exists then
						File_system.make_directory (picture_dir)
					end
				end
			end
			update_pictures
			Database.store_all
		end

feature {EQA_TEST_SET} -- Implementation

	add_picture (song: RBOX_SONG; a_picture: TL_ID3_PICTURE)
		local
			mpeg: TL_MUSICBRAINZ_MPEG_FILE; mpeg_picture: TL_ID3_PICTURE
		do
			mpeg := song.mp3_info; mpeg_picture := mpeg.tag.picture
			if mpeg_picture.is_default or else mpeg_picture.same_type_and_description (a_picture) then
				lio.put_new_line
				lio.put_string_field ("Setting " + a_picture.type_name, a_picture.description)
				lio.put_new_line
				lio.put_path_field ("Song", song.mp3_relative_path)
				lio.put_new_line

				mpeg.tag.set_picture (a_picture)
				change_count := change_count + 1

				-- Both albumid fields need to be set in ID3 info otherwise
				-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
				mpeg.set_album_id (a_picture.checksum.out)
				mpeg.save
				mpeg.dispose
				song.set_album_picture_checksum (a_picture.checksum)
				song.update_file_info
				song.update_checksum
			end
			mpeg.dispose
		end

	cortina_type (song: RBOX_SONG): ZSTRING
		do
			if song.title.starts_with (Tanda.the_end) then
				Result := Tanda.the_end
			else
				Result := song.title.substring_between (Dot_space, Space_tanda, 1)
			end
		end

	new_picture_list (jpeg_path_list: LIST [FILE_PATH]): EL_ARRAYED_LIST [TL_ID3_PICTURE]
		local
			picture: TL_ID3_PICTURE; type_name: STRING
		do
			create Result.make (jpeg_path_list.count)
			across jpeg_path_list as jpeg loop
				type_name := jpeg.item.parent.base
				create picture.make (jpeg.item, jpeg.item.base_sans_extension, Picture_type.value (type_name))
				Result.extend (picture)
			end
		end

	p: like Picture_type
		do
			Result := Picture_type
		end

	song_picture (song: RBOX_SONG): TL_ID3_PICTURE
		local
			field_map: like Picture_to_field_map
			field_value: ZSTRING; found: BOOLEAN
			picture_table: like picture_group_table.found_item
		do
			Result := Default_picture; field_map := Picture_to_field_map
			if song.genre ~ Extra_genre.cortina
				and then picture_group_table.has_key (Picture_type.illustration)
			then
				field_value := cortina_type (song)
				picture_table := picture_group_table.found_item
				if picture_table.has_key (field_value) then
					Result := picture_table.found_item
				end
			else
				from field_map.start until field_map.after or found loop
					field_value := field_map.item_key (song)
					if not (field_value.is_empty or else field_value ~ Unknown_string) then
						across field_map.item_value as picture_code until found loop
							if picture_group_table.has_key (picture_code.item) then
								picture_table := picture_group_table.found_item
								if picture_table.has_key (field_value) then
									Result := picture_table.found_item
									found := True
								end
							end
						end
					end
					field_map.forth
				end
			end
		end

	update_pictures
		local
			picture: TL_ID3_PICTURE
		do
			change_count := 0; reset
			across Database.existing_songs as song loop
				print_progress (song.cursor_index.to_natural_32)
				picture := song_picture (song.item)
				if not picture.is_default and then picture.checksum /= song.item.album_picture_checksum then
					add_picture (song.item, picture)
				end
			end
			if change_count = 0 then
				lio.put_line ("No pictures changed")
			end
			lio.put_new_line
		end

feature {EQA_TEST_SET} -- Internal attributes

	create_folders: BOOLEAN

	picture_group_table: HASH_TABLE [HASH_TABLE [TL_ID3_PICTURE, ZSTRING], NATURAL_8]
		-- picture tables grouped by `Picture_type' enumeration value
		-- Table items indexed by picture description

	change_count: INTEGER

feature {NONE} -- String Constants

	Dot_space: ZSTRING
		once
			Result := ". "
		end

	Space_tanda: ZSTRING
		once
			Result := " tanda"
		end

feature {NONE} -- Constants

	Album_picture_types: ARRAY [NATURAL_8]
		once
			Result := <<
				p.back_cover, p.front_cover, p.leaflet_page, p.media,
				p.recording_location, p.other, p.publisher_logo, p.movie_screen_capture
			>>
		end

	Default_picture: TL_ID3_PICTURE
		once
			create Result.make_default
		end

	Lead_artist_picture_types: ARRAY [NATURAL_8]
		once
			Result := <<
				p.artist, p.band, p.band_logo, p.composer, p.conductor,
				p.during_performance, p.during_recording,
				p.lead_artist, p.lyricist, p.other, p.movie_screen_capture
			>>
		end

	Iterations_per_dot: NATURAL_32 = 50

	Picture_to_field_map: EL_ARRAYED_MAP_LIST [FUNCTION [RBOX_SONG, ZSTRING], ARRAY [NATURAL_8]]
		once
			create Result.make_from_array (<<
				[agent {RBOX_SONG}.lead_artist, Lead_artist_picture_types],
				[agent {RBOX_SONG}.album, Album_picture_types],
				[agent {RBOX_SONG}.composer, << p.composer >>],
				[agent {RBOX_SONG}.title_and_album, << p.movie_screen_capture, p.illustration, p.other >>]
			>>)
		end

end