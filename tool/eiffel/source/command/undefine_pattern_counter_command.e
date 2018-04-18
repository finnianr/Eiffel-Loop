note
	description: "[
		Command operating on a source code tree manifest to count the number of classes containing the
		following code pattern:

			class MY_CLASS
			inherit
				A_CLASS
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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-11 15:15:18 GMT (Wednesday 11th April 2018)"
	revision: "2"

class
	UNDEFINE_PATTERN_COUNTER_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
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

	make (source_manifest_path: EL_FILE_PATH; environ_variable: EL_DIR_PATH_ENVIRON_VARIABLE)
		do
			make_default
			environ_variable.apply
			make_command (source_manifest_path)
		end

	make_default
		do
			make_machine
			Precursor {SOURCE_MANIFEST_COMMAND}
		end

feature -- Access

	class_count: INTEGER

	pattern_count: INTEGER

	total_class_count: INTEGER

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			Precursor
			lio.put_new_line
			lio.put_substitution ("Repetition of undefine pattern occurs in %S out of %S classes", [class_count, total_class_count])
			lio.put_new_line
			log.exit
		end

	process_file (source_path: EL_FILE_PATH)
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			total_class_count := total_class_count + 1
			pattern_count := 0
			create source_lines.make (source_path)
			do_once_with_file_lines (agent find_class_definition, source_lines)
			if pattern_count >= 2 then
				class_count := class_count + 1
			end
		end

feature {NONE} -- Line state handlers

	expect_end (line: ZSTRING)
		do
			if code_line ~ Keyword_end then
				state := agent find_class_name
			elseif code_line ~ Keyword_redefine then
				state := agent find_class_name
				pattern_count := pattern_count - 1
			end
		end

	expect_feature_list (line: ZSTRING)
		local
			feature_list: EL_SPLIT_ZSTRING_LIST
		do
			create feature_list.make (code_line, Comma_string)
			feature_list.enable_left_adjust
			if feature_list.for_all (agent Common_undefines.has) then
				pattern_count := pattern_count + 1
			end
			state := agent expect_end
		end

	find_undefine (line: ZSTRING)
		do
			if Excluded_keywords.has (code_line) then
				state := agent find_class_name
			elseif code_line ~ Keyword_undefine then
				state := agent expect_feature_list
			else
				state := agent find_class_name
			end
		end

	find_class_definition (line: ZSTRING)
		do
			if code_line_is_class_declaration then
				state := agent find_inherit
			end
		end

	find_inherit (line: ZSTRING)
		do
			if code_line_starts_with (0, Keyword_inherit) then
				state := agent find_class_name
			end
		end

	find_class_name (line: ZSTRING)
		do
			if code_line.starts_with (Keyword_feature) then
				state := final

			elseif code_line_is_type_identifier then
				state := agent find_undefine
			end
		end

feature {NONE} -- Constants

	Comma_string: ZSTRING
		once
			Result := ","
		end

	Common_undefines: ARRAY [ZSTRING]
		once
			Result := << "default_create", "is_equal", "out", "copy" >>
			Result.compare_objects
		end

	Excluded_keywords: ARRAY [ZSTRING]
		once
			Result := << "redefine", "export", "rename" >>
			Result.compare_objects
		end

end
