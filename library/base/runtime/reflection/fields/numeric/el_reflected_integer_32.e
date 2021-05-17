note
	description: "[
		[$source INTEGER_32] field
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 13:29:24 GMT (Monday 17th May 2021)"
	revision: "14"

class
	EL_REFLECTED_INTEGER_32

inherit
	EL_REFLECTED_NUMERIC_FIELD [INTEGER_32]
		rename
			field_value as integer_32_field
		redefine
			append_indirectly, reset, set_indirectly, to_string_indirectly, write_crc
		end

	EL_MODULE_TIME

create
	make

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			set (a_object, 0)
		end

	set (a_object: EL_REFLECTIVE; a_value: INTEGER_32)
		do
			enclosing_object := a_object
			set_integer_32_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_integer_32)
		end

	string_value (string: READABLE_STRING_GENERAL): INTEGER_32
		do
			Result := string.to_integer_32
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_32 (value (a_object))
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: INTEGER_32)
		do
			crc.add_integer_32 (enum_value)
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_32)
		do
			string.append_integer (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_integer_32 (v)
			end
		end

	append_indirectly (a_object: EL_REFLECTIVE; str: ZSTRING; a_representation: ANY)
		do
			if attached {DATE_TIME} a_representation as date_time then
				if attached value (a_object) as v then
					date_time.make_from_epoch (v)
					str.append_string_general (date_time.out)
				end
			else
				Precursor (a_object, str, a_representation)
			end
		end

	set_indirectly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL; a_representation: ANY)
		do
			if attached {DATE_TIME} a_representation as date_time then
				if attached Buffer_8.copied_general (string) as str_8 then
					date_time.make_from_string_default (str_8)
					set (a_object, Time.unix_date_time (date_time))
				end
			else
				Precursor (a_object, string, a_representation)
			end
		end

	to_string_indirectly (a_object: EL_REFLECTIVE; a_representation: ANY): STRING
		do
			if attached {DATE_TIME} a_representation as date_time then
				date_time.make_from_epoch (value (a_object))
				Result := date_time.out
			else
				Result := Precursor (a_object, a_representation)
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			if attached {DATE_TIME} representation as date_time then
				crc.add_string_8 (date_time.generator)
			end
		end

end