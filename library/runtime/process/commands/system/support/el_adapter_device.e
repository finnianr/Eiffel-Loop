note
	description: "Adapter device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_ADAPTER_DEVICE

inherit
	EL_MODULE_HEXADECIMAL

create
	make

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			name := a_name
			type := ""
			address := create {like new_hardware_address}.make_empty
		end

feature -- Access

	address: like new_hardware_address

	name: ZSTRING

	type: ZSTRING

feature -- Element change

	set_address (address_string: ZSTRING)
		do
			address := new_hardware_address (address_string)
		end

	set_type (a_type: like type)
		do
			type := a_type
		end

feature {NONE} -- Factory

	new_hardware_address (address_string: ZSTRING): ARRAY [NATURAL_8]
		local
			byte_list: EL_ZSTRING_LIST
		do
			create byte_list.make_with_separator (address_string, ':', False)
			create Result.make_filled (0, 1, byte_list.count)
			across byte_list as byte loop
				Result [byte.cursor_index] := Hexadecimal.to_integer (byte.item.as_string_8).to_natural_8
			end
		end
end
