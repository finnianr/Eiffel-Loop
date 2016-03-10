note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_REGULAR_INTERVAL_EVENT_CONSUMER

inherit
	EL_CONSUMER [EL_REGULAR_INTERVAL_EVENT]
		rename
			consume_product as process_event,
			product as event
		end

	EL_REGULAR_INTERVAL_EVENT_CONSTANTS
		undefine
			default_create
		end

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
