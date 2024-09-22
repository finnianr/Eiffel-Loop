note
	description: "[
		Table of actions to add XML element attribute to output string.
		See class ${TB_XHTML_FOLDER_EXPORTER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:05:12 GMT (Sunday 22nd September 2024)"
	revision: "14"

class
	TB_ATTRIBUTE_EDIT_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [PROCEDURE [ZSTRING, ZSTRING, ZSTRING]]
		export
			{NONE} all
			{ANY} force, put, extend, force_key
		end

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_assignments

feature -- Basic operations

	do_with_attributes (element: ZSTRING)
		-- edit attributes in `element' using edit procedure
		require
			is_element: element.enclosed_with ("<>")
		local
			start_index, end_index: INTEGER; XML: XML_ROUTINES
			name, ending: ZSTRING; quote_splitter: EL_SPLIT_ON_CHARACTER [ZSTRING]
		do
			start_index := element.index_of ('=', 1)
			if start_index > 0 then
				start_index := attribute_name_index (element)
				from end_index := element.count - 1 until element [end_index] = '"' or else end_index = 0 loop
					end_index := end_index - 1
				end
				if start_index < end_index then
					across String_scope as scope loop
						if attached scope.item as str then
							str.append_substring (element, start_index, end_index)
							create quote_splitter.make_adjusted (str, '"', {EL_SIDE}.Both)
							ending := element.substring_end (end_index + 1)
							element.keep_head (start_index - 1)
							element.right_adjust
							across quote_splitter as split loop
								if split.cursor_index \\ 2 = 1 then
									name := split.item_copy
									name.remove_tail (1)
									name.right_adjust
									search (name)
								elseif found then
									found_item (name, split.item, element)
								else
									XML.append_attribute (name, split.item, element)
								end
							end
							element.append (ending)
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	attribute_name_index (element: ZSTRING): INTEGER
		local
			i: INTEGER
		do
			from i := 2 until element.is_space_item (i) loop
				i := i + 1
			end
			from until element.is_alpha_item (i) or else i = element.count loop
				i := i + 1
			end
			Result := i
		end

end