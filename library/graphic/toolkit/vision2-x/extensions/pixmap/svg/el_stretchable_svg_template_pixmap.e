note
	description: "[
		SVG template graphic where the relative width to height can be altered before rendering
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:31:32 GMT (Friday 21st December 2018)"
	revision: "4"

class
	EL_STRETCHABLE_SVG_TEMPLATE_PIXMAP

inherit
	EL_SVG_TEMPLATE_PIXMAP
		redefine
			rendering_variables
		end

create
	default_create, make_from_other, make_with_width_cms, make_with_height_cms, make_with_width, make_with_height,
	make_with_path_and_width, make_with_path_and_height,
	make_transparent_with_width, make_transparent_with_height, make_transparent_with_width_cms,
	make_transparent_with_height_cms, make_transparent_with_path_and_width, make_transparent_with_path_and_height

feature -- Access

	svg_width: INTEGER
		-- width declared in SVG root element
		-- 	<svg width="$svg_width">

feature -- Element change

	set_svg_width (a_svg_width: like svg_width)
		do
			svg_width := a_svg_width
			set_variable (Var_svg_width, svg_width)
		end

feature {NONE} -- Implementation

	rendering_variables: ARRAYED_LIST [like Type_rendering_variable]
			-- Make sure rendered png is unique for svg_width
		do
			Result := Precursor
			Result.extend ([once "svgw", svg_width])
		end

feature {NONE} -- Constants

	Var_svg_width: ZSTRING
		once
			Result := "width"
		end

end
