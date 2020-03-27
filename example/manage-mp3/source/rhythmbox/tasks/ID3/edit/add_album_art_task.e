note
	description: "Add album art task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-27 10:20:18 GMT (Friday 27th March 2020)"
	revision: "7"

class
	ADD_ALBUM_ART_TASK

inherit
	ID3_TASK
		redefine
			make
		end

	TL_SHARED_PICTURE_TYPE_ENUM

	EL_MODULE_STRING_8

create
	make

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		local
			picture_list: like new_picture_list
		do
			Precursor (a_file_path)
			if album_art_dir.exists then
				picture_list := new_picture_list (OS.file_list (album_art_dir, "*.jpeg"))
			else
				create picture_list.make_empty
			end
			create picture_group_table.make (agent picture_type_enum, picture_list)
		end

feature -- Access

	album_art_dir: EL_DIR_PATH

feature -- Basic operations

	apply
		local
			picture_table: EL_ZSTRING_HASH_TABLE [TL_ID3_PICTURE]
			picture: TL_ID3_PICTURE; jpeg_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("apply")
			jpeg_path_list := OS.file_list (album_art_dir, "*.jpeg")
			create picture_table.make_equal (jpeg_path_list.count)
			across jpeg_path_list as jpeg_path loop
				create picture.make (jpeg_path.item, jpeg_path.item.parent.base, Picture_type.conductor)
				picture_table [jpeg_path.item.base_sans_extension] := picture
			end
			across Database.songs.query (not song_is_hidden and song_has_artist_or_album_picture (picture_table)) as song loop
				add_song_picture (song.item, picture_table)
			end
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	add_song_picture (song: RBOX_SONG; picture_table: EL_ZSTRING_HASH_TABLE [TL_ID3_PICTURE])
		local
			picture: TL_ID3_PICTURE; mp3_info: TL_MPEG_FILE
		do
			mp3_info := song.mp3_info
			if song_has_artist_picture (picture_table).met (song) and then not mp3_info.tag.has_picture then
				picture := picture_table [song.artist]

			elseif song_has_album_picture (picture_table).met (song) and then song.album /~ Unknown then
				picture := picture_table [song.album]

			else
				create picture.make_default
			end
			if picture.data.count > 0 and then picture.checksum /= song.album_picture_checksum then
				lio.put_labeled_string ("Setting", picture.description.as_proper_case + " picture")
				lio.put_new_line
				lio.put_path_field ("Song", song.mp3_relative_path)
				lio.put_new_line
				lio.put_new_line

				mp3_info.tag.set_picture (picture)

				-- Both albumid fields need to be set in ID3 info otherwise
				-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
				across Musicbrainz_album_id_set as id loop
					mp3_info.tag.set_user_text (id.item, picture.checksum.out)
				end
				mp3_info.save
				song.set_album_picture_checksum (picture.checksum)
				song.update_checksum
			end
		end

	new_picture_list (jpeg_path_list: LIST [EL_FILE_PATH]): EL_ARRAYED_LIST [TL_ID3_PICTURE]
		local
			picture: TL_ID3_PICTURE; type_enum: NATURAL_8
			type_name: STRING
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

	picture_type_enum (picture: TL_ID3_PICTURE): NATURAL_8
		do
			Result := picture.type_enum
		end

feature {NONE} -- Internal attributes

	picture_group_table: EL_GROUP_TABLE [TL_ID3_PICTURE, NATURAL_8]

end
