note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TIMED_PROGRESS_BAR

inherit
	EV_DRAWING_AREA

	EL_REGULAR_INTERVAL_EVENT_PROCESSOR
		undefine
			default_create, copy
		redefine
			stop
		end

	EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER
		rename
			make as make_event_consumer,
			on_event as on_timer_event,
			stop as stop_consumer
		export
			{NONE} all
		undefine
			default_create, copy
		redefine
			on_events_start
		end

	EV_SHARED_APPLICATION
		undefine
			default_create, copy
		end

	EV_FONT_CONSTANTS
		undefine
			default_create, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		local
			colors: EV_STOCK_COLORS
		do
			default_create
			make_event_consumer
			make_event_producer (Current, "Progress bar timer", 100)

			create colors
			set_background_color (colors.Color_3d_face)
			bar_color := colors.Blue
			text_color := colors.White
			expose_actions.force_extend (agent draw_meter)
			create message.make_empty

		end

feature {NONE} -- Basic operations

	draw_meter
			--
		do
			log.enter ("draw_meter")
			if not is_stopped then
				draw_meter_increment
			else
				clear
			end
			log.exit
		end

	draw_meter_increment
			-- Redraw `drawable_item' into `drawable' by looking up the current progress
			-- for that item and displaying it as as status bar.
		local
			progress_width: INTEGER
		do
			progress_width := (percent_complete * bar_rect.width).rounded

			set_foreground_color (bar_color)
			fill_rectangle (
				bar_rect.x, bar_rect.y, progress_width, bar_rect.height
			)

			-- Erase text
			clear_rectangle (
				bar_rect.x + progress_width + 1, bar_rect.y,
				bar_rect.width - progress_width, bar_rect.height
			)

			message.wipe_out
			message.append_integer ((percent_complete * 100).floor)
			message.append ("%% complete")

			set_foreground_color (text_color)
			set_font (font)
			draw_text_top_left (bar_rect.x + 10, bar_rect.y + (height * 0.2).rounded, message)
		end

feature -- 	Element change

	set_projected_task_time (task_time: INTEGER)
			--
		do
			projected_task_time := task_time
			regular_event_producer.set_interval ((projected_task_time / 100.0).rounded)
			start
		end

feature -- Basic operations

	stop
			--
		do
			Precursor
			percent_complete := 1.0
			redraw
		end

feature {NONE} -- Event handlers

	on_events_start
			--
		do
			log.enter ("on_events_start")
			percent_complete := 0.0
			create bar_rect.make (0, 0, width, height)
			set_font (
				create {EV_FONT}.make_with_values (
					family_sans, weight_regular, shape_regular, height * 2 // 3
				)
			)
			redraw
			log.exit
		end

	on_timer_event
			-- Update progress of status bar
		do
			log.enter ("on_timer_event")
			if percent_complete < 0.9 then
				percent_complete := event.elapsed_millisecs.to_real / projected_task_time
--				ev_application.do_once_on_idle (agent redraw)
				redraw
			end
			log.put_integer_field ("event.count", event.count)
			log.put_string (" ")
			log.put_real_field ("percent_complete", percent_complete)
			log.put_new_line
			log.exit
		end


feature {NONE} -- Implementation

	projected_task_time: INTEGER
			-- Milliseconds

	percent_complete: REAL

	message: STRING

	bar_rect: EV_RECTANGLE

	bar_color: EV_COLOR

	text_color: EV_COLOR

end
