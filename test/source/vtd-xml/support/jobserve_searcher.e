note
	description: "[
		Parse and query jobserve XML file for short contracts with option xpath filter
		and normalize the contract duration as number of days.
	]"
	notes: "[
		Sample XML:
		
			<?xml version="1.0" encoding="iso-8859-1"?>
			<job-serve>
				<row>
					<type value="Permanent"/>
					<postion value="Java Developer"/>
					<details value="Java/J2EE Developer - Banking - Finance - 55k-65k pa My client.."/>
					<location value="London"/>
					<when_start value="asap"/>
					<duration value="permanent"/>
					<rate value="£55 - £65"/>
					<advertiser value="Explore Group (Employment Agency)"/>
					<contact value="Josiah Millar"/>
					<tel1 value=""/>
					<tel2 value=""/>
					<email value="Josiah.Millar.9BCA2.7ECA8@mail.jobserve.com"/>
					<web value=""/>
					<reference value="JS"/>
					<job_url value="http://www.jobserve.com/E3373BCAA5919AC43.jsap"/>
					<visa value=""/>
					<date value="25/10/10 20:06"/>
				</row>
			<job-serve>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 12:13:51 GMT (Thursday 7th September 2023)"
	revision: "9"

class
	JOBSERVE_SEARCHER

inherit
	EL_COMMAND

	EL_MODULE_LIO

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_xml_path: FILE_PATH; output_dir: DIR_PATH; a_query_filter: ZSTRING)
		do
			xml_path := a_xml_path; query_filter := a_query_filter

			results_path := xml_path.with_new_extension ("results.html")
			if not output_dir.is_empty then
				results_path.set_parent_path (output_dir)
			end
			if not query_filter.is_empty then
				query_filter.prepend_string_general (" and (")
				query_filter.append_character (')')
			end
		end

feature -- Access

	query_filter: STRING

	results_path: FILE_PATH

	xml_path: FILE_PATH

feature -- Basic operations

	execute
		local
			jobs_result_set: JOBS_RESULT_SET; xpath: STRING
			xdoc: EL_XML_DOC_CONTEXT
		do
			create xdoc.make_from_file (xml_path)
			xpath := Xpath_template #$ [query_filter]
			lio.put_string_field ("XPATH", xpath)
			lio.put_new_line
			create jobs_result_set.make (xdoc, xpath)
			across jobs_result_set as job loop
				lio.put_labeled_string ("Position", job.item.position)
				lio.put_new_line
				lio.put_integer_interval_field ("Duration", job.item.duration_interval)
				lio.put_new_line
			end

			jobs_result_set.save_as_xml (results_path)
		end

feature {NONE} -- Constants

	Xpath_template: ZSTRING
		once
			Result := "/job-serve/row[type/@value='Contract'%S]"
		end

end