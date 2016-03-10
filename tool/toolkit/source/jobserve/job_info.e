note
	description: "Summary description for {JOB_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 12:33:19 GMT (Thursday 1st January 2015)"
	revision: "3"

class
	JOB_INFO

inherit
	COMPARABLE
		redefine
			is_equal
		end

	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (row_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make_default

			duration_text := row_node.string_at_xpath ("duration/@value").as_lower
			duration_text.left_adjust
			if duration_text.is_empty then
				duration_text := "Unknown"
			end
			Duration_parser.set_duration_interval (duration_text)
			duration_interval := Duration_parser.duration_interval
			location := row_node.string_at_xpath ("location/@value")
			position := row_node.string_at_xpath ("position/@value")
			job_url := row_node.string_at_xpath ("job_url/@value")
			details := row_node.string_at_xpath ("details/@value")
			contact := row_node.string_at_xpath ("contact/@value")
		end

feature -- Access

	position: STRING

	details: STRING

	location: STRING

	contact: STRING

	duration_interval: INTEGER_INTERVAL

	duration_text: STRING

	job_url: STRING

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			--
		do
			if duration_interval.lower = other.duration_interval.lower then
				Result := location < other.location
			else
				Result := duration_interval.lower < other.duration_interval.lower
			end
		end

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := job_url.is_equal (other.job_url)
		end

feature {NONE} -- Implementation

	Duration_parser: JOB_DURATION_PARSER
			--
		once
			create Result.make
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["position",					 	agent: STRING do Result := position end],
				["details", 						agent: STRING do Result := details end],
				["location",					 	agent: STRING do Result := location end],
				["contact",							agent: STRING do Result := contact end],
				["duration_text", 				agent: STRING do Result := duration_text end],
				["duration_interval_lower", 	agent: INTEGER do Result := duration_interval.lower.to_reference end],
				["job_url", 						agent: STRING do Result := job_url end]
			>>)
		end

end
