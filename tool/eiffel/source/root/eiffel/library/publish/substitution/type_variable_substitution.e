note
	description: "[
		${HYPERLINK_SUBSTITUTION} with new style of abbreviated source link format as
		shown at start of line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 10:15:28 GMT (Friday 8th November 2024)"
	revision: "20"

class
	TYPE_VARIABLE_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		rename
			make as make_hyperlink
		redefine
			substitute_html
		end

	EL_EIFFEL_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_POOL

create
	make, make_preformatted

feature {NONE} -- Initialization

	make
		do
			make_substitution (Dollor_left_brace, char ('}'), Empty_string, Empty_string)
			anchor_id := new_faux_markup (" id=%"source%"")
			link_text_count := anchor_id.count + Html_link_template.count - Html_link_template.occurrences ('%S')
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

feature -- Status query

	is_preformatted: BOOLEAN
		do
			Result := anchor_id.is_empty
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		local
			previous_end_index, preceding_start_index, preceding_end_index, l_count: INTEGER
			class_link: CLASS_LINK
		do
			if attached Class_link_list as list then
				list.fill (html_string)
				l_count := html_string.count + list.character_count (link_text_count, relative_page_dir)
				if attached String_pool.sufficient_item (l_count) as borrowed then
					if attached borrowed.empty as buffer then
						from list.start until list.after loop
							class_link := list.item
							preceding_start_index := previous_end_index + 1
							preceding_end_index := class_link.start_index - 1
							if (preceding_end_index - preceding_start_index + 1) > 0 then
								buffer.append_substring (html_string, preceding_start_index, preceding_end_index)
							end
							buffer.append (new_link_markup (class_link))
							previous_end_index := class_link.end_index
							list.forth
						end
						if html_string.count - previous_end_index > 0 then
							buffer.append_substring (html_string, previous_end_index + 1, html_string.count)
						end
						html_string.copy (buffer)
					end
					borrowed.return
				end
			end
		end

feature {NONE} -- Implementation

	new_link_markup (link: CLASS_LINK): ZSTRING
		-- HTML with spaces substituted by non-breaking space
		local
			html_text, markup: ZSTRING; relative_path: FILE_PATH
		do
			if link.has_parameters and then attached String_pool.borrowed_item as borrowed then
				markup := borrowed.copied (link.expanded_parameters)
				if attached Class_link_list.expanded_list (link) as list then
					from list.finish until list.before loop
						if attached list.item as class_link then
							relative_path := class_link.relative_path (relative_page_dir)
							html_text := Html_link_template #$ [relative_path, Empty_string, class_link.class_name]
							if class_link.type = Link_type_abstract then
								html_text.append (Bold_asterisk)
							end
							markup.replace_substring (html_text, class_link.start_index, class_link.end_index)
						end
						list.back
					end
					Result := if is_preformatted then markup.twin else Source_span_template #$ [markup] end
				end
				borrowed.return
			elseif link.type = Link_type_routine then
				Result := Html_link_template #$ [link.relative_path (relative_page_dir), Empty_string, link.class_name]
				if is_preformatted then
					Result := Routine_name_template #$ [Result, link.routine_name]
				else
					Result := Routine_name_span_template #$ [Result, link.routine_name]
				end

			else
				Result := Html_link_template #$ [link.relative_path (relative_page_dir), anchor_id, link.class_name]
				if link.type = Link_type_abstract then
					Result.append (Bold_asterisk)
				end
			end
		end

feature {NONE} -- Internal attributes

	anchor_id: ZSTRING

	link_text_count: INTEGER

feature {NONE} -- Constants

	Bold_asterisk: ZSTRING
		once
			Result := new_faux_markup ("<b>*</b>")
		end

	Source_span_template: ZSTRING
		once
			Result := new_faux_markup ("[
				<span id="source">#</span>
			]")
		end

	Routine_name_span_template: ZSTRING
		once
			Result := Source_span_template #$ [Routine_name_template]
		end

	Routine_name_template: ZSTRING
		once
			Result := "{#}.#"
		end

end