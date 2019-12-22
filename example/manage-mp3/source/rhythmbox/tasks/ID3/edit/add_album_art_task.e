note
	description: "Add album art task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 10:41:35 GMT (Sunday 22nd December 2019)"
	revision: "5"

class
	ADD_ALBUM_ART_TASK

inherit
	ID3_TASK

create
	make

feature -- Access

	album_art_dir: EL_DIR_PATH

feature -- Basic operations

	apply
		local
			picture_table: EL_ZSTRING_HASH_TABLE [ID3_ALBUM_PICTURE]
			picture: ID3_ALBUM_PICTURE; jpeg_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("apply")
			jpeg_path_list := OS.file_list (album_art_dir, "*.jpeg")
			create picture_table.make_equal (jpeg_path_list.count)
			across jpeg_path_list as jpeg_path loop
				create picture.make_from_file (jpeg_path.item, jpeg_path.item.parent.base)
				picture_table [jpeg_path.item.base_sans_extension] := picture
			end
			across Database.songs.query (not song_is_hidden and song_has_artist_or_album_picture (picture_table)) as song loop
				add_song_picture (song.item, picture_table)
			end
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	add_song_picture (song: RBOX_SONG; picture_table: EL_ZSTRING_HASH_TABLE [ID3_ALBUM_PICTURE])
		local
			id3_info: ID3_INFO; picture: ID3_ALBUM_PICTURE
		do
			id3_info := song.id3_info
			if song_has_artist_picture (picture_table).met (song) and then not id3_info.has_album_picture then
				picture := picture_table [song.artist]

			elseif song_has_album_picture (picture_table).met (song) and then song.album /~ Unknown then
				picture := picture_table [song.album]

			else
				create picture
			end
			if picture.data.count > 0 and then picture.checksum /= song.album_picture_checksum then
				lio.put_labeled_string ("Setting", picture.description.as_proper_case + " picture")
				lio.put_new_line
				lio.put_path_field ("Song", song.mp3_relative_path)
				lio.put_new_line
				lio.put_new_line

				id3_info.set_album_picture (picture)

				-- Both albumid fields need to be set in ID3 info otherwise
				-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
				Musicbrainz_album_id_set.do_all (agent id3_info.set_user_text (?, id3_info.album_picture.checksum.out))
				id3_info.update
				song.set_album_picture_checksum (id3_info.album_picture.checksum)
				song.update_checksum
			end
		end

end
