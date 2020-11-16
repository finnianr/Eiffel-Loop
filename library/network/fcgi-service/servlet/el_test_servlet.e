note
	description: "Test servlet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-16 11:22:33 GMT (Monday 16th November 2020)"
	revision: "2"

class
	EL_TEST_SERVLET

inherit
	FCGI_HTTP_SERVLET

create
	make

feature {NONE} -- Basic operations

	serve (request: like new_request; response: like new_response)
		do
			response.set_content (Hello_page, Doc_type_html_utf_8)
		end

	Hello_page: STRING
		once
			Result := "[
				<html>
					<head>
						<title>Fast-CGI test</title>
						<style type="text/css">
						<!--
						h1	{text-align:center;
							font-family:Arial, Helvetica, Sans-Serif;
						}
						body	{
							margin-top: 20px;
							text-indent: 20px;
						}
						-->
						</style>
					</head>
					<body bgcolor = "#ffffcc" text = "#000000">
						<h2>Fast-CGI test</h2>
						<p>Hello world</p>
					</body>
				</html>
			]"
		end
end