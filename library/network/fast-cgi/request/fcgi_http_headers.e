note
	description: "Fast-CGI HTTP headers and custom headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "23"

class
	FCGI_HTTP_HEADERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Snake_case_upper,
			make_default as make,
			field_included as is_any_field
		redefine
			make
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		redefine
			set_table_field
		end

	EL_MODULE_ITERABLE; EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create custom_table.make (3)
		end

feature -- Access

	as_table (translater: EL_NAME_TRANSLATER): HASH_TABLE [ZSTRING, STRING]
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
					Result [translater.exported (table.key_for_iteration)] := value
				end
				table.forth
			end
			from custom_table.start until custom_table.after loop
				value := custom_table.item_for_iteration
				if not value.is_empty then
					Result [translater.exported (custom_table.key_for_iteration)] := value
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
			if custom_table.has_key (kebab_name) then
				Result := custom_table.found_item
			else
				create Result.make_empty
			end
		end

	selected (name_list: ITERABLE [STRING]; translater: EL_NAME_TRANSLATER): HASH_TABLE [ZSTRING, STRING]
		-- returns table of field values for keys present in `name_list'
		local
			l_name: STRING
		do
			create Result.make (Iterable.count (name_list))
			across name_list as name loop
				l_name := translater.imported (name.item)
				if field_table.has_key (l_name) then
					Result.extend (field_string (field_table.found_item), name.item)
				else
					if custom_table.has_key (l_name) then
						Result.extend (custom_table.found_item, name.item)
					end
				end
			end
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

	set_accept (a_accept: ZSTRING)
		do
			accept := a_accept
		end

	set_accept_encoding (a_accept_encoding: ZSTRING)
		do
			accept_encoding := a_accept_encoding
		end

	set_accept_language (a_accept_language: ZSTRING)
		do
			accept_language := a_accept_language
		end

	set_authorization (a_authorization: ZSTRING)
		do
			authorization := a_authorization
		end

	set_cache_control (a_cache_control: ZSTRING)
		do
			cache_control := a_cache_control
		end

	set_connection (a_connection: ZSTRING)
		do
			connection := a_connection
		end

	set_content_length (a_content_length: INTEGER)
		do
			content_length := a_content_length
		end

	set_content_type (a_content_type: ZSTRING)
		do
			content_type := a_content_type
		end

	set_cookie (a_cookie: ZSTRING)
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

	set_from (a_from: ZSTRING)
		do
			from_ := a_from
		end

	set_host (a_host: ZSTRING)
		do
			host := a_host
		end

	set_referer (a_referer: ZSTRING)
		do
			referer := a_referer
		end

	set_upgrade_insecure_requests (a_upgrade_insecure_requests: ZSTRING)
		do
			upgrade_insecure_requests := a_upgrade_insecure_requests
		end

	set_user_agent (a_user_agent: ZSTRING)
		do
			user_agent := a_user_agent
		end

	wipe_out
		do
			reset_fields
			custom_table.wipe_out
			content_length := -1
		end

feature {NONE} -- Implementation

	set_table_field (table: like field_table; name: STRING; value: ZSTRING)
		-- set field with name
		do
			Precursor (table, name, value)
			if not table.found then
				custom_table.extend (value, name.as_lower)
			end
		end

feature {NONE} -- Internal attributes

	custom_table: HASH_TABLE [ZSTRING, STRING] note option: transient attribute end
		-- custom_table fields prefixed with x_

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end

end