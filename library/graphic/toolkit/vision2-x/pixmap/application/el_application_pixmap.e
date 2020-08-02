note
	description: "Application pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:00:23 GMT (Sunday 2nd August 2020)"
	revision: "15"

deferred class
	EL_APPLICATION_PIXMAP

inherit
	EL_MODULE_COLOR
	EL_MODULE_EXCEPTION
	EL_MODULE_SCREEN

	EL_MODULE_IMAGE_PATH
		rename
			Image_path as Mod_image_path
		end

	EL_FACTORY_CLIENT

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		end

feature -- Access

	from_file (a_file_path: EL_FILE_PATH): EL_PIXMAP
			--
		do
			Result := new_pixmap (a_file_path)
		end

	image_path (relative_path_steps: EL_PATH_STEPS): EL_FILE_PATH
		deferred
		end

feature -- Status query

	is_loadable (file_path: EL_FILE_PATH): BOOLEAN
		local
			l_pixmap: EV_PIXMAP; load_failed: BOOLEAN
		do
			if not load_failed then
				create l_pixmap
				if file_path.exists then
					l_pixmap.set_with_named_file (file_path)
					Result := True
				end
			end
		rescue
			if attached {DEVELOPER_EXCEPTION} Exception.last_exception as developer
				and then developer.description.starts_with (once "Could not load")
			then
				load_failed := True
				retry
			end
		end

feature -- Constants

	Transparent_color: EL_COLOR
		local
			svg_pixmap: EL_SVG_PIXMAP
		once
			create svg_pixmap
			Result := svg_pixmap.Transparent_color
		end

feature -- Colored PNG

	of_height_and_color (relative_path_steps: EL_PATH_STEPS; height: INTEGER; background_color: EV_COLOR): EL_PIXMAP
			-- Pixmap scaled to `height' in pixels
		do
			Result := of_size_and_color (relative_path_steps, By_height, height, background_color)
		end

	of_height_and_color_cms (relative_path_steps: EL_PATH_STEPS; height_cms: REAL; background_color: EV_COLOR): EL_PIXMAP
			-- Pixmap scaled to `height_cms' centimeters
		do
			Result := of_size_and_color (relative_path_steps, By_height, Screen.vertical_pixels (height_cms), background_color)
		end

	of_size_and_color (
		relative_path_steps: EL_PATH_STEPS; dimension: NATURAL_8; size: INTEGER; background_color: EV_COLOR
	): EL_PIXMAP
			-- pixmap scaled to `size' in pixels for `dimension' and filled with `background_color'
			-- (The pixmap must have an alpha channel)
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			top_layer, bottom_layer: CAIRO_DRAWING_AREA
			rectangle: EL_RECTANGLE
		do
			top_layer := new_drawing_area (relative_path_steps)
			rectangle := top_layer.scaled_dimensions (dimension, size)
			create bottom_layer.make_with_size (rectangle.width, rectangle.height)
			bottom_layer.set_color (background_color)
			bottom_layer.fill
			bottom_layer.draw_scaled_drawing_area (dimension, 0, 0, size, top_layer)
			Result := bottom_layer.to_pixmap
		end

	of_width_and_color (relative_path_steps: EL_PATH_STEPS; width: INTEGER; background_color: EV_COLOR): EL_PIXMAP
			-- Pixmap scaled to `width' in pixels
		do
			Result := of_size_and_color (relative_path_steps, By_width, width, background_color)
		end

	of_width_and_color_cms (relative_path_steps: EL_PATH_STEPS; width_cms: REAL; background_color: EV_COLOR): EL_PIXMAP
			-- Pixmap scaled to `width_cms' centimeters
		do
			Result := of_size_and_color (relative_path_steps, By_width, Screen.horizontal_pixels (width_cms), background_color)
		end

feature -- PNG

	of_height (relative_path_steps: EL_PATH_STEPS; height: INTEGER): EL_PIXMAP
			-- Pixmap scaled to height in pixels
		do
			create Result.make_scaled_to_height (pixmap (relative_path_steps), height)
		end

	of_height_cms (relative_path_steps: EL_PATH_STEPS; height_cms: REAL): EL_PIXMAP
			-- Pixmap scaled to height in centimeters
		do
			Result := of_size_cms (relative_path_steps, By_height, height_cms)
		end

	of_width (relative_path_steps: EL_PATH_STEPS; width: INTEGER): EL_PIXMAP
			-- Pixmap scaled to width in pixels
		do
			create Result.make_scaled_to_width (pixmap (relative_path_steps), width)
		end

	of_width_cms (relative_path_steps: EL_PATH_STEPS; width_cms: REAL): EL_PIXMAP
			-- Pixmap scaled to width in centimeters
		do
			Result := of_size_cms (relative_path_steps, By_width, width_cms)
		end

	pixmap (relative_path_steps: EL_PATH_STEPS): EL_PIXMAP
			-- Unscaled pixmap
		do
			Result := from_file (image_path (relative_path_steps))
		end

	of_size_cms (relative_path_steps: EL_PATH_STEPS; dimension: NATURAL_8; distance_cms: REAL): EL_PIXMAP
			-- Pixmap scaled to height in centimeters
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			size_pixels: INTEGER
		do
			size_pixels := Screen.dimension_pixels (dimension, distance_cms)
			create Result.make_scaled_to_size (dimension, pixmap (relative_path_steps), size_pixels)
		end

feature -- SVG

	svg_of_height (relative_path_steps: EL_PATH_STEPS; height: INTEGER; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to height in pixels
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_height (image_path (relative_path_steps), height, background_color)
			)
		end

	svg_of_height_cms (relative_path_steps: EL_PATH_STEPS; height_cms: REAL; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to height in centimeters
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_height_cms (image_path (relative_path_steps), height_cms, background_color)
			)
		end

	svg_of_width (relative_path_steps: EL_PATH_STEPS; width: INTEGER; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to width in pixels
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_width (image_path (relative_path_steps), width, background_color)
			)
		end

	svg_of_width_cms (relative_path_steps: EL_PATH_STEPS; width_cms: REAL; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to width in centimeters
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_width_cms (image_path (relative_path_steps), width_cms, background_color)
			)
		end

feature {NONE} -- Factory

	new_svg_pixmap (make_pixmap: PROCEDURE [EL_SVG_PIXMAP]): EL_SVG_PIXMAP
		local
			result_type: TYPE [EL_SVG_PIXMAP]
		do
			Procedure.set_from_other (make_pixmap)
			if attached {like image_path} Procedure.closed_operands.reference_item (1) as l_image_path
				and then l_image_path.with_new_extension (Png_extension).exists
			then
				result_type := {EL_SVG_TEMPLATE_PIXMAP}
			else
				result_type := {EL_SVG_PIXMAP}
			end
			if attached Svg_factory.new_item_from_type (result_type) as new then
				make_pixmap (new)
				Result := new
			else
				create Result
				make_pixmap (Result)
			end
			if attached {EL_SVG_TEMPLATE_PIXMAP} Result as template_pixmap then
				template_pixmap.update_png
			end
		end

	new_drawing_area (relative_path_steps: EL_PATH_STEPS): CAIRO_DRAWING_AREA
		do
			create Result.make_with_path (image_path (relative_path_steps))
		end

	new_pixmap (a_file_path: EL_FILE_PATH): EL_PIXMAP
			--
		local
			font: EL_FONT rect: EL_RECTANGLE
		do
			if a_file_path.exists then
				create Result
				Result.set_with_named_file (a_file_path)
			else
				create font.make_bold ("Verdana", 1.0)
				create rect.make_for_text ("?", font)
				create Result.make_with_rectangle (rect)
				Result.set_background_color (Color.Black)
				Result.set_foreground_color (Color.White)
				Result.clear
				Result.set_font (font)
				Result.draw_centered_text ("?", rect)
			end
		end

feature {NONE} -- Constants

	Png_extension: ZSTRING
		once
			Result := "png"
		end

	Procedure: EL_PROCEDURE
		once
			create Result
		end

	SVG_factory: EL_OBJECT_FACTORY [EL_SVG_PIXMAP]
		once
			create Result
		end

end
