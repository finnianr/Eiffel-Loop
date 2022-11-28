note
	description: "[
		Pattern that has literal text which can be searched for directly in source text using either
		**substring_index** or **index_of**
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 8:11:40 GMT (Monday 28th November 2022)"
	revision: "2"

deferred class
	TP_SEARCHABLE

feature -- Access

	name: STRING
		deferred
		end

	index_in (source_text: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		-- index of current literal text in `source_text'
		-- 0 if not found
		deferred
		end

	character_count: INTEGER
		deferred
		end

note
	descendants: "[
			TP_SEARCHABLE*
				[$source TP_LITERAL_CHAR]
					[$source TP_RSTRING_LITERAL_CHAR]
					[$source TP_ZSTRING_LITERAL_CHAR]
				[$source TP_LITERAL_PATTERN]
					[$source TP_RSTRING_LITERAL]
					[$source TP_ZSTRING_LITERAL]
	]"

end