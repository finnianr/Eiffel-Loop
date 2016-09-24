note
	description: "API function pointers for libcairo-2"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CAIRO_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	get_antialias: POINTER

	arc: POINTER

	clip: POINTER

	close_path: POINTER

	new_sub_path: POINTER

	create_: POINTER

	destroy: POINTER

	surface_destroy: POINTER

	fill: POINTER

	format_stride_for_width: POINTER

	image_surface_create_for_data: POINTER

	line_to: POINTER

	move_to: POINTER

	image_surface_create: POINTER

	image_surface_create_from_png: POINTER

	new_path: POINTER

	win32_surface_create: POINTER

	paint: POINTER

	rectangle: POINTER

	reset_clip: POINTER

	restore: POINTER

	rotate: POINTER

	save: POINTER

	scale: POINTER

	select_font_face: POINTER

	set_antialias: POINTER

	set_font_size: POINTER

	set_line_width: POINTER

	set_source_rgb: POINTER

	set_source_rgba: POINTER

	set_source_surface : POINTER

	show_text: POINTER

	stroke: POINTER

	image_surface_get_data: POINTER

	surface_flush: POINTER

	image_surface_get_format: POINTER

	image_surface_get_height: POINTER

	surface_mark_dirty: POINTER

	image_surface_get_width: POINTER

	translate: POINTER

end
