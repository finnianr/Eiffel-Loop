note
	description: "Object for obtaining code names from code fields via object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 11:17:06 GMT (Wednesday 6th December 2017)"
	revision: "3"

deferred class
	EL_STATUS_CODE_REFLECTION [N -> {NUMERIC, HASHABLE}]

inherit
	EL_REFLECTION

	EL_ATTRIBUTE_NAME_TRANSLATEABLE

feature {NONE} -- Initialization

	initialize
		-- initialize fields with unique value
		local
			value: INTEGER_32_REF
		do
			create value
			do_with_numeric (agent initialize_field (?, ?, value))
		end

	make
		require
			valid_type: Field_type_info_table.has_key ({N})
		local
			object: like current_object
		do
			object := new_current_object (Current)
			create field_name_by_code.make (object.field_count)
			create code_by_field_name.make_equal (object.field_count)
			field_type_info := Field_type_info_table [{N}]
			initialize
			do_with_numeric (agent extend_field_tables)
			recycle (object)
		end

feature -- Access

	code (a_code_name: STRING): N
		local
			name: STRING; table: like code_by_field_name
		do
			name := String_pool.new_string; table := code_by_field_name
			import_name (a_code_name, name)
			table.search (name)
			if table.found then
				Result := table.found_item
			end
			String_pool.recycle (name)
		end

	code_name (a_code: N): STRING
		require
			has_code: is_valid_code (a_code)
		local
			name: STRING; found: BOOLEAN
			table: like field_name_by_code
		do
			table := field_name_by_code
			table.search (a_code)
			if table.found then
				name := table.found_item
				create Result.make (name.count)
				export_name (name, Result)
			else
				create Result.make_empty
			end
		end

feature -- Status query

	has_duplicate_code: BOOLEAN

	is_valid_code (a_code: N): BOOLEAN
		do
			Result := field_name_by_code.has_key (a_code)
		end

	is_valid_code_name (a_code_name: STRING): BOOLEAN
		do
			Result := code_by_field_name.has_key (a_code_name)
		end

feature {NONE} -- Implementation

	do_with_numeric (action: PROCEDURE [REFLECTED_REFERENCE_OBJECT, INTEGER])
		local
			object: like current_object
			i, field_count, numeric_type_id: INTEGER
		do
			object := new_current_object (Current) ; field_count := object.field_count
			numeric_type_id := field_type_info.type_id
			from i := 1 until i > field_count loop
				if object.field_type (i) = numeric_type_id then
					action (object, i)
				end
				i := i + 1
			end
			recycle (object)
		end

	extend_field_tables (object: like current_object; i: INTEGER)
		local
			name: STRING; get_value: FUNCTION [INTEGER, NUMERIC]
		do
			-- Report failure of `Field_info.get (i)' as a bug
			get_value := field_type_info.get; get_value.set_target (object)
			if attached {N} get_value (i) as value then
				name := object.field_name (i)
				field_name_by_code.put (name, value)
				code_by_field_name.extend (value, name)
			end
			has_duplicate_code := has_duplicate_code or field_name_by_code.conflict
		end

	initialize_field (object: like current_object; i: INTEGER; a_value: INTEGER_REF)
		local
			value: INTEGER; set: PROCEDURE [INTEGER, NUMERIC]
		do
			a_value.set_item (a_value.item + 1)
			value := a_value.item
			set := field_type_info.set
			set.set_target (object)
			inspect object.field_type (i)
				when Natural_8_type then
					set (i, value.to_natural_8)
				when Natural_16_type then
					set (i, value.to_natural_16)
				when Natural_32_type then
					set (i, value.to_natural_32)
				when Natural_64_type then
					set (i, value.to_natural_64)

				when Integer_8_type then
					set (i, value.to_integer_8)
				when Integer_16_type then
					set (i, value.to_integer_16)
				when Integer_32_type then
					set (i, value.to_integer_32)
				when Integer_64_type then
					set (i, value.to_integer_64)
			else
			end
		end

feature {NONE} -- Internal attributes

 	field_type_info: like Field_type_info_table.item

	field_name_by_code: HASH_TABLE [STRING, N]
		-- map field value to field name

	code_by_field_name: HASH_TABLE [N, STRING]
		-- map field name to field value

feature {NONE} -- Constants

	Field_type_info_table: EL_HASH_TABLE [
		TUPLE [type_id: INTEGER; get: FUNCTION [INTEGER, NUMERIC]; set: PROCEDURE [INTEGER, NUMERIC]],
		TYPE [NUMERIC]
	]
		local
			object: like Once_current_object
		once
			object := Once_current_object
			create Result.make (<<
				[{NATURAL_8}, [Natural_8_type, agent object.natural_8_field, agent object.set_natural_8_field]],
				[{NATURAL_16}, [Natural_16_type, agent object.natural_16_field, agent object.set_natural_16_field]],
				[{NATURAL_32}, [Natural_32_type, agent object.natural_32_field, agent object.set_natural_32_field]],
				[{NATURAL_64}, [Natural_64_type, agent object.natural_64_field, agent object.set_natural_64_field]],

				[{INTEGER_8}, [Integer_8_type, agent object.integer_8_field, agent object.set_integer_8_field]],
				[{INTEGER_16}, [Integer_16_type, agent object.integer_16_field, agent object.set_integer_16_field]],
				[{INTEGER_32}, [Integer_32_type, agent object.integer_32_field, agent object.set_integer_32_field]],
				[{INTEGER_64}, [Integer_64_type, agent object.integer_64_field, agent object.set_integer_64_field]]
			>>)
		end

invariant
	no_duplicate_codes: not has_duplicate_code
end
