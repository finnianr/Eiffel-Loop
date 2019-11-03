note
	description: "Add album art task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-08 15:16:36 GMT (Tuesday 8th October 2019)"
	revision: "3"

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
			pictures: EL_ZSTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
			picture: EL_ID3_ALBUM_PICTURE
			jpeg_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("apply")
			jpeg_path_list := OS.file_list (album_art_dir, "*.jpeg")
			create pictures.make_equal (jpeg_path_list.count)
			across jpeg_path_list as jpeg_path loop
				create picture.make_from_file (jpeg_path.item, jpeg_path.item.parent.base)
				pictures [jpeg_path.item.base_sans_extension] := picture
			end
			Database.for_all_songs (
				not song_is_hidden and song_has_artist_or_album_picture (pictures),
				agent add_song_picture (?, ?, ?, pictures)
			)
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	add_song_picture (
		song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO
		pictures: EL_ZSTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
	)
		local
			picture: EL_ID3_ALBUM_PICTURE
		do
			if song_has_artist_picture (pictures).met (song) and then not id3_info.has_album_picture then
				picture := pictures [song.artist]

			elseif song_has_album_picture (pictures).met (song) and then song.album /~ Unknown then
				picture := pictures [song.album]

			else
				create picture
			end
			if picture.data.count > 0 and then picture.checksum /= song.album_picture_checksum then
				lio.put_labeled_string ("Setting", picture.description.as_proper_case + " picture")
				lio.put_new_line
				lio.put_path_field ("Song", relative_song_path)
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
