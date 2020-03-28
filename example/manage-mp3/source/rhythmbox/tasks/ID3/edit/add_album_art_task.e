note
	description: "[
		Add album art from folder `album_art_dir' and organized in sub-folders matching
		{[$source TL_PICTURE_TYPE_ENUM]}.name for all enumeration types.
	]"
	notes: "[
		If `create_folders' is true, create sub-folders for all picture types.

		Song fields are mapped to picture types according to mapping specified in `Picture_to_field_map'
		
			create Result.make_from_array (<<
				[agent {RBOX_SONG}.lead_artist, Lead_artist_picture_types],
				[agent {RBOX_SONG}.album, Album_picture_types],
				[agent {RBOX_SONG}.composer, << p.composer >>],
				[agent {RBOX_SONG}.title_and_album, << p.movie_screen_capture, p.illustration, p.other >>]
			>>)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-28 14:09:17 GMT (Saturday 28th March 2020)"
	revision: "8"

class
	ADD_ALBUM_ART_TASK

inherit
	ID3_TASK
		redefine
			make
		end

	TL_SHARED_PICTURE_TYPE_ENUM

	EL_MODULE_STRING_8

	EL_MODULE_FILE_SYSTEM

create
	make

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: EL_FILE_PATH)
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

	album_art_dir: EL_DIR_PATH

feature -- Basic operations

	apply
		local
			picture_dir: EL_DIR_PATH
		do
			log.enter ("apply")
			if create_folders then
				across Picture_type.list as type loop
					picture_dir := album_art_dir.joined_dir_path (Picture_type.name (type.item))
					if not picture_dir.exists then
						File_system.make_directory (picture_dir)
					end
				end
			end
			update_pictures
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	add_picture (song: RBOX_SONG; a_picture: TL_ID3_PICTURE)
		local
			mpeg: TL_MUSICBRAINZ_MPEG_FILE; mpeg_picture: TL_ID3_PICTURE
		do
			mpeg := song.mp3_info; mpeg_picture := mpeg.tag.picture
			if mpeg_picture.is_default or else mpeg_picture.same_type_and_description (a_picture) then
				lio.put_string_field ("Setting " + a_picture.type_name, a_picture.description)
				lio.put_new_line
				lio.put_path_field ("Song", song.mp3_relative_path)
				lio.put_new_line
				lio.put_new_line

				mpeg.tag.set_picture (a_picture)
				change_count := change_count + 1

				-- Both albumid fields need to be set in ID3 info otherwise
				-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
				mpeg.set_album_id (a_picture.checksum.out)
				mpeg.save
				song.set_album_picture_checksum (a_picture.checksum)
				song.update_checksum
			end
		end

	new_picture_list (jpeg_path_list: LIST [EL_FILE_PATH]): EL_ARRAYED_LIST [TL_ID3_PICTURE]
		local
			picture: TL_ID3_PICTURE; type_name: STRING
		do
			create Result.make (jpeg_path_list.count)
			across jpeg_path_list as jpeg loop
				type_name := jpeg.item.parent.base
				type_name.to_lower
				String_8.replace_character (type_name, ' ', '_')
				create picture.make (jpeg.item, jpeg.item.base_sans_extension, Picture_type.value (type_name))
				Result.extend (picture)
			end
		end

	song_picture (song: RBOX_SONG): TL_ID3_PICTURE
		local
			field_map: like Picture_to_field_map
			field_value: ZSTRING; found: BOOLEAN
			picture_table: like picture_group_table.found_item
		do
			Result := Default_picture; field_map := Picture_to_field_map

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

	update_pictures
		local
			picture: TL_ID3_PICTURE
		do
			change_count := 0
			across Database.songs.query (not song_is_hidden) as song loop
				picture := song_picture (song.item)
				if not picture.is_default and then picture.checksum /= song.item.album_picture_checksum then
					add_picture (song.item, picture)
				end
			end
			if change_count = 0 then
				lio.put_line ("No pictures changed")
			end
		end

feature {NONE} -- Internal attributes

	create_folders: BOOLEAN

	picture_group_table: HASH_TABLE [HASH_TABLE [TL_ID3_PICTURE, ZSTRING], NATURAL_8]
		-- picture tables grouped by `Picture_type' enumeration value
		-- Table items indexed by picture description

	change_count: INTEGER

feature -- Constants

	Album_picture_types: ARRAY [NATURAL_8]
		local
			p: like Picture_type
		once
			p := Picture_type
			Result := <<
				p.back_cover, p.front_cover, p.leaflet_page, p.media,
				p.recording_location, p.other, p.publisher_logo
			>>
		end

	Default_picture: TL_ID3_PICTURE
		once
			create Result.make_default
		end

	Lead_artist_picture_types: ARRAY [NATURAL_8]
		local
			p: like Picture_type
		once
			p := Picture_type
			Result := <<
				p.artist, p.band, p.band_logo, p.composer, p.conductor,
				p.during_performance, p.during_recording,
				p.lead_artist, p.lyricist, p.other
			>>
		end

	Picture_to_field_map: EL_ARRAYED_MAP_LIST [FUNCTION [RBOX_SONG, ZSTRING], ARRAY [NATURAL_8]]
		local
			p: like Picture_type
		once
			p := Picture_type
			create Result.make_from_array (<<
				[agent {RBOX_SONG}.lead_artist, Lead_artist_picture_types],
				[agent {RBOX_SONG}.album, Album_picture_types],
				[agent {RBOX_SONG}.composer, << p.composer >>],
				[agent {RBOX_SONG}.title_and_album, << p.movie_screen_capture, p.illustration, p.other >>]
			>>)
		end

end
