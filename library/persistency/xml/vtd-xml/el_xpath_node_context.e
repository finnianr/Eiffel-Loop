note
	description: "A Xpath queryable XML node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:20:54 GMT (Thursday 24th February 2022)"
	revision: "23"

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

	EL_STRING_8_CONSTANTS

	EL_VTD_CONSTANTS

	EL_XPATH_FIELD_SETTERS

	EL_MODULE_LIO

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

create
	make_from_other

convert
	as_string: {ZSTRING}, as_string_8: {STRING}, as_string_32: {STRING_32},
	as_real: {REAL}, as_double: {DOUBLE}, as_natural: {NATURAL}, as_natural_64: {NATURAL_64},
	as_integer: {INTEGER}, as_integer_64: {INTEGER_64}, as_file_path: {FILE_PATH}, as_dir_path: {DIR_PATH},
	as_boolean: {BOOLEAN}

feature {NONE} -- Initaliazation

	make (a_context: POINTER; a_parent: EL_XPATH_NODE_CONTEXT)
			--
		require
			context_attached: is_attached (a_context)
		do
			parent := a_parent
			make_from_pointer (a_context)
			actual_context_image := Empty_context_image -- Order of initialization important
			namespace_key := Empty_string_8

			create parent_context_image.make_from_other (a_parent.context_image)
			create attributes.make (Current)
			create xpath_query.make (Current)
		end

	make_from_other (other: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (c_create_context_copy (other.self_ptr), other)
			namespace_key := other.namespace_key
		end

feature -- Access

	attributes: EL_ELEMENT_ATTRIBUTE_TABLE

	context_list (a_xpath: READABLE_STRING_GENERAL): EL_XPATH_NODE_CONTEXT_LIST
			--
		do
			create Result.make (Current, a_xpath)
		end

	name: STRING
			--
		do
			Result := wide_string (c_node_context_name (self_ptr))
		end

	namespace_key: STRING
		-- value in `namespace_table'

	namespace_table: HASH_TABLE [STRING, STRING]
		do
			Result := parent.namespace_table
		end

	query (a_xpath: READABLE_STRING_GENERAL): EL_VTD_XPATH_QUERY
			--
		do
			if is_namespace_set then
				create Result.make_xpath_for_namespace (Current, a_xpath, namespace_key)
			else
				create Result.make_xpath (Current, a_xpath)
			end
		end

feature -- Element change

	set_namespace_key (a_namespace_key: STRING)
			--
		require
			valid_namespace: namespace_table.has_key (a_namespace_key)
		do
			namespace_key := a_namespace_key
		ensure
			name_space_set: is_namespace_set
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
						tuple.put_integer (query (xpath), index)

					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (query (xpath), index)

					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (query (xpath), index)

					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (query (xpath), index)

					when {TUPLE}.Real_32_code then
						tuple.put_real_32 (query (xpath), index)

					when {TUPLE}.Real_64_code then
						tuple.put_real_64 (query (xpath), index)

					when {TUPLE}.Boolean_code then
						tuple.put_boolean (query (xpath), index)

					when {TUPLE}.Reference_code then
						type_id := tuple_type.generic_parameter_type (index).type_id
						if type_id = Class_id.ZSTRING then
							tuple.put_reference (query (xpath).as_string, index)
						elseif type_id = Class_id.STRING_8 then
							tuple.put_reference (query (xpath).as_string_8, index)
						elseif type_id = Class_id.STRING_32 then
							tuple.put_reference (query (xpath).as_string_32, index)
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
			Result := not namespace_key.is_empty
		end

	is_xpath (a_xpath: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := query (a_xpath).as_boolean
		end

feature -- Element values

	as_boolean: BOOLEAN
		local
			value: STRING_32
		do
			value := as_raw_string_32
			if value.is_boolean then
				Result := value.to_boolean
			end
		end

	as_date: DATE
			-- element content as a DOUBLE
		require
			days_format: as_string.is_natural
		do
			create Result.make_by_days (as_integer)
		end

	as_dir_path: DIR_PATH
			--
		do
			Result := as_string
		end

	as_double: DOUBLE
			-- element content as a DOUBLE
		require
			value_is_double: as_string.is_double
		do
			Result := c_node_context_double (self_ptr)
		end

	as_file_path: FILE_PATH
			--
		do
			Result := as_string
		end

	as_full_string: ZSTRING
			-- The entity and character references will be resolved
			-- whitespace not trimmed
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	as_full_string_32: STRING_32
			-- The entity and character references will be resolved
			-- whitespace not trimmed
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	as_full_string_8: STRING
			-- The entity and character references will be resolved
			-- whitespace not trimmed
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	as_integer: INTEGER
			-- element content as an INTEGER
		require
			value_is_integer: as_string.is_integer
		do
			Result := c_node_context_integer (self_ptr)
		end

	as_integer_64: INTEGER_64
			-- element content as an INTEGER_64
		require
			value_is_integer_64: as_string.is_integer_64
		do
			Result := c_node_context_integer_64 (self_ptr)
		end

	as_natural: NATURAL
			-- element content as a NATURAL
		require
			value_is_natural: as_string.is_natural
		do
			Result := as_string.to_natural
		end

	as_natural_64: NATURAL_64
			-- element content as a NATURAL_64
		require
			value_is_natural_64: as_string.is_natural_64
		do
			Result := as_string.to_natural_64
		end

	as_raw_string: ZSTRING
			-- element content as string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	as_raw_string_32: STRING_32
			-- element content as wide string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	as_real: REAL
			-- element content as a REAL
		require
			value_is_real: as_string.is_real
		do
			Result := c_node_context_real (self_ptr)
		end

	as_string: ZSTRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	as_string_32: STRING_32
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	as_string_8: STRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
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
				xpath_query.set_xpath_for_namespace (a_xpath, namespace_key)
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

	reset
			--
		do
			c_evx_set_node_context (self_ptr, parent_context_image.area.base_address)
		end

feature {EL_XPATH_NODE_CONTEXT} -- Internal attributes

	actual_found_node: EL_XPATH_NODE_CONTEXT

	parent: EL_XPATH_NODE_CONTEXT

	parent_context_image, actual_context_image: EL_VTD_CONTEXT_IMAGE

	xpath_query: EL_VTD_XPATH_QUERY

end