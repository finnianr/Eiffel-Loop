note
	description: "Regular interval event consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_REGULAR_INTERVAL_EVENT_CONSUMER

inherit
	EL_CONSUMER [EL_REGULAR_INTERVAL_EVENT]
		rename
			consume_product as process_event,
			product as event
		end

	EL_REGULAR_INTERVAL_EVENT_CONSTANTS

feature {NONE} -- Event handlers

	on_event
			--
		deferred
		end

	on_events_start
			--
		do
		end

	on_events_end
			--
		do
		end

feature {NONE} -- Implementation

	process_event
			--
		do
			inspect event.type

			when Delimiter_start then
				on_events_start

			when Delimiter_end then
				on_events_end

			else
				on_event
			end
		end

end