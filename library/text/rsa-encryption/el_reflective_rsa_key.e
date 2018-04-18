note
	description: "RSA key reflectively createable from PKCS1 standard names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_REFLECTIVE_RSA_KEY

inherit
	EL_REFLECTIVE
		rename
			field_included as is_any_field
		redefine
			Import_name, print_fields
		end

	EL_MODULE_BASE_64

	EL_MODULE_RSA

feature {NONE} -- Initialization

	make_default
		deferred
		end

	make_from_map_list (map_list: EL_ARRAYED_MAP_LIST [STRING, STRING])
		local
			table: like field_table
		do
			make_default
			table := field_table
			from map_list.start until map_list.after loop
				table.search (map_list.item_key)
				if table.found then
					table.found_item.set (Current, Rsa.integer_x_from_hex_sequence (map_list.item_value))
				end
				map_list.forth
			end
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

	Default_exponent: INTEGER_X
		once
			create Result.make_from_integer (65537)
		end

	import_name: like Naming.default_export
		do
			Result := agent Naming.from_camel_case
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

end
