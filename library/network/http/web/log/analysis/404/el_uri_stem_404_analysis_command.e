note
	description: "[
		Command to analyze URI requests with status 404 (not found) by frequency of the
		normalized URI stem defined by function ${EL_WEB_LOG_ENTRY}.request_stem_lower.
		Saves selected URI-stems in `configuration_words_path' to help configure
		${EL_HACKER_INTERCEPT_CONFIG} import file.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-03 15:26:04 GMT (Monday 3rd February 2025)"
	revision: "6"

class
	EL_URI_STEM_404_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute
		end

	EL_MODULE_NAMING; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

create
	make

feature -- Basic operations

	execute
		local
			request_list: EL_STRING_8_LIST; natural_input: EL_USER_INPUT_VALUE [NATURAL]
			request_counter_table: EL_COUNTER_TABLE [STRING]; prompt: STRING
			occurrence_count, minimum_occurrences: NATURAL
		do
			Precursor
			create request_counter_table.make (500)
			create request_list.make (50)

			across not_found_list as list loop
				if attached uri_part (list.item) as str and then str.count > 0 then
					request_counter_table.put (str)
				end
			end
			if attached Naming.class_with_separator (Current, ' ', 1, 3) as name then
				lio.put_substitution ("REQUEST %S OCCURRENCE FREQUENCY", [name])
				lio.put_new_line
			end
			if attached request_counter_table.as_count_group_table as group_table then
				group_table.sort_by_key (False) -- most occurrences first
				across group_table as table loop
					create request_list.make_from_special (table.item_area)
					lio.put_natural_field ("OCCURRENCES", table.key)
					lio.put_new_line
					lio.put_words (request_list, 100)
					lio.put_new_line
				end
			end
			if attached configuration_words_path as path then
			-- save all `uri_part' if they occur a minimum number of times specified by user.
			-- Useful for configuring `EL_HACKER_INTERCEPT_CONFIG' import file.
				prompt := "Enter minimum occurrences for inclusion in file " + path.base.to_latin_1
				create natural_input.make (prompt)
				minimum_occurrences := natural_input.value
				if minimum_occurrences > 0 then
					request_list.wipe_out
					across request_counter_table as table loop
						if table.item >= minimum_occurrences then
							request_list.extend (table.key)
						end
					end
					File_system.make_directory (path.parent)
					File.write_text (path, request_list.joined_grouped_words (";", 80))
					Lio.put_path_field ("Saved %S", path)
					Lio.put_new_line_x2
				end
			end
		end

feature {NONE} -- Implementation

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.request_stem_lower
		end

	configuration_words_path: FILE_PATH
		-- text file containing all `uri_part' that occur a minimum number of times specified by user
		do
			Result := config.text_output_dir + "match-starts_with.txt"
		end

note
	notes: "[
		EXAMPLE REPORT
		(In descending order of request stem occurrence frequency)

			LOG LINE COUNTS
			Selected: 1098 Ignored: 3191

			REQUEST URI EXTENSION OCCURRENCE FREQUENCY
			OCCURRENCES: 13
			.png

			OCCURRENCES: 4
			.git/config

			OCCURRENCES: 3
			.json; .shtml
	]"

end