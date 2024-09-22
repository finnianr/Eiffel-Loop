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
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:13:35 GMT (Sunday 22nd September 2024)"
	revision: "24"

class
	EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_TEMPLATE_LIST [S, READABLE_STRING_8]

create
	make

convert
	make ({S})

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
		local
			dollor_split: EL_SPLIT_ON_CHARACTER [S]; item, template: S
			i, length, variable_count, offset, item_count: INTEGER
			previous_end_character: CHARACTER_32
		do
			template := new_string (a_template)
			create dollor_split.make (template, '$')
			variable_count := a_template.occurrences ('$')
			create place_holder_table.make (variable_count)
			make_list (variable_count * 2)
			across dollor_split as list loop
				item_count := list.item_count
				item := list.item; offset := list.item_lower
				if list.cursor_index = 1 or else previous_end_character = '%%' then
					if previous_end_character = '%%' then
						last.put_code ({EL_ASCII}.Dollar, last.count)
					end
					if item_count > 0 then
						extend (item.twin)
					end
				else
					length := 0
					from i := 1 until i > item_count loop
						inspect item [i]
							when 'a'.. 'z', 'A'.. 'Z', '0' .. '9', '_', '{' then
								length := length + 1
								i := i + 1
							when '}' then
								length := length + 1
								i := item_count + 1
						else
							i := item_count + 1
						end
					end
					put_substitution (template.substring (offset - 1, offset + length - 1))
					if length < item_count then
						extend (item.substring (length + 1, item_count))
					end
				end
				if item_count > 0 then
					previous_end_character := item [item_count]
				else
					previous_end_character := '%U'
				end
			end
		end

feature -- Access

	name_list: EL_ARRAYED_LIST [READABLE_STRING_8]
		-- variable name list
		do
			Result := place_holder_table.key_list
		end

feature -- Status query

	has (name: READABLE_STRING_8): BOOLEAN
		do
			Result := place_holder_table.has (name)
		end

feature {NONE} -- Implementation

	field_key (name: READABLE_STRING_8): READABLE_STRING_8
		do
			Result := name
		end

	found_item (name: READABLE_STRING_8): detachable S
		do
			if place_holder_table.has_key (name) then
				Result := place_holder_table.found_item
			end
		end

	key (str: READABLE_STRING_8): READABLE_STRING_8
		do
			Result := str
		end

	put_substitution (variable: S)
		require
			latin_1_characters: variable.is_valid_as_string_8
		local
			place_holder: S; name: STRING_8
		do
			name := variable.to_string_8
			if name.same_type (variable) then
				name := name.twin
			end
			if name [2] = '{' then
			-- canonical form: ${var}
				name.remove_head (2); name.remove_tail (1)
			else
				name.remove_head (1)
			end
			if place_holder_table.has_key (name) then
			-- same `place_holder' can appear repeatedly in `Current' list
				place_holder := place_holder_table.found_item
			else
				place_holder := variable
				place_holder_table.extend (place_holder, name)
			end
			extend (place_holder)
		end

feature {NONE} -- Internal attributes

	place_holder_table: EL_STRING_8_TABLE [S];
		-- variable name list

note
	notes: "[
		An alternative to this class is ${EL_SUBSTITUTION_TEMPLATE} found in libary
		[./library/text-process.html text-process.ecf].

			EL_SUBSTITUTION_TEMPLATE*
				${EL_STRING_8_TEMPLATE}
				${EL_STRING_32_TEMPLATE}
				${EL_ZSTRING_TEMPLATE}
				
		Template classes ${EL_STRING_32_TEMPLATE} and ${EL_ZSTRING_TEMPLATE} permit variable
		names with characters outside the Latin-1 set.
	]"

end