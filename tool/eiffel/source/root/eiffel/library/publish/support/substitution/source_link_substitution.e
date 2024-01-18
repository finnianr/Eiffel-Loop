note
	description: "Expand class notes with source hyperlink: ${MY_CLASS [ANY]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-17 10:06:55 GMT (Wednesday 17th January 2024)"
	revision: "9"

class
	SOURCE_LINK_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		rename
			make as make_hyperlink,
			expand_hyperlink_markup as expand_as_source_link
		redefine
			substitute_html, expand_as_source_link, new_expanded_link, A_href_template
		end

	PUBLISHER_CONSTANTS

	SHARED_CLASS_PATH_TABLE; SHARED_ISE_CLASS_TABLE

create
	make, make_preformatted

feature {NONE} -- Initialization

	make
		do
			make_hyperlink (char ('[') + Source_variable)
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
			make_hyperlink (char ('[') + Source_variable)
			create anchor_id.make_empty
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		do
			Editor.set_target (html_string)
			Editor.for_each_balanced ('[', ']', Source_variable, agent expand_as_source_link)
		end

feature {NONE} -- Implementation

	expand_as_source_link (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			link_text: ZSTRING
		do
			link_text := substring.substring (start_index, end_index)
			link_text.adjust
			substring.share (new_expanded_link (Source_variable, link_text))
		end

	new_expanded_link (path, text: ZSTRING): ZSTRING
		local
			l_path, link_text: ZSTRING
		do
			if text.has (' ') then
				create link_text.make (text.count + text.occurrences (' ') * NB_space_entity.count)
				link_text.append_replaced (text, space * 1, NB_space_entity)
			else
				link_text := text
			end
			if Class_path_table.has_class (text) then
				l_path := Class_path_table.found_item.universal_relative_path (relative_page_dir)
			elseif ISE_class_table.has_class (text) then
				l_path := ISE_class_table.found_item
			else
				l_path := path
			end
			Result := A_href_template #$ [l_path, anchor_id, link_text]
		end

feature {NONE} -- Internal attributes

	anchor_id: STRING

feature {NONE} -- Constants

	A_href_template: ZSTRING
			-- contains to '%S' markers
		once
			Result := "[
				<a href="#"# target="_blank">#</a>
			]"
		end

end