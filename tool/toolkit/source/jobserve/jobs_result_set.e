note
	description: "Summary description for {JOB_INFO_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:56:29 GMT (Thursday 24th December 2015)"
	revision: "1"

class
	JOBS_RESULT_SET

inherit
	BINARY_SEARCH_TREE_SET [JOB_INFO]
		rename
			make as make_set
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			getter_function_table, Template
		end

create
	make

feature {NONE} -- Initialization

	make (document_root_node: EL_XPATH_ROOT_NODE_CONTEXT; a_xpath_query: STRING)
			--
		do
			make_set
			compare_objects
			make_default
			xpath_query := a_xpath_query
			across document_root_node.context_list (xpath_query) as job loop
				extend (create {JOB_INFO}.make (job.node))
			end
		end

feature {NONE} -- Evolicity fields

	get_current: ARRAYED_LIST [JOB_INFO]
			--
		do
			create Result.make (count)
			Result.fill (Current)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["current", 	 agent get_current],
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
				#foreach $result in $current loop
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