note
	description: "Summary description for {EL_VTD_XPATH_QUERY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EL_VTD_XPATH_QUERY

inherit
	EL_C_OBJECT -- AutoPilot
		rename
			c_free as c_evx_free_xpath_query
		undefine
			c_evx_free_xpath_query
		redefine
			is_memory_owned
		end

	EL_VTD_XML_API

	EL_VTD_SHARED_NATIVE_XPATH

create
	make, make_xpath, make_xpath_for_namespace

feature {NONE} -- Initialization

	make (a_context: EL_XPATH_NODE_CONTEXT)
			--
		do
			context := a_context
		end

	make_xpath (a_context: EL_XPATH_NODE_CONTEXT; a_xpath: STRING_32)
			--
		do
			make (a_context)
			set_xpath (a_xpath)
		end

	make_xpath_for_namespace (a_context: EL_XPATH_NODE_CONTEXT; a_xpath: STRING_32; namespace: STRING)
			--
		do
			make (a_context)
			set_xpath_for_namespace (a_xpath, namespace)
		end

feature -- Element change

	set_xpath (a_xpath: STRING_32)
			--
		do
			dispose
			xpath := a_xpath
			make_from_pointer (c_create_xpath_query (native_xpath (a_xpath).base_address))
		end

	set_xpath_for_namespace (a_xpath: STRING_32; namespace: STRING)
			--
		require
			not_namespace_empty: not namespace.is_empty
		local
			c_ns_prefix, c_ns_url: EL_C_WIDE_CHARACTER_STRING
		do
			dispose
			xpath := a_xpath
			C_namespaces.search (namespace)
			if C_namespaces.found then
				c_ns_prefix := C_namespaces.found_item [1]
				c_ns_url := C_namespaces.found_item [2]
			else
				create c_ns_prefix.make_from_string (namespace)
				create c_ns_url.make_from_string (context.namespace_urls [namespace])
				C_namespaces.extend (<< c_ns_prefix, c_ns_url >>, namespace)
			end
			make_from_pointer (
				c_create_xpath_query_for_namespace (
					native_xpath (a_xpath).base_address, c_ns_prefix.base_address, c_ns_url.base_address
				)
			)
		end

feature -- Acces

	xpath: STRING_32

	evaluate_boolean: BOOLEAN
			--
		do
			Result := c_evaluate_xpath_to_boolean (context.self_ptr, self_ptr)
		end

	evaluate_number: DOUBLE
			--
		do
			Result := c_evaluate_xpath_to_number (context.self_ptr, self_ptr)
		end

	evaluate_string: ASTRING
			--
		do
			Result := wide_string (c_evaluate_xpath_to_string (context.self_ptr, self_ptr))
		end

	evaluate_string_32: STRING_32
			--
		do
			Result := wide_string (c_evaluate_xpath_to_string (context.self_ptr, self_ptr))
		end

feature -- Basic operations

	start
			--
		do
			nodeset_index := c_xpath_query_start (context.self_ptr, self_ptr)
			if after then
				c_evx_reset_xpath_query (self_ptr)
			end
		end

	forth
			--
		do
			nodeset_index := c_xpath_query_forth (context.self_ptr, self_ptr)
			if after then
				c_evx_reset_xpath_query (self_ptr)
			end
		end

feature -- Status query

	is_xpath_set: BOOLEAN
			--
		do
			Result := is_attached (self_ptr)
		end

	after: BOOLEAN
			--
		do
			Result := nodeset_index = -1
		end

feature {NONE} -- Implementation

	C_namespaces: HASH_TABLE [ARRAY [EL_C_WIDE_CHARACTER_STRING], STRING]
			--
		once
			create Result.make_equal (11)
		end

	context: EL_XPATH_NODE_CONTEXT

	nodeset_index: INTEGER

   is_memory_owned: BOOLEAN = true

end
