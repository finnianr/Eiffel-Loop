note
	description: "A XML node queryable with xpath expressions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-13 13:57:21 GMT (Thursday 13th February 2025)"
	revision: "30"

class
	EL_XPATH_NODE_CONTEXT

inherit
	EL_XPATH_NODE_CONTEXT_BASE

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
			create xpath_query.make (Current)
		end

	make_from_other (other: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (c_create_context_copy (other.self_ptr), other)
			namespace_key := other.namespace_key
		end

feature -- Access

	context_list (a_xpath: READABLE_STRING_GENERAL): EL_XPATH_NODE_CONTEXT_LIST
			--
		do
			create Result.make (Current, a_xpath)
		end

	item alias "[]" (a_name: READABLE_STRING_GENERAL): EL_ELEMENT_ATTRIBUTE
			-- shared element attribute named `a_name'
			-- (WARNING: do not keep as reference without twinning)
		require
			exists: has_attribute (a_name)
		do
			Result := Shared_attribute
			Result.set_context (Current, a_name)
		end

	name: STRING
			--
		do
			Result := wide_string (c_node_context_name (self_ptr))
		end

	namespace_key: STRING
		-- value in `namespace_table'

	namespace_table: EL_HASH_TABLE [STRING, STRING]
		do
			Result := parent.namespace_table
		end

	query alias "@" (a_xpath: READABLE_STRING_GENERAL): EL_VTD_XPATH_QUERY
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

	apply_node (a_xpath: READABLE_STRING_GENERAL; set_values: PROCEDURE [EL_XPATH_NODE_CONTEXT])
			-- call `set_values' with node at `a_xpath' if found
		do
			if attached find_node (a_xpath) as node then
				set_values (node)
			end
		end

	fill_tuple (tuple: TUPLE; a_xpath_list: STRING)
		require
			same_field_count: tuple.count = a_xpath_list.occurrences (',') + 1
		local
			xpath_splitter: EL_SPLIT_ON_CHARACTER_8 [STRING]; index, type_id: INTEGER
			tuple_type: TYPE [TUPLE]; xpath: STRING
		do
			tuple_type := tuple.generating_type
			create xpath_splitter.make_adjusted (a_xpath_list, ',', {EL_SIDE}.Left)
			across xpath_splitter as split loop
				index := split.cursor_index
				xpath := split.item
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

	find_node (a_xpath: READABLE_STRING_GENERAL): detachable EL_XPATH_NODE_CONTEXT
			--
		do
			create actual_found_node.make_from_other (Current)
			actual_found_node.do_query (a_xpath)
			if actual_found_node.match_found then
				Result := actual_found_node
			end
		end

feature -- Status query

	has (xpath: STRING): BOOLEAN
			--
		do
			Result := not is_empty_result_set (xpath)
		end

	has_attribute (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if node element has attribute with `a_name'
		do
			if attached Shared_attribute as l_attribute then
				l_attribute.set_context (Current, a_name)
				Result := l_attribute.is_valid_name
			end
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