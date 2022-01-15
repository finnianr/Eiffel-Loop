note
	description: "A Xpath queryable XML node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 17:15:13 GMT (Saturday 15th January 2022)"
	revision: "21"

class
	EL_XPATH_NODE_CONTEXT

inherit
	EL_OWNED_C_OBJECT -- VTDNav
		rename
			c_free as c_evx_free_node_context
		export
			{EL_XPATH_NODE_CONTEXT, EL_VTD_XPATH_QUERY, EL_VTD_XML_ATTRIBUTE_API} self_ptr
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

	EL_STRING_8_CONSTANTS

	EL_VTD_CONSTANTS

	EL_XPATH_FIELD_SETTERS

	EL_MODULE_LIO

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

create
	make_from_other

feature {NONE} -- Initaliazation

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

	make_from_other (other: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (c_create_context_copy (other.self_ptr), other)
		end

feature -- Access

	attributes: EL_ELEMENT_ATTRIBUTE_TABLE

	context_list (a_xpath: READABLE_STRING_GENERAL): EL_XPATH_NODE_CONTEXT_LIST
			--
		do
			create Result.make (Current, a_xpath)
		end

	date_at_xpath (a_xpath: READABLE_STRING_GENERAL): DATE
			--
		require
			days_format: string_at_xpath (a_xpath).is_natural
		do
			create Result.make_by_days (integer_at_xpath (a_xpath))
		end

	double_at_xpath (a_xpath: READABLE_STRING_GENERAL): DOUBLE
			--
		do
			Result := new_query (a_xpath).evaluate_number
		end

	integer_64_at_xpath (a_xpath: READABLE_STRING_GENERAL): INTEGER_64
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded_real_64.truncated_to_integer_64
		end

	integer_at_xpath (a_xpath: READABLE_STRING_GENERAL): INTEGER
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded
		end

	name: STRING
			--
		do
			Result := wide_string (c_node_context_name (self_ptr))
		end

	natural_64_at_xpath (a_xpath: READABLE_STRING_GENERAL): NATURAL_64
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded_real_64.truncated_to_integer_64.to_natural_64
		end

	natural_at_xpath (a_xpath: READABLE_STRING_GENERAL): NATURAL
			--
		do
			Result := new_query (a_xpath).evaluate_number.rounded_real_64.truncated_to_integer_64.to_natural_32
		end

	real_at_xpath (a_xpath: READABLE_STRING_GENERAL): REAL
			--
		do
			Result := new_query (a_xpath).evaluate_number.truncated_to_real
		end

	string_32_at_xpath (a_xpath: READABLE_STRING_GENERAL): STRING_32
			--
		do
			Result := new_query (a_xpath).evaluate_string_32
		end

	string_8_at_xpath (a_xpath: READABLE_STRING_GENERAL): STRING
			--
		do
			Result := new_query (a_xpath).evaluate_string_8
		end

	string_at_xpath (a_xpath: READABLE_STRING_GENERAL): ZSTRING
			--
		do
			Result := new_query (a_xpath).evaluate_string
		end

feature -- Element change

	set_namespace (a_namespace: STRING)
			--
		require
			namespace_exists: namespace_urls.has (a_namespace)
		do
			namespace := a_namespace
		end

feature -- Basic operations

	find_node (a_xpath: READABLE_STRING_GENERAL): detachable EL_XPATH_NODE_CONTEXT
			--
		do
			create actual_found_node.make_from_other (Current)
			actual_found_node.do_query (a_xpath)
			if actual_found_node.match_found then
				Result := actual_found_node
			end
		end

feature -- External field setters

	set_boolean (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [BOOLEAN])
			-- call `set_value' with BOOLEAN value at `a_xpath'
		do
			Setter_boolean.set_from_node (Current, a_xpath, set_value)
		end

	set_double (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [DOUBLE])
			-- call `set_value' with DOUBLE value at `a_xpath'
		do
			Setter_double.set_from_node (Current, a_xpath, set_value)
		end

	set_integer (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [INTEGER])
			-- call `set_value' with INTEGER value at `a_xpath'
		do
			Setter_integer.set_from_node (Current, a_xpath, set_value)
		end

	set_integer_64 (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [INTEGER_64])
			-- call `set_value' with INTEGER_64 value at `a_xpath'
		do
			Setter_integer_64.set_from_node (Current, a_xpath, set_value)
		end

	set_natural (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [NATURAL])
			-- call `set_value' with NATURAL value at `a_xpath'
		do
			Setter_natural.set_from_node (Current, a_xpath, set_value)
		end

	set_natural_64 (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [NATURAL_64])
			-- call `set_value' with NATURAL_64 value at `a_xpath'
		do
			Setter_natural_64.set_from_node (Current, a_xpath, set_value)
		end

	set_node_values (a_xpath: READABLE_STRING_GENERAL; set_values: PROCEDURE [EL_XPATH_NODE_CONTEXT])
			-- call `set_values' with node at `a_xpath' if found
		do
			if attached find_node (a_xpath) as node then
				set_values (node)
			end
		end

	set_real (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [REAL])
			-- call `set_value' with REAL value at `a_xpath'
		do
			Setter_real.set_from_node (Current, a_xpath, set_value)
		end

	set_string (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [ZSTRING])
			-- call `set_value' with ZSTRING value at `a_xpath'
		do
			Setter_string.set_from_node (Current, a_xpath, set_value)
		end

	set_string_32 (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [STRING_32])
			-- call `set_value' with STRING_32 value at `a_xpath'
		do
			Setter_string_32.set_from_node (Current, a_xpath, set_value)
		end

	set_string_8 (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [STRING])
			-- call `set_value' with STRING_8 value at `a_xpath'
		do
			Setter_string_8.set_from_node (Current, a_xpath, set_value)
		end

	set_string_general (a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [READABLE_STRING_GENERAL])
			-- call `set_value' with ZSTRING value at `a_xpath'
		do
			Setter_string_general.set_from_node (Current, a_xpath, set_value)
		end

	set_tuple (tuple: TUPLE; a_xpath_list: STRING)
		require
			same_field_count: tuple.count = a_xpath_list.occurrences (',') + 1
		local
			xpath_list: EL_STRING_8_LIST; index, type_id: INTEGER
			tuple_type: TYPE [TUPLE]; xpath: STRING
		do
			tuple_type := tuple.generating_type
			create xpath_list.make_comma_split (a_xpath_list)
			across xpath_list as l_xpath loop
				index := l_xpath.cursor_index
				xpath := l_xpath.item
				inspect tuple.item_code (index)
					when {TUPLE}.Integer_32_code then
						tuple.put_integer (integer_at_xpath (xpath), index)

					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (integer_64_at_xpath (xpath), index)

					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (natural_at_xpath (xpath), index)

					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (natural_64_at_xpath (xpath), index)

					when {TUPLE}.Real_32_code then
						tuple.put_real_32 (real_at_xpath (xpath), index)

					when {TUPLE}.Real_64_code then
						tuple.put_real_64 (double_at_xpath (xpath), index)

					when {TUPLE}.Boolean_code then
						tuple.put_boolean (is_xpath (xpath), index)

					when {TUPLE}.Reference_code then
						type_id := tuple_type.generic_parameter_type (index).type_id
						if type_id = Class_id.ZSTRING then
							tuple.put_reference (string_at_xpath (xpath), index)
						elseif type_id = Class_id.STRING_8 then
							tuple.put_reference (string_8_at_xpath (xpath), index)
						elseif type_id = Class_id.STRING_32 then
							tuple.put_reference (string_32_at_xpath (xpath), index)
						end
				else
				end
			end
		end

feature -- Status query

	has (xpath: STRING): BOOLEAN
			--
		do
			Result := not is_empty_result_set (xpath)
		end

	is_empty_result_set (xpath: READABLE_STRING_GENERAL): BOOLEAN
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

	is_xpath (a_xpath: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := new_query (a_xpath).evaluate_boolean
		end

feature -- Element values

	boolean_value: BOOLEAN
		local
			value: STRING_32
		do
			value := raw_string_32_value
			if value.is_boolean then
				Result := value.to_boolean
			end
		end

	date_value: DATE
			-- element content as a DOUBLE
		require
			days_format: normalized_string_value.is_natural
		do
			create Result.make_by_days (integer_value)
		end

	double_value: DOUBLE
			-- element content as a DOUBLE
		require
			value_is_double: normalized_string_value.is_double
		do
			Result := c_node_context_double (self_ptr)
		end

	integer_64_value: INTEGER_64
			-- element content as an INTEGER_64
		require
			value_is_integer_64: normalized_string_value.is_integer_64
		do
			Result := c_node_context_integer_64 (self_ptr)
		end

	integer_value: INTEGER
			-- element content as an INTEGER
		require
			value_is_integer: normalized_string_value.is_integer
		do
			Result := c_node_context_integer (self_ptr)
		end

	natural_64_value: NATURAL_64
			-- element content as a NATURAL_64
		require
			value_is_natural_64: normalized_string_value.is_natural_64
		do
			Result := normalized_string_value.to_natural_64
		end

	natural_value: NATURAL
			-- element content as a NATURAL
		require
			value_is_natural: normalized_string_value.is_natural
		do
			Result := normalized_string_value.to_natural
		end

	normalized_string_32_value: STRING_32
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	normalized_string_8_value: STRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	normalized_string_value: ZSTRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	raw_string_32_value: STRING_32
			-- element content as wide string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	raw_string_value: ZSTRING
			-- element content as string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	real_value: REAL
			-- element content as a REAL
		require
			value_is_real: normalized_string_value.is_real
		do
			Result := c_node_context_real (self_ptr)
		end

	string_32_value: STRING_32
			-- The entity and character references will be resolved
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	string_8_value: STRING
			-- The entity and character references will be resolved
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	string_value: ZSTRING
			-- The entity and character references will be resolved
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

feature {EL_XPATH_NODE_CONTEXT, EL_XPATH_NODE_CONTEXT_LIST, EL_XPATH_NODE_CONTEXT_LIST_ITERATION_CURSOR}
	-- Implementation: query iteration

	match_found: BOOLEAN
			--
		do
			Result := not xpath_query.after
		end

	query_forth
			--
		do
			xpath_query.forth
		end

	query_start, do_query (a_xpath: READABLE_STRING_GENERAL)
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

feature {EL_XPATH_NODE_CONTEXT} -- Implementation

	context_image: EL_VTD_CONTEXT_IMAGE
			-- Update context image from context
		local
			size: INTEGER
		do
			size := c_evx_size_of_node_context_image (self_ptr)
			if actual_context_image.is_empty then
				create actual_context_image.make (size)

			elseif actual_context_image.count /= size then
				actual_context_image.conservative_resize_with_default (0, 1, size)
			end
			Result := actual_context_image
			c_evx_read_node_context (self_ptr, actual_context_image.area.base_address )
		end

	new_query (a_xpath: READABLE_STRING_GENERAL): EL_VTD_XPATH_QUERY
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

feature {EL_XPATH_NODE_CONTEXT} -- Internal attributes

	xpath_query: EL_VTD_XPATH_QUERY

	actual_found_node: EL_XPATH_NODE_CONTEXT

	namespace: STRING

	parent_context_image, actual_context_image: EL_VTD_CONTEXT_IMAGE

end