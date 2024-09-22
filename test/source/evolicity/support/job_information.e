note
	description: "Job information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:38 GMT (Sunday 22nd September 2024)"
	revision: "9"

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

	contact_name: STRING

	date_posted_d_m_y: STRING

	description: STRING

	duration: STRING

	job_reference: STRING

	location: STRING

	salary: INTEGER

	start_date_d_m_y: STRING

	title: STRING

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["title",				 agent: STRING do Result := title end],
				["duration",			 agent: STRING do Result := duration end],
				["description",		 agent: STRING do Result := description end],
				["date_posted_d_m_y", agent: STRING do Result := date_posted_d_m_y end],
				["contact_name",		 agent: STRING do Result := contact_name end],
				["start_date_d_m_y",	 agent: STRING do Result := start_date_d_m_y end],
				["job_reference",		 agent: STRING do Result := job_reference end],
				["location",			 agent: STRING do Result := location end],
				["salary",				 agent: INTEGER_REF do Result := salary.to_reference end]
			>>)
		end

end