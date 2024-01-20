note
	description: "[
		${SOURCE_LINK_SUBSTITUTION} with new style of abbreviated source link format as
		shown at start of line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:57:04 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	TYPE_VARIABLE_SUBSTITUTION

inherit
	SOURCE_LINK_SUBSTITUTION
		redefine
			make_hyperlink, substitute_html
		end

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_preformatted

feature {NONE} -- Initialization

	make_hyperlink (a_delimiter_start: ZSTRING)
		do
			make_substitution (Dollor_left_brace, char ('}'), Empty_string, Empty_string)
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		local
			previous_end_index, preceding_start_index, preceding_end_index: INTEGER
			path: FILE_PATH; type_name, link_markup, buffer: ZSTRING
		do
			if attached Class_reference_list as list then
				list.parse (html_string)
			-- In reverse order to allow substitutions
				across String_scope as scope loop
					buffer := scope.best_item (html_string.count + list.count * 50)
					from list.start until list.after loop
						preceding_start_index := previous_end_index + 1
						preceding_end_index := list.item_start_index - 1
						if (preceding_end_index - preceding_start_index + 1) > 0 then
							buffer.append_substring (html_string, preceding_start_index, preceding_end_index)
						end
						type_name := list.item_type_name
						if attached list.item_value.path as class_path then
							path := class_path
						else
							path := Unknown
						end
						buffer.append (new_link_markup (path, type_name, list.item_value.is_ise_path))
						previous_end_index := list.item_end_index
						list.forth
					end
					if html_string.count - previous_end_index > 0 then
						buffer.append_substring (html_string, previous_end_index + 1, html_string.count)
					end
					html_string.copy (buffer)
				end
			end
		end

feature {NONE} -- Implementation

	new_link_markup (a_path: FILE_PATH; type_name: ZSTRING; is_ise_path: BOOLEAN): ZSTRING
		local
			path: FILE_PATH
		do
			if a_path.base /~ Unknown and then not is_ise_path then
				path := a_path.universal_relative_path (relative_page_dir)
			else
				path := a_path
			end
			Result := A_href_template #$ [path, anchor_id, new_link_text (type_name)]
		end

end