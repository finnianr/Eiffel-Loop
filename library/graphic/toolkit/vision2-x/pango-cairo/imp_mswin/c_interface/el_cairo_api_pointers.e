note
	description: "API function pointers for libcairo-2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-10 8:56:55 GMT (Friday 10th July 2020)"
	revision: "5"

class
	EL_CAIRO_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Functions A - G

	arc: POINTER

	clip: POINTER

	close_path: POINTER

	create_: POINTER

	destroy: POINTER

	fill: POINTER

	format_stride_for_width: POINTER

	get_antialias: POINTER

feature {EL_DYNAMIC_MODULE} -- Functions I

	image_surface_create: POINTER

	image_surface_create_for_data: POINTER

	image_surface_create_from_png: POINTER

	image_surface_get_data: POINTER

	image_surface_get_format: POINTER

	image_surface_get_height: POINTER

	image_surface_get_width: POINTER

feature {EL_DYNAMIC_MODULE} -- Functions L - P

	line_to: POINTER

	mask_surface: POINTER

	matrix_init_scale: POINTER

	move_to: POINTER

	new_path: POINTER

	new_sub_path: POINTER

	paint: POINTER

	paint_with_alpha: POINTER

	pattern_create_for_surface: POINTER

	pattern_destroy: POINTER

	pattern_set_matrix: POINTER

feature {EL_DYNAMIC_MODULE} -- Functions R

	rectangle: POINTER

	reset_clip: POINTER

	restore: POINTER

	rotate: POINTER

feature {EL_DYNAMIC_MODULE} -- Functions S

	save: POINTER

	scale: POINTER

	select_font_face: POINTER

	set_antialias: POINTER

	set_font_size: POINTER

	set_line_width: POINTER

	set_source: POINTER

	set_source_rgb: POINTER

	set_source_rgba: POINTER

	set_source_surface : POINTER

	show_text: POINTER

	stroke: POINTER

	surface_destroy: POINTER

	surface_finish: POINTER

	surface_flush: POINTER

	surface_mark_dirty: POINTER

feature {EL_DYNAMIC_MODULE} -- Functions T - Z

	translate: POINTER

	version: POINTER

	win32_surface_create: POINTER
		--	win32_surface_create_with_format: POINTER
		-- Only available since version 1.14

	win32_surface_get_dc: POINTER

end
