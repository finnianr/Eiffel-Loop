note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 12:10:59 GMT (Saturday 15th March 2025)"
	revision: "11"

class
	EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]
		redefine
			append_item_to, is_i_th_white_space, initialize, set_separator_start
		end

	EL_SHARED_ZSTRING_CODEC

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Basic operations

	append_item_to (general: STRING_GENERAL)
		do
			if Empty_string.same_type (general) and then attached {ZSTRING} general as zstr then
				zstr.append_substring (target, item_lower, item_upper)
			else
				item.append_to_general (general)
			end
		end

	append_item_to_zstring (str: ZSTRING)
		do
			str.append_substring (target, item_lower, item_upper)
		end

feature {NONE} -- Implementation

	initialize
		do
			separator_zcode := Codec.as_z_code (separator)
		end

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
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