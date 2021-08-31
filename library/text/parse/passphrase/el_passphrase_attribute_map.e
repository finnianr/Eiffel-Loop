note
	description: "[
		Map of password security `item_attribute' to boolean `item_has_attribute'
		Attributes are defined by enumeration [$source EL_PASSWORD_ATTRIBUTES_ENUM]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-31 14:48:51 GMT (Tuesday 31st August 2021)"
	revision: "7"

class
	EL_PASSPHRASE_ATTRIBUTE_MAP

inherit
	HASH_TABLE [BOOLEAN, ZSTRING]
		rename
			make as make_with_count
		export
			{NONE} all
			{ANY} new_cursor
		end

	EL_SHARED_PASSPHRASE_ATTRIBUTE

create
	make

feature {NONE} -- Initialization

	make
		do
			if attached Passphrase_attribute.text_list as text_list then
				make_with_count (text_list.count)
				across text_list as list loop
					extend (False, list.item)
				end
			end
		end

feature -- Measurement

	score: INTEGER
		do
			across Current as list loop
				Result := Result + list.item.to_integer
			end
		end

feature -- Element change

	update (passphrase: READABLE_STRING_GENERAL)
		local
			i: INTEGER; c: CHARACTER_32
		do
			reset
			from i := 1 until i > passphrase.count loop
				c := passphrase [i]
				if c.is_digit then
					force (True, Passphrase_attribute.has_numeric)
				elseif c.is_alpha then
					if c.is_upper then
						force (True, Passphrase_attribute.has_upper_case)
					else
						force (True, Passphrase_attribute.has_lower_case)
					end
				else
					force (True, Passphrase_attribute.has_symbolic)
				end
				i := i + 1
			end
			if passphrase.count >= 8 then
				force (True, Passphrase_attribute.has_at_least_8)
			end
			if passphrase.count >= 12 then
				force (True, Passphrase_attribute.has_at_least_12)
			end
		end

	reset
		do
			across current_keys as key loop
				force (False, key.item)
			end
		end

end