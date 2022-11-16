note
	description: "Jobs result set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	JOBS_RESULT_SET

inherit
	EL_ARRAYED_LIST [JOB_INFO]
		rename
			make as make_set
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		undefine
			copy, is_equal
		redefine
			getter_function_table, Template
		end

create
	make

feature {NONE} -- Initialization

	make (document_root_node: EL_XML_DOC_CONTEXT; a_xpath_query: STRING)
			--
		do
			make_set (20)
			compare_objects
			make_default
			xpath_query := a_xpath_query
			across document_root_node.context_list (xpath_query) as job loop
				extend (create {JOB_INFO}.make (job.node))
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				[Var_current, 	 agent: LIST [JOB_INFO] do Result := Current end],
				["xpath_query", agent: STRING do Result := xpath_query end]
			>>)
		end

feature {NONE} -- Implementation

	xpath_query: STRING

	Template: STRING =
		-- Substitution template

	"[
		<html>	
			<head>
			    <title>Jobserve contracts</title>
			</head>
			<body>
			<h3>Results for query: $xpath_query</h3>
			#if $current.count = 0 then
				<h3>Zero results found</h3>
			#else
				#foreach $result in $Current loop
			    	<h3><a href="$result.job_url">$result.position</a></h3>
			    	<h4>Duration: $result.duration_interval_lower days</h4>
					<h4>$result.location ($result.duration_text)</h4>
			    	<p>$result.details</p>
			    	<p><b>Contact:</b> $result.contact</p>
			    #end
			#end
			</body>
		</html>
	]"

end