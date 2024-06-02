note
	description: "Eiffel class serializeable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-02 13:36:55 GMT (Sunday 2nd June 2024)"
	revision: "1"

deferred class
	EIFFEL_CLASS_SERIALIZEABLE

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			output_path as html_output_path
		redefine
			serialize
		end

	EL_THREAD_ACCESS [CODEBASE_METRICS]

	EL_EIFFEL_KEYWORDS

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_XML

	PUBLISHER_CONSTANTS; EL_ZSTRING_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	SHARED_CODEBASE_METRICS

	EL_SHARED_ZSTRING_BUFFER_SCOPES

feature -- Status query

	notes_filled: BOOLEAN

feature -- Basic operations

	serialize
		do
			if not notes_filled then
				fill_notes
			end
			Precursor
		end

feature {NONE} -- Deferred

	fill_notes
		deferred
		end

feature {NONE} -- Constants

	Class_begin_strings: EL_ZSTRING_LIST
		once
			create Result.make (3)
			across Class_declaration_keywords as l_word loop
				Result.extend (new_line * 1 + l_word.item)
			end
		end

	Default_notes: EIFFEL_NOTES
		once
			create Result.make_default
		end

	Template: STRING = ""

end