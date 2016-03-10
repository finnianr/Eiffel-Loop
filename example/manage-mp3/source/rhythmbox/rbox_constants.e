note
	description: "Summary description for {RBOX_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	RBOX_CONSTANTS

inherit
	EL_MODULE_STRING
		undefine
			default_create
		end

	EL_MODULE_URL
		undefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			 user_config_dir := Execution.home_directory.joined_dir_path ({STRING_32} ".gnome2/rhythmbox")
			 if not user_config_dir.exists then
				 user_config_dir := Execution.home_directory.joined_dir_path ({STRING_32} ".local/share/rhythmbox")
			 end
		end

feature -- Access

	user_config_dir: EL_DIR_PATH

	Sync_info_name: EL_ASTRING
		once
			Result := {STRING_32} "rhythmdb-sync.xml"
		end

feature -- Constants

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

	ID3_comment_description: EL_ASTRING
		once
			Result := "c0"
		end

	Tanda_format: ARRAY [EL_ASTRING]
		once
			Result := << Genre_milonga, Genre_tango, Genre_tango, Genre_vals, Genre_tango, Genre_tango >>
		end

	General_tango_genres: ARRAY [EL_ASTRING]
		once
			Result := << Genre_tango, Genre_vals, Genre_milonga, "Foxtrot" >>
		end

	Genre_tango: EL_ASTRING
		once
			Result := "Tango"
		end

	Genre_vals: EL_ASTRING
		once
			Result := "Vals"
		end

	Genre_milonga: EL_ASTRING
		once
			Result := "Milonga"
		end

	Genre_silence: EL_ASTRING
		once
			Result := "Silence"
		end

	Genre_cortina: EL_ASTRING
		once
			Result := "Cortina"
		end

	Picture_artist: EL_ASTRING
		once
			Result := "Artist"
		end

	Picture_album: EL_ASTRING
		once
			Result := "Album"
		end

	Playlist_template: STRING = "[
		#EXTINF: $duration, $artists -- $genre - $title
		$location_path

	]"

end
