note
	description: "Tango mp3 file collator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-29 15:39:34 GMT (Monday 29th October 2018)"
	revision: "7"

class
	TANGO_MP3_FILE_COLLATOR

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_dir_path: like dir_path; a_is_dry_run: like is_dry_run)
		do
			is_dry_run := a_is_dry_run
			dir_path := a_dir_path
			create song_title_counts.make_equal (100)
		end

feature -- Basic operations

	execute
		local
			file_list: like OS.file_list
			per_page: INTEGER
		do
			log.enter ("execute")
			per_page := 50
			if dir_path.exists then
				file_list := OS.file_list (dir_path, "*.mp3")
				song_title_counts.accommodate (file_list.count)
				if is_dry_run then
					across file_list as mp3_path loop
						if mp3_path.cursor_index > per_page * 0 then
							relocate_mp3_file (mp3_path.item)
							if mp3_path.cursor_index \\ per_page = 0 then
								page := page + 1
								lio.put_integer_field ("Page", page);
								lio.put_new_line
								from until User_input.line ("Press return to continue").is_empty loop
									lio.put_new_line
								end
								lio.put_new_line
							end
						end
					end
				else
					across file_list as mp3_path loop
						relocate_mp3_file (mp3_path.item)
					end
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	dir_path: EL_DIR_PATH

	is_dry_run: BOOLEAN

	new_artist (id3_info: EL_ID3_INFO; mp3_path: EL_FILE_PATH): ZSTRING
		local
			path, result_lower: ZSTRING; found: BOOLEAN
		do
			Result := id3_info.artist
			if Result.is_empty then
				path := mp3_path.to_string
				Result := path
			end
			result_lower := Result.as_lower
			across Standard_artists_lower as artist until found loop
				if Result.count > artist.item.count
					and then result_lower.has_substring (artist.item)
					or else result_lower.has_substring (Standard_artist_words_lower.i_th (artist.cursor_index).last)
				then
					Result := Standard_artists [artist.cursor_index]
					found := True
				end
			end
			if Result = path then
				Result := Unknown
			end
			Result.left_adjust
		end

	new_genre (id3_info: EL_ID3_INFO): ZSTRING
		do
			Result := id3_info.genre
			if Result.is_empty or else Tango_genres.has (Result) then
				Result := Tango

			elseif Result.starts_with (Prefix_argentine) then
				Result.remove_head (Prefix_argentine.count)

			elseif Result ~ Electronica then
				Result := "Tango (Electro)"

			end
		end

	new_title (id3_info: EL_ID3_INFO; mp3_path: EL_FILE_PATH): ZSTRING
		do
			Result := id3_info.title
			if Result.is_empty then
				Result := mp3_path.base_sans_extension
			end
			-- Remove numbers and other rubbish from start
			from until Result.is_empty or else Result.unicode_item (1).is_alpha loop
				Result.remove_head (1)
			end
			Result.replace_character ('_', ' ')
		end

	page: INTEGER

	relocate_mp3_file (mp3_path: EL_FILE_PATH)
		local
			id3_info: EL_ID3_INFO; destination_mp3_path: EL_FILE_PATH
			title_count: INTEGER; genre, artist, title: ZSTRING
		do
			create id3_info.make_version (mp3_path, 2.4)
			genre := new_genre (id3_info)
			title := new_title (id3_info, mp3_path)
			artist := new_artist (id3_info, mp3_path)

			destination_mp3_path := dir_path.joined_file_tuple ([genre, artist, title])
			song_title_counts.search (destination_mp3_path)
			if song_title_counts.found then
				title_count := song_title_counts.found_item + 1
			else
				title_count := 1
			end
			song_title_counts [destination_mp3_path.twin] := title_count
			destination_mp3_path.add_extension (Double_digits.formatted (title_count))
			destination_mp3_path.add_extension ("mp3")

			if not is_dry_run then
				File_system.make_directory (destination_mp3_path.parent)
				OS.move_file (mp3_path, destination_mp3_path)
				File_system.delete_empty_branch (mp3_path.parent)
			end

			lio.put_path_field ("NEW", destination_mp3_path.relative_path (dir_path))
			lio.put_new_line
			if title ~ Unknown or else artist ~ Unknown then
				lio.put_path_field ("ORIGINAL", mp3_path.relative_path (dir_path))
				lio.put_new_line
			end
		end

	song_title_counts: EL_HASH_TABLE [INTEGER, EL_FILE_PATH]

feature {NONE} -- Constants

	Double_digits: FORMAT_INTEGER
		once
			create Result.make (2)
			Result.zero_fill
		end

	Electronica: ZSTRING
		once
			Result := "Electronica"
		end

	Prefix_argentine: ZSTRING
		once
			Result := "Argentine "
		end

	Standard_artist_words_lower: ARRAYED_LIST [EL_ZSTRING_LIST]
		once
			create Result.make (Standard_artists_lower.count)
			across Standard_artists_lower as name loop
				Result.extend (create {EL_ZSTRING_LIST}.make_with_words (name.item))
			end
		end

	Standard_artists: ARRAY [ZSTRING]
		once
			Result := <<
				"Alberto Moran",
				"Aníbal Troilo",
				"ngel D'Agostino",
				"Alfredo Gobbi",

				"Astor Piazzolla", -- Correct
				"Astor Piazzola",

				"Baffa-Berlingieri",
				"Carlos Di Sarli",
				"Edgardo Donato",
				"Francisco Canaro",
				"Juan D'Arienzo",
				"Jorge Dragone",
				"Lucio Demare",
				"Miguel Caló",
				"Pedro Laurenz",
				"Osvaldo Pugliese",
				"Roberto Goyeneche",
				"Rodolfo Biagi"
			>>
		end

	Standard_artists_lower: ARRAYED_LIST [ZSTRING]
		once
			create Result.make (Standard_artists.count)
			across Standard_artists as name loop
				Result.extend (name.item.as_lower)
			end
		end

	Tango: ZSTRING
		once
			Result := "Tango"
		end

	Tango_genres: ARRAY [ZSTRING]
		once
			Result := << "Latin", "(113)", "(4294967295)", "Traditional", "South/Central American" >>
			Result.compare_objects
		end

	Unknown: ZSTRING
		once
			Result := "Unknown"
		end

end
