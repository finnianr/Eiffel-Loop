note
	description: "Summary description for {EL_SERVER_ACTIVITY_METERS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:58:24 GMT (Sunday 10th May 2015)"
	revision: "4"

class
	EL_SERVER_ACTIVITY_METERS

inherit
	EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER
		rename
			on_event as refresh,
			on_events_start as on_server_activity_start,
			on_events_end as  on_server_activity_end,
			stop as stop_consumer,
			prompt as prompt_refresh
		export
			{NONE} all
		redefine
			on_server_activity_start, on_server_activity_end, prompt_refresh
		end

	EL_EROS_UI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_LOG
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_max_threads: INTEGER)
			--
		local
			row: EV_HORIZONTAL_BOX
		do
			make_default
			max_threads := a_max_threads

			create service_stats.make (max_threads)
			service_stats.set_display_refresh_timer (
				create {EL_REGULAR_INTERVAL_EVENT_PROCESSOR}.make_event_producer (Current, "Activity meters refresh timer", Refresh_interval)
			)

			create thread_count_suffix.make_from_string (" of ")
			thread_count_suffix.append_integer (max_threads)

			create row
			row.set_border_width (5)
			row.set_padding (10)

			create thread_count_meter
			create queued_connection_count_meter
			row.extend (
				create_meter_column ("Connections", <<
					create_meter_frame ("Request threads", << thread_count_meter >>),
					create_meter_frame ("Queued connections", << queued_connection_count_meter >>)
				>>)
			)
			row.disable_item_expand (row.last)
			row.extend (vertical_separator (5))

			create procedure_count_meter; create procedure_rate_meter
			create function_count_meter; create function_rate_meter
			row.extend (
				create_meter_column ("Routines", <<
					create_meter_frame ("Procedures executed", << procedure_count_meter, procedure_rate_meter >>),
					create_meter_frame ("Functions executed", << function_count_meter, function_rate_meter >>)
				>>)
			)
			row.disable_item_expand (row.last)
			row.extend (vertical_separator (5))

			create failure_meter
			row.extend (
				create_meter_column ("Errors", <<
					create_meter_frame ("Routine failures", << failure_meter >>)
				>>)
			)
			row.disable_item_expand (row.last)
			row.extend (vertical_separator (5))

			create data_received_meter; create data_received_rate_meter
			create data_sent_meter; create data_sent_rate_meter
			row.extend (
				create_meter_column ("Data volume", <<
					create_meter_frame ("Megabytes received", << data_received_meter, data_received_rate_meter >>),
					create_meter_frame ("Megabytes sent", << data_sent_meter, data_sent_rate_meter >>)
				>>)
			)
			row.disable_item_expand (row.last)

			widget := row
		end

feature -- Access

	widget: EV_WIDGET

	service_stats: EL_ROUTINE_CALL_SERVICE_STATS

feature -- Basic operations

	reset
			--
		do
			refresh_count := 0
			refresh_count := 0

			-- Line 1
			set_thread_count_meter (0)
			set_count_meter (queued_connection_count_meter, 0, Format_queued_connection_count)

			set_count_meter (function_count_meter, 0, Format_count)
			set_routine_rate_meter (function_rate_meter, 0)

			set_count_meter (procedure_count_meter, 0, Format_count)
			set_routine_rate_meter (procedure_rate_meter, 0)

			set_count_meter (failure_meter, 0, Format_failed_connection_count)

			-- Line 2
			set_data_meter (data_received_meter, 0)
			set_data_rate_meter (data_received_rate_meter, 0)
			set_data_meter (data_sent_meter, 0)
			set_data_rate_meter (data_sent_rate_meter, 0)
		end

	refresh
			--
		do
			if refresh_count \\ 5 = 0 then
				log.enter_no_header ("refresh")
				log.put_integer_field ("Activity meters refresh count", refresh_count)
				log.put_new_line
				log.exit_no_trailer
			end

			set_count_meter (function_count_meter, service_stats.function_count.value, Format_count)
			set_routine_rate_meter (function_rate_meter, service_stats.function_rate)

			set_count_meter (procedure_count_meter, service_stats.procedure_count.value, Format_count)
			set_routine_rate_meter (procedure_rate_meter, service_stats.procedure_rate)

			set_count_meter (failure_meter, service_stats.failure_count.value, Format_failed_connection_count)

			set_data_meter (data_received_meter, service_stats.bytes_received_count.value)
			set_data_rate_meter (data_received_rate_meter, service_stats.bytes_received_rate)

			set_data_meter (data_sent_meter, service_stats.bytes_sent_count.value)
			set_data_rate_meter (data_sent_rate_meter, service_stats.bytes_sent_rate)

			set_thread_count_meter (service_stats.thread_count.value)
			set_count_meter (
				queued_connection_count_meter, service_stats.queued_connection_count.value,
				Format_queued_connection_count
			)
		end

feature -- Element change

	set_routine_rate_meter (meter: EV_LABEL; rate: INTEGER)
			--
		do
			meter.set_text (Format_rate.formatted (rate) + once "/sec")
		end

	set_data_rate_meter (meter: EV_LABEL; byte_rate: DOUBLE)
			--
		do
			meter.set_text (Format_data_rate.formatted (byte_rate / Mega_bytes) + once "/sec")
		end

	set_count_meter (meter: EV_LABEL; count: INTEGER; format: FORMAT_INTEGER)
			--
		do
			meter.set_text (format.formatted (count))
		end

	set_thread_count_meter (count: INTEGER)
			--
		do
			thread_count_meter.set_text (Format_thread_count.formatted (count) + thread_count_suffix)
		end

	set_data_meter (meter: EV_LABEL; bytes: INTEGER_64)
			--
		do
			meter.set_text (Format_data.formatted (bytes / Mega_bytes) + once " mb")
		end

feature {NONE} -- UI building

	create_meter_frame (name: STRING; meters: ARRAY [EV_LABEL]): EL_FRAME [EL_HORIZONTAL_BOX]
			--
		local
			meter: EV_LABEL
			i: INTEGER
		do
			create Result.make_with_text (0.2, 0.2, name)
			Result.set_style (Frame_style.Ev_frame_etched_out)

			from i := 1 until i > meters.count loop
				meter := meters [i]
				meter.set_background_color (Stock_colors.Black)
				meter.set_foreground_color (Color_orange)
				meter.set_font (Meter_font)
				meter.set_minimum_height ((Meter_font.height * 1.2).rounded)

				Result.extend (meter)
				Result.disable_last_item_expand
				i := i + 1
			end
		end

	create_meter_column (heading: STRING; meter_frames: ARRAY [like create_meter_frame]): EV_VERTICAL_BOX
			--
   		local
   			label: EV_LABEL
			i: INTEGER
		do
			create Result
			Result.set_padding (5)
			create label.make_with_text (heading)
			label.set_font (Heading_font)
			label.align_text_center
			Result.extend (label)
			Result.disable_item_expand (Result.last)

			from i := 1 until i > meter_frames.count loop
				Result.extend (meter_frames [i])
				Result.disable_item_expand (Result.last)
				i := i + 1
			end
		end

	vertical_separator (a_width: INTEGER): EV_VERTICAL_SEPARATOR
			--
		do
			create Result
			Result.set_minimum_width (a_width)
		end

feature {NONE} -- Implementation: routines


	on_server_activity_start
			--
		do
			refresh_count := 0
			reset
			refresh
		end

	on_server_activity_end
			--
		do
			refresh
			set_routine_rate_meter (function_rate_meter, 0)
			set_routine_rate_meter (procedure_rate_meter, 0)
			set_data_rate_meter (data_received_rate_meter, 0)
			set_data_rate_meter (data_sent_rate_meter, 0)
		end

	prompt_refresh
			--
		do
			Precursor
			refresh_count := refresh_count + 1
			if refresh_count \\ 5 = 0 then
				log.enter_no_header ("prompt_refresh")
				log.put_integer_field ("Timer event count", refresh_count)
				log.put_new_line
				log.exit_no_trailer
			end
		end

feature {NONE} -- Meter labels

	thread_count_meter: EV_LABEL

	queued_connection_count_meter: EV_LABEL

	procedure_count_meter: EV_LABEL

	function_count_meter: EV_LABEL

	procedure_rate_meter: EV_LABEL

	function_rate_meter: EV_LABEL

	failure_meter: EV_LABEL

	data_received_meter: EV_LABEL

	data_received_rate_meter: EV_LABEL

	data_sent_meter: EV_LABEL

	data_sent_rate_meter: EV_LABEL

feature {NONE} -- Implementation: attributes

	max_threads: INTEGER

	refresh_count: INTEGER

	thread_count_suffix: STRING

feature {NONE} -- Constants

	Format_data: FORMAT_DOUBLE
			--
		once
			create Result.make (6, 1)
			Result.show_zero
		end

	Format_data_rate: FORMAT_DOUBLE
			--
		once
			create Result.make (5, 2)
			Result.show_zero
		end

	Format_count: FORMAT_INTEGER
			--
		once
			create Result.make (7)
		end

	Format_thread_count, Format_queued_connection_count, Format_failed_connection_count: FORMAT_INTEGER
			--
		once
			create Result.make (3)
		end

	Format_rate: FORMAT_INTEGER
			--
		once
			create Result.make (4)
		end

	Mega_bytes: INTEGER
			--
		once
			Result := 1000 * 1000
		end

	Color_orange: EV_COLOR
			--
		once
			create Result.make_with_8_bit_rgb (250, 161, 29)
		end

	Refresh_interval: INTEGER = 250 -- millisecs

end
