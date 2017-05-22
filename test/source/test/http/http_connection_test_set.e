note
	description: "[
		Eiffel tests for class `EL_HTTP_COMMAND' that can be executed with testing tool.
	]"

	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-12 10:37:02 GMT (Friday 12th May 2017)"
	revision: "6"

class
	HTTP_CONNECTION_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_WEB
		undefine
			default_create
		end

	EL_MODULE_HTML
		undefine
			default_create
		end

feature -- Test routines

	test_cookies
		local
			city_location, json_fields: EL_HTTP_HASH_TABLE
			url: ZSTRING; cookies: EL_HTTP_COOKIES
		do
			log.enter ("test_cookies")
			city_location := new_city_location
			url := Set_cookie_url + city_location.url_query_string
			log.put_labeled_string ("url", url)
			log.put_new_line

			web.set_cookie_paths (Cookie_path)
			web.open (url)
			web.read_string_get
			assert ("is redirection page", h1_text (web.last_string).same_string ("Redirecting..."))
			web.close

			create cookies.make_from_file (Cookie_path)
			web.open (Cookies_url)
			web.read_string_get
			json_fields := new_json_fields (web.last_string)

			assert ("two cookies set", cookies.count = 2)
			across cookies as cookie loop
				log.put_string_field (cookie.key, cookie.item)
				log.put_new_line
				assert ("json has cookie key", json_fields.has (cookie.key))
				assert ("cookie equals json value", json_fields.item (cookie.key) ~ cookie.item)
			end
			log.exit
		end

	test_download_document_and_headers
		local
			url: ZSTRING; headers: like web.last_headers
		do
			log.enter ("test_download_document_and_headers")
			across << Http >> as protocol loop -- Https
				across document_retrieved_table as is_retrieved loop
					url := protocol.item + Httpbin_url + is_retrieved.key
					log.put_labeled_string ("url", url)
					log.put_new_line
					web.open (url)

					web.read_string_head
					headers := web.last_headers
					print_lines (web)
					assert_valid_headers (headers)
					if is_retrieved.key ~ "xml" then
						assert ("valid content_type", headers.content_type ~ "application/xml")
					else
						assert ("valid content_type", headers.content_type ~ "text/html")
						assert ("valid encoding_name", headers.encoding_name ~ "utf-8")
					end
					web.read_string_get
					assert ("retrieved", is_retrieved.item (web.last_string))
					assert ("valid content_length", headers.content_length = web.last_string.count)

					web.close
					log.put_new_line
				end
			end
			log.exit
		end

	test_documents_download
		local
			url: ZSTRING
		do
			log.enter ("test_documents_download")
			across << Http >> as protocol loop -- Https
				across document_retrieved_table as is_retrieved loop
					url := protocol.item + Httpbin_url + is_retrieved.key
					log.put_labeled_string ("url", url)
					log.put_new_line
					web.open (url)

					web.read_string_get
					assert ("retrieved", is_retrieved.item (web.last_string))

					web.close
					log.put_new_line
				end
			end
			log.exit
		end

	test_download_image_and_headers
		note
			testing: "covers/{EL_HTTP_CONNECTION}.read_string_head"
		local
			headers: like web.last_headers
			image_path: like new_image_path
		do
			log.enter ("test_download_image_and_headers")
			across << "png", "jpeg", "webp", "svg" >> as image loop
				web.open (Image_url + image.item)
				web.read_string_head
				print_lines (web)

				image_path := new_image_path (image.item)
				web.download (image_path)

				headers := web.last_headers
				assert_valid_headers (headers)
				assert ("valid content_type", headers.content_type.starts_with ("image/" + image.item))
				assert ("valid content_length", headers.content_length = OS.File_system.file_byte_count (image_path))
				assert ("valid encoding_name", headers.encoding_name.is_empty)

				web.close
			end
			log.exit
		end

	test_http_hash_table
		note
			testing: "covers/{EL_URL_QUERY_STRING}.to_string", "covers/{EL_HTTP_HASH_TABLE}.make_from_url_query"
		local
			table_1, table_2: EL_HTTP_HASH_TABLE
			query_string: STRING
		do
			log.enter ("test_table")
			create table_1.make_equal (2)
			table_1.set_string_general ("city", "Dún Búinne")
			table_1.set_string_general ("code", "+/xPVBTmoka3ZBeARZ8uKA==")
			query_string := table_1.url_query_string
			log.put_line (query_string)
			create table_2.make_from_url_query (query_string)
			across table_2 as variable loop
				table_1.search (variable.key)
				assert ("has variable", table_1.found)
				assert ("same value", variable.item ~ table_1.found_item)
			end
			log.exit
		end

	test_http_post
		local
			city_location, json_fields: EL_HTTP_HASH_TABLE
			url: ZSTRING
		do
			log.enter ("test_http_post")
			city_location := new_city_location
			across << Http, Https >> as protocol loop
				url := protocol.item + Html_post_url
				log.put_labeled_string ("url", url)
				log.put_new_line
				web.open (url)
				web.set_post_parameters (city_location)
				web.read_string_post
				print_lines (web)

				json_fields := new_json_fields (web.last_string)
				across city_location as nvp loop
					assert ("has json value", json_fields.has (nvp.key))
					assert ("value is equal json value", json_fields.item (nvp.key) ~ nvp.item)
				end
				assert ("url echoed", json_fields.item ("url") ~ url)
				web.close
			end
			log.exit
		end

	test_image_headers
		-- using new web object for each request
		note
			testing: "covers/{EL_HTTP_CONNECTION}.read_string_head"
		local
			headers: like web.last_headers
		do
			log.enter ("test_image_headers")
			across << "png", "jpeg", "webp", "svg" >> as image loop
				web.open (Image_url + image.item)
				web.read_string_head
				print_lines (web)

				headers := web.last_headers
				assert_valid_headers (headers)
				assert ("valid content_type", headers.content_type.starts_with ("image/" + image.item))

				web.close
			end
			log.exit
		end

feature {NONE} -- Implementation

	assert_valid_headers (headers: like web.last_headers)
		do
			assert ("valid date_stamp", headers.date_stamp.date ~ create {DATE}.make_now)
			assert ("valid response_code", headers.response_code = 200)
			assert ("valid server", is_server_name (headers.server))
		end

	document_retrieved_table: EL_HASH_TABLE [PREDICATE [STRING], STRING]
			-- table of predicates testing if document was retrieved
		do
			create Result.make (<<
				["html", agent (text: STRING): BOOLEAN do Result := h1_text (text).same_string ("Herman Melville - Moby-Dick") end],
				["links/10/0", agent (text: STRING): BOOLEAN do Result := title_text (text).same_string ("Links") end],
				["xml", agent (text: STRING): BOOLEAN do Result := em_text (text).same_string ("WonderWidgets") end]
			>>)
		end

	h1_text (text: ZSTRING): ZSTRING
		do
			Result := element_text ("h1", text)
		end

	is_server_name (text: STRING): BOOLEAN
		local
			parts: LIST [STRING]
		do
			parts := text.split ('/')
			Result := parts.count = 2 and then across parts.last.split ('.') as n all n.item.is_natural end
		end

	title_text (text: ZSTRING): ZSTRING
		do
			Result := element_text ("title", text)
		end

	em_text (text: ZSTRING): ZSTRING
		do
			Result := element_text ("em", text)
		end

	element_text (name: STRING; text: ZSTRING): ZSTRING
		do
			Result := text.substring_between_general (Html.open_tag (name), Html.closed_tag (name), 1)
		end

	print_lines (a_web: like web)
		do
			across a_web.last_string.split ('%N') as line loop
				log.put_line (line.item)
			end
			log.put_new_line
		end

feature {NONE} -- Factory

	new_city_location: EL_HTTP_HASH_TABLE
		do
			create Result.make_equal (2)
			Result.set_string ("city", "Köln")
			Result.set_string ("district", "Köln-Altstadt-Süd")
		end

	new_file_tree: HASH_TABLE [ARRAY [READABLE_STRING_GENERAL], EL_DIR_PATH]
		do
			create Result.make (0)
			Result [Folder_name] := << Cookie_path.base.to_latin_1 >>
		end

	new_image_path (name: STRING): EL_FILE_PATH
		do
			Result := Current_work_area_dir + "image"
			Result.add_extension (name)
		end

	new_json_fields (json_data: ZSTRING): EL_HTTP_HASH_TABLE
		local
			lines: EL_ZSTRING_LIST; nvp: EL_JSON_NAME_VALUE_PAIR
		do
			create lines.make_with_lines (json_data)
			create Result.make_equal (lines.count)
			create nvp.make_empty
			across lines as line loop
				if not across "{}" as bracket some line.item.has (bracket.item) end then
					line.item.left_adjust
					nvp.set_from_string (line.item)
					Result.set_string (nvp.name, nvp.value)
				end
			end
		end

feature {NONE} -- Constants

	Cookie_path: EL_FILE_PATH
		once
			Result := Current_work_area_dir + (Folder_name + "/cookie.txt")
		end

	Cookies_url: STRING = "http://httpbin.org/cookies"

	Folder_name: STRING_32
		once
			Result := "Gefäß" -- vessel
		end

	Html_post_url: STRING = "://httpbin.org/post"

	Httpbin_url: STRING = "://httpbin.org/"

	Http: STRING = "http"

	Https: STRING = "https"

	Image_url: STRING = "http://httpbin.org/image/"

	Set_cookie_url: STRING = "http://httpbin.org/cookies/set?"

end

