note
	description: "[
		Optimized implementation of [$source EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-02 10:48:14 GMT (Friday 2nd June 2023)"
	revision: "4"

class
	EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]
		redefine
			append_item_to, is_white_space, initialize, set_separator_start
		end

	EL_SHARED_ZSTRING_CODEC

	EL_MODULE_REUSEABLE

create
	make

feature -- Basic operations

	append_item_to (general: STRING_GENERAL)
		do
			if attached {ZSTRING} general as zstr then
				zstr.append_substring (target, item_lower, item_upper)
			else
				item.append_to_general (general)
			end
		end

feature {NONE} -- Implementation

	initialize
		do
			separator_zcode := Codec.as_z_code (separator)
		end

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

	set_separator_start
		do
			separator_start := target.index_of_z_code (separator_zcode, separator_end + 1)
		end

feature {NONE} -- Internal attributes

	separator_zcode: NATURAL

end