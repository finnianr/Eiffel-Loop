note
	description: "[
		Object to periodically process events in some other context whilst in the midst of a computation.
		Useful especially to check for UI events.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EVENT_CHECKER

feature -- Element change

	set_event_processor (an_event_processor: like event_processor)
			-- Set event_processor to check periodically
		do
			event_processor := an_event_processor
		ensure
			event_processor_assigned: event_processor = an_event_processor
		end
		
	set_event_checking_frequency (a_checking_frequency: INTEGER)
			-- 
		do
			checking_frequency := a_checking_frequency
		end
		

feature {NONE} -- Basic operations

	check_events
			-- Interrupt current calculation to check for and process events
		do
			if event_processor /= Void then
				if checking_frequency = 0 or check_count \\ checking_frequency = 0 then
					event_processor.process_events
				end
				check_count := check_count + 1
			end
		end

feature -- Implementation

	event_processor: EL_EVENT_PROCESSOR

	check_count: INTEGER
	
	checking_frequency: INTEGER
	
end
