note
	description: "Cached XML http connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-16 9:14:30 GMT (Wednesday 16th October 2024)"
	revision: "11"

class
	EL_CACHED_XML_HTTP_CONNECTION

inherit
	EL_XML_HTTP_CONNECTION
		rename
			make as make_default,
			make_with_default as make_http_with_default
		redefine
			on_not_xml_read, on_xml_read
		end

	EL_MODULE_FILE

create
	make, make_with_default

feature {NONE} -- Initialization

	make (a_cache_file_path: like cache_file_path)
		do
			make_with_default (a_cache_file_path, create {EL_DEFAULT_SERIALIZEABLE_XML})
		end

	make_with_default (a_cache_file_path: like cache_file_path; a_default_document: like default_document)
		do
			cache_file_path := a_cache_file_path
			make_http_with_default (a_default_document)
		end

feature {NONE} -- Event handling

	on_not_xml_read
		do
			if cache_file_path.exists then
				last_string := File.plain_text (cache_file_path)
				lio.put_path_field ("Read %S", cache_file_path)
				lio.put_new_line
			else
				Precursor
			end
		end

	on_xml_read
		local
			xml_file: PLAIN_TEXT_FILE
		do
			lio.put_labeled_string ("Read", url)
			lio.put_new_line
			create xml_file.make_open_write (cache_file_path)
			xml_file.put_string (last_string)
			xml_file.close
		end

feature {NONE} -- Implementation

	cache_file_path: FILE_PATH

end