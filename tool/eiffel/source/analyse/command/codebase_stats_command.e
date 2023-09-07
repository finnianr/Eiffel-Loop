note
	description: "Count classes, code words and combined source file size for Eiffel source trees"
	tests: "[$source EIFFEL_SOURCE_COMMAND_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-03 16:25:16 GMT (Sunday 3rd September 2023)"
	revision: "21"

class
	CODEBASE_STATS_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
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

feature -- Access

	Description: STRING = "[
		Count lines of eiffel code for combined source trees defined by a source tree manifest.
		Lines are counted starting from the class keyword and exclude comments and blank lines.
	]"

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

	do_with_file (source_path: FILE_PATH)
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
				["class_count",	agent: INTEGER_REF do Result := class_count.to_reference end],
				["word_count",		agent: INTEGER_REF do Result := word_count.to_reference end],
				["mega_bytes",		agent: STRING do Result := Double.formatted (mega_bytes) end]
			>>)
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 1)
			Result.no_justify
		end

end