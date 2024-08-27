note
	description: "Deserialized response to Paypal HTTP method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 13:08:20 GMT (Tuesday 27th August 2024)"
	revision: "19"

class
	PP_HTTP_RESPONSE

inherit
	EL_URI_QUERY_TABLE
		rename
			make_url as make
		undefine
			is_equal
		end

	PP_SETTABLE_FROM_UPPER_CAMEL_CASE
		redefine
			new_field_printer
		end

	EL_MODULE_LIO

	EL_CHARACTER_32_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make_count (n: INTEGER)
		do
			make_default
			error_list := Default_error_list
		end

feature -- Access

	error_list: like Default_error_list

feature -- Basic operations

	print_errors
		local
			code: STRING
		do
			across error_list as list loop
				code := Code_prefix + list.item.code.out
				if Error_table.has_key_8 (code) then
					lio.put_labeled_lines (list.item.severity, Error_table.found_item_lines)
				else
					lio.put_labeled_string (list.item.severity, "Unknown error")
					lio.put_new_line
				end
			end
		end

	print_values
		do
			if is_ok then
				print_fields (lio)
			else
				print_error
			end
		end

feature -- Paypal fields

	ack: STRING

	build: NATURAL

	correlation_id: STRING

	email_link: STRING

	http_read_ok: BOOLEAN

	time_stamp: EL_ISO_8601_DATE_TIME

	version: STRING

feature -- Status query

	is_ok: BOOLEAN
		do
			Result := http_read_ok and ack.starts_with (Success)
			-- `starts_with' because "SuccessWithWarning" is a possible ACK value
		end

	has_errors: BOOLEAN
		do
			Result := error_list.count > 0
		end

feature -- Element change

	set_http_read_ok (a_http_read_ok: like http_read_ok)
		do
			http_read_ok := a_http_read_ok
		end

feature {NONE} -- Implementation

	print_error
		do
			lio.put_line ("ERROR")
		end

	set_name_value (key, value: EL_ZSTRING)
		local
			table: like field_table; s: EL_STRING_8_ROUTINES
			index_dot: INTEGER
		do
			table := field_table
			if table.has_imported_key (key) then
				if attached {EL_REFLECTED_DATE_TIME} table.found_item as date_time then
					index_dot := value.last_index_of ('.', value.count)
					if s.ends_with_character (date_time.format (Current), 'Z') and then index_dot > 0 then
					-- Correct invalid "2023-12-05T05:56:21.668" to "2023-12-05T05:56:21Z"
					-- (happens when an internal error is being reported)
						value.replace_substring_general (char ('Z'), index_dot, value.count)
					end
				end
				set_reflected_field (table.found_item, Current, value)
			else
				set_indexed_value (variable (key), value)
			end
		end

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): ZSTRING
		do
			Result := url.decoded
		end

	new_field_printer: EL_REFLECTIVE_CONSOLE_PRINTER
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		do
			create Result.make_with_hidden ("time_stamp")
		end

	set_error_entry (index: INTEGER; a_value: ZSTRING; is_code: BOOLEAN)
		do
			if error_list = Default_error_list then
				create error_list.make (1)
			end
			from until error_list.valid_index (index) or index > 5 loop
				error_list.extend ([0, Empty_string_8])
			end
			if index < 5 then
				if is_code then
					error_list [index].code := a_value.to_integer
				else
					error_list [index].severity := a_value.to_latin_1
				end
			end
		end

	set_indexed_value (var_key: PP_L_VARIABLE; a_value: ZSTRING)
		do
			if var_key.is_error then
				set_error_entry (var_key.index, a_value, var_key.is_error_code)
			end
		end

	variable (key: ZSTRING): PP_L_VARIABLE
		do
			Result := Once_variable
			Result.set_from_string (key)
		end

feature {NONE} -- Constants

	Default_error_list: EL_ARRAYED_LIST [TUPLE [code: INTEGER; severity: STRING]]
		once ("PROCESS")
			create Result.make_empty
		end

	Code_prefix: STRING = "n_"

	Error_table: EL_IMMUTABLE_STRING_8_TABLE
		once
			create Result.make ({EL_TABLE_FORMAT}.Indented_eiffel, "[
				n_10001:
					Internal Error
				n_11923:
					The button image value specified is invalid.
				n_11924:
					The button image URL specified is invalid.
				n_11925:
					The button type specified is invalid.
				n_11926:
					One of the parameters specified using ButtonVar is invalid.
				n_11927:
					The Buy Now button text specified is invalid.
				n_11928:
					The email or merchant ID specified is invalid.
				n_11929:
					A cart button must have an item name and amount specified.
				n_11931:
					The subscription button text specified is invalid.
				n_11932:
					You must specify a corresponding number of entries for option names and selections.
				n_11933:
					You cannot skip index numbers for option selections.
					Option selections must be specified sequentially.
				n_11934:
					You must specify the same number of entries for option prices and selections.
				n_11936:
					You cannot specify both an item price and prices for individual selections within an option.
				n_11937:
					A text box name specified is invalid.
					Text box names must not exceed 64 characters.
				n_11938:
					The button code value specified is invalid.	
				n_11940:
					An option name specified is invalid.
					Option names must not exceed 64 characters.
				n_11941:
					An option selection value specified is invalid.
					Option selection values must not exceed 64 characters.	
				n_11942:
					An option price value specified is invalid.
					Make sure any punctuation marks are in the correct places.
				n_11943:
					The button country value specified is invalid.
				n_11945:
					The button country and language code combination specified is invalid.
				n_11947:
					The tax rate specified is invalid.
					Make sure any punctuation marks are in the correct places
					and value specified is in the range 0.0 to 100.
				n_11948:
					The amount specified is invalid.
					Make sure any punctuation marks are in the correct places.
				n_12210:
					The currency code value specified is invalid.
				n_13117:
					Subtotal amount is not valid.
				n_13118:
					Tax amount is not valid.
				n_13119:
					Handling amount is not valid.
				n_13120:
					Shipping amount is not valid.
			]")
		end

	Once_variable: PP_L_VARIABLE
		once
			create Result.make_default
		end

	Success: STRING = "Success"

end