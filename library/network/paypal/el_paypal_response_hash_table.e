note
	description: "Summary description for {EL_PAYPAL_RESPONSE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:59:15 GMT (Sunday 20th December 2015)"
	revision: "1"

class
	EL_PAYPAL_RESPONSE_HASH_TABLE

inherit
	EL_HTTP_HASH_TABLE
		redefine
			item, make_equal
		end

	EL_SHARED_PAYPAL_VARIABLES
		undefine
			is_equal, copy, default_create
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy, default_create
		end

	EL_SHARED_ONCE_STRINGS
		undefine
			is_equal, copy, default_create
		end

create
	make_equal, make_from_nvp_string

feature {NONE} -- Initialization

	make_equal (n: INTEGER)
		do
			Precursor (n)
			key_set := Once_key_set
		end

feature -- Access

	item (name: ZSTRING): ZSTRING
		do
			Result := Precursor (name)
			if Result.has_quotes (2) then
				Result.remove_quotes
			end
		end

	i_th_item (name_prefix: ZSTRING; i: INTEGER): ZSTRING
		local
			name: ZSTRING
		do
			name := empty_once_string
			name.append (name_prefix)
			name.append_z_code (Zero.natural_32_code + i.to_natural_32)
			Result := item (name)
		end

	name_value_pair (name: ZSTRING): TUPLE [name, value: ZSTRING]
		require
			valid_item: item (name).has ('=')
		local
			pos_equal: INTEGER;item_str: ZSTRING
		do
			item_str := item (name)
			pos_equal := item_str.index_of ('=', 1)
			if pos_equal > 0 then
				Result := [item_str.substring (1, pos_equal - 1), item_str.substring (pos_equal + 1, item_str.count)]
			else
				Result := [Empty_string, Empty_string]
			end
		end

feature {NONE} -- Constants

	Once_key_set: EL_HASH_SET [ZSTRING]
		local
			i: INTEGER
		once
			create Result.make_equal (50)
			from i := 1 until i > Variable.count loop
				if attached {ZSTRING} Variable.reference_item (i) as name then
					Result.put (name)
				end
				i := i + 1
			end
		end

	Zero: CHARACTER_32 = '0'

end