note
	description: "[
		Example of a class that does not exemplify the
		[https://en.wikipedia.org/wiki/Don%27t_repeat_yourself DRY principle].
		Contrast 87 lines with [$source MY_DRY_CLASS].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	MY_WET_CLASS

create
	make

feature {NONE} -- Initialization

	make (data_import: like data_export)
		do
			set_from_table (data_import)
		end

feature -- Access

	boolean: BOOLEAN

	data_export: HASH_TABLE [STRING_32, STRING]
		do
			create Result.make (5)
			Result [Field_boolean] := boolean.out
			Result [Field_double] := double.out
			Result [Field_string] := string
			Result [Field_string_32] := string_32
			Result [Field_integer] := integer.out
			Result [Field_natural] := natural.out
			Result [Field_real] := real.out
		end

	double: DOUBLE

	integer: INTEGER

	natural: NATURAL

	real: REAL

	string: STRING

	string_32: STRING_32

feature -- Element change

	reset_fields
		do
			boolean := False
			double := 0
			natural := 0
			integer := 0
			real := 0
			string.wipe_out
			string_32.wipe_out
		end

	set_from_table (data_import: like data_export)
		do
			if data_import.has_key (Field_boolean) then
				boolean := data_import.found_item.to_boolean
			end
			if data_import.has_key (Field_double) then
				double := data_import.found_item.to_double
			end
			if data_import.has_key (Field_integer) then
				integer := data_import.found_item.to_integer
			end
			if data_import.has_key (Field_natural) then
				natural := data_import.found_item.to_natural
			end
			if data_import.has_key (Field_real) then
				real := data_import.found_item.to_real_32
			end
			if data_import.has_key (Field_string) then
				string := data_import.found_item
			else
				create string.make_empty
			end
			if data_import.has_key (Field_string_32) then
				string_32 := data_import.found_item
			else
				create string_32.make_empty
			end
		end

feature -- Basic operations

	print_fields (lio: EL_LOGGABLE)
		do
			across data_export as field loop
				lio.put_labeled_string (field.key, field.item)
				lio.put_new_line
			end
		end

feature {NONE} -- Variables

	Field_boolean: STRING = "boolean"

	Field_double: STRING = "double"

	Field_integer: STRING = "integer"

	Field_natural: STRING = "natural"

	Field_real: STRING = "real"

	Field_string: STRING = "string"

	Field_string_32: STRING = "string_32"

end