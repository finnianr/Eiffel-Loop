note
	description: "Summary description for {EL_XML_BASIC_ESCAPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_XML_CHARACTER_ESCAPER

inherit
	EL_CHARACTER_ESCAPER

create
	make, make_128_plus

feature {NONE} -- Initialization

	make
		do
			create predefined_entities.make (<<
				[{CHARACTER_32}'<', named_entity ("lt")],
				[{CHARACTER_32}'>', named_entity ("gt")],
				[{CHARACTER_32}'&', named_entity ("amp")],
				[{CHARACTER_32}'%'', named_entity ("apos")]
			>>)
			create character_intervals.make_empty (0)
		end

	make_128_plus
			-- include escaping of all codes > 128
		local
			array: ARRAY [like character_intervals.item]
			from_code, code: NATURAL
		do
			make
			from_code := 129
			array := << [from_code.to_character_32, code.Max_value.to_character_32] >>
			character_intervals := array.area
		end

feature -- Transformation

	escape_sequence (c: CHARACTER_32): STRING_32
		local
			entities: like predefined_entities
		do
			entities := predefined_entities
			entities.search (c)
			if entities.found then
				Result := entities.found_item
			else
				Result := named_entity (once "#" + c.natural_32_code.out)
			end
		end

feature -- Element change

	extend (c: CHARACTER_32; sequence: STRING_32)
		do
			predefined_entities [c] := sequence
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: STRING_32; c: CHARACTER_32)
		do
			str.append (escape_sequence (c))
		end

	named_entity (a_name: STRING): STRING_32
		do

			create Result.make_from_string (once "&" + a_name + once ";")
		end

	character_intervals: SPECIAL [TUPLE [from_code, to_code: CHARACTER_32]]

	predefined_entities: EL_HASH_TABLE [STRING_32, CHARACTER_32]

feature {NONE} -- Constants

	Characters: STRING_32
		once
			create Result.make (predefined_entities.count)
			predefined_entities.current_keys.do_all (agent Result.append_character)
		end

end
