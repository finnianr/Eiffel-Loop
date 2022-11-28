note
	description: "Literal text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 6:45:32 GMT (Monday 28th November 2022)"
	revision: "4"

class
	TP_LITERAL_PATTERN

inherit
	TP_PATTERN
		redefine
			first_searchable, match_count
		end

	TP_SEARCHABLE

create
	make, make_caseless

feature {NONE} -- Initialization

	make (a_text: READABLE_STRING_GENERAL)
			--
		do
			set_text (a_text)
		end

	make_caseless (a_text: READABLE_STRING_GENERAL)
			--
		do
			set_text (a_text)
			is_caseless := True
		end

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
			--
		do
			text := new_text (a_text)
		end

feature -- Access

	character_count: INTEGER
		do
			Result := text.count
		end

	text: like new_text

feature -- Status query

	is_caseless: BOOLEAN

feature {NONE} -- Implementation

	first_searchable: detachable TP_SEARCHABLE
		-- first pattern that can be searched for in source text as literal string or character
		-- Void if none
		do
			if not is_caseless then
				Result := Current
			end
		end

	index_in (source_text: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		-- index of current literal text in `source_text'
		-- 0 if not found
		do
			Result := source_text.substring_index (text, start_index)
		end

	match_count (a_offset: INTEGER; source_text: like new_text): INTEGER
			--
		local
			text_count: INTEGER
		do
			text_count := text.count
			if (source_text.count - a_offset) >= text_count
				and then same_characters (source_text, a_offset, text_count)
			then
				Result := text_count
			else
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; source_text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := source_text.substring (a_offset + 1, a_offset + count).same_string (text)
		end

	name_inserts: TUPLE
		do
			Result := [text]
		end

	new_text (a_text: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			Result := a_text
		end

	same_characters (source_text: like new_text; a_offset, text_count: INTEGER): BOOLEAN
		do
			if is_caseless then
				Result := text.same_caseless_characters (source_text, a_offset + 1, a_offset + text_count, 1)
			else
				Result := text.same_characters (source_text, a_offset + 1, a_offset + text_count, 1)
			end
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "'%S'"
		end

end
