note
	description: "JSON test data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 19:06:24 GMT (Saturday 11th March 2023)"
	revision: "5"

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

end