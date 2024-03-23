note
	description: "[
		Basic string template to substitute variables names with possible forms:
		
			$a_1 OR ${a_1}
			
		and composed of characters in ranges
			
			'a' .. 'z'
			'A' .. 'Z'
			'0' .. '9'
			'_'
			
		For a literal dollar sign use % to escape it, for example: "USD 100 %$"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-23 8:14:31 GMT (Saturday 23rd March 2024)"
	revision: "18"

class
	EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_LIST [S]
		rename
			joined_strings as substituted,
			append_to as substitute_to,
			item as list_item,
			has as has_item,
			put as put_item,
			make as make_list
		export
			{NONE} all
			{ANY} substituted, substitute_to
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as variable_map_array,
			new_item as new_variable_map_array,
			actual_item as actual_variable_map_array
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_LAZY_ATTRIBUTE_2
		rename
			item as repeated_variable,
			new_item as new_repeated_variable,
			actual_item_2 as actual_repeated_variable
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

convert
	make ({S})

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
		local
			dollor_split: EL_SPLIT_ON_CHARACTER [S]; item: S; previous_end_character: CHARACTER_32
			i, length, start_index, end_index, variable_count: INTEGER; has_braces: BOOLEAN
		do
			create dollor_split.make (new_string (a_template), '$')
			variable_count := a_template.occurrences ('$')
			create variable_values.make_size (variable_count)
			make_list (variable_count * 2)
			across dollor_split as list loop
				item := list.item
				if list.cursor_index = 1 or else previous_end_character = '%%' then
					if previous_end_character = '%%' then
						last.put_code ({EL_ASCII}.Dollar, last.count)
					end
					if not item.is_empty then
						extend (item.twin)
					end
				else
					length := 0; has_braces := False
					from i := 1 until i > item.count loop
						inspect item [i]
							when 'a'.. 'z', 'A'.. 'Z', '0' .. '9', '_', '{' then
								length := length + 1
								i := i + 1
							when '}' then
								length := length + 1
								i := item.count + 1
								has_braces := True
						else
							i := item.count + 1
						end
					end
					if has_braces then
						start_index := 2; end_index := length - 1
					else
						start_index := 1; end_index := length
					end
					put_variable (item.substring (start_index, end_index).to_string_8)
					extend (last_value)
					if length < item.count then
						extend (item.substring (length + 1, item.count))
					end
				end
				if item.count > 0 then
					previous_end_character := item [item.count]
				else
					previous_end_character := '%U'
				end
			end
		end

feature -- Access

	variable_values: EL_STRING_8_TABLE [S]
		-- variable name list

feature -- Element change

	put (name: READABLE_STRING_8; value: S)
		require
			has_name: has (name)
		do
			if variable_values.has_key (name) then
				if variable_values.found_item = repeated_variable
					and then attached actual_variable_map_array as list
				then
					from list.start until list.after loop
						if list.item_key.same_string (name)
							and then attached {BAG [ANY]} list.item_value as bag
						then
							bag.wipe_out
							list.item_value.append (value)
						end
						list.forth
					end
				else
					if attached {BAG [ANY]} variable_values.found_item as bag then
						bag.wipe_out
					end
					variable_values.found_item.append (value)
				end
			end
		end

	put_general (name: READABLE_STRING_8; value: READABLE_STRING_GENERAL)
		do
			put (name, new_string (value))
		end

feature -- Status query

	has (name: READABLE_STRING_8): BOOLEAN
		do
			Result := variable_values.has (name)
		end

feature {NONE} -- Implementation

	new_repeated_variable: S
		do
			create Result.make_empty
		end

	new_variable_map_array: EL_ARRAYED_MAP_LIST [READABLE_STRING_8, S]
		do
			create Result.make_empty
		end

	put_variable (name: READABLE_STRING_8)
		do
			create last_value.make_empty
			variable_values.put (last_value, name)
			if not variable_values.inserted then
				if variable_map_array.is_empty then
					variable_map_array.extend (name, variable_values.found_item)
				end
				variable_map_array.extend (name, last_value)
				variable_values [name] := repeated_variable
			end
		end

feature {NONE} -- Internal attributes

	last_value: S

end