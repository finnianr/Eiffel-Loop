note
	description: "Generates clicked and hightlighted button from normal.svg"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 8:14:09 GMT (Monday 22nd May 2017)"
	revision: "3"

class
	EL_GENERATED_SVG_BUTTON_PIXMAP_SET

inherit
	EL_SVG_BUTTON_PIXMAP_SET
		redefine
			fill_pixmaps, make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_DIRECTORY

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

feature {NONE} -- State procedures

	add_to_output_files (line: ZSTRING)
		do
			put_line (file_highlighted, line)
			put_line (file_clicked, line)
		end

	find_border_rect_style (line: ZSTRING)
		local
			list: EL_ZSTRING_LIST
		do
			if line.has_substring ("#radialGradient933") then
				put_line (file_highlighted, line)
				create list.make_with_separator (line, ';', False)
				from list.start until list.after loop
					if list.item.starts_with_general (once "stroke-width:") then
						list.item.put (Clicked_border_width, list.item.count)
					elseif list.item.starts_with_general (once "stroke:") then
						-- stroke:#eecd94
						list.item.remove_tail (6)
						list.item.append (Clicked_border_color)
					end
					list.forth
				end
				put_line (file_clicked, list.joined (';'))
				state := agent find_g_transform
			else
				add_to_output_files (line)
			end
		end

	find_g_transform (line: ZSTRING)
		local
			quote_pos: INTEGER
		do
			if line.has_substring (once "transform=") then
				put_line (file_highlighted, line)
				quote_pos := line.last_index_of ('"', line.count)
				line.insert_string_general (once " translate (0, 15)", quote_pos)
				put_line (file_clicked, line)
				state := agent add_to_output_files
			else
				add_to_output_files (line)
			end
		end

	find_linear_gradient_stop (line: ZSTRING)
		do
			add_to_output_files (line)
			if line.ends_with_general (once "<stop") then
				state := agent insert_stop_color
			end
		end

	find_radial_gradient (line: ZSTRING)
		do
			add_to_output_files (line)
			if line.ends_with_general (once "<radialGradient") then
				state := agent find_radius_r
			end
		end

	find_radius_r (line: ZSTRING)
		do
			if line.has_substring (once "r=") then
				line.remove_tail (5)
				line.append_string_general ("%"180%"")
				state := agent find_border_rect_style
			end
			add_to_output_files (line)
		end

	insert_stop_color (line: ZSTRING)
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_with_separator (line, ';', False)
			list.first.remove_tail (6)
			list.first.append_string_general (Highlighted_stop_color)
			add_to_output_files (list.joined (';'))
			state := agent find_radial_gradient
		end

feature {NONE} -- Implementation

	file_clicked: PLAIN_TEXT_FILE

	file_highlighted: PLAIN_TEXT_FILE

	fill_pixmaps (width_cms: REAL)
		local
			generated_svg_highlighted_file_path: EL_FILE_PATH
			generated_svg_relative_path_steps, final_relative_path_steps: EL_PATH_STEPS
			generated_svg_image_dir: EL_DIR_PATH
			image_dir_path: EL_DIR_PATH
		do
			pixmaps [Normal_svg] := svg_icon (Normal_svg, width_cms)

			final_relative_path_steps := icon_path_steps.twin
			final_relative_path_steps.put_front (Image_path.Step_icons)
			image_dir_path := Directory.Application_installation.joined_dir_steps (final_relative_path_steps)

			create generated_svg_relative_path_steps.make_with_count (icon_path_steps.count + 1)
			generated_svg_relative_path_steps.extend (Image_path.Step_icons)
			generated_svg_relative_path_steps.append (icon_path_steps)
			generated_svg_image_dir := Directory.User_configuration.joined_dir_steps (
				generated_svg_relative_path_steps
			)
			File_system.make_directory (generated_svg_image_dir)
			generated_svg_highlighted_file_path := generated_svg_image_dir + Highlighted_svg
			if not generated_svg_highlighted_file_path.exists then
				create file_highlighted.make_open_write (generated_svg_highlighted_file_path)
				create file_clicked.make_open_write (generated_svg_image_dir + Depressed_svg)

				create linear_gradient_lines.make (12)

				-- Generate highlighted.svg and clicked.svg from normal.svg
				do_with_lines (
					agent find_linear_gradient_stop, create {EL_FILE_LINE_SOURCE}.make (image_dir_path + Normal_svg)
				)
				file_highlighted.close; file_clicked.close

			end
			final_relative_path_steps.force (Highlighted_svg)
			pixmaps [Highlighted_svg] := create {like normal}.make_with_width_cms (
				Directory.User_configuration.joined_file_steps (final_relative_path_steps),
				width_cms, background_color
			)
			final_relative_path_steps.finish; final_relative_path_steps.replace (Depressed_svg)
			pixmaps [Depressed_svg] := create {like normal}.make_with_width_cms (
				Directory.User_configuration.joined_file_steps (final_relative_path_steps),
				width_cms, background_color
			)
		end

	linear_gradient_lines: ARRAYED_LIST [ZSTRING]

	put_line (a_file: PLAIN_TEXT_FILE; line: ZSTRING)
		do
			a_file.put_string (line); a_file.put_new_line
		end

end
