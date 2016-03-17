note
	description: "Summary description for {EL_HTTP_SERVLET_REQUEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-28 20:01:30 GMT (Thursday 28th January 2016)"
	revision: "7"

class
	EL_HTTP_SERVLET_REQUEST

inherit
	GOA_FAST_CGI_SERVLET_REQUEST
		rename
			has_parameter as has_parameter_8,
			servlet_path as servlet_path_string,
			parameters as list_parameters, -- each value is a list
			path_info as path_info_utf_8,
			parse_parameters as make_parameters
		export
			{NONE} has_parameter_8, get_parameter, path_info_utf_8
		redefine
			make_parameters,
			parse_parameter_string
		end

	EL_MODULE_BASE_64

	EL_MODULE_URL

create
	make

feature {NONE} -- Initialization

	make_parameters
		do
			create parameters.make_equal (0)
			-- This does not allow duplicate parameters, original parameters does.
			Precursor
		end

feature -- Access

	value_string (name: ZSTRING): ZSTRING
		local
			l_parameters: like parameters
		do
			l_parameters := parameters
			l_parameters.search (name)
			if l_parameters.found then
				Result := l_parameters.found_item
			else
				create Result.make_empty
			end
		end

	value_string_8 (name: ZSTRING): STRING
		do
			Result := value_string (name).as_string_8
		end

	value_natural (name: ZSTRING): NATURAL
		do
			Result := value_string (name).to_natural_32
		end

	value_integer (name: ZSTRING): INTEGER
		do
			Result := value_string (name).to_integer_32
		end

	parameters: EL_HTTP_HASH_TABLE
		-- non-duplicate http parameters

	path_info: ZSTRING
		do
			create Result.make_from_utf_8 (path_info_utf_8)
			Result.prune_all_leading ('/')
		end

	dir_path: EL_DIR_PATH
		do
			Result := path_info
		end

	remote_address_32: NATURAL
		local
			ip_address: STRING; l_parser: like Parser
			i: INTEGER; c: CHARACTER
		do
			ip_address := remote_address
			l_parser := Parser
			l_parser.reset ({NUMERIC_INFORMATION}.type_natural_32)
			from i := 1 until i > ip_address.count loop
				c := ip_address [i]
				if c = '.' then
					Result := (Result |<< 8) | l_parser.parsed_natural
					l_parser.reset ({NUMERIC_INFORMATION}.type_natural_32)
				else
					l_parser.parse_character (c)
				end
				i := i + 1
			end
			Result := (Result |<< 8) | l_parser.parsed_natural
		end

feature -- Status report

	has_parameter (name: ZSTRING): BOOLEAN
			-- Does this request have a parameter named 'name'?
		do
			Result := parameters.has (name)
		end

feature {NONE} -- Implementation

	parse_parameter_string (str: STRING)
		do
			-- This does not allow duplicate parameters, original parameters does.
			create parameters.make_from_nvp_string (str)
		end

feature {NONE} -- Constants

	Parser: STRING_TO_INTEGER_CONVERTOR
 		once
 			create Result.make
 		end

end
