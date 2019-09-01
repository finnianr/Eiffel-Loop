note
	description: "Add album art task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:25:02 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	ADD_ALBUM_ART_TASK

inherit
	MANAGEMENT_TASK

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
				agent Database.add_song_picture (?, ?, ?, pictures)
			)
			Database.store_all
			log.exit
		end


end
