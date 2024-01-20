note
	description: "[
		A ${NATURAL_32_REF} for counting increments of 1 and with a zero-padding convenience function
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_NATURAL_32_COUNTER

inherit
	NATURAL_32_REF
		export
			{NONE} all
			{ANY} item, set_item
		end

	SINGLE_MATH
		export
			{NONE} all
		undefine
			is_equal, out
		end

feature -- Element change

	bump
		do
			set_item (item + 1)
		end

	reset
		do
			set_item (0)
		end

feature -- Access

	zero_padded (digit_count: INTEGER): STRING
		do
			Result := out
			if Result.count < digit_count then
				Result.grow (digit_count)
				from  until Result.count = digit_count loop
					Result.prepend_character ('0')
				end
			end
		end

end