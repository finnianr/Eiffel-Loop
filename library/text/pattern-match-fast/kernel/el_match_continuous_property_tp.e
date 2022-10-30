note
	description: "Match consecutive characters that share the same property"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-30 10:53:27 GMT (Sunday 30th October 2022)"
	revision: "2"

deferred class
	EL_MATCH_CONTINUOUS_PROPERTY_TP

inherit
	EL_TEXT_PATTERN
		redefine
			match_count
		end

feature {NONE} -- Initialization

	make (a_minimum_match_count: INTEGER)
			--
		do
			make_default
			minimum_match_count := a_minimum_match_count
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			offset, l_count: INTEGER; done: BOOLEAN
		do
			l_count := text.count
			from offset := a_offset until offset = l_count or done loop
				if i_th_has (offset + 1, text) then
					Result := Result + 1
				else
					done := True
				end
				offset := offset + 1
			end
			if not (Result >= minimum_match_count) then
				Result := Match_fail
			end
		ensure then
			definition: Result > Match_fail implies
				across 1 |..| Result as index all i_th_has (a_offset + index.item, text) end
		end

feature -- Access

	minimum_match_count: INTEGER

feature {NONE} -- Implementation

	i_th_has (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character exhibits property
		deferred
		end

	spell_minimum: STRING
		do
			if minimum_match_count = 0 then
				Result := "zero"
			else
				Result := "one"
			end
		end

end