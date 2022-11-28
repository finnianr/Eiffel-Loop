note
	description: "Matches single literal character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 6:45:14 GMT (Monday 28th November 2022)"
	revision: "4"

class
	TP_LITERAL_CHAR

inherit
	TP_CHARACTER_PROPERTY
		redefine
			first_searchable
		end

	TP_SEARCHABLE

create
	make, make_with_action

feature {NONE} -- Initialization

	make (uc: CHARACTER_32)
			--
		do
			item := uc
		end

	make_with_action (a_item: like item; a_action: like Default_action)
			--
		do
			make (a_item); set_action (a_action)
		end

feature -- Access

	item: CHARACTER_32

	character_count: INTEGER
		do
			Result := 1
		end

feature {NONE} -- Implementation

	first_searchable: detachable TP_SEARCHABLE
		-- first pattern that can be searched for in source text as literal string or character
		-- Void if none
		do
			Result := Current
		end

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i] = item
		end

	index_in (source_text: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		-- index of current literal text in `source_text'
		-- 0 if not found
		do
			Result := source_text.index_of (item, start_index)
		end

	name_inserts: TUPLE
		do
			Result := [item]
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "'%S'"
		end
end