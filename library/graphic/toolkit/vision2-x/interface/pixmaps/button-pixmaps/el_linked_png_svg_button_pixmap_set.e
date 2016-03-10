note
	description: "Summary description for {EL_LINKED_PNG_SVG_BUTTON_PIXMAP_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_LINKED_PNG_SVG_BUTTON_PIXMAP_SET

inherit
	EL_SVG_BUTTON_PIXMAP_SET
		redefine
			normal, svg_icon
		end

create
	make, default_create

feature -- Access

	normal: EL_LINKED_PNG_SVG_PIXMAP
		do
			Result := pixmaps [Normal_svg]
		end

feature {NONE} -- Implementation

	svg_icon (last_step: EL_ASTRING; width_cms: REAL): like normal
		local

		do
			icon_path_steps.extend (last_step)
			create Result.make_with_width_cms (Image_path.icon (icon_path_steps), width_cms, background_color)
			icon_path_steps.remove_tail (1)

			icon_path_steps.extend ("object.png")
			Result.set_file_path_variable (Var_object_image_path, Image_path.icon (icon_path_steps))
			Result.update_png
			icon_path_steps.remove_tail (1)
		end

feature {NONE} -- Constants

	Var_object_image_path: EL_ASTRING
		once
			Result := "object_image_path"
		end

end
