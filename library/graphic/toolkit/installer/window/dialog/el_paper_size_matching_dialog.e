note
	description: "Resizeable a5 paper dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-06 10:37:37 GMT (Thursday 6th July 2023)"
	revision: "15"

class
	EL_PAPER_SIZE_MATCHING_DIALOG

inherit
	EL_UNTITLED_INSTALLER_DIALOG
		redefine
			on_cancel
		end

	EL_MODULE_BUILD_INFO

	EL_MODULE_COLOR

	EL_MODULE_DESKTOP_MENU_ICON

	EL_APPLICATION_CONSTANTS

	EL_SHARED_INSTALL_TEXTS

create
	make

feature {NONE} -- Initialization

	make (a_latest_version: NATURAL)
		do
			latest_version := a_latest_version
			paper_code := best_paper_size

			default_create
			enable_border

			if attached real_dimension (paper_code) as paper then
				original_size := [paper.width.to_double, paper.height.to_double]
			end
			set_size (original_size.width, original_size.height)
			pixel_area := original_size.width * original_size.height
			set_background_color (Color.White)
			show_actions.extend (agent on_show)

			create paper_box.make (Current, paper_code)
			put (paper_box)
			propagate_background_color
			set_default_cancel_button (paper_box.cancel_button)
			set_default_push_button (paper_box.next_button)
		end

feature {EL_INSTALLER_BOX} -- Event handling

	on_cancel
		do
			is_cancelled := True
			destroy
		end

	on_next
		local
			display_size: EL_ADJUSTED_DISPLAY_SIZE
		do
			if width /= original_size.width or height /= original_size.height then
				create display_size.make_default
				display_size.set_file_path (package_dir)
				display_size.write
			end
			destroy
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		local
			l_width, l_height, l_pixel_area, percent_change: INTEGER
			paper: like real_dimension
		do
			paper := real_dimension (paper_code)
			if a_height > a_width then
				l_width := a_height; l_height := a_width
			else
				l_width := a_width; l_height := a_height
			end
			Screen.set_dimensions (
				Screen.width / (l_width / paper.width), Screen.height / (l_height / paper.height)
			)
			l_pixel_area := l_width * l_height
			percent_change := ((pixel_area - l_pixel_area).abs * 100 / pixel_area).rounded
			if percent_change > 2 then
				Action.do_later (1, agent redraw_a5_paper_box)
				pixel_area := l_pixel_area
			end
			if not is_final_resize_set then
				Action.do_once_on_idle (agent on_final_resize)
				is_final_resize_set := True
			end
		end

	on_final_resize
		do
			redraw_a5_paper_box
			is_final_resize_set := False
		end

	on_show
		local
			dialog: like new_info_dialog; version: EL_SOFTWARE_VERSION
		do
			resize_actions.extend (agent on_resize)
			if Build_info.version_number < latest_version then
				create version.make (latest_version, 0)

				dialog := new_info_dialog (Text.version_title (version), Text.newer_version (version), False)
				Screen.center (dialog)
				dialog.show_modal_to_window (Current)
			end
		end

feature {NONE} -- Implementation

	redraw_a5_paper_box
		do
			paper_box.text_area.redraw
		end

feature {NONE} -- Internal attributes

	paper_box: EL_PAPER_MATCHING_INSTALLER_BOX

	paper_code: NATURAL_8

	is_final_resize_set: BOOLEAN

	latest_version: NATURAL

	original_size: EL_RECTANGLE

	pixel_area: INTEGER
		-- current pixel area

end