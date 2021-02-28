note
	description: "Expand class notes with source hyperlink: [$source MY_CLASS [ANY]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-28 17:41:50 GMT (Sunday 28th February 2021)"
	revision: "1"

class
	SOURCE_LINK_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		rename
			make as make_hyperlink,
			expand_hyperlink_markup as expand_as_source_link
		redefine
			substitute_html, expand_as_source_link
		end

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			make_hyperlink (Square_bracket.left)
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING; new_link_agent: like new_expanded_link)
		do
			new_expanded_link := new_link_agent
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

feature {NONE} -- Constants

	Editor: EL_ZSTRING_EDITOR
		once
			create Result.make_empty
		end

end