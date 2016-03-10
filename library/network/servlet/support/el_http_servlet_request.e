note
	description: "Summary description for {EL_HTTP_SERVLET_REQUEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-04 9:50:21 GMT (Saturday 4th October 2014)"
	revision: "5"

class
	EL_HTTP_SERVLET_REQUEST

inherit
	GOA_FAST_CGI_SERVLET_REQUEST
		rename
			servlet_path as servlet_path_string,
			parameters as list_parameters, -- each value is a list
			get_parameter as value_string_8,
			parse_parameters as make_parameters
		redefine
			default_create, make_parameters,
			has_parameter, value_string_8, path_info,
			parse_parameter_string
		end

	EL_MODULE_BASE_64
		undefine
			default_create
		end

	EL_MODULE_URL
		undefine
			default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	default_create
		do
			create internal_content.make_empty
			create internal_cookies.make_default
			create internal_request.make
			create internal_response.make (create {GOA_FAST_CGI_REQUEST}.make)
			create list_parameters.make_default
			create parameters.make_equal (0)
			create session_id.make_empty
		end

	make_parameters
		do
			create parameters.make_equal (0)
			-- This does not allow duplicate parameters, original parameters does.
			Precursor
		end

feature -- Access

	value_string (name: ASTRING): ASTRING
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

	value_string_8 (name: ASTRING): STRING
		do
			Result := value_string (name).as_string_8
		end

	value_natural (name: ASTRING): NATURAL
		do
			Result := value_string (name).to_natural_32
		end

	value_integer (name: ASTRING): INTEGER
		do
			Result := value_string (name).to_integer_32
		end

	parameters: EL_HTTP_HASH_TABLE
		-- non-duplicate http parameters

	path_info: ASTRING
		do
			create Result.make_from_utf8 (Precursor)
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

	has_parameter (name: ASTRING): BOOLEAN
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
