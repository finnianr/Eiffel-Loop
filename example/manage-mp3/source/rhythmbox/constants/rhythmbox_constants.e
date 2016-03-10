note
	description: "Summary description for {RBOX_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 9:26:46 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	RHYTHMBOX_CONSTANTS

inherit
	EL_MODULE_URL
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY
		export
			{NONE} all
		end

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

	ID3_comment_description: ZSTRING
		once
			Result := "c0"
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

	Root_m3u_path_count: INTEGER_REF
			-- string count of M3U playlist root music path (used to calculate playlist size in mb)
			-- Example: "/storage/sdcard1/Music/"
		once
			create Result
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
