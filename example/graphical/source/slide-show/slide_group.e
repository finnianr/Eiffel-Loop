note
	description: "Group of slides belonging to same theme folder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 16:43:58 GMT (Tuesday 31st May 2022)"
	revision: "3"

class
	SLIDE_GROUP

inherit
	ANY

	EL_MODULE_LIO; EL_MODULE_COLOR; EL_MODULE_VISION_2; EL_MODULE_GUI

	EL_SHARED_PROGRESS_LISTENER

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_file_list: like file_list; a_parent: SLIDE_SHOW)
		do
			name := a_name; file_list := a_file_list; parent := a_parent
			theme_name := file_list.first.parent.base
		end

feature -- Access

	file_list: EL_ARRAYED_LIST [FILE_PATH]

	name: ZSTRING

	theme_name: ZSTRING

feature -- Measurement

	image_count: INTEGER
		do
			Result := parent.title_duration_ratio + file_list.count
		end

feature -- Basic operations

	generate
		do
			if attached title_area as area then
				across 1 |..| parent.title_duration_ratio as n loop
					-- Generate title image
					parent.add_image (area)
				end
			end
			across file_list as list loop
				parent.add_named_image (list.item, list.is_first)
			end
		end

feature {NONE} -- Implementation

	title_area: CAIRO_DRAWING_AREA
		local
			rect: EL_RECTANGLE; height: INTEGER
		do
			rect := parent.dimensions
			create Result.make_with_size (rect.width, rect.height)

			Result.set_color (Color.Black); Result.fill

			Result.set_color (Color.White)

			height := (rect.height / 5).rounded
			rect.set_height (height)
			across << theme_name, Name_template #$ [name] >> as title loop
				rect.move_by (0, rect.height)
				if title.is_first then
					Result.set_font (parent.new_theme_font)
				else
					Result.set_font (parent.new_name_font)
				end
				Result.draw_centered_text (title.item, rect)
			end
		end

feature {NONE} -- Internal attributes

	parent: SLIDE_SHOW

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "~ %S ~"
		end

end