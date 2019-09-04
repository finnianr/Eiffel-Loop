note
	description: "Rhythmbox constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-03 12:02:47 GMT (Tuesday 3rd September 2019)"
	revision: "6"

deferred class
	RHYTHMBOX_CONSTANTS

inherit
	EL_MODULE_URL

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

	ID3_comment_description: ZSTRING
		once
			Result := "c0"
		end

	Media_type: TUPLE [octet_stream, mpeg, plain_text, pyxis: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "application/octet-stream, audio/mpeg, text/plain, text/pyxis")
		end

	Media_type_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Media_type)
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

	Unescaped_location_characters: DS_HASH_SET [CHARACTER]
			--
		local
			l_set: STRING
		once
			create l_set.make_empty;
			l_set.append_string_general (Url.Rfc_digit_characters)
			l_set.append_string_general (Url.Rfc_lowalpha_characters)
			l_set.append_string_general (Url.Rfc_upalpha_characters)
			l_set.append_string_general ("/!$&*()_+-=':@~,.")
			Result := Url.new_character_set (l_set)
		end

	User_config_dir: EL_DIR_PATH
		once
			 Result := Directory.home.joined_dir_path (".gnome2/rhythmbox")
			 if not Result.exists then
				 Result := Directory.home.joined_dir_path (".local/share/rhythmbox")
			 end
		end

	Sync_table_name: ZSTRING
		once
			Result := "rhythmdb-sync.xml"
		end

end
