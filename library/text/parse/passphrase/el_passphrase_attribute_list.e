note
	description: "[
		Map of password security `item_attribute' to boolean `item_has_attribute'
		Attributes are defined by enumeration [$source EL_PASSWORD_ATTRIBUTES_ENUM]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-07 11:50:27 GMT (Monday 7th September 2020)"
	revision: "1"

class
	EL_PASSPHRASE_ATTRIBUTE_LIST

inherit
	EL_ARRAYED_MAP_LIST [ZSTRING, BOOLEAN]
		rename
			make as make_with_count,
			item_key as item_attribute,
			item_value as item_has_attribute
		export
			{NONE} all
			{ANY} start, forth, after, item_attribute, item_has_attribute
		end

	EL_SHARED_PASSPHRASE_ATTRIBUTE

	EL_MODULE_DEFERRED_LOCALE

create
	make, make_empty

feature {NONE} -- Initialization

	make (passphrase: ZSTRING)
		local
			key: ZSTRING; i: INTEGER; c: CHARACTER_32
		do
			make_with_count (Passphrase_attribute.count)
			across Passphrase_attribute.list as value loop
				Locale.set_next_translation (Passphrase_attribute.description (value.item))
				key := Passphrase_attribute.field_name (value.item)
				key.enclose ('{', '}')
				extend (Locale * key, False)
			end
			from i := 1 until i > passphrase.count loop
				c := passphrase.unicode_item (i)
				if c.is_digit then
					i_th (Passphrase_attribute.has_numeric).value := True
				elseif c.is_alpha then
					if c.is_upper then
						i_th (Passphrase_attribute.has_upper_case).value := True
					else
						i_th (Passphrase_attribute.has_lower_case).value := True
					end
				else
					i_th (Passphrase_attribute.has_symbolic).value := True
				end
				i := i + 1
			end
			if passphrase.count >= 8 then
				i_th (Passphrase_attribute.has_at_least_8).value := True
			end
			if passphrase.count >= 12 then
				i_th (Passphrase_attribute.has_at_least_12).value := True
			end
		end

feature -- Measurement

	score: INTEGER
		do
			from start until after loop
				Result := Result + item_has_attribute.to_integer
				forth
			end
		end
end
