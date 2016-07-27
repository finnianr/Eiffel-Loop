note
	description: "A Xpath queryable XML node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:52:07 GMT (Friday 8th July 2016)"
	revision: "8"

class
	EL_XPATH_NODE_CONTEXT

inherit
	EL_C_OBJECT -- VTDNav
		rename
			c_free as c_evx_free_node_context
		export
			{EL_XPATH_NODE_CONTEXT, EL_VTD_XPATH_QUERY, EL_VTD_XML_ATTRIBUTE_API} self_ptr
		undefine
			c_evx_free_node_context
		redefine
			is_memory_owned
		end

	EL_VTD_XML_API
		export
			{NONE} all
			{EL_VTD_XML_ATTRIBUTE_API} exception_callbacks_c_struct
		end

	EL_XML_NAMESPACES
		rename
			make as parse_namespace_declarations,
			make_from_other as make_from_namespace,
			make_from_file as make_namespace_from_file
		end

	EL_VTD_CONSTANTS

	EL_MODULE_LIO

create
	make_from_other

feature {NONE} -- Initaliazation

	make_from_other (other: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (c_create_context_copy (other.self_ptr), other)
		end

	make (a_context: POINTER; parent: EL_XPATH_NODE_CONTEXT)
			--
		require
			context_attached: is_attached (a_context)
		do
			make_from_pointer (a_context)
			make_from_namespace (parent)
			actual_context_image := Empty_context_image -- Order of initialization important

			namespace :=  parent.namespace
			create parent_context_image.make_from_other (parent.context_image)
			create attributes.make (Current)
			create xpath_query.make (Current)
		end

feature -- Access

	name: STRING
			--
		do
			Result := wide_string (c_node_context_name (self_ptr))
		end

	attributes: EL_ELEMENT_ATTRIBUTE_TABLE

	found_node: EL_XPATH_NODE_CONTEXT
			--
		require
			node_found: node_found
		do
			Result := actual_found_node
		end

	context_list (a_xpath: STRING_32): EL_XPATH_NODE_CONTEXT_LIST
			--
		do
			create Result.make (Current, a_xpath)
		end

	double_at_xpath (a_xpath: STRING_32): DOUBLE
			--
		do
			Result := new_query (a_xpath).evaluate_number
		end

	date_at_xpath (a_xpath: STRING_32): DATE
			--
		require
			days_format: string_at_xpath (a_xpath).is_natural
		do
			create Result.make_by_days (integer_at_xpath (a_xpath))
		end

	integer_at_xpath (a_xpath: STRING_32): INTEGER
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded
		end

	integer_64_at_xpath (a_xpath: STRING_32): INTEGER_64
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded_real_64.truncated_to_integer_64
		end

	natural_at_xpath (a_xpath: STRING_32): NATURAL
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded_real_64.truncated_to_integer_64.to_natural_32
		end

	natural_64_at_xpath (a_xpath: STRING_32): NATURAL_64
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded_real_64.truncated_to_integer_64.to_natural_64
		end

	real_at_xpath (a_xpath: STRING_32): REAL
			--
		do
			Result := new_query (a_xpath).evaluate_number.truncated_to_real
		end

	string_at_xpath (a_xpath: STRING_32): ZSTRING
			--
		do
			Result := new_query (a_xpath).evaluate_string
		end

	string_32_at_xpath (a_xpath: STRING_32): STRING_32
			--
		do
			Result := new_query (a_xpath).evaluate_string_32
		end

feature -- Element change

	set_namespace (a_namespace: STRING)
			--
		require
			namespace_exists: namespace_urls.has (a_namespace)
		do
			namespace := a_namespace
		end

feature -- Search

	find_node (a_xpath: STRING_32)
			--
		do
			create actual_found_node.make_from_other (Current)
			actual_found_node.do_query (a_xpath)
		end

feature -- Status query

	node_found: BOOLEAN
			--
		do
			Result := actual_found_node.match_found
		end

	has (xpath: STRING): BOOLEAN
			--
		do
			Result := not is_empty_result_set (xpath)
		end

	is_empty_result_set (xpath: STRING): BOOLEAN
			-- query returns zero nodes
		local
			l_context: EL_XPATH_NODE_CONTEXT
		do
			create l_context.make_from_other (Current)
			l_context.query_start (xpath)
			Result := not l_context.match_found
		end

	is_namespace_set: BOOLEAN
			--
		do
			Result := not namespace.is_empty
		end

	is_xpath (a_xpath: STRING_32): BOOLEAN
			--
		do
			Result := new_query (a_xpath).evaluate_boolean
		end

feature -- Element values

	double_value: DOUBLE
			-- element content as a DOUBLE
		require
			value_is_double: normalized_string_value.is_double
		do
			Result := c_node_context_double (self_ptr)
		end

	date_value: DATE
			-- element content as a DOUBLE
		require
			days_format: normalized_string_value.is_natural
		do
			create Result.make_by_days (integer_value)
		end

	integer_value: INTEGER
			-- element content as an INTEGER
		require
			value_is_integer: normalized_string_value.is_integer
		do
			Result := c_node_context_integer (self_ptr)
		end

	integer_64_value: INTEGER_64
			-- element content as an INTEGER_64
		require
			value_is_integer_64: normalized_string_value.is_integer_64
		do
			Result := c_node_context_integer_64 (self_ptr)
		end

	normalized_string_value: ZSTRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	normalized_string_32_value: STRING_32
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	raw_string_value: ZSTRING
			-- element content as string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	raw_string_32_value: STRING_32
			-- element content as wide string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	string_value: ZSTRING
			-- The entity and character references will be resolved
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	string_32_value: STRING_32
			-- The entity and character references will be resolved
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	natural_value: NATURAL
			-- element content as a NATURAL
		require
			value_is_natural: normalized_string_value.is_natural
		do
			Result := normalized_string_value.to_natural
		end

	natural_64_value: NATURAL_64
			-- element content as a NATURAL_64
		require
			value_is_natural_64: normalized_string_value.is_natural_64
		do
			Result := normalized_string_value.to_natural_64
		end

	real_value: REAL
			-- element content as a REAL
		require
			value_is_real: normalized_string_value.is_real
		do
			Result := c_node_context_real (self_ptr)
		end

feature {EL_XPATH_NODE_CONTEXT, EL_XPATH_NODE_CONTEXT_LIST, EL_XPATH_NODE_CONTEXT_LIST_ITERATION_CURSOR}
	-- Implementation: query iteration

	query_start, do_query (a_xpath: STRING_32)
			--
		do
			reset
			if is_namespace_set then
				xpath_query.set_xpath_for_namespace (a_xpath, namespace)
			else
				xpath_query.set_xpath (a_xpath)
			end
			xpath_query.start
		end

	query_forth
			--
		do
			xpath_query.forth
		end

	match_found: BOOLEAN
			--
		do
			Result := not xpath_query.after
		end

	xpath_query: EL_VTD_XPATH_QUERY

feature {EL_XPATH_NODE_CONTEXT} -- Implementation

	new_query (a_xpath: STRING_32): EL_VTD_XPATH_QUERY
			--
		do
			if is_namespace_set then
				create Result.make_xpath_for_namespace (Current, a_xpath, namespace)
			else
				create Result.make_xpath (Current, a_xpath)
			end
		end

	reset
			--
		do
			c_evx_set_node_context (self_ptr, parent_context_image.area.base_address)
		end

	context_image: EL_VTD_CONTEXT_IMAGE
			-- Update context image from context
		local
			size: INTEGER
		do
			size := c_evx_size_of_node_context_image (self_ptr)
			if actual_context_image.is_empty then
				create actual_context_image.make (1, size)

			elseif actual_context_image.count /= size then
				actual_context_image.conservative_resize (1, size)
			end
			Result := actual_context_image
			c_evx_read_node_context (self_ptr, actual_context_image.area.base_address )
		end

	actual_found_node: EL_XPATH_NODE_CONTEXT

	parent_context_image, actual_context_image: EL_VTD_CONTEXT_IMAGE

	namespace: STRING

   is_memory_owned: BOOLEAN = true

feature {NONE} -- Constants

	Empty_context_image: EL_VTD_CONTEXT_IMAGE
			--
		once
			create Result.make (1, 0)
		end

end