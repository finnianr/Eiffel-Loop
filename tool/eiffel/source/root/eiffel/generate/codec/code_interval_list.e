note
	description: "List of character code intervals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-17 9:28:46 GMT (Friday 17th March 2023)"
	revision: "2"

class
	CODE_INTERVAL_LIST

inherit
	EL_ARRAYED_INTERVAL_LIST

create
	make_latin_subset, make

feature {NONE} -- Initialization

	make_latin_subset (latin_table: SPECIAL [LATIN_CHARACTER]; included: PREDICATE [LATIN_CHARACTER])
		local
			i: INTEGER
		do
			make (10)
			from i := 0 until i = 256 loop
				if included (latin_table [i]) then
					extend_upper (i)
				end
				i := i + 1
			end
		end

feature -- Status query

	has_character (latin: LATIN_CHARACTER): BOOLEAN
		do
			Result := some_interval_has (latin.code.to_integer_32)
		end

feature -- Conversion

	to_string: STRING
		do
			create Result.make (10)
			from start until after loop
				if index > 1 then
					Result.append (", ")
				end
				Result.append_integer (item_lower)
				if item_count > 1 then
					Result.append ("..")
					Result.append_integer (item_upper)
				end
				forth
			end
		end

end