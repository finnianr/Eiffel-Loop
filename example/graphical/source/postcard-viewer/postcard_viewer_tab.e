note
	description: "Postcard viewer tab"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	POSTCARD_VIEWER_TAB

inherit
	EL_DOCKED_TAB
		rename
			make as make_tab
		end

	EV_BUILDER

	EL_MODULE_ACTION

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make (a_location: DIR_PATH)
		do
			location := a_location
			make_tab
			replace_content_widget
		end

feature -- Access

	description: ZSTRING
		do
			Result := "Photo in directory"
		end

	detail: ZSTRING
		do
			Result := location
		end

	location: DIR_PATH

	long_title: ZSTRING
		do
			Result := title
		end

	title: ZSTRING
		do
			Result := unique_title
		end

	unique_title: ZSTRING
		do
			Result := location.base
		end

feature {NONE} -- Factory

	new_content_widget: EL_SCROLLABLE_VERTICAL_BOX
		local
			l_dir: EL_DIRECTORY; postcard: EL_PIXMAP
		do
			create Result.make (0.3, 0.3)
			create l_dir.make (location)
			across << "jpg", "png" >> as format loop
				across l_dir.files_with_extension (format.item) as image_path loop
					create postcard
					postcard.set_with_named_file (image_path.item)
					postcard.scale_to_width_cms (20)
					Result.extend_unexpanded (
						Vision_2.new_horizontal_box (0, 0, <<
							create {EL_EXPANDED_CELL},
							Vision_2.new_vertical_box (0, 0.2, << Vision_2.new_label (image_path.item.base.to_unicode), postcard >>),
							create {EL_EXPANDED_CELL}
						>>)
					)
				end
			end
		end

feature {NONE} -- Event handling

	on_close
		do
		end

	on_selected
		do
		end

feature {NONE} -- Implementation

	icon: EV_PIXMAP
		local
			icon_path: FILE_PATH
		do
			create Result
			icon_path := "$ISE_EIFFEL/examples/vision2/edraw/toolbar/picture.png"
			icon_path.expand
			Result.set_with_named_file (icon_path)
		end

end