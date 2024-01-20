note
	description: "Expand class notes with source hyperlink: ${MY_CLASS [ANY]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:53:27 GMT (Saturday 20th January 2024)"
	revision: "12"

class
	SOURCE_LINK_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		rename
			make as make_hyperlink,
			expand_hyperlink_markup as expand_as_source_link
		redefine
			substitute_html, expand_as_source_link, new_expanded_link
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
			substring.share (new_expanded_link (Unknown, link_text))
		end

	new_expanded_link (unknown_path, type_name: ZSTRING): ZSTRING
		local
			path: ZSTRING; class_name: ZSTRING; eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			class_name := eif.parsed_class_name (type_name)
			if Class_path_table.has_class (class_name) then
				path := Class_path_table.found_item.universal_relative_path (relative_page_dir)

			elseif ISE_class_table.has_class (class_name) then
				path := ISE_class_table.found_item
			else
				path := unknown_path
			end
			Result := A_href_template #$ [path, anchor_id, new_link_text (type_name)]
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

feature {NONE} -- Constants

	Editor: EL_ZSTRING_EDITOR
		once
			create Result.make_empty
		end

	Unknown: ZSTRING
		once
			Result := "unknown"
		end
end