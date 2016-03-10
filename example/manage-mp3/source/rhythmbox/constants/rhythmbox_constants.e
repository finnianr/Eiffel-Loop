note
	description: "Summary description for {RBOX_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-15 11:38:48 GMT (Sunday 15th December 2013)"
	revision: "4"

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

	General_tango_genres: ARRAY [ASTRING]
		once
			Result := << Genre_tango, Genre_vals, Genre_milonga, Genre_foxtrot >>
		end

	Genre_cortina: ASTRING
		once
			Result := "Cortina"
		end

	Genre_foxtrot: ASTRING
		once
			Result := "Foxtrot"
		end

	Genre_tango: ASTRING
		once
			Result := "Tango"
		end

	Genre_vals: ASTRING
		once
			Result := "Vals"
		end

	Genre_milonga: ASTRING
		once
			Result := "Milonga"
		end

	Genre_other: ASTRING
		once
			Result := "Other"
		end

	Genre_silence: ASTRING
		once
			Result := "Silence"
		end

feature {NONE} -- Constants

	ID3_comment_description: ASTRING
		once
			Result := "c0"
		end

	Tanda_types: ARRAY [ASTRING]
		once
			Result := <<
				Genre_tango, Genre_vals, Genre_milonga, Genre_other, Genre_foxtrot, Tanda_type_the_end
			>>
		end

	Tanda_type_the_end: ASTRING
		once
			Result := "THE END"
		end

	Picture_artist: ASTRING
		once
			Result := "Artist"
		end

	Picture_album: ASTRING
		once
			Result := "Album"
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

	Sync_info_name: ASTRING
		once
			Result := {STRING_32} "rhythmdb-sync.xml"
		end

end
