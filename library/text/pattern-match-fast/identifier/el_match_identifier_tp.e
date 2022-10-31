note
	description: "Match computer language identifier name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 9:49:04 GMT (Monday 31st October 2022)"
	revision: "3"

deferred class
	EL_MATCH_IDENTIFIER_TP

inherit
	EL_TEXT_PATTERN
		rename
			make_default as make
		redefine
			match_count
		end

feature -- Access

	name: STRING
		do
			Result := language_name + " identifier"
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			offset, l_count: INTEGER; done: BOOLEAN
		do
			l_count := text.count
			from offset := a_offset until offset = l_count or done loop
				if i_th_conforms (offset + 1, text, offset = a_offset) then
					Result := Result + 1

				else
					done := True
				end
				offset := offset + 1
			end
			if Result = 0 then
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- contract support
		do
			Result := across 1 |..| count as index all
				i_th_conforms (a_offset + index.item, text, index.item =1)
			end
		end

feature {NONE} -- Implementation

	language_name: STRING
		deferred
		end

	i_th_conforms (i: INTEGER_32; text: READABLE_STRING_GENERAL; is_first_character: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		deferred
		end

end