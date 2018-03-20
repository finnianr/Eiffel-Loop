note
	description: "Summary description for {FCGI_HTTP_HEADERS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:15:28 GMT (Thursday 28th December 2017)"
	revision: "6"

class
	FCGI_HTTP_HEADERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field
		redefine
			make, Except_fields, import_name
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		redefine
			set_field
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create custom_table.make (3)
		end

feature -- Access

	as_table (kebab_names: BOOLEAN): HASH_TABLE [ZSTRING, STRING]
		-- table of all non-empty headers with name-keys adjusted to use hyphen word separator
		-- if `kebab_names' is true
		local
			table: like field_table; value: ZSTRING
		do
			table := field_table
			create Result.make (custom_table.count + 7)
			from table.start until table.after loop
				value := field_string (table.item_for_iteration)
				if not value.is_empty then
					Result [as_table_key (table.key_for_iteration, kebab_names)] := value
				end
				table.forth
			end
			from custom_table.start until custom_table.after loop
				value := custom_table.item_for_iteration
				if not value.is_empty then
					Result [as_table_key (custom_table.key_for_iteration, kebab_names)] := value
				end
				custom_table.forth
			end
		end

	custom (name: STRING): ZSTRING
		local
			kebab_name: STRING
		do
			create kebab_name.make (name.count)
			Naming.from_kebab_case (name, kebab_name)
			custom_table.search (kebab_name)
			if custom_table.found then
				Result := custom_table.found_item
			else
				create Result.make_empty
			end
		end

	selected (name_list: EL_SPLIT_STRING_LIST [STRING]): HASH_TABLE [ZSTRING, STRING]
		-- returns table of field values for keys present in `name_list'
		local
			name: STRING
		do
			name := String_8_pool.new_string
			create Result.make (name_list.count)
			from name_list.start until name_list.after loop
				name.wipe_out
				Naming.from_kebab_case (name_list.item, name)

				field_table.search (name)
				if field_table.found then
					Result.extend (field_string (field_table.found_item), name_list.item.twin)
				else
					custom_table.search (name)
					if custom_table.found then
						Result.extend (custom_table.found_item, name_list.item.twin)
					end
				end
				name_list.forth
			end
			String_8_pool.recycle (name)
		end

feature -- Access attributes

	accept: ZSTRING

	accept_encoding: ZSTRING

	accept_language: ZSTRING

	authorization: ZSTRING

	cache_control: ZSTRING

	connection: ZSTRING

	content_length: INTEGER

	content_type: ZSTRING

	cookie: ZSTRING


	from_: ZSTRING
		-- Trailing `_' to distinguish from Eiffel keyword

	host: ZSTRING

	referer: ZSTRING

	upgrade_insecure_requests: ZSTRING

	user_agent: ZSTRING

	x_forwarded_host: ZSTRING

feature -- Element change

	set_accept (a_accept: like accept)
		do
			accept := a_accept
		end

	set_accept_encoding (a_accept_encoding: like accept_encoding)
		do
			accept_encoding := a_accept_encoding
		end

	set_accept_language (a_accept_language: like accept_language)
		do
			accept_language := a_accept_language
		end

	set_authorization (a_authorization: like authorization)
		do
			authorization := a_authorization
		end

	set_cache_control (a_cache_control: like cache_control)
		do
			cache_control := a_cache_control
		end

	set_connection (a_connection: like connection)
		do
			connection := a_connection
		end

	set_content_length (a_content_length: like content_length)
		do
			content_length := a_content_length
		end

	set_content_type (a_content_type: like content_type)
		do
			content_type := a_content_type
		end

	set_cookie (a_cookie: like cookie)
		do
			cookie := a_cookie
		end

	set_custom (name: STRING; value: ZSTRING)
		local
			kebab_name: STRING
		do
			create kebab_name.make (name.count)
			Naming.from_kebab_case (name, kebab_name)
			custom_table [kebab_name] := value
		end

	set_field (name: STRING; value: ZSTRING)
		-- set field with name
		do
			Precursor (name, value)
			if not field_table.found then
				custom_table.extend (value, name.as_lower)
			end
		end

	set_from (a_from: like from_)
		do
			from_ := a_from
		end

	set_host (a_host: like host)
		do
			host := a_host
		end

	set_referer (a_referer: like referer)
		do
			referer := a_referer
		end

	set_upgrade_insecure_requests (a_upgrade_insecure_requests: like upgrade_insecure_requests)
		do
			upgrade_insecure_requests := a_upgrade_insecure_requests
		end

	set_user_agent (a_user_agent: like user_agent)
		do
			user_agent := a_user_agent
		end

	wipe_out
		do
			set_default_values
			custom_table.wipe_out
			content_length := -1
		end

feature {NONE} -- Implementation

	as_table_key (name: STRING; kebab_names: BOOLEAN): STRING
		do
			if kebab_names then
				create Result.make (name.count)
				Naming.to_kebab_case (name, Result)
			else
				Result := name
			end
		end

	import_name: like Naming.Default_import
		do
			Result := agent Naming.from_upper_snake_case
		end

feature {NONE} -- Internal attributes

	custom_table: HASH_TABLE [ZSTRING, STRING]
		-- custom_table fields prefixed with x_

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", custom_table"
		end

end
