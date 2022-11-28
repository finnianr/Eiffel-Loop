note
	description: "[
		Pattern can be searched for directly in source text using either
		**substring_index** or **index_of**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 5:49:52 GMT (Monday 28th November 2022)"
	revision: "1"

deferred class
	TP_SEARCHABLE

feature -- Access

	index_in (source_text: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		-- index of current literal text in `source_text'
		-- 0 if not found
		deferred
		end

	character_count: INTEGER
		deferred
		end
end