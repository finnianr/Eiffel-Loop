note
	description: "Group of slides belonging to same theme folder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 15:33:24 GMT (Thursday 2nd June 2022)"
	revision: "4"

class
	SLIDE_GROUP

inherit
	EL_SLIDE_GROUP
		redefine
			parent
		end

	EL_MODULE_LIO; EL_MODULE_COLOR; EL_MODULE_VISION_2; EL_MODULE_GUI

create
	make

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

end