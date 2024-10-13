note
	description: "Field types in `rhythmdb.c for Rhythmbox version 3.0.1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-12 8:46:02 GMT (Saturday 12th October 2024)"
	revision: "1"

class
	RBOX_DATABASE_FIELD_TYPES

feature -- Access

	type (field_code: N_16): N_16
		do
			Result := field_code & 0xFF
		end

feature {NONE} -- Implementation

	numbered_boolean (n: INTEGER): N_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_boolean
		end

	numbered_double (n: INTEGER): N_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_double
		end

	numbered_string (n: INTEGER): N_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_string
		end

	numbered_uint64 (n: INTEGER): N_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_uint64
		end

	numbered_ulong (n: INTEGER): N_16
		do
			Result := (n.to_natural_16 |<< 8) | G_type_ulong
		end

	hi_byte (n: INTEGER): N_16
		do
			Result := n.to_natural_16 |<< 8
		end

feature {NONE} -- Constants

	G_type_boolean: N_16 = 0

	G_type_double: N_16 = 0x1

	G_type_string: N_16 = 0x2

	G_type_uint64: N_16 = 0x4

	G_type_ulong: N_16 = 0x8

end