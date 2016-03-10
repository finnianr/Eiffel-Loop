note
	description: "Generates clicked and hightlighted button from normal.svg"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GENERATED_SVG_BUTTON_PIXMAP_SET

inherit
	EL_SVG_BUTTON_PIXMAP_SET
		redefine
			fill_pixmaps
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			default_create
		end

create
	make, default_create

feature {NONE} -- State procedures

	find_linear_gradient_stop (line: EL_ASTRING)
		do
			add_to_output_files (line)
			if line.ends_with (once "<stop") then
				state := agent insert_stop_color
			end
		end

	insert_stop_color (line: EL_ASTRING)
		local
			list: LIST [EL_ASTRING]
		do
			list := line.split (';')
			list.first.remove_tail (6)
			list.first.append (Highlighted_stop_color)
			add_to_output_files (String.joined (list, ";"))
			state := agent find_radial_gradient
		end

	find_radial_gradient (line: EL_ASTRING)
		do
			add_to_output_files (line)
			if line.ends_with (once "<radialGradient") then
				state := agent find_radius_r
			end
		end

	find_radius_r (line: EL_ASTRING)
		do
			if line.has_substring (once "r=") then
				line.remove_tail (5)
				line.append ("%"180%"")
				state := agent find_border_rect_style
			end
			add_to_output_files (line)
		end

	find_border_rect_style (line: EL_ASTRING)
		local
			list: LIST [EL_ASTRING]
		do
			if line.has_substring ("#radialGradient933") then
				put_line (file_highlighted, line)
				list := line.split (';')
				from list.start until list.after loop
					if list.item.starts_with ("stroke-width:") then
						list.item.put (Clicked_border_width, list.item.count)
					elseif list.item.starts_with ("stroke:") then
						-- stroke:#eecd94
						list.item.remove_tail (6)
						list.item.append (Clicked_border_color)
					end
					list.forth
				end
				put_line (file_clicked, String.joined (list, ";"))
				state := agent find_g_transform
			else
				add_to_output_files (line)
			end
		end

	find_g_transform (line: EL_ASTRING)
		local
			quote_pos: INTEGER
		do
			if line.has_substring (once "transform=") then
				put_line (file_highlighted, line)
				quote_pos := line.last_index_of ('"', line.count)
				line.insert_string (" translate (0, 15)", quote_pos)
				put_line (file_clicked, line)
				state := agent add_to_output_files
			else
				add_to_output_files (line)
			end
		end

	add_to_output_files (line: EL_ASTRING)
		do
			put_line (file_highlighted, line)
			put_line (file_clicked, line)
		end

feature {NONE} -- Implementation

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
			image_dir_path := Execution_environment.Application_installation_dir.joined_dir_steps (final_relative_path_steps)

			create generated_svg_relative_path_steps.make_with_count (icon_path_steps.count + 1)
			generated_svg_relative_path_steps.extend (Image_path.Step_icons)
			icon_path_steps.do_all (agent generated_svg_relative_path_steps.extend)
			generated_svg_image_dir := Execution_environment.User_configuration_dir.joined_dir_steps (
				generated_svg_relative_path_steps
			)
			File_system.make_directory (generated_svg_image_dir)
			generated_svg_highlighted_file_path := generated_svg_image_dir + Highlighted_svg
			if not generated_svg_highlighted_file_path.exists then
				create file_highlighted.make_open_write (generated_svg_highlighted_file_path.unicode)
				create file_clicked.make_open_write ((generated_svg_image_dir + Clicked_svg).unicode)

				create linear_gradient_lines.make (12)

				-- Generate highlighted.svg and clicked.svg from normal.svg
				do_with_lines (
					agent find_linear_gradient_stop, create {EL_FILE_LINE_SOURCE}.make (image_dir_path + Normal_svg)
				)
				file_highlighted.close; file_clicked.close

			end
			final_relative_path_steps.force (Highlighted_svg)
			pixmaps [Highlighted_svg] := create {like normal}.make_with_width_cms (
				Execution_environment.User_configuration_dir.joined_file_steps (final_relative_path_steps),
				width_cms, background_color
			)
			final_relative_path_steps.finish; final_relative_path_steps.replace (Clicked_svg)
			pixmaps [Clicked_svg] := create {like normal}.make_with_width_cms (
				Execution_environment.User_configuration_dir.joined_file_steps (final_relative_path_steps),
				width_cms, background_color
			)
		end

	put_line (a_file: PLAIN_TEXT_FILE; line: EL_ASTRING)
		do
			a_file.put_string (line); a_file.put_new_line
		end

	file_highlighted: PLAIN_TEXT_FILE

	file_clicked: PLAIN_TEXT_FILE

	linear_gradient_lines: ARRAYED_LIST [EL_ASTRING]

end
