note
	description: "JSON test data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-19 13:53:16 GMT (Sunday 19th March 2023)"
	revision: "8"

deferred class
	JSON_TEST_DATA

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	JSON_archived_snapshots: ZSTRING
		once
			Result := "[
				{
					"url": "http://www.emotionaliching.com/lofting/bx101010.html",
					"archived_snapshots": {
						"closest": {
							"status": "200",
							"available": true,
							"url": "http://web.archive.org/web/20130124193934/http://www.emotionaliching.com:80/lofting/bx101010.html",
							"timestamp": "20130124193934"
						}
					}
				}
			]"
		end

	JSON_eiffel_loop_ip: STRING = "[
		{
			"ip": "77.68.64.12",
			"version": "IPv4",
			"city": "Kensington",
			"region": "England",
			"region_code": "ENG",
			"country": "GB",
			"country_name": "United Kingdom",
			"country_code": "GB",
			"country_code_iso3": "GBR",
			"country_capital": "London",
			"country_tld": ".uk",
			"continent_code": "EU",
			"in_eu": false,
			"postal": "SW7",
			"latitude": 51.4957,
			"longitude": -0.1772,
			"timezone": "Europe/London",
			"utc_offset": "+0100",
			"country_calling_code": "+44",
			"currency": "GBP",
			"currency_name": "Pound",
			"languages": "en-GB,cy-GB,gd",
			"country_area": 244820.6,
			"country_population": 66488991,
			"asn": "AS8560",
			"org": "IONOS SE"
		}
	]"

	JSON_person: ZSTRING
		once
			Result := {STRING_32} "[
				{
					"name": "John Smith",
					"city": "New York",
					"gender": "♂",
					"age": 45
				}
			]"
		end

	JSON_price: ZSTRING
		once
			Result := "[
				{
					"name" : "\"My Ching\u2122\" \uD852\uDF62",
					"price" : "\u20AC\t3.00"
				}
			]"
		end

	JSON_vector_plane_data: STRING
		once
			Result := "[
				{
					"q": [
						[0, 1, 2, 3],
						[4, 0, 3, 5],
						[6, 4, 5, 7]
					],
					"p": [
						[-3.021211040636997, 0, 0.14217187491185729],
						[-2.9544233358350973, 0, 0.52094409745481851],
						[-2.909539006810594, 0.52094453300079102, 0.51302978605945249],
						[-2.9763267116124936, 0.52094453300079102, 0.13425756351649126],
						[-3.0879987454388971, 0, -0.23660034763110396],
						[-3.0431144164143937, 0.52094453300079102, -0.24451465902646999],
						[-3.1547864502407967, 0, -0.6153725701740651],
						[-3.1099021212162934, 0.52094453300079102, -0.62328688156943113]
					]
				}
			]"
		end

end