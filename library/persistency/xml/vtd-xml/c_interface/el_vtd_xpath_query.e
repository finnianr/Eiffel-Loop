note
	description: "Vtd xpath query"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-11 10:02:53 GMT (Sunday 11th May 2025)"
	revision: "18"

class
	EL_VTD_XPATH_QUERY

inherit
	EL_OWNED_C_OBJECT -- AutoPilot
		rename
			c_free as c_evx_free_xpath_query
		end

	EL_VTD_XML_API

	EL_READABLE
		rename
			read_character_8 as as_character_8,
			read_character_32 as as_character_32,
			read_integer_8 as as_integer_8,
			read_integer_16 as as_integer_16,
			read_integer_32 as as_integer,
			read_integer_64 as as_integer_64,
			read_natural_8 as as_natural_8,
			read_natural_16 as as_natural_16,
			read_natural_32 as as_natural,
			read_natural_64 as as_natural_64,
			read_real_32 as as_real,
			read_real_64 as as_double,
			read_string as as_string,
			read_string_8 as as_string_8,
			read_string_32 as as_string_32,
			read_boolean as as_boolean,
			read_pointer as as_pointer
		end

	EL_VTD_SHARED_NATIVE_XPATH_TABLE

create
	make, make_xpath, make_xpath_for_namespace

convert
	as_string: {ZSTRING}, as_string_8: {STRING}, as_string_32: {STRING_32},
	as_real: {REAL}, as_double: {DOUBLE}, as_natural: {NATURAL}, as_natural_64: {NATURAL_64},
	as_integer: {INTEGER}, as_integer_64: {INTEGER_64}, as_file_path: {FILE_PATH}, as_dir_path: {DIR_PATH},
	as_boolean: {BOOLEAN}

feature {NONE} -- Initialization

	make (a_context: EL_XPATH_NODE_CONTEXT)
			--
		do
			context := a_context
		end

	make_xpath (a_context: EL_XPATH_NODE_CONTEXT; a_xpath: READABLE_STRING_GENERAL)
			--
		do
			make (a_context)
			set_xpath (a_xpath)
		end

	make_xpath_for_namespace (a_context: EL_XPATH_NODE_CONTEXT; a_xpath: READABLE_STRING_GENERAL; namespace_key: STRING)
			--
		do
			make (a_context)
			set_xpath_for_namespace (a_xpath, namespace_key)
		end

feature -- Element change

	set_xpath (a_xpath: READABLE_STRING_GENERAL)
			--
		do
			dispose
			make_from_pointer (c_create_xpath_query (Native_xpath_table.item (a_xpath).base_address))
		end

	set_xpath_for_namespace (a_xpath: READABLE_STRING_GENERAL; namespace_key: STRING)
			--
		require
			not_namespace_empty: not namespace_key.is_empty
		local
			c_ns_prefix, c_ns_url: EL_C_WIDE_CHARACTER_STRING; xpath: EL_VTD_NATIVE_XPATH_I [COMPARABLE]
		do
			dispose
			xpath := Native_xpath_table.item (a_xpath)
			if C_namespaces.has_key (namespace_key) then
				c_ns_prefix := C_namespaces.found_item [1]
				c_ns_url := C_namespaces.found_item [2]
			else
				create c_ns_prefix.make_from_string (namespace_key)
				create c_ns_url.make_from_string (context.namespace_table [namespace_key])
				C_namespaces.extend (<< c_ns_prefix, c_ns_url >>, namespace_key)
			end
			make_from_pointer (
				c_create_xpath_query_for_namespace (xpath.base_address, c_ns_prefix.base_address, c_ns_url.base_address)
			)
		end

feature -- Access

	as_boolean: BOOLEAN
			--
		do
			Result := as_wide_string.to_boolean

--			For some reason `c_evaluate_xpath_to_boolean' does not work
--			Result := c_evaluate_xpath_to_boolean (context.self_ptr, self_ptr)
		end

	as_character_8: CHARACTER_8
		do
			Result := as_character_32.to_character_8
		end

	as_character_32: CHARACTER_32
		do
			if attached as_wide_string as string and then string.count > 0 then
				Result := string.item (1)
			end
		end

	as_date: DATE
			--
		require
			days_format: as_string_8.is_integer
		do
			create Result.make_by_days (as_integer)
		end

	as_dir_path: DIR_PATH
			--
		do
			Result := as_string
		end

	as_double, as_real_64: DOUBLE
			--
		do
			Result := c_evaluate_xpath_to_number (context.self_ptr, self_ptr)
		end

	as_file_path: FILE_PATH
			--
		do
			Result := as_string
		end

feature -- Integer

	as_integer_8: INTEGER_8
		do
			Result := as_integer_32.to_integer_8
		end

	as_integer_16: INTEGER_16
		do
			Result := as_integer_32.to_integer_16
		end

	as_integer, as_integer_32: INTEGER
		do
			Result := as_double.truncated_to_integer
		end

	as_integer_64: INTEGER_64
		do
			Result := as_double.truncated_to_integer_64
		end

feature -- Natural

	as_natural_8: NATURAL_8
			--
		do
			Result := as_integer_32.to_natural_8
		end

	as_natural_16: NATURAL_16
			--
		do
			Result := as_integer_32.to_natural_16
		end

	as_natural, as_natural_32: NATURAL
			--
		do
			Result := as_integer_64.to_natural_32
		end

	as_natural_64: NATURAL_64
			--
		do
			Result := as_integer_64.to_natural_64
		end

	as_real, as_real_32: REAL
			--
		do
			Result := as_double.truncated_to_real
		end

feature -- String

	as_string: ZSTRING
			--
		do
			Result := as_wide_string
		end

	as_string_8: STRING_8
			--
		do
			Result := as_wide_string
		end

	as_string_32: STRING_32
			--
		do
			Result := as_wide_string
		end

	as_wide_string: like wide_string
		do
			Result := wide_string (c_evaluate_xpath_to_string (context.self_ptr, self_ptr))
		end

feature -- Basic operations

	forth
			--
		do
			nodeset_index := c_xpath_query_forth (context.self_ptr, self_ptr)
			if after then
				c_evx_reset_xpath_query (self_ptr)
			end
		end

	start
			--
		do
			nodeset_index := c_xpath_query_start (context.self_ptr, self_ptr)
			if after then
				c_evx_reset_xpath_query (self_ptr)
			end
		end

feature -- Status query

	after: BOOLEAN
			--
		do
			Result := nodeset_index = -1
		end

	is_xpath_set: BOOLEAN
			--
		do
			Result := is_attached (self_ptr)
		end

feature {NONE} -- Implementation

	as_pointer: POINTER
		do
			do_nothing
		end

	C_namespaces: EL_HASH_TABLE [ARRAY [EL_C_WIDE_CHARACTER_STRING], STRING]
			--
		once
			create Result.make_equal (11)
		end

feature {NONE} -- Internal attributes

	context: EL_XPATH_NODE_CONTEXT

	nodeset_index: INTEGER

end