note
	description: "Style information for object conforming to ${EL_SCROLLABLE_SEARCH_RESULTS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_SEARCH_RESULTS_STYLE

inherit
	ANY; EL_MODULE_COLOR

	EL_SHARED_DATE_FORMAT
		rename
			Date_format as Format
		end

create
	make

feature {NONE} -- Initialization

	make (a_font_table: EL_FONT_SET)
		do
			make_default
			font_table := a_font_table
		end

	make_default
		do
			links_per_page := 20
			link_text_color := Color.Blue
			border_cms := 0.5
			set_date_format (Format.YYYY_MMM_DD)
		end

feature -- Access

	background_color: detachable EV_COLOR

	date_format: STRING

	font_table: EL_FONT_SET

	link_text_color: EV_COLOR

feature -- Measurement

	border_cms: REAL

	details_indent: INTEGER
		-- left margin for search result details

	links_per_page: INTEGER

feature -- Status query

	is_date_shown: BOOLEAN
		do
			Result := not date_format.is_empty
		end

feature -- Status change

	hide_date
		do
			create date_format.make_empty
		end

feature -- Element change

	set_date_format (a_format: STRING)
		require
			valid_format: not a_format.is_empty implies valid_format (a_format)
		do
			date_format := a_format
		end

	set_details_indent (a_details_indent: INTEGER)
		do
			details_indent := a_details_indent
		end

	set_font_table (a_font_table: EL_FONT_SET)
		do
			font_table := a_font_table
		end

	set_link_text_color (a_link_text_color: like link_text_color)
			--
		do
			link_text_color := a_link_text_color
		end

	set_links_per_page (a_links_per_page: INTEGER)
			--
		do
			links_per_page := a_links_per_page
		end

end