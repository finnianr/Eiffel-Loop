note
	description: "[
		Generates XHTML representation of Eiffel cluster class list with indexing descriptions (if any)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	CLASS_LIBRARY_MANIFEST

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			getter_function_table, Template
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_empty
			create cluster_list.make
		end

feature -- Access

	cluster_list: LINKED_LIST [CLUSTER]

feature {NONE} -- Evolicity fields

	get_cluster_list: LINKED_LIST [CLUSTER]
			--
		do
			Result := cluster_list
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["cluster_list", agent get_cluster_list]
			>>)
		end

feature {NONE} -- Implementation

	Template: STRING = "[
		#if $cluster_list.count > 0 then	
		<h2>Contents</h2>
		#across $cluster_list as $cluster loop
			<p><a href="#CL$cluster.cursor_index">$cluster.item.path</a></p>
		#end
		#across $cluster_list as $cluster loop
			<h4><a name="CL$cluster.cursor_index"></a>$cluster.item.path</h4>
			#if $cluster.item.class_info_list.count > 0 then
				#across $cluster.item.class_info_list as $class loop
			<p>
				#if $class.item.has_description then
					$class.item.name: <pre>$class.item.escaped_description</pre>
				#else
					$class.item.name
				#end
			</p>
				#end
			#end
		#end
		#end
	]"

end
