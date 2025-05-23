note
	description: "[
		RSA key reflectively createable from PKCS1 standard names. Base class for ${EL_RSA_PUBLIC_KEY}
		and ${EL_RSA_PRIVATE_KEY}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 9:38:08 GMT (Tuesday 29th April 2025)"
	revision: "19"

deferred class
	EL_REFLECTIVE_RSA_KEY

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version,
			foreign_naming as camel_case
		redefine
			extra_reader_writer_types, print_fields, is_storable_field, Use_default_values
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_from_map_list as make_settable_from_map_list
		end

	EL_MODULE_BASE_64; EL_MODULE_RSA

feature {NONE} -- Initialization

	make_from_pkcs1_table (table: HASH_TABLE [STRING, STRING])
		do
			make_default
			across table as pkcs1 loop
				set_table_field (field_export_table, pkcs1.key, create {INTEGER_X}.make_from_hex_string (pkcs1.item))
			end
		end

feature -- Access

	modulus: INTEGER_X
		deferred
		end

feature -- Basic operations

	print_fields (a_lio: EL_LOGGABLE)
		do
			a_lio.put_labeled_string ("Key type", generator)
			a_lio.put_new_line
			across field_table as field loop
				if attached {INTEGER_X} field.item.value (Current) as value then
					put_number (a_lio, field.item.name, value, True)
				end
			end
		end

feature {NONE} -- Implementation

	is_storable_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			if field.is_reference then
				Result := {ISE_RUNTIME}.type_conforms_to (field.static_type, Integer_x_type)
			end
		end

	extra_reader_writer_types: TUPLE [EL_INTEGER_X_READER_WRITER]
		do
			create Result
		end

	put_number (a_lio: EL_LOGGABLE; label: ZSTRING; number: INTEGER_X; indefinite_length: BOOLEAN)
		-- indefinite_length is a special case that indicates a form of encoding, known as "indefinite-length encoding,"
		-- is being used, in which case the end of this ASN.1 value's data is marked by two consecutive zero-value octets.
		local
			bytes: SPECIAL [NATURAL_8]; line: STRING
			i: INTEGER
		do
			bytes := number.as_bytes
			a_lio.put_labeled_string (label, "")
			a_lio.tab_right
			a_lio.put_new_line
			create line.make (3 * 15)
			if indefinite_length then
				line.append ("00:")
			end
			from i := 0 until i > bytes.upper loop
				line.append (bytes.item (i).to_hex_string.as_lower)
				line.append_character (':')
				if line.full then
					a_lio.put_line (line)
					line.wipe_out
				end
				i := i + 1
			end
			a_lio.put_line (line)
			a_lio.tab_left
			a_lio.put_new_line
		end

feature {NONE} -- Constants

	Default_exponent: INTEGER = 65537

	Integer_x_type: INTEGER
		once
			Result := ({INTEGER_X}).type_id
		end

	Use_default_values: BOOLEAN = False

end