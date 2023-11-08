note
	description: "[
		Displays reflective fields conforming to [$source EL_REFLECTED_FIELD] in call to [$source EL_REFLECTIVE].print_fields
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 10:30:26 GMT (Wednesday 8th November 2023)"
	revision: "4"

class
	EL_REFLECTIVE_CONSOLE_PRINTER

inherit
	ANY

	EL_SHARED_CLASS_ID; EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make_default, make_with_hidden

feature {NONE} -- Initialization

	make_default
		do
			create hidden_fields.make_empty
			escape_table := Default_escape_table
		end

	make_with_hidden (a_hidden_fields: STRING)
		do
			make_default
			hidden_fields.share (a_hidden_fields)
		end

feature -- Access

	hidden_fields: STRING
		-- comma-separated list of fields that will not be output by `EL_REFLECTIVE.print_fields'

	escape_fields: ARRAY [STRING]
		do
			Result := escape_table.current_keys
		end

feature -- Basic operations

	print_fields (a_object: EL_REFLECTIVE; a_lio: EL_LOGGABLE)
		local
			line_length: INTEGER_REF
		do
			create line_length
			across displayable_fields as field loop
				print_field_value (a_object, field.item, escape_table, line_length, a_lio)
			end
			a_lio.put_new_line
		end

feature -- Element change

	put_escaper (escaper: like escape_table.item; name: STRING)
		do
			if escape_table.is_empty then
				create escape_table.make_size (3)
			end
			escape_table.put (escaper, name)
		end

	set_displayable_fields (a_displayable_fields: like displayable_fields)
		do
			displayable_fields := a_displayable_fields
		end

	set_hidden_fields (a_hidden_fields: STRING)
		do
			hidden_fields := a_hidden_fields
		end

feature {NONE} -- Implementation

	print_field_value (
		a_object: EL_REFLECTIVE; a_field: EL_REFLECTED_FIELD; a_escape_table: like escape_table
		line_length: INTEGER_REF; a_lio: EL_LOGGABLE
	)
		local
			length: INTEGER; value: ZSTRING; exceeded_maximum: BOOLEAN
		do
			if attached {EL_REFLECTED_COLLECTION [ANY]} a_field as collection
				and then {ISE_RUNTIME}.type_conforms_to (collection.item_type_id, Class_id.EL_REFLECTIVE)
			then
				line_length.set_item (0)
				a_lio.put_new_line
				collection.print_items (a_object, a_lio)
			else
				across String_scope as scope loop
					value := scope.item
					a_field.append_to_string (a_object, value)
					if a_escape_table.has_key (a_field.name) then
						value.escape (a_escape_table.found_item)
					end
					if value.has (' ') then
						value.quote (3)
					end
					length := a_field.name.count + value.count + 2
					if line_length.item > 0 then
						exceeded_maximum := line_length.item + length > Info_line_length
						if not exceeded_maximum then
							a_lio.put_character (';'); a_lio.put_character (' ')
						end
						if exceeded_maximum then
							a_lio.put_new_line
							line_length.set_item (0)
						end
					end
					a_lio.put_labeled_string (a_field.name, value)
					line_length.set_item (line_length.item + length)
				end
			end
		end

feature {NONE} -- Internal attributes

	displayable_fields: SPECIAL [EL_REFLECTED_FIELD]

	escape_table: like Default_escape_table
		-- table of `EL_STRING_ESCAPER [ZSTRING]' objects used to escape field values for output to console

feature {NONE} -- Constants

	Default_escape_table: EL_HASH_TABLE [EL_STRING_ESCAPER [ZSTRING], STRING]
		once
			create Result
		end

	Info_line_length: INTEGER
		once
			Result := 100
		end

end