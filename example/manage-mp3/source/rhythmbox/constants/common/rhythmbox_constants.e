note
	description: "Rhythmbox constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 7:22:00 GMT (Thursday 27th July 2023)"
	revision: "17"

deferred class
	RHYTHMBOX_CONSTANTS

inherit
	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

feature {NONE} -- Tango related

	Tanda: TUPLE [foxtrot, milonga, other, tango, vals, the_end: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Foxtrot, Milonga, Other, Tango, Vals, THE END")
		end

	Tanda_types: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Tanda)
		end

	Tango_genre: TUPLE [foxtrot, milonga, tango, vals: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Foxtrot, Milonga, Tango, Vals")
		end

	Tango_genre_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Tango_genre)
		end

	Extra_genre: TUPLE [cortina, other, silence: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Cortina, Other, Silence")
		end

feature {NONE} -- Paths

	User_config_dir: DIR_PATH
		once
			 Result := Directory.home #+ ".gnome2/rhythmbox"
			 if not Result.exists then
				 Result := Directory.home #+ ".local/share/rhythmbox"
			 end
		end

	Rhythmbox_db_path: FILE_PATH
		once
			 Result := User_config_dir + "rhythmdb.xml"
		end

feature {NONE} -- Constants

	Artist_type: TUPLE [artist, composer, performer, singer, soloist: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Artist, Composer, Performer, Singer, Soloist")
		end

	Artist_type_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Artist_type)
		end

	Default_album_artists: TUPLE [type: ZSTRING; list: EL_ZSTRING_LIST]
		once
			Result := [Unknown_string, create {EL_ZSTRING_LIST}.make_empty]
		end

	Encoded_location: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

	ID3_comment_description: ZSTRING
		once
			Result := "c0"
		end

	Media_type: TUPLE [octet_stream, mpeg, plain_text, pyxis: STRING]
		once
			create Result
			Tuple.fill (Result, "application/octet-stream, audio/mpeg, text/plain, text/pyxis")
		end

	Media_type_list: EL_STRING_8_LIST
		once
			create Result.make_from_tuple (Media_type)
		end

	Mp3_extension: ZSTRING
		once
			Result := "mp3"
		end

	Playlist_genre: ZSTRING
		-- special genre to mark Rhythmbox ignored entry as a DJ event playlist
		once
			Result := "playlist"
		end

	Picture_artist: ZSTRING
		once
			Result := "Artist"
		end

	Picture_album: ZSTRING
		once
			Result := "Album"
		end

	Unknown_string: ZSTRING
		once
			Result := "Unknown"
		end

	Unknown_artist_names: EL_ZSTRING_LIST
		once
			Result := "Various, Various Artists, Unknown"
		end

	Sync_table_name: ZSTRING
		once
			Result := "rhythmdb-sync.xml"
		end

end