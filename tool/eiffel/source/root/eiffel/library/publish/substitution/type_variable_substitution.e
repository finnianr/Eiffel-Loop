note
	description: "[
		${SOURCE_LINK_SUBSTITUTION} with new style of abbreviated source link format as
		shown at start of line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-27 15:04:02 GMT (Wednesday 27th March 2024)"
	revision: "9"

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
			previous_end_index, preceding_start_index, preceding_end_index, approx_count: INTEGER
			buffer: ZSTRING
		do
			if attached Class_link_list as list then
				list.parse (html_string)
				list.do_all (agent {CLASS_LINK}.adjust_path (relative_page_dir))

				across String_scope as scope loop
					approx_count := html_string.count 	+ list.count * Html_link_template.count
																	+ list.sum_integer (agent {CLASS_LINK}.path_count)
																	+ list.count * anchor_id.count

					buffer := scope.best_item (approx_count)
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
		-- HTML with spaces substituted by non-breaking space
		do
			Result := Html_link_template #$ [link.path, anchor_id, link.class_name]
		end

feature {NONE} -- Internal attributes

	anchor_id: STRING

end