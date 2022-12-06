note
	description: "Generates clicked and hightlighted button from normal.svg"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 18:54:09 GMT (Monday 5th December 2022)"
	revision: "14"

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
		undefine
			copy, is_equal
		end

	EL_MODULE_DIRECTORY

	EL_FILE_OPEN_ROUTINES

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
				create list.make_split (line, ';')
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
			create list.make_split (line, ';')
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
			generated_svg_highlighted_file_path, image_dir_path: FILE_PATH
			final_relative_path_steps, generated_svg_relative_path_steps: EL_PATH_STEPS
			generated_svg_image_dir: DIR_PATH
			svg_image: like new_svg_image
		do
			put (svg_icon (Button_state.normal, width_cms), Button_state.normal)

			final_relative_path_steps := icon_path_steps.to_string
			final_relative_path_steps.put_front (Image.Step.icons)
			image_dir_path := Directory.Application_installation + final_relative_path_steps

			create generated_svg_relative_path_steps.make_steps (icon_path_steps.count + 1)
			generated_svg_relative_path_steps.extend (Image.Step.icons)
			generated_svg_relative_path_steps.append_path (icon_path_steps)
			generated_svg_image_dir := Directory.App_configuration #+ generated_svg_relative_path_steps
			File_system.make_directory (generated_svg_image_dir)
			generated_svg_highlighted_file_path := generated_svg_image_dir + svg_name (Button_state.highlighted)
			if not generated_svg_highlighted_file_path.exists then
				create file_highlighted.make_open_write (generated_svg_highlighted_file_path)
				create file_clicked.make_open_write (generated_svg_image_dir + svg_name (Button_state.depressed))

				create linear_gradient_lines.make (12)

				-- Generate highlighted.svg and clicked.svg from normal.svg
				if attached open_lines (image_dir_path + svg_name (Button_state.normal), Latin_1) as lines then
					do_with_lines (agent find_linear_gradient_stop, lines)
				end
				file_highlighted.close; file_clicked.close

			end
			final_relative_path_steps.extend (svg_name (Button_state.highlighted))
			create svg_image.make_with_width_cms (
				Directory.App_configuration + final_relative_path_steps, width_cms, background_color
			)
			put (svg_image, Button_state.highlighted)
			final_relative_path_steps.set_base (svg_name (Button_state.depressed))
			create svg_image.make_with_width_cms (
				Directory.App_configuration + final_relative_path_steps, width_cms, background_color
			)
			put (svg_image, Button_state.depressed)
		end

	linear_gradient_lines: ARRAYED_LIST [ZSTRING]

	put_line (a_file: PLAIN_TEXT_FILE; line: ZSTRING)
		do
			a_file.put_string (line); a_file.put_new_line
		end

end