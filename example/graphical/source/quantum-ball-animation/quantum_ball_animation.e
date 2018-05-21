note
	description: "Quantum ball animation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:02 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	QUANTUM_BALL_ANIMATION

inherit
	EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER
		rename
			make_default as make_event_consumer,
			on_event as redraw,
			stop as stop_consumer
		export
			{NONE} all
		redefine
			on_events_start
		end

	EL_LOGGED_EVENT_COUNTER

	EL_LOGGED_REGULAR_INTERVAL_EVENT_PROCESSOR
		undefine
			default_create
		end

	EL_MODULE_IMAGE
		undefine
			default_create
		end

	EL_MODULE_ARGS
		undefine
			default_create
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	MODEL_WORLD_TILER
		rename
			model as world
		undefine
			default_create
		end

	EV_FONT_CONSTANTS
		undefine
			default_create
		end

	DOUBLE_MATH
		rename
			log as logarithm
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		local
			pos: EV_COORDINATE
		do
			make_event_consumer

--			make_event_producer (Current, (1000 / Frames_per_sec).rounded)
			make_event_producer ("Animation timer", Current, (1000 / Frames_per_sec).rounded)
--			make_bounded_loop_event_producer (Current, "Ball animation timer", (1000 / Frames_per_sec).rounded, 3)

			radius := 70
			millisecs_per_cycle := 4100

			create world
			create model_cell.make_with_world (world)
			model_cell.set_world_border (10)
			model_cell.set_minimum_size (Background_tile.width * 3, Background_tile.height * 3)

			create lesson_label.make_with_text ("Hydrogen Atom")
			lesson_label.set_point_position (7, 7)
			lesson_label.set_font (create {EV_FONT}.make_with_values (Family_roman, Weight_bold, Shape_regular, 28))
			lesson_label.set_foreground_color (Colors.Dark_red)
			world.extend (lesson_label)

			create lesson_label.make_with_text ("2p electron orbital")
			lesson_label.set_point_position (15, 40)
			lesson_label.set_font (create {EV_FONT}.make_with_values (Family_roman, Weight_regular, Shape_regular, 20))
			world.extend (lesson_label)

			create pos.make_with_position ((Background_tile.width * 2.3).rounded, (Background_tile.height * 0.16).rounded)

			create proton.make_with_pixmap (Soccer_ball_image)
			world.extend (proton)
			proton.set_x_y (model_cell.width // 2, model_cell.height // 2)

			set_position (0)
			create electron.make
			world.extend (electron)
			electron.set_x_y (x_pos, y_pos)

			add_tiles (Background_tile)
		end

feature -- Access

	model_cell: QUANTUM_BALL_ANIMATION_AREA_CELL

	world: EV_MODEL_WORLD

	electron: MODEL_ELECTRON

	proton: EV_MODEL_PICTURE

	label: EV_MODEL_TEXT

	lesson_label: EV_MODEL_TEXT

feature -- Element change

	set_position (a_elapsed_millisecs: INTEGER)
			--
		local
			proportion_x, proportion_y, proportion_radius, radius_variability: DOUBLE
			new_angle: DOUBLE
		do
			new_angle := radians_per_millisec * a_elapsed_millisecs

			proportion_x := sine (new_angle)
			proportion_y := cosine (new_angle / 2)
			z_acceleration_proportion := z_acceleration_proportion + 0.001
			proportion_z := cosine (new_angle * z_acceleration_proportion)

			radius_variability :=0.3 + sine (0.5 * new_angle) * 0.2
			proportion_radius := 0.3 + sine (radius_variability * new_angle)

			x_pos := model_cell.width // 2 - (model_cell.width // 3 * proportion_x * proportion_radius).rounded
			y_pos := model_cell.height // 2 - (model_cell.height // 3 * proportion_y * proportion_radius).rounded

		end

feature {NONE} -- Implementation

	count: INTEGER
		do
			Result := event.count
		end

	elapsed_millisecs: INTEGER
		do
			Result := event.elapsed_millisecs
		end

	redraw
			--
		local
			previous_pos_flag: BOOLEAN; size_proportion: DOUBLE
		do
			log_event
			set_position (elapsed_millisecs)

			electron.set_x_y (x_pos, y_pos)
			size_proportion := 0.2 + 0.8 * (proportion_z + 1) / 2.0
			electron.scale (size_proportion)

			previous_pos_flag := is_electron_behind_proton
			is_electron_behind_proton := size_proportion < 0.7 and electron.bounding_box.intersects (proton.bounding_box)

			if previous_pos_flag /= is_electron_behind_proton then
				world.finish
				world.swap (world.index - 1)
			end

			model_cell.projector.full_project

			if millisecs_per_cycle > 1000.0 then
				millisecs_per_cycle := millisecs_per_cycle - 0.4
			end
		end

	on_events_start
			--
		do
			z_acceleration_proportion := 0.5
			reset
		end

	radians_per_millisec: DOUBLE
			--
		do
			Result := 2 * PI / millisecs_per_cycle
		end

	Background_tile: EV_PIXMAP
			--
		once
			Result := Image.pixmap (<< "floral.png" >>)
		end

	Soccer_ball_image: EV_PIXMAP
			--
		once
			Result := Image.pixmap (<< "soccer-ball.png" >>)
		end

	millisecs_per_cycle: DOUBLE

	z_acceleration_proportion: DOUBLE

	x_pos, y_pos, radius: INTEGER

	proportion_z: DOUBLE

	tiles: ARRAY [EV_MODEL_PICTURE]

	is_electron_behind_proton: BOOLEAN

feature {NONE} -- Constants

	Stock_colors: EV_STOCK_COLORS
			--
		once
			create Result
		end

--	Frames_per_sec: INTEGER = 24
	Frames_per_sec: INTEGER
		local
			frames_arg: INTEGER_REF
		do
			create frames_arg
			Args.set_integer_from_word_option ("frames", agent frames_arg.set_item, 8)
			Result := frames_arg.item
		end

	Colors: EV_STOCK_COLORS
			--
		once
			create Result
		end

	Count_label: ZSTRING
		once
			Result := "Redraws"
		end

end