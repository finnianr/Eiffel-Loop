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

feature {NONE} -- Genres

	General_tango_genres: ARRAY [ZSTRING]
		once
			Result := << Genre_tango, Genre_vals, Genre_milonga, Genre_foxtrot >>
		end

	Genre_cortina: ZSTRING
		once
			Result := "Cortina"
		end

	Genre_foxtrot: ZSTRING
		once
			Result := "Foxtrot"
		end

	Genre_tango: ZSTRING
		once
			Result := "Tango"
		end

	Genre_vals: ZSTRING
		once
			Result := "Vals"
		end

	Genre_milonga: ZSTRING
		once
			Result := "Milonga"
		end

	Genre_other: ZSTRING
		once
			Result := "Other"
		end

	Genre_silence: ZSTRING
		once
			Result := "Silence"
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

	Media_types: EL_ZSTRING_LIST
		once
			create Result.make_from_array (
				<< "application/octet-stream", "audio/mpeg", Text_plain, Text_pyxis >>
			)
		end

	Text_plain: ZSTRING
		once
			Result := "text/plain"
		end

	Text_pyxis: ZSTRING
		once
			Result := "text/pyxis"
		end

	Tanda_types: ARRAY [ZSTRING]
		once
			Result := <<
				Genre_tango, Genre_vals, Genre_milonga, Genre_other, Genre_foxtrot, Tanda_type_the_end
			>>
		end

	Tanda_type_the_end: ZSTRING
		once
			Result := "THE END"
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
