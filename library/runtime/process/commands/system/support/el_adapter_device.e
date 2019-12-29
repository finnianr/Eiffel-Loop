note
	description: "[
		Adapter device with types based on field `GENERAL.TYPE' from the
		[https://developer.gnome.org/NetworkManager/stable/nmcli.html nmcli] command output
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-29 16:19:57 GMT (Sunday 29th December 2019)"
	revision: "10"

class
	EL_ADAPTER_DEVICE

inherit
	ANY

	EL_MODULE_HEXADECIMAL

create
	make, make_default

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			make_default
			name.share (a_name)
		end

	make_default
		do
			create name.make_empty
			create type.make_empty
			create address.make_empty
			create description.make_empty
		end

feature -- Access

	address: ARRAY [NATURAL_8]

	name: ZSTRING

	description: ZSTRING

	type: STRING

feature -- Element change

	set_address_from_string (string: ZSTRING)
		require
			valid_address: valid_hardware_address (string)
		do
			address := new_hardware_address (string)
		end

	set_description (a_description: ZSTRING)
		do
			description := a_description
		end

	set_type (a_type: ZSTRING)
		do
			type := a_type
			type.to_lower
		end

feature -- Contract Support

	valid_hardware_address (value: ZSTRING): BOOLEAN
		do
			Result := value.occurrences (':') = MAC_address_colon_count
		end

feature {NONE} -- Factory

	new_hardware_address (string: ZSTRING): ARRAY [NATURAL_8]
		local
			byte_list: EL_ZSTRING_LIST
		do
			create byte_list.make_with_separator (string, ':', False)
			create Result.make_filled (0, 1, byte_list.count)
			across byte_list as byte loop
				Result [byte.cursor_index] := Hexadecimal.to_integer (byte.item.as_string_8).to_natural_8
			end
		end

feature {NONE} -- Constants

	MAC_address_colon_count: INTEGER = 5

end
