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
	date: "2025-02-12 15:00:43 GMT (Wednesday 12th February 2025)"
	revision: "12"

class
	EL_URI_FIRST_STEP_404_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_NAMING; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create root_names_set.make_from (root_names_list, True)
			create foreign_extension_set.make_equal (0)
		end

feature -- Basic operations

	execute
		local
			request_list: EL_STRING_8_LIST; natural_input: EL_USER_INPUT_VALUE [NATURAL]
			request_counter_table: EL_COUNTER_TABLE [STRING]; prompt: STRING
			minimum_occurrences: NATURAL; filter_extensions: BOOLEAN
			excess_digit_count: INTEGER
		do
			Precursor
			create request_counter_table.make (500)
			create request_list.make (50)
			ask_to_filter_extensions
			filter_extensions := foreign_extension_set.count > 0
			across not_found_list as list loop
				if attached list.item as entry then
					if entry.has_excess_digits then
						excess_digit_count := excess_digit_count + 1

					elseif filter_extensions implies not has_foreign_extension (entry) then
						if attached uri_part (entry) as str and then str.count > 0 then
							request_counter_table.put (str)
						end
					end
				end
			end
			lio.put_integer_field ("Entries with digit count > " + config.maximum_uri_digits.out, excess_digit_count)
			lio.put_new_line
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
					if is_word_output then
						lio.put_words (request_list, 100)
					else
						lio.put_labeled_lines ("URI paths", request_list)
					end
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
							if include_uri_part (table.key) then
								request_list.extend (table.key)
							end
						end
					end
					request_list.sort (True)
					File_system.make_directory (path.parent)
					if is_word_output then
						File.write_text (path, request_list.joined_grouped_words (";", 160))
					else
						File.write_text (path, request_list.joined_lines)
					end
					Lio.put_path_field ("Saved %S", path)
					Lio.put_new_line_x2
				end
			end
		end

feature {NONE} -- Implementation

	ask_to_filter_extensions
		local
			extension_list: EL_STRING_8_LIST
		do
			lio.put_labeled_lines ("Foreign extensions", config.foreign_extensions.split ('%N'))
			lio.put_new_line
			if User_input.approved_action_y_n ("Exclude foreign extensions") then
				create extension_list.make_multiline_words (config.foreign_extensions, ';', 0)
				create foreign_extension_set.make_from (extension_list, True)
			end
		end

	configuration_words_path: FILE_PATH
		-- text file containing all `uri_part' that occur a minimum number of times specified by user
		do
			Result := config.text_output_dir + "match-first_step.txt"
		end

	is_word_output: BOOLEAN
		do
			Result := True
		end

	include_uri_part (uri_first_step: STRING): BOOLEAN
		do
			Result := not root_names_set.has (uri_first_step)
		end

	has_foreign_extension (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		do
			if attached entry.uri_extension as extension and then extension.count > 0 then
				Result := foreign_extension_set.has (extension)
			end
		end

	root_names_list: EL_STRING_8_LIST
		do
			Result := config.root_names_list
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.uri_step
		end

feature {NONE} -- Internal attributes

	foreign_extension_set: EL_HASH_SET [STRING]

	root_names_set: EL_HASH_SET [STRING];

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