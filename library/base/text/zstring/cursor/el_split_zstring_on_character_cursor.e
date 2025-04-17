note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 12:51:52 GMT (Thursday 17th April 2025)"
	revision: "15"

class
	EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING, CHARACTER_32]
		redefine
			append_item_to, is_i_th_white_space, item, initialize, internal_item,
			set_separator, set_separator_start
		end

	EL_SHARED_ZSTRING_CODEC

	EL_STRING_HANDLER

create
	make_adjusted

feature {NONE} -- Initialization

	initialize
		do
			create internal_item.make_empty
			forth
		end

feature -- Access

	item: like target
		-- dynamic singular substring of `target' at current split position if the
		-- `target' conforms to `STRING_GENERAL' else the value of `item_copy'
		-- use `item_copy' if you intend to keep a reference to `item' beyond the scope of the
		-- client routine
		do
			Result := internal_item
			Result.wipe_out
			Result.append_substring (target, item_lower, item_upper)
		end

feature -- Basic operations

	append_item_to (general: STRING_GENERAL)
		do
			if conforms_to_zstring (general) and then attached {ZSTRING} general as zstr then
				zstr.append_substring (target, item_lower, item_upper)
			else
				item.append_to_general (general)
			end
		end

	append_item_to_zstring (str: ZSTRING)
		do
			str.append_substring (target, item_lower, item_upper)
		end

feature -- Element change

	set_separator (a_separator: like separator)
		do
			separator := a_separator
			separator_zcode := Codec.as_z_code (separator)
		end

feature {NONE} -- Implementation

	i_th_character (a_target: like target; i: INTEGER): CHARACTER_32
		-- i'th character of `a_target'
		do
			Result := a_target [i]
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

	internal_item: ZSTRING

	separator_zcode: NATURAL

end