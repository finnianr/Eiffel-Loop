note
	description: "[
		Eiffel tests for class ${EL_HTTP_CONNECTION} that can be executed with testing tool.
	]"
	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 11:30:53 GMT (Tuesday 29th April 2025)"
	revision: "78"

class
	HTTP_CONNECTION_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_clean, on_prepare
		end

	EL_MODULE_GEOLOCATION; EL_MODULE_HTML; EL_MODULE_IP_ADDRESS

	EL_MODULE_WEB; EL_MODULE_XML

	EL_SHARED_GEOGRAPHIC_INFO_TABLE; EL_SHARED_IP_ADDRESS_GEOLOCATION

	EL_SHARED_HTTP_STATUS

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["cached_documents",					 agent test_cached_documents],
				["cookies",								 agent test_cookies],
				["download_document_and_headers", agent test_download_document_and_headers],
				["download_image_and_headers",	 agent test_download_image_and_headers],
				["headers",								 agent test_headers],
				["http_hash_table",					 agent test_http_hash_table],
				["http_post",							 agent test_http_post],
				["image_headers",						 agent test_image_headers],
				["ip_address_info",					 agent test_ip_address_info],
				["ip_geolocation",					 agent test_ip_geolocation],
				["url_encoded",						 agent test_url_encoded],
				["web_archive",						 agent test_web_archive]
			>>)
		end

feature -- Tests

	test_cached_documents
		note
			testing: "[
				covers/{EL_CACHED_HTTP_FILE}.make,
				covers/{EL_HTTP_CONNECTION}.download
			]"
		local
			url: STRING; cached_file: EL_CACHED_HTTP_FILE
		do
			across << Http >> as protocol loop -- Https
				across Document_table as table loop
					url := protocol.item + Httpbin_url + table.key
					lio.put_labeled_string ("url", url)
					lio.put_new_line
					create cached_file.make (url, 24)

					if attached value_at_xpath (File.plain_text (cached_file.path), table.item.xpath) as value then
						assert ("xpath matches", value.starts_with (table.item.first_words))
					end
					lio.put_new_line
				end
			end
		end

	test_cookies
		-- HTTP_CONNECTION_TEST_SET.test_cookies
		local
			city_location, json_fields: EL_URI_QUERY_ZSTRING_HASH_TABLE
			url: STRING; cookies: EL_HTTP_COOKIE_TABLE
		do
			-- There is an issue with httpbin.org that prevents setting of 2 cookies with 1 call
			-- so we do a loop instead
			across new_city_location.query_string (True, False).split ('&') as nvp loop
				url := Set_cookie_url + nvp.item
				lio.put_labeled_string ("url", url)
				lio.put_new_line

				web.set_cookie_paths (Cookie_path)
				web.open (url)
				try_3_times (agent web.read_string_get)
				assert_same_string ("is redirection page", h1_text (web.last_string), "Redirecting...")
				web.close
			end

			create cookies.make_from_file (Cookie_path)
			web.open (Cookies_url)
			try_3_times (agent web.read_string_get)
			json_fields := new_json_fields (web.last_string)

			assert ("two cookies set", cookies.count = 2)
			across cookies as cookie loop
				lio.put_string_field (cookie.key, cookie.item); lio.put_string_field (" JSON", json_fields.item (cookie.key))
				lio.put_new_line

				assert ("json has cookie key", json_fields.has (cookie.key))
				assert ("cookie equals json value", json_fields.item (cookie.key) ~ cookie.item)
			end
		end

	test_download_document_and_headers
		local
			url: STRING; headers: like web.last_headers
		do
			across << Http >> as protocol loop -- Https
				across Document_table as table loop
					url := protocol.item + Httpbin_url + table.key
					lio.put_labeled_string ("url", url)
					lio.put_new_line
					web.open (url)

					try_3_times (agent web.read_string_head)
					headers := web.last_headers
					print_lines (web)
					assert_valid_headers (headers)
					if table.key ~ "xml" then
						assert_same_string ("mime_type", headers.mime_type, "application/xml")
					else
						assert_same_string ("mime_type", headers.mime_type, "text/html")
						assert_same_string ("encoding_name", headers.encoding_name, "utf-8")
					end
					try_3_times (agent web.read_string_get)
					if attached value_at_xpath (web.last_string, table.item.xpath) as value then
						assert ("xpath matches", value.starts_with (table.item.first_words))
					end
					assert ("valid content_length", headers.content_length = web.last_string.count)

					web.close
					lio.put_new_line
				end
			end
		end

	test_download_image_and_headers
		-- HTTP_CONNECTION_TEST_SET.test_download_image_and_headers
		note
			testing: "[
				covers/{EL_HTTP_CONNECTION}.read_string_head,
				covers/{EL_HTTP_HEADERS}.make, covers/{EL_HTTP_HEADERS}.set_table_field,
				covers/{EL_HTTP_HEADERS}.x_field
			]"
		local
			headers: like web.last_headers; image_url: STRING
		do
			across << "png", "jpeg", "webp", "svg" >> as image loop
				image_url := Image_url_stem + image.item
				web.open (image_url)
				try_3_times (agent web.read_string_head)
				print_lines (web)

				if attached new_image_path (image.item) as image_path then
					try_3_times (agent web.download (image_path))

					headers := web.last_headers
					assert_valid_headers (headers)
					assert ("valid content_type", headers.mime_type.starts_with ("image/" + image.item))
					assert ("valid content_length", headers.content_length = File.byte_count (image_path))
					assert ("valid encoding_name", headers.encoding_name.is_empty)
				end
				web.close
			end
		end

	test_headers
		-- HTTP_CONNECTION_TEST_SET.test_headers
		note
			testing: "[
				covers/{EL_HTTP_CONNECTION}.read_string_head,
				covers/{EL_HTTP_HEADERS}.make, covers/{EL_HTTP_HEADERS}.set_table_field,
				covers/{EL_HTTP_HEADERS}.x_field
			]"
		local
			headers: EL_HTTP_HEADERS
		do
			create headers.make (Headers_text)
			assert ("response_code OK", headers.response_code = Http_status.ok)
			assert_same_string ("mime_type", headers.mime_type, "text/html")
			assert_same_string ("encoding_name", headers.encoding_name, "UTF-8")
			across << "X-Powered-By", "powered_by" >> as key loop
				assert ("has powered by", headers.has_x_field (key.item))
				assert_same_string ("X-field", headers.x_field (key.item), "PHP/7.2.34")
			end
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
			headers: like web.last_headers; image_url: STRING
		do
			across << "png", "jpeg", "webp", "svg" >> as image loop
				image_url := Image_url_stem + image.item
				web.open (image_url)
				try_3_times (agent web.read_string_head)
				print_lines (web)

				headers := web.last_headers
				assert_valid_headers (headers)
				assert ("valid content_type", headers.mime_type.starts_with ("image/" + image.item))

				web.close
			end
		end

	test_ip_address_info
		-- HTTP_CONNECTION_TEST_SET.test_ip_address_info
		note
			testing: "[
				covers/{EL_SETTABLE_FROM_JSON_STRING}.set_from_json,
				covers/{EL_IP_ADDRESS_ROUTINES}.to_number, covers/{EL_IP_ADDRESS_ROUTINES}.to_string,
				covers/{EL_IP_ADDRESS_INFO_TABLE}.new_info,
				covers/{EL_CODE_REPRESENTATION}.to_value, covers/{EL_CODE_REPRESENTATION}.to_string
			]"
		local
			info: EL_IP_ADDRESS_GEOGRAPHIC_INFO; ip_number: NATURAL
		do
			ip_number := IP_address.to_number (www_eiffel_loop_com)
			info := Geographic_info_table.item (ip_number)
			assert_same_string ("same asn code", info.asn_, "AS8560")
			assert_same_string ("same location", info.location, "United Kingdom, England")
			assert_same_string ("same country", info.country_, "GB")
			assert_same_string ("same country code", info.country_code_, "GB")
			assert_same_string ("same 3 letter country code", info.country_code_iso3_, "GBR")
			assert_same_string ("same top level domain", info.country_tld_, ".uk")
			assert_same_string ("same continent", info.continent_code_, "EU")
			assert_same_string ("same currency", info.currency_, "GBP")
			assert_same_string ("same region code", info.region_code_, "ENG")
			assert_same_string ("same version", info.version_, "IPv4")

			assert ("same location", info.location ~ IP_country_region_table.item (ip_number))
			assert ("same ip", info.ip_address ~ Www_eiffel_loop_com)
			assert ("same area", info.country_area.to_integer_32 = 244820)

			-- `utc_offset' can vary depending if daylight saving is in effect
			assert ("same UTC offset", ("+0000, +0100").has_substring (info.utc_offset_))

			lio.put_integer_field ("size of info", info.deep_physical_size)
			lio.put_new_line
		end

	test_ip_geolocation
		-- HTTP_CONNECTION_TEST_SET.test_ip_geolocation
		note
			testing: "[
				covers/{EL_GEOLOCATION_ROUTINES}.for_number
			]"
		local
			ip: NATURAL
		do
		-- shetinin-school.ru has address 31.31.196.245
			ip := Ip_address.to_number ("31.31.196.245")
			assert_same_string (Void, Geolocation.for_number (ip), "Russia, Moscow")
		--	fasthosts.co.uk has address 213.171.195.48
			ip := Ip_address.to_number ("213.171.195.48")
			assert_same_string (Void, Geolocation.for_number (ip), "United Kingdom of Great Britain and Northern Ireland")
		end

	test_url_encoded
		-- HTTP_CONNECTION_TEST_SET.test_url_encoded
		note
			testing: "[
				covers/{EL_HTTP_CONNECTION}.read_string_head,
				covers/{EL_HTTP_HEADERS}.make, covers/{EL_HTTP_HEADERS}.set_table_field,
				covers/{EL_HTTP_HEADERS}.x_field
			]"
		local
			url: STRING; s: EL_STRING_8_ROUTINES; powered_by_title: STRING
		do
			across << "einführung.html", "einf%%C3%%BChrung.html" >> as name loop
				url := "https://myching.software/de/manual/" + name.item
				web.open (url)
				web.read_string_head
				if attached web.last_headers as header then
					assert ("Response OK", header.response_code = Http_status.ok)
					assert_same_string ("content_type", header.content_type, "text/html; charset=UTF-8")
					across << "X-Powered-By", "powered_by" >> as key loop
						assert_same_string (Void, header.x_field (key.item), "Eiffel-Loop Fast-CGI servlets")
					end
				end
				web.close
			end
		end

	test_web_archive
		-- HTTP_CONNECTION_TEST_SET.test_web_archive
		local
			url_parts: EL_STRING_8_LIST; archive: EL_WEB_ARCHIVE_HTTP_CONNECTION
			url: STRING
		do
			create archive.make
			url := "http://www.emotionaliching.com/lofting/bx101010.html"

			create url_parts.make_split (url, '/')
			url_parts [3].append (":80") -- append port number to domain

			if attached Archive.wayback (url) as closest and then closest.status.to_boolean then
				assert ("status OK", closest.status = Http_status.ok)
				assert ("available OK", closest.available)
				assert ("timestamp OK", closest.timestamp = 20130124193934)
				assert ("valid wayback ending", closest.url.ends_with (url_parts.joined ('/')))
				assert ("valid wayback start", closest.url.starts_with ("http://web"))
			end
		end

feature -- Unused

	test_http_errors
		local
			url: STRING
		do
			url := "http://localhost/en/home/my-ching.html"
			web.open (url)
			web.read_string_get
			if web.has_error then
				web.put_error (lio)
			end
			lio.put_labeled_substitution ("PAGE ERROR", "%S %S", [web.page_error_code, web.page_error_name])
			lio.put_new_line

			web.close
		end

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
			assert_same_string ("location", web.last_headers.location, "https://www.academie-francaise.fr/")
			web.close
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			File_system.make_directory (Cookie_path.parent)
			Web.set_log_output (lio)
		end

	on_clean
		do
			Precursor
			Web.set_silent_output
		end

feature {NONE} -- Implementation

	assert_document_retrieved (expected_leading_string_and_count: IMMUTABLE_STRING_8; doc_text: STRING; line_count: INTEGER)
		local
			list: EL_STRING_8_LIST
		do
			list := expected_leading_string_and_count.to_string_8
			assert ("2 items", list.count = 2)
			assert ("retrieved", doc_text.starts_with (list.first) and line_count = list.last.to_integer)
		end

	assert_valid_headers (headers: like web.last_headers)
		do
			assert ("valid date_stamp", headers.date_stamp.date ~ create {DATE}.make_now)
			if headers.response_code = Http_status.ok then
				assert ("valid server", is_server_name (headers.server))
			else
				lio.put_integer_field (Http_status.name (headers.response_code), headers.response_code)
				lio.put_new_line
				failed ("valid response_code")
			end
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

	try_3_times (web_operation: PROCEDURE)
		-- try 3 times if error is gateway timeout
		require
			target_is_web: web_operation.target = web
		local
			done: BOOLEAN
		do
			across 1 |..| 3 as n until done loop
				lio.put_integer_field ("Try number", n.item)
				lio.put_new_line
				web_operation.apply
				if web.has_error then
					done := not web.is_gateway_timeout
				else
					done := (web.last_headers.response_code) = Http_status.ok
				end
			end
		end

	value_at_xpath (text, xpath: STRING): ZSTRING
		local
			xdoc: EL_XML_DOC_CONTEXT
		do
			if XML.is_xml_declaration (text) then
				create xdoc.make_from_string (text)

			elseif HTML.is_document (text) then
				create xdoc.make_from_xhtml (text)
			else
				create xdoc.make_from_fragment (text, {CODE_PAGE_CONSTANTS}.Utf8)
			end
			Result := xdoc @ xpath
			Result.left_adjust
		end

feature {NONE} -- Factory

	new_city_location: EL_URI_QUERY_ZSTRING_HASH_TABLE
		do
			create Result.make_equal (2)
			Result.set_string ("city", "Köln")
			Result.set_string ("district", "Köln-Altstadt-Süd")
		end

	new_image_path (name: STRING): FILE_PATH
		do
			Result := Work_area_absolute_dir + "image"
			Result.add_extension (name)
		end

	new_json_fields (json_data: STRING): EL_URI_QUERY_ZSTRING_HASH_TABLE
		local
			pair_list: JSON_NAME_VALUE_LIST; s: EL_STRING_8_ROUTINES
			value: EL_COOKIE_STRING_8
		do
			create pair_list.make (json_data)
			create Result.make_equal (pair_list.count)
			from pair_list.start until pair_list.after loop
				create value.make_encoded (pair_list.item_value (False).to_latin_1)
				if not super_readable_8 (value).is_character ('{') then
					Result.set_string (pair_list.item_name (True), value.decoded)
				end
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

	Cookie_path: FILE_PATH
		once
			Result := Work_area_absolute_dir + {STRING_32} "Gefäß/cookie.txt"
		end

	Cookies_url: STRING = "http://httpbin.org/cookies"

	Document_table: EL_HASH_TABLE [TUPLE [xpath, first_words: STRING], STRING]
		-- table of predicates to test if document was retrieved
		once
			create Result.make_assignments (<<
				["html",			["/html/body/div/p", "Availing himself"]],
				["links/10/0",	["/html/body/a", "1"]],
				["xml",			["/slideshow/slide[1]/title", "Wake up"]]
			>>)
		end

	Html_post_url: STRING = "://httpbin.org/post"

	Http: STRING = "http"

	Httpbin_url: STRING = "://httpbin.org/"

	Https: STRING = "https"

	Image_url_stem: STRING = "http://httpbin.org/image/"

	Set_cookie_url: STRING = "http://httpbin.org/cookies/set?"

	www_eiffel_loop_com: STRING = "77.68.64.12"

end