note
	description: "[
		Eiffel tests for class [$source EL_HTTP_CONNECTION] that can be executed with testing tool.
	]"
	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-11 8:15:10 GMT (Saturday 11th September 2021)"
	revision: "35"

class
	HTTP_CONNECTION_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_WEB

	EL_MODULE_HTML

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("cookies", agent test_cookies)
			eval.call ("documents_download", agent test_documents_download)
			eval.call ("download_document_and_headers", agent test_download_document_and_headers)
			eval.call ("download_image_and_headers", agent test_download_image_and_headers)
			eval.call ("headers", agent test_headers)
			eval.call ("http_hash_table", agent test_http_hash_table)
			eval.call ("http_post", agent test_http_post)
			eval.call ("image_headers", agent test_image_headers)
			eval.call ("url_encoded", agent test_url_encoded)
		end

feature -- Tests

	test_cookies
		local
			city_location, json_fields: EL_URI_QUERY_ZSTRING_HASH_TABLE
			url: ZSTRING; cookies: EL_HTTP_COOKIE_TABLE
		do
			-- There is an issue with httpbin.org that prevents setting of 2 cookies with 1 call
			-- so we do a loop instead
			across new_city_location.query_string (True, False).split ('&') as nvp loop
				url := Set_cookie_url + nvp.item
				lio.put_labeled_string ("url", url)
				lio.put_new_line

				web.set_cookie_paths (Cookie_path)
				web.open (url)
				web.read_string_get
				assert ("is redirection page", h1_text (web.last_string).same_string ("Redirecting..."))
				web.close
			end

			create cookies.make_from_file (Cookie_path)
			web.open (Cookies_url)
			web.read_string_get
			json_fields := new_json_fields (web.last_string)

			assert ("two cookies set", cookies.count = 2)
			across cookies as cookie loop
				lio.put_string_field (cookie.key, cookie.item)
				lio.put_new_line
				assert ("json has cookie key", json_fields.has (cookie.key))
				assert ("cookie equals json value", json_fields.item (cookie.key) ~ cookie.item)
			end
		end

	test_documents_download
		local
			url: ZSTRING
		do
			across << Http >> as protocol loop -- Https
				across document_retrieved_table as is_retrieved loop
					url := protocol.item + Httpbin_url + is_retrieved.key
					lio.put_labeled_string ("url", url)
					lio.put_new_line
					web.open (url)

					web.read_string_get
					assert ("retrieved", is_retrieved.item (web.last_string))

					web.close
					lio.put_new_line
				end
			end
		end

	test_download_document_and_headers
		local
			url: ZSTRING; headers: like web.last_headers
		do
			across << Http >> as protocol loop -- Https
				across document_retrieved_table as is_retrieved loop
					url := protocol.item + Httpbin_url + is_retrieved.key
					lio.put_labeled_string ("url", url)
					lio.put_new_line
					web.open (url)

					web.read_string_head
					headers := web.last_headers
					print_lines (web)
					assert_valid_headers (headers)
					if is_retrieved.key ~ "xml" then
						assert ("valid content_type", headers.mime_type ~ "application/xml")
					else
						assert ("valid content_type", headers.mime_type ~ "text/html")
						assert ("valid encoding_name", headers.encoding_name ~ "utf-8")
					end
					web.read_string_get
					assert ("retrieved", is_retrieved.item (web.last_string))
					assert ("valid content_length", headers.content_length = web.last_string.count)

					web.close
					lio.put_new_line
				end
			end
		end

	test_download_image_and_headers
		note
			testing: "covers/{EL_HTTP_CONNECTION}.read_string_head"
		local
			headers: like web.last_headers
			image_path: like new_image_path
		do
			across << "png", "jpeg", "webp", "svg" >> as image loop
				web.open (Image_url + image.item)
				web.read_string_head
				print_lines (web)

				image_path := new_image_path (image.item)
				web.download (image_path)

				headers := web.last_headers
				assert_valid_headers (headers)
				assert ("valid content_type", headers.mime_type.starts_with ("image/" + image.item))
				assert ("valid content_length", headers.content_length = OS.File_system.file_byte_count (image_path))
				assert ("valid encoding_name", headers.encoding_name.is_empty)

				web.close
			end
		end

	test_headers
		local
			headers: EL_HTTP_HEADERS
		do
			create headers.make (Headers_text)
			assert ("same code", headers.response_code = 200)
			assert ("same string", headers.mime_type ~ "text/html")
			assert ("same string", headers.encoding_name ~ "UTF-8")
			assert ("", headers.x_field ("powered_by") ~ "PHP/7.2.34")
		end

	test_http_hash_table
		note
			testing: "covers/{EL_URI_QUERY_TABLE}.make_url"
		local
			table_1, table_2: EL_URI_QUERY_ZSTRING_HASH_TABLE
			query_string: STRING
		do
			create table_1.make_equal (2)
			table_1.set_string_general ("city", "Dún Búinne")
			table_1.set_string_general ("code", "+/xPVBTmoka3ZBeARZ8uKA==")
			query_string := table_1.url_query
			lio.put_line (query_string)
			create table_2.make_url (query_string)
			across table_2 as variable loop
				table_1.search (variable.key)
				assert ("has variable", table_1.found)
				assert ("same value", variable.item ~ table_1.found_item)
			end
		end

	test_http_post
		local
			city_location, json_fields: EL_URI_QUERY_ZSTRING_HASH_TABLE
			url: ZSTRING
		do
			city_location := new_city_location
			across << Http, Https >> as protocol loop
				url := protocol.item + Html_post_url
				lio.put_labeled_string ("url", url)
				lio.put_new_line
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
		end

	test_image_headers
		-- using new web object for each request
		note
			testing: "covers/{EL_HTTP_CONNECTION}.read_string_head"
		local
			headers: like web.last_headers
		do
			across << "png", "jpeg", "webp", "svg" >> as image loop
				web.open (Image_url + image.item)
				web.read_string_head
				print_lines (web)

				headers := web.last_headers
				assert_valid_headers (headers)
				assert ("valid content_type", headers.mime_type.starts_with ("image/" + image.item))

				web.close
			end
		end

	test_url_encoded
		local
			url: STRING; s: EL_STRING_8_ROUTINES
		do
			across << "über-my-ching.html", "%%C3%%BCber-my-ching.html" >> as name loop
				url := "http://myching.software/de/about/" + name.item
				if s.is_ascii (name.item) then
					web.open_url (url)
				else
					web.open (url)
				end
				web.read_string_head
				assert ("Response 200", web.last_headers.response_code = 200)
				web.close
			end
		end

feature -- Problematic

	test_open_url
		local
			url: EL_URL
		do
			-- This works on command line: curl -I http://www.académie-française.fr/

			-- If libcurl is built with IDN support, the server name part of the URL can use an
			-- "international name" by using the current encoding (according to locale) or UTF-8
			-- (when winidn is used; or a Windows Unicode build using libidn2)

			create url.make ("http://www.académie-française.fr/")
			web.open_url (url)
			web.read_string_head
			assert ("correct title", web.last_headers.location ~ "https://www.academie-francaise.fr/")
			web.close
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			File_system.make_directory (Cookie_path.parent)
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

	element_text (name: STRING; a_text: STRING): ZSTRING
		local
			text: ZSTRING
		do
			text := a_text
			Result := text.substring_between_general (Html.open_tag (name), Html.closed_tag (name), 1)
		end

	em_text (text: ZSTRING): ZSTRING
		do
			Result := element_text ("em", text)
		end

	h1_text (text: STRING): ZSTRING
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

	print_lines (a_web: like web)
		do
			across a_web.last_string.split ('%N') as line loop
				lio.put_line (line.item)
			end
			lio.put_new_line
		end

	title_text (text: ZSTRING): ZSTRING
		do
			Result := element_text ("title", text)
		end

feature {NONE} -- Factory

	new_city_location: EL_URI_QUERY_ZSTRING_HASH_TABLE
		do
			create Result.make_equal (2)
			Result.set_string ("city", "Köln")
			Result.set_string ("district", "Köln-Altstadt-Süd")
		end

	new_image_path (name: STRING): EL_FILE_PATH
		do
			Result := Work_area_absolute_dir + "image"
			Result.add_extension (name)
		end

	new_json_fields (json_data: STRING): EL_URI_QUERY_ZSTRING_HASH_TABLE
		local
			lines: EL_STRING_8_LIST
			pair_list: EL_JSON_NAME_VALUE_LIST
		do
			create lines.make_with_lines (json_data)
			from lines.start until lines.after loop
				if lines.index > 1 and then lines.index < lines.count and then not lines.item.has_substring ("%": %"") then
					lines.remove
				else
					lio.put_line (lines.item)
					lines.forth
				end
			end

			create pair_list.make (lines.joined_lines)
			create Result.make_equal (pair_list.count)
			from pair_list.start until pair_list.after loop
				Result.set_string (pair_list.name_item, pair_list.value_item)
				pair_list.forth
			end
		end

feature {NONE} -- Text manifest

	Headers_text: STRING = "[
		HTTP/1.1 200 OK
		Accept-Ranges: bytes
		access-control-allow-origin: *
		age: 0
		alt-svc: h3=":443"; ma=2592000, h3-29=":443"; ma=2592000, h3-Q050=":443"
		cache-control: no-cache, no-store, must-revalidate, max-age=0
		Connection: Keep-Alive
		Content-Length: 62128
		content-type: text/html; charset=UTF-8
		Date: Thu, 02 Sep 2021 10:48:51 GMT
		etag: "234ea00d6e2defa13d5ca7844fdd1821-ssl"
		host-header: c2hhcmVkLmJsdWVob3N0LmNvbQ==
		Keep-Alive: timeout=5, max=100
		Last-Modified: Fri, 25 Sep 2020 01:40:31 GMT
		Link: <https://www.ichingmeditations.com/rb>; rel=shorturl, <https://www.ichingmeditations.com/wp-json/>
		memento-datetime: Mon, 14 Jan 2013 21:39:36 GMT
		location: http://www.laetusinpraesens.org
		Referrer-Policy: no-referrer-when-downgrade
		Permissions-Policy: interest-cohort=()
		Server: Apache
		Set-Cookie: PHPSESSID=0208ad1dda50c9c00f6d9ea60285266e; path=/; secure; HttpOnly
		strict-transport-security: max-age=31536000; includeSubDomains; preload
		Upgrade: h2,h2c
		vary: User-Agent
		x-content-type-options: nosniff
		x-frame-options: SAMEORIGIN
		x-nf-request-id: 01FEK1KJWRMEY7HVCHM7B3V8FY
		X-Pingback: https://www.ichingmeditations.com/xmlrpc.php
		x-powered-by: PHP/7.2.34
	]"

feature {NONE} -- Constants

	Cookie_path: EL_FILE_PATH
		once
			Result := Work_area_absolute_dir + {STRING_32} "Gefäß/cookie.txt"
		end

	Cookies_url: STRING = "http://httpbin.org/cookies"

	Html_post_url: STRING = "://httpbin.org/post"

	Http: STRING = "http"

	Httpbin_url: STRING = "://httpbin.org/"

	Https: STRING = "https"

	Image_url: STRING = "http://httpbin.org/image/"

	Set_cookie_url: STRING = "http://httpbin.org/cookies/set?"

end