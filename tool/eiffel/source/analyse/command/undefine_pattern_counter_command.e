note
	description: "[
		Command operating on a source code tree manifest to count the number of classes containing the
		following code pattern:

			class MY_CLASS
			inherit
				A_CLASS
					rename
						x as y
					undefine
						<feature list>
					end

				B_CLASS
					undefine
						<feature list>
					end
					
		where the feature list contains only identifiers defined in `Common_undefines'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 16:56:05 GMT (Monday 15th January 2024)"
	revision: "24"

class
	UNDEFINE_PATTERN_COUNTER_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make_default, execute
		end

	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

create
	make, make_default, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			make_machine
			create greater_than_0_list.make (20)
			Precursor {SOURCE_MANIFEST_COMMAND}
		end

feature -- Access

	Description: STRING = "[
		Count the number of classes in the source tree manifest that exhibit multiple inheritance of classes
		with an identical pattern of feature undefining.
	]"

	greater_than_0_list: EL_ARRAYED_MAP_LIST [ZSTRING, INTEGER]
		-- List of pattern counts > 0

feature -- Measurement

	class_count: INTEGER

	pattern_count: INTEGER

	total_class_count: INTEGER

feature -- Basic operations

	execute
		do
			Precursor
			if is_lio_enabled and then attached greater_than_0_list as list then
				from list.start until list.after loop
					lio.put_integer_field (list.item_key + " pattern count", list.item_value)
					lio.put_new_line
					list.forth
				end
			end
			lio.put_new_line
			lio.put_substitution (
				"Repetition of undefine pattern occurs in %S out of %S classes", [class_count, total_class_count]
			)
			lio.put_new_line
		end

	do_with_file (source_path: FILE_PATH)
		do
			total_class_count := total_class_count + 1
			pattern_count := 0
			do_once_with_file_lines (agent find_class_definition, open_lines (source_path, Latin_1))
			if pattern_count > 0 then
				greater_than_0_list.extend (source_path.base, pattern_count)
				if pattern_count >= 2 then
					class_count := class_count + 1
				end
			end
		end

feature {NONE} -- Line state handlers

	expect_end (line: ZSTRING)
		do
			if code_line ~ Keyword.end_ then
				state := agent find_class_name

			elseif code_line ~ Keyword.redefine_ then

				state := agent find_class_name
				pattern_count := pattern_count - 1
			end
		end

	expect_feature_list (line: ZSTRING)
		local
			feature_list: EL_SPLIT_ZSTRING_LIST
		do
			create feature_list.make_adjusted (code_line, ',', {EL_SIDE}.Left)
			if across feature_list as list all Common_undefines.has (list.item) end then
				pattern_count := pattern_count + 1
			end
			state := agent expect_end
		end

	find_class_definition (line: ZSTRING)
		do
			if code_line_is_class_declaration then
				state := agent find_inherit
			end
		end

	find_class_name (line: ZSTRING)
		do
			if code_line.starts_with (Keyword.feature_) then
				state := final

			elseif code_line_is_type_identifier then
				state := agent find_undefine
			end
		end

	find_inherit (line: ZSTRING)
		do
			if code_line_starts_with (0, Keyword.inherit_) then
				state := agent find_class_name
			end
		end

	find_not_renamed_as (line: ZSTRING)
		do
			if not code_line.has_substring (Padded_as) then
				if code_line ~ Keyword.end_ then
					state := agent find_class_name
				else
					state := agent find_undefine
					find_undefine (line)
				end
			end
		end

	find_undefine (line: ZSTRING)
		do
			if Excluded_keywords.has (code_line) then
				state := agent find_class_name

			elseif code_line ~ Keyword.rename_ then
				state := agent find_not_renamed_as

			elseif code_line ~ Keyword.undefine_ then
				state := agent expect_feature_list
			else
				state := agent find_class_name
			end
		end

feature {NONE} -- Constants

	Padded_as: ZSTRING
		once
			Result := " as "
		end

	Common_undefines: EL_ZSTRING_LIST
		once
			Result := "default_create, is_equal, out, copy"
		end

	Excluded_keywords: EL_ZSTRING_LIST
		once
			Result := "redefine, export"
		end

end