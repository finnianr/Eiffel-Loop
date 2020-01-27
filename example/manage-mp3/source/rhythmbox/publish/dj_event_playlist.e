note
	description: "[
		Playlist exported from Rhythmbox in Pyxis format with information about DJ gig.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-26 19:13:53 GMT (Sunday 26th January 2020)"
	revision: "15"

class
	DJ_EVENT_PLAYLIST

inherit
	PLAYLIST
		rename
			make as make_playlist
		redefine
			replace_cortinas, replace_song
		end

	EL_FILE_PERSISTENT_BUILDABLE_FROM_PYXIS
		undefine
			copy, is_equal
		redefine
			make_default, make_from_file, building_action_table, getter_function_table, Is_bom_enabled
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_LOG

	EL_MODULE_TIME

	EL_MODULE_DATE
		rename
			Date as Mod_date
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	SHARED_DATABASE

create
	make, make_from_file

feature {NONE} -- Initialization

	make (playlist: RBOX_PLAYLIST; a_dj_name: like dj_name; a_title: like title)
			--
		local
			word_list: EL_ZSTRING_LIST; date_str: STRING
		do
			make_default
			dj_name := a_dj_name; title := a_title
			word_list := playlist.name
			date_str := word_list.first.to_latin_1
			if Date_checker.date_valid (date_str, Name_date_format) then
				create date.make_from_string (date_str, Name_date_format)
				word_list.start; word_list.remove
			else
				create date.make_now
				is_publishable := False
			end
			venue := word_list.joined_words
			across playlist as l_song loop
				extend (l_song.item)
			end
		end

	make_default
		do
			make_playlist (20)
			create unplayed.make (Unplayed_name); unplayed.compare_objects
			title := Empty_string
			venue := Empty_string
			dj_name := Empty_string
			create start_time.make (0, 0, 0)
			create date.make_by_days (0)
			is_publishable := True
			Precursor
		end

	make_from_file (a_file_path: like output_path)
		do
			Precursor (a_file_path)
			checksum := new_checksum
		end

feature -- Access

	DJ_name: ZSTRING

	date: DATE

	formatted_month_date: ZSTRING
			--
		do
			Result := Mod_date.formatted (date, once "$long_month_name $canonical_numeric_month &nbsp;<i>($long_day_name)</i>")
		end

	html_page_name: ZSTRING
		do
			Result := output_path.base_sans_extension + ".html"
		end

	less_unplayed: EL_ARRAYED_LIST [RBOX_SONG]
		-- list less the unplayed songs
		do
			create Result.make (count - unplayed.count)
			from start until after loop
				if not unplayed.has (song) then
					Result.extend (song)
				end
				forth
			end
		end

	name: ZSTRING
		do
			Result := output_path.base_sans_extension
		end

	new_rbox_entry: RBOX_PLAYLIST_ENTRY
		do
			create Result.make (Current)
		end

	spell_date: ZSTRING
			--
		do
			Result := Mod_date.formatted (date, once "$short_day_name $canonical_numeric_month $long_month_name $year")
		end

	start_time: TIME

	title: ZSTRING

	unplayed: RBOX_PLAYLIST
		-- songs unplayed on the night (marked by the DJ with an X as first character of path)

	venue: ZSTRING

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := checksum /= new_checksum
		end

	is_publishable: BOOLEAN
		-- False if @ignore is set to true in DJ event list

feature -- Element change

	replace_cortinas (cortina_set: CORTINA_SET)
		do
			Precursor (cortina_set)
			unplayed.replace_cortinas (cortina_set)
		end

	replace_song (a_song, replacement_song: RBOX_SONG)
		do
			Precursor (a_song, replacement_song)
			unplayed.replace_song (a_song, replacement_song)
		end

feature {NONE} -- Implementation

	new_checksum: NATURAL
		local
			crc: like crc_generator
			both: ARRAY [PLAYLIST]
		do
			crc := crc_generator
			crc.add_tuple ([dj_name, title, venue, date.ordered_compact_date, start_time.compact_time, is_publishable])
			both := << Current, unplayed >>
			across both as list loop
				across list.item as l_song loop
					crc.add_path (l_song.item.mp3_path)
				end
			end
			Result := crc.checksum
		end

feature {NONE} -- Evolicity fields

	get_path_list: EL_ARRAYED_LIST [ZSTRING]
		local
			escaper: EL_PYTHON_ZSTRING_ESCAPER
		do
			create escaper.make (2)
			create Result.make (count)
			across Current as l_song loop
				Result.extend (l_song.item.mp3_relative_path.to_string.escaped (escaper))
				if unplayed.has (l_song.item) then
					Result.last.prepend_character ('X')
				end
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["path_list", 					agent get_path_list],
				["title", 						agent: like title do Result := title end],
				["DJ_name",						agent: like dj_name do Result := dj_name end],
				["venue",						agent: like venue do Result := venue end],
				["html_page_name", 			agent: like html_page_name do Result := html_page_name end],

				["ignore", 						agent: STRING do Result := (not is_publishable).out.as_lower end],
				["start_time",					agent: STRING do Result := start_time.formatted_out (once "hh:[0]mi") end],
				["spell_date", 				agent: ZSTRING do Result := spell_date end],
				["formatted_month_date",	agent: ZSTRING do Result := formatted_month_date end],
				["date", 						agent: STRING do Result := date.formatted_out (Date_format) end]
			>>)
		end

feature {NONE} -- Building from XML

	Root_node_name: STRING = "DJ-event"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@title", 				agent do title := node.to_string end],
				["@DJ_name",			agent do dj_name := node.to_string end],
				["@venue",				agent do venue := node.to_string end],
				["@date", 				agent set_date_from_node],
				["@start_time", 		agent set_start_time_from_node],
				["@ignore", 			agent do is_publishable := not node.to_boolean end],
				["mp3-path/text()", 	agent extend_from_path_node]
			>>)
		end

	extend_from_path_node
		local
			path: ZSTRING; is_unplayed: BOOLEAN
		do
			path := node.to_string
			is_unplayed := path [1] = 'X'
			if is_unplayed then
				path.remove_head (1)
			end
			if database.songs_by_location.has_key (database.music_dir + path) then
				extend (database.songs_by_location.found_item)
				if is_unplayed then
					unplayed.extend (last)
				end
			else
				lio.put_labeled_string ("Venue", venue)
				lio.put_labeled_string (" Date", date.formatted_out (Date_format))
				lio.put_new_line
				lio.put_labeled_string ("Exported song not found", path)
				lio.put_new_line
			end
		end

	set_date_from_node
		local
			str: STRING
		do
			str := node.to_string_8
			if Date_checker.date_valid (str, Date_format) then
				create date.make_from_string (str, Date_format)
			end
		end

	set_start_time_from_node
		local
			str: STRING
		do
			str := node.to_string_8
			if Time.is_valid (str) then
				create start_time.make_from_string (str, "hh:mi")
			end
		end

feature {NONE} -- Internal attributes

	checksum: NATURAL

feature {NONE} -- Constants

	Date_checker: DATE_VALIDITY_CHECKER
		once
			create Result
		end

	Date_format: STRING = "dd/mm/yyyy"

	Is_bom_enabled: BOOLEAN = False

	Name_date_format: STRING = "yyyy-mm-dd"

	Template: STRING = "[
		pyxis-doc:
			version = 1.0; encoding = "UTF-8"
		DJ-event:
			title = "$title"; date = "$date"; start_time = "$start_time"
			venue = "$venue"; DJ_name = "$DJ_name"; ignore = $ignore
			mp3-path:
			#across $path_list as $path loop
				"$path.item"
			#end
	]"

	Unplayed_name: ZSTRING
		once
			Result := "unplayed"
		end

end
