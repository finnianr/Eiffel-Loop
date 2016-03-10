note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:28:14 GMT (Thursday 1st January 2015)"
	revision: "4"

class
	JOB_INFORMATION

inherit
	EVOLICITY_EIFFEL_CONTEXT

create
	make

feature -- Initialization

	make (
		a_title, a_duration, a_description, a_date_posted_d_m_y, a_contact_name: STRING
		a_job_reference, a_start_date_d_m_y, a_location: STRING
		a_salary: INTEGER
	)
			--
		do
			make_default
			title := a_title
			duration := a_duration
			description := a_description
			date_posted_d_m_y := a_date_posted_d_m_y
			contact_name := a_contact_name
			job_reference := a_job_reference
			start_date_d_m_y := a_start_date_d_m_y
			location := a_location
			salary := a_salary
		end

feature -- Access

	title: STRING

	duration: STRING

	description: STRING

	date_posted_d_m_y: STRING

	contact_name: STRING

	job_reference: STRING

	start_date_d_m_y: STRING

	location: STRING

	salary: INTEGER

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["title", agent: STRING do Result := title end],
				["duration", agent: STRING do Result := duration end],
				["description", agent: STRING do Result := description end],
				["date_posted_d_m_y", agent: STRING do Result := date_posted_d_m_y end],
				["contact_name", agent: STRING do Result := contact_name end],
				["start_date_d_m_y", agent: STRING do Result := start_date_d_m_y end],
				["job_reference", agent: STRING do Result := job_reference end],
				["location", agent: STRING do Result := location end],
				["salary", agent: INTEGER_REF do Result := salary.to_reference end]
			>>)
		end

end
