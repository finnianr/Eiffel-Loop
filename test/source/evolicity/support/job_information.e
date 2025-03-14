note
	description: "Job information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 9:02:02 GMT (Friday 14th March 2025)"
	revision: "11"

class
	JOB_INFORMATION

inherit
	EVOLICITY_EIFFEL_CONTEXT

create
	make

feature -- Initialization

	make (
		a_title, a_duration, a_description, a_contact_name: STRING
		a_job_reference, a_location: STRING; a_posted_date, a_start_date: EL_DATE
		a_salary: INTEGER
	)
			--
		do
			make_default
			title := a_title; duration := a_duration; description := a_description
			contact_name := a_contact_name; job_reference := a_job_reference
			posted_date := a_posted_date; start_date := a_start_date
			location := a_location; salary := a_salary
		end

feature -- Dates

	posted_date: EL_DATE

	start_date: EL_DATE

feature -- Access

	contact_name: STRING

	description: STRING

	duration: STRING

	job_reference: STRING

	location: STRING

	salary: INTEGER

	title: STRING

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["title",			agent: STRING do Result := title end],
				["duration",		agent: STRING do Result := duration end],
				["description",	agent: STRING do Result := description end],
				["contact_name",	agent: STRING do Result := contact_name end],
				["job_reference",	agent: STRING do Result := job_reference end],
				["location",		agent: STRING do Result := location end],

				["posted_date",	agent: EL_DATE do Result := posted_date end],
				["start_date",		agent: EL_DATE do Result := start_date end],
				["salary",			agent: INTEGER_REF do Result := salary.to_reference end]
			>>)
		end

end