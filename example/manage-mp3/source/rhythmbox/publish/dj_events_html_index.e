note
	description: "Summary description for {MUSIC_VENUE_EVENTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-08 17:51:08 GMT (Thursday 8th January 2015)"
	revision: "7"

class
	DJ_EVENTS_HTML_INDEX

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (dj_events: ARRAY [DJ_EVENT_PLAYLIST]; a_template_path, a_output_path: like output_path)
			--
		local
			events_ordered_by_date: EL_SORTABLE_ARRAYED_LIST [DJ_EVENT_PLAYLIST]
			events_for_year: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]
			year: INTEGER; year_context: EVOLICITY_CONTEXT_IMPL
		do
			create events_by_year.make (10)
			make_from_template_and_output (a_template_path, a_output_path)
			create events_ordered_by_date.make_from_array (dj_events)
			events_ordered_by_date.sort
			across events_ordered_by_date as event loop
				if year /= event.item.date.year then
					create events_for_year.make (20)
					create year_context.make
					year := event.item.date.year
					year_context.put_variable (year.to_reference, once "year")
					year_context.put_variable (events_for_year, once "list")
					events_by_year.extend (year_context)
				end
				events_for_year.extend (event.item)
			end
		end

feature -- Access

	events_by_year: EL_ARRAYED_LIST [EVOLICITY_CONTEXT_IMPL]

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
		do
			create Result.make (<<
				["events_by_year", agent: like events_by_year do Result := events_by_year end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING = ""

end
