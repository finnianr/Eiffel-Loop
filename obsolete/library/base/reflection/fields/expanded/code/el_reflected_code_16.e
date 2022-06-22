note
	description: "Reflected field for type [$source EL_CODE_16]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-16 13:51:14 GMT (Saturday 16th October 2021)"
	revision: "1"

class
	EL_REFLECTED_CODE_16

inherit
	EL_REFLECTED_ALPHA_NUMERIC_CODE [EL_CODE_16]
		redefine
			value
		end

create
	make

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): EL_CODE_16_REF
		do
			Result := value (a_object).to_reference
		end

	value (a_object: EL_REFLECTIVE): EL_CODE_16
		do
			enclosing_object := a_object
			Result.set_item ({ISE_RUNTIME}.natural_16_field (Item_index, object_address, 0))
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: EL_CODE_16)
		do
			enclosing_object := a_object
			{ISE_RUNTIME}.set_natural_16_field (Item_index, object_address, 0, a_value.item)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		local
			code: EL_CODE_16
		do
			code.set_item (a_value.to_natural_16)
			set (a_object, code)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		local
			code: EL_CODE_16
		do
			code.set_item (readable.read_natural_16)
			set (a_object, code)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_16 (value (a_object).item)
		end

feature {NONE} -- Implementation

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			code: EL_CODE_16
		do
			if string.is_empty then
				set (a_object, code)

			elseif attached Buffer_8.copied_general (string) as str_8 then
				code.set (str_8)
				set (a_object, code)
			end
		end

feature {NONE} -- Constants

	Item_index: INTEGER = 1

end