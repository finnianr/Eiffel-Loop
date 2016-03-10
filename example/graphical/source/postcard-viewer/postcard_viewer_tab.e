note
	description: "Summary description for {POSTCARD_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-28 11:00:32 GMT (Friday 28th March 2014)"
	revision: "4"

class
	POSTCARD_VIEWER_TAB

inherit
	EL_DOCKED_TAB
		rename
			make as make_tab
		end

	EV_BUILDER

	EL_MODULE_GUI
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_LOG
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_location: EL_DIR_PATH)
		do
			location := a_location
			make_tab
			replace_content_widget
		end

feature -- Access

	unique_title: EL_ASTRING
		do
			Result := location.base
		end

	title: EL_ASTRING
		do
			Result := unique_title
		end

	long_title: EL_ASTRING
		do
			Result := title
		end

	description: EL_ASTRING
		do
			Result := "Photo in directory"
		end

	detail: EL_ASTRING
		do
			Result := location
		end

	location: EL_DIR_PATH

feature {NONE} -- Factory

	new_content_widget: EL_SCROLLABLE_VERTICAL_BOX
		local
			l_dir: EL_DIRECTORY
			postcard: EL_PIXMAP
		do
			create Result.make (0.3, 0.3)
			create l_dir.make_open_read (location)
			across << "jpg", "png" >> as format loop
				across l_dir.file_list (format.item) as image_path loop
					create postcard
					postcard.set_with_named_file (image_path.item.unicode)
					postcard.scale_to_width_cms (20)
					Result.extend_unexpanded (
						GUI.horizontal_box (0, 0, <<
							create {EL_EXPANDED_CELL},
							GUI.vertical_box (0, 0.2, << GUI.label (image_path.item.base.to_unicode), postcard >>),
							create {EL_EXPANDED_CELL}
						>>)
					)
				end
			end
		end

feature {NONE} -- Implementation

	icon: EV_PIXMAP
		local
			icon_path: EL_FILE_PATH
		do
			create Result
			icon_path := Execution.variable_dir_path ("ISE_EIFFEL").joined_file_steps (
				<< "examples", "vision2", "edraw", "toolbar", "picture.png" >>
			)
			Result.set_with_named_file (icon_path.unicode)
		end

end
