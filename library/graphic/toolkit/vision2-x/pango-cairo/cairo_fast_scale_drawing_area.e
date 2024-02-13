note
	description: "[
		${CAIRO_DRAWING_AREA} with caching of results from `scaled_to_size' duplication functions.
		Caching the results can greatly improve the performance of fractal geomety applications.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-13 11:47:09 GMT (Tuesday 13th February 2024)"
	revision: "1"

class
	CAIRO_FAST_SCALE_DRAWING_AREA

inherit
	CAIRO_DRAWING_AREA
		redefine
			initialize, scaled_to_size
		end

create
	default_create, make_with_size, make_with_rectangle,
	make_with_path, make_with_png, make_with_pixmap, make_with_svg_image,
	make_with_scaled_pixmap, make_scaled_to_width, make_scaled_to_height, make_scaled_to_size

convert
	make_with_path ({FILE_PATH}), make_with_pixmap ({EV_PIXMAP, EL_PIXMAP}),
	dimensions: {EL_RECTANGLE}, to_buffer: {EV_PIXEL_BUFFER}

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create scaled_to_size_cache_table.make (11, agent new_scaled_to_size)
		end

feature -- Conversion

	scaled_to_size (a_width, a_height: INTEGER; fill_color: detachable EV_COLOR): CAIRO_DRAWING_AREA
		-- scaled to greater of dimension: `a_width' or `a_height'
		local
			l_width, l_height: INTEGER
		do
			l_width := a_width.max (1); l_height := a_height.max (1);
			if l_width >= l_height then
				Result := scaled_to_size_cache_table.item (l_width)
			else
				Result := scaled_to_size_cache_table.item (l_height.opposite)
			end
		end

feature {NONE} -- Internal attributes

	new_scaled_to_size (size: INTEGER): CAIRO_DRAWING_AREA
		-- `size' < 0 implies `size.abs' is the target height
		do
			if size < 0 then
				create Result.make_scaled_to_height (Current, size.abs, Void)
			else
				create Result.make_scaled_to_width (Current, size, Void)
			end
		end

feature {NONE} -- Internal attributes

	scaled_to_size_cache_table: EL_AGENT_CACHE_TABLE [CAIRO_DRAWING_AREA, INTEGER]

end