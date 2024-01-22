note
	description: "[
		${SOURCE_LINK_SUBSTITUTION} with new style of abbreviated source link format as
		shown at start of line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 9:51:57 GMT (Monday 22nd January 2024)"
	revision: "6"

class
	TYPE_VARIABLE_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		rename
			make as make_hyperlink
		redefine
			substitute_html
		end

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_preformatted

feature {NONE} -- Initialization

	make
		do
			make_substitution (Dollor_left_brace, char ('}'), Empty_string, Empty_string)
			anchor_id := " id=%"source%""
		ensure
			leading_space: anchor_id [1] = ' '
		end

	make_preformatted
		-- link with empty `anchor_id'
		-- The output will appear in a preformated HTML section so there is no need for identifier
		-- <a id="source"> in the anchor tag.

		--		<pre>
		--			The class <a href="http://.." target="_blank">MY_CLASS</a>
		--		</pre>
		do
			make
			create anchor_id.make_empty
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		local
			previous_end_index, preceding_start_index, preceding_end_index: INTEGER
			buffer: ZSTRING
		do
			if attached Class_link_list as list then
				list.parse (html_string)
			-- In reverse order to allow substitutions
				across String_scope as scope loop
					buffer := scope.best_item (html_string.count + list.count * 50)
					from list.start until list.after loop
						preceding_start_index := previous_end_index + 1
						preceding_end_index := list.item.start_index - 1
						if (preceding_end_index - preceding_start_index + 1) > 0 then
							buffer.append_substring (html_string, preceding_start_index, preceding_end_index)
						end
						buffer.append (new_link_markup (list.item))
						previous_end_index := list.item.end_index
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

	new_link_markup (link: CLASS_LINK): ZSTRING
		do
			Result := A_href_template #$ [
				link.adjusted_path (relative_page_dir), anchor_id, new_link_text (link.type_name)
			]
		end

	new_link_text (type_name: ZSTRING): ZSTRING
		do
			if type_name.has (' ') then
				create Result.make (type_name.count + type_name.occurrences (' ') * NB_space_entity.count)
				Result.append_replaced (type_name, space, NB_space_entity)
			else
				Result := type_name
			end
		end

feature {NONE} -- Internal attributes

	anchor_id: STRING

end