note
	description: "Dj events html index"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	DJ_EVENTS_HTML_INDEX

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

	EL_STRING_8_CONSTANTS
		rename
			Empty_string_8 as Template
		end

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_dj_events: like dj_events; a_template_path, a_output_path: like output_path)
			--
		do
			make_from_template_and_output (a_template_path, a_output_path)
			dj_events := a_dj_events
		end

feature {NONE} -- Implementation

	events_ordered_by_date: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]
		-- reverse chronological order
		do
			Result := dj_events.ordered_by (agent {DJ_EVENT_PLAYLIST}.date, False)
		end

feature {NONE} -- Evolicity fields

	get_events_by_year: EL_ARRAYED_LIST [EVOLICITY_CONTEXT_IMP]
		local
			events_for_year: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]
			year: INTEGER; year_context: EVOLICITY_CONTEXT_IMP
		do
			create Result.make (10)
			across events_ordered_by_date as event loop
				if year /= event.item.date.year then
					create events_for_year.make (20)
					create year_context.make
					year := event.item.date.year
					year_context.put_variable (year.to_reference, once "year")
					year_context.put_variable (events_for_year, once "list")
					Result.extend (year_context)
				end
				events_for_year.extend (event.item)
			end
		end

	getter_function_table: like getter_functions
		do
			create Result.make (<< ["events_by_year", agent get_events_by_year] >>)
		end

feature {NONE} -- Internal attributes

	dj_events: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]

end