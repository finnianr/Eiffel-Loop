note
	description: "Hacker intercept configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-21 8:51:14 GMT (Friday 21st February 2025)"
	revision: "19"

class
	EL_404_INTERCEPT_CONFIG

inherit
	FCGI_SERVICE_CONFIG
		redefine
			building_action_table, make_default, make_from_file, on_context_exit
		end

	EL_URI_FILTER_BASE
		rename
			match_output_dir as dir_path
		end

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create filter_table.make
			create last_white_list_name.make_empty
			screen_session_name := "Firewall updating service"
			slash := '/'
			Precursor
		end

	make_from_file (a_file_path: FILE_PATH)
		do
			dir_path := a_file_path.parent
			Precursor (a_file_path)
		end

feature -- Access

	filter_table: EL_URI_FILTER_TABLE

	maximum_rule_count: INTEGER
		-- max. number of IP addresses that can be blocked with
		-- Older blocks are removed to make way for newer ones.

	screen_session_name: ZSTRING
		-- screen session name of the address blocking script: run_service_update_firewall.sh
		-- See screen command -S option

feature -- Status query

	missing_match_files: EL_STRING_8_LIST
		do
			create Result.make (0)
			across filter_table.predicate_list as p loop
				if attached new_match_path (p.item) as path and then not path.exists then
					Result.extend (path.base)
				end
			end
		end

feature {NONE} -- Build from XML

	append_white_listed (is_directory_item: BOOLEAN)
		local
			word_list: EL_STRING_8_LIST
		do
			if attached last_white_list_name as name then
				create word_list.make_multiline_words (node.adjusted_8 (False), ';', 0)
				across word_list as list loop
					if attached list.item as word then
						if is_directory_item then
							filter_table.put_whitelist (slash.joined (name, word))
						else
							if name.is_empty then
								filter_table.put_whitelist (word)

							elseif word.count = 1 and then word [1] = '.' then
							-- '.' indicates the file is in the root directory
								filter_table.put_whitelist (name.twin)
							else
								filter_table.put_whitelist (slash.joined (word, name))
							end
						end
					end
				end
				name.wipe_out
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["@maximum_rule_count",						agent do maximum_rule_count := node end],
				["@maximum_uri_digits",						agent do filter_table.set_maximum_uri_digits (node) end],
				["@screen_session_name",					agent do node.set (screen_session_name) end],

				["white_listed/item/@name",				agent do node.set_8 (last_white_list_name) end],
				["white_listed/item/text()",				agent append_white_listed (False)],

				["white_listed/directory_item/@name",	agent do node.set_8 (last_white_list_name) end],
				["white_listed/directory_item/text()",	agent append_white_listed (True)]
			>>)
		end

	on_context_exit
		do
			across filter_table.predicate_list as p loop
				if attached new_match_manifest (p.item) as manifest and then manifest.count > 0 then
					filter_table.extend (manifest, p.item)
				end
			end
		end

feature {NONE} -- Internal attributes

	dir_path: DIR_PATH

	last_white_list_name: STRING

	slash: EL_CHARACTER_32

end