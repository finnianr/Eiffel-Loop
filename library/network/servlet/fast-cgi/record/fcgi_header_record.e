note
	description: "[
		A FastCGI record consists of a fixed-length prefix followed by a variable number of content and padding bytes.
		See: [https://fast-cgi.github.io/spec#33-records]
		
			typedef struct {
				unsigned char version;
				unsigned char type;
				unsigned char requestIdB1;
				unsigned char requestIdB0;
				unsigned char contentLengthB1;
				unsigned char contentLengthB0;
				unsigned char paddingLength;
				unsigned char reserved;
				unsigned char contentData[contentLength];
				unsigned char paddingData[paddingLength];
			} FCGI_Record;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-05 10:06:49 GMT (Tuesday 5th December 2017)"
	revision: "2"

class
	FCGI_HEADER_RECORD

inherit
	FCGI_RECORD

create
	default_create

feature -- Element change

	set_fields (a_version: NATURAL_8; a_request_id: NATURAL_16; a_type, a_content_length, a_padding_length: INTEGER)
			-- Create a new record header for the specified request.	
		require
			valid_version: a_version >= 1
			valid_request_id: a_request_id >= 0
			-- valid_type: valid_type (a_type)
			valid_content_length: a_content_length >= 0
			valid_padding_length: a_padding_length >= 0
		do
			version := a_version
			type := a_type.to_natural_8

			request_id := a_request_id
			content_length := a_content_length.to_natural_16
			padding_length := a_padding_length.to_natural_8
		end

feature -- Access

	content_length: NATURAL_16

	padding_length: NATURAL_8

	request_id: NATURAL_16

	type: NATURAL_8

	type_record: FCGI_RECORD
		do
			Result := Record_type_array [type]
		end

	version: NATURAL_8

	reserved: NATURAL_8

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := content_length = 0
		end

	is_end_service: BOOLEAN
		-- `True' if type is request to end service
		do
			Result := type = Fcgi_end_service
		end

feature {NONE} -- Implementation

	on_data_read (request: FCGI_REQUEST)
		do
			request.on_header (Current)
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			version := memory.read_natural_8
			type := memory.read_natural_8
			request_id := memory.read_natural_16
			content_length := memory.read_natural_16
			padding_length := memory.read_natural_8
			reserved := memory.read_natural_8
		ensure then
			same_request_id: request_id.as_integer_32 = 1
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			 memory.write_natural_8 (version)
			 memory.write_natural_8 (type)
			 memory.write_natural_16 (request_id)
			 memory.write_natural_16 (content_length)
			 memory.write_natural_8 (padding_length)
			 memory.write_natural_8 (reserved)
		end

feature {NONE} -- Constants

	Record_type_array: ARRAY [FCGI_RECORD]
		local
			string_content: FCGI_STRING_CONTENT_RECORD
		once
			create Result.make_filled (Current, 1, Fcgi_stdout)
			create string_content
			Result [Fcgi_params] := create {FCGI_PARAMETER_RECORD}

			Result [Fcgi_begin_request] := create {FCGI_BEGIN_REQUEST_RECORD}
			Result [Fcgi_end_request] := create {FCGI_END_REQUEST_RECORD}

			Result [Fcgi_stdin] := string_content
			Result [Fcgi_stdout] := string_content
		end

end
