note
	description: "Hacker intercept configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 17:41:23 GMT (Wednesday 19th February 2025)"
	revision: "17"

class
	EL_404_INTERCEPT_CONFIG

inherit
	FCGI_SERVICE_CONFIG
		redefine
			building_action_table, make_default, make_from_file, on_context_exit
		end

	EL_MODULE_FILE

	EL_URI_FILTER_CONSTANTS

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

	maximum_rule_count: INTEGER
		-- max. number of IP addresses that can be blocked with
		-- Older blocks are removed to make way for newer ones.

	filter_table: EL_URI_FILTER_TABLE

	screen_session_name: ZSTRING
		-- screen session name of the address blocking script: run_service_update_firewall.sh
		-- See screen command -S option

feature {NONE} -- Build from XML

	append_filter (a_predicate: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached node.adjusted_8 (False) as lines then
				s.replace_character (lines, ';', '%N')
				filter_table.extend (lines, a_predicate)
			end
		end

	append_filter_set (a_predicate: STRING)
		do
		end

	append_white_listed (is_directory_item: BOOLEAN)
		do
			if attached last_white_list_name as name then
				across node.adjusted (False).lines as line loop
					across line.item.split (';') as split loop
						if is_directory_item then
							filter_table.put_whitelist (slash.joined (name, split.item))
						else
							if name.is_empty then
								filter_table.put_whitelist (split.item_copy)

							elseif split.item.count = 1 and then split.item [1] = '.' then
							-- '.' indicates the file is in the root directory
								filter_table.put_whitelist (name.twin)
							else
								filter_table.put_whitelist (slash.joined (split.item, name))
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

				["white_listed/item/@name",				agent do node.set (last_white_list_name) end],
				["white_listed/item/text()",				agent append_white_listed (False)],

				["white_listed/directory_item/@name",	agent do node.set (last_white_list_name) end],
				["white_listed/directory_item/text()",	agent append_white_listed (True)]
			>>)
			across << Predicate.starts_with, Predicate.ends_with >> as p loop
				Result [Xpath_match_text #$ [p.item]] := agent append_filter (p.item)
			end
		end

	on_context_exit
		do
			across << Predicate.has_extension, Predicate.first_step >> as p loop
				if attached (dir_path + File_match_text #$ [p.item]) as path
					and then path.exists
				then
					filter_table.extend (File.plain_text (path), p.item)
				end
			end
		end

feature {NONE} -- Internal attributes

	dir_path: DIR_PATH

	last_white_list_name: ZSTRING

	slash: EL_CHARACTER_32

end