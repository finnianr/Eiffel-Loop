note
	description: "Field conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 12:20:36 GMT (Monday 17th May 2021)"
	revision: "19"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]
		redefine
			write_crc
		end

feature -- Status query

	is_zero (a_object: EL_REFLECTIVE): BOOLEAN
		local
			l_zero: N
		do
			Result := value (a_object) = l_zero
		end

feature {NONE} -- Implementation

	append_indirectly (a_object: EL_REFLECTIVE; str: ZSTRING; a_representation: ANY)
		do
			if attached {EL_ENUMERATION [N]} a_representation as enumeration then
				if attached value (a_object) as v then
					str.append_string_general (enumeration.name (v))
				end
			end
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string_value (string))
		end

	set_indirectly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL; a_representation: ANY)
		do
			if attached {EL_ENUMERATION [N]} a_representation as enumeration then
				if attached Buffer_8.copied_general (string) as l_name then
					set (a_object, enumeration.value (l_name))
				end
			end
		end

	set (a_object: EL_REFLECTIVE; a_value: N)
		-- `a_value: like value' causes a segmentation fault in `{EL_REFLECTED_ENUMERATION}.set_from_string'
		deferred
		end

	string_value (string: READABLE_STRING_GENERAL): N
		deferred
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING
		local
			n, v: like field_value; str: STRING
		do
			v := value (a_object)
			if v = n.zero then
				Result := Zero
			elseif v = n.one then
				Result := One
			else
				str := Buffer_8.empty
				append (str, v)
				Result := str.twin
			end
		end

	to_string_indirectly (a_object: EL_REFLECTIVE; a_representation: ANY): STRING
		do
			if attached {EL_ENUMERATION [N]} a_representation as enumeration then
				Result := enumeration.name (value (a_object))
			else
				create Result.make_empty
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			if attached {EL_ENUMERATION [N]} representation as enumeration then
				across enumeration.field_table as table loop
					crc.add_string_8 (table.key)
					if attached {N} table.item.value (enumeration) as enum_value then
						write_crc_value (crc, enum_value)
					end
				end
			end
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: N)
		deferred
		end

feature {NONE} -- Constants

	One: STRING = "1"

	Zero: STRING = "0"

end