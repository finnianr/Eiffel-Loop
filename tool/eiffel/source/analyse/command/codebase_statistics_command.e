note
	description: "Count classes, code words and combined source file size for Eiffel source trees"
	tests: "[$source CODEBASE_STATISTICS_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 12:57:04 GMT (Thursday 6th January 2022)"
	revision: "14"

class
	CODEBASE_STATISTICS_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
		redefine
			make_default, execute
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_MODULE_FILE_SYSTEM

create
	make, make_default, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor {SOURCE_MANIFEST_COMMAND}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

	make (source_manifest_path: FILE_PATH; environ_variable: EL_DIR_PATH_ENVIRON_VARIABLE)
		do
			make_default
			environ_variable.apply
			make_command (source_manifest_path)
		end

feature -- Access

	byte_count: INTEGER

	word_count: INTEGER

	class_count: INTEGER

	mega_bytes: DOUBLE
		do
			Result := byte_count / 1000_000
		end

feature -- Basic operations

	execute
		do
			Precursor
			lio.put_new_line
			lio.put_integer_field ("Classes", class_count)
			lio.put_new_line
			lio.put_integer_field ("Words", word_count)
			lio.put_new_line
			if byte_count < 100000 then
				lio.put_integer_field ("Bytes", byte_count.to_integer_32)
			else
				lio.put_real_field ("Mega bytes", mega_bytes.truncated_to_real)
			end
			lio.put_new_line
		end

	process_file (source_path: FILE_PATH)
		do
			add_class_stats (create {CLASS_STATISTICS}.make_from_file (source_path))
		end

	add_class_stats (a_class: CLASS_STATISTICS_I)
		do
			class_count := class_count + 1
			word_count := word_count + a_class.word_count
			byte_count := byte_count + a_class.file_size
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_count", 		agent: INTEGER_REF do Result := class_count.to_reference end],
				["word_count", 		agent: INTEGER_REF do Result := word_count.to_reference end],
				["mega_bytes", 		agent: STRING do Result := Double.formatted (mega_bytes) end]
			>>)
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 1)
			Result.no_justify
		end

end