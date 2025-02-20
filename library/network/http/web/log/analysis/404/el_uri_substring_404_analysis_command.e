note
	description: "[
		Command to analyze URI requests with status 404 (not found) by frequency of the
		request URI path defined by function ${EL_WEB_LOG_ENTRY}.uri_path.
		Saves selected extensions in `config.text_output_dir + output_name' to help configure
		${EL_HACKER_INTERCEPT_CONFIG} import file.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-20 15:21:24 GMT (Thursday 20th February 2025)"
	revision: "2"

deferred class
	EL_URI_SUBSTRING_404_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_NAMING; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_URI_FILTER_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create root_names_set.make_from (root_names_list, True)
			create foreign_starts_with_set.make_empty
			create foreign_extension_set.make_equal (0)
		end

feature -- Basic operations

	execute
		local
			request_list: EL_STRING_8_LIST; natural_input: EL_USER_INPUT_VALUE [NATURAL]
			request_counter_table: EL_COUNTER_TABLE [STRING]; prompt: STRING
			minimum_occurrences: NATURAL; excess_digit_count: INTEGER
			utf: EL_UTF_8_CONVERTER; invalid_utf_8: BOOLEAN
		do
			Precursor
			create request_counter_table.make (500)
			create request_list.make (50)
			ask_to_filter_extensions
			across not_found_list as list loop
				if attached list.item as entry then
					if entry.has_excess_digits then
						excess_digit_count := excess_digit_count + 1

					elseif not utf.is_valid_string_8 (entry.uri_path) then
						if not invalid_utf_8 then
							lio.put_line ("INVALID UTF-8")
							invalid_utf_8 := True
						end
						lio.put_line (entry.uri_path)

					elseif filter_foreign implies not matches_foreign (entry) then
						if attached uri_part (entry) as str and then str.count > 0 then
							request_counter_table.put (str)
						end
					end
				end
			end
			if invalid_utf_8 then
				User_input.press_enter
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
					request_list.sort (True)
					lio.put_natural_field ("OCCURRENCES", table.key)
					lio.put_new_line
					if grid_column_count > 1 then
						lio.put_columns (request_list, grid_column_count, grid_column_width)
					else
						lio.put_labeled_lines ("URI paths", request_list)
					end
					lio.put_new_line
				end
			end
			if attached (config.match_output_dir + File_match_text #$ [predicate_name]) as path then
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
					File.write_text (path, request_list.joined_lines)
					Lio.put_path_field ("Saved %S", path)
					Lio.put_new_line_x2
				end
			end
		end

feature {NONE} -- Implementation

	ask_to_filter_extensions
		do
			filter_foreign := False
			across << Predicate.has_extension, Predicate.starts_with >> as p loop
				lio.put_labeled_string ("PREDICATE", p.item)
				lio.put_new_line
				if attached config.new_match_manifest (p.item) as lines then
					lio.put_columns (lines.split ('%N'), 8, 6)
					lio.put_new_line
					if User_input.approved_action_y_n ("Exclude entries matching " + p.item) then
						filter_foreign := True
						if p.item = Predicate.has_extension then
							create foreign_extension_set.make (lines)

						elseif p.item = Predicate.starts_with  then
							create foreign_starts_with_set.make_with_lines (lines)
						end
					end
				end
			end
		end

	matches_foreign (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		do
			if attached entry.uri_extension as extension and then extension.count > 0 then
				Result := foreign_extension_set.has_8 (extension)
			end
			if not Result then
				Result := across foreign_starts_with_set as set some entry.uri_path.starts_with (set.item) end
			end
		end

	root_names_list: EL_STRING_8_LIST
		do
			Result := config.root_names_list
		end

feature -- Deferred

	grid_column_count: INTEGER
		-- number of grid columns to display `uri_path'
		deferred
		end

	grid_column_width: INTEGER
		-- maxium column width to display `uri_path' in grid columns
		deferred
		end

	include_uri_part (uri_first_step: STRING): BOOLEAN
		deferred
		end

	predicate_name: STRING
		-- predicate name for EL_URI_FILTER_TABLE
		deferred
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		deferred
		end

feature {NONE} -- Internal attributes

	filter_foreign: BOOLEAN

	foreign_extension_set: EL_IMMUTABLE_STRING_8_SET

	foreign_starts_with_set: EL_STRING_8_LIST

	root_names_set: EL_HASH_SET [STRING];

end