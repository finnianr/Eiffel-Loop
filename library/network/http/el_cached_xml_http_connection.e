note
	description: "Summary description for {EL_XML_HTTP_CONNECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-20 14:29:01 GMT (Wednesday 20th May 2015)"
	revision: "3"

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

	EL_MODULE_FILE_SYSTEM

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
				last_string := File_system.plain_text (cache_file_path)
				log.put_path_field ("Read", cache_file_path)
				log.put_new_line
			else
				Precursor
			end
		end

	on_xml_read
		local
			xml_file: PLAIN_TEXT_FILE
		do
			log.put_labeled_string ("Read", url)
			log.put_new_line
			create xml_file.make_open_write (cache_file_path)
			xml_file.put_string (last_string)
			xml_file.close
		end

feature {NONE} -- Implementation

	cache_file_path: EL_FILE_PATH

end
