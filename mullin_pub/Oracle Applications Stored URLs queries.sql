SELECT text_value
FROM wf_notification_attributes
WHERE text_value LIKE '%'||'https://sssdev'||'%'


SELECT text_value
FROM wf_item_attribute_values
WHERE text_value LIKE '%'||'https://sssdev'||'%'

SELECT parameter_name, VALUE
FROM GECM_EPCARD_PARAMETERS
WHERE  parameter_name IN ( 'XML_PO_URL',  'XML_Url', 'SSO_URL','PO_VIEWER_BASE_DIR')


SELECT b.ITEM_SOURCE_NAME, A.URL
FROM ICX_POR_ITEM_SOURCES A, ICX_POR_ITEM_SOURCEs_tl b
WHERE A.ITEM_SOURCE_ID = b.ITEM_SOURCE_ID
AND b.LANGUAGE = 'US'
AND A.url LIKE '%corporate%'

SELECT company, callback_url, authentication_url
FROM ICX_PROCUREMENT_SERVER_SETUP

SELECT function_name,web_host_name--,SUBSTR(web_host_name,1,(LENGTH(web_host_name)-1))
FROM fnd_form_functions
WHERE web_host_name LIKE '%corporate%'

SELECT function_name,web_html_call--,SUBSTR(web_host_name,1,(LENGTH(web_host_name)-1))
FROM fnd_form_functions
WHERE web_html_call LIKE '%corp%'

SELECT fpo.PROFILE_OPTION_NAME, fpov.PROFILE_OPTION_VALUE
FROM fnd_profile_option_values fpov, fnd_profile_options fpo 
WHERE fpov.profile_option_value LIKE '%https:%corporate%'
AND fpov.application_id = fpo.application_id
AND fpov.profile_option_id = fpo.profile_option_id


SELECT *
FROM ecx_hubs
WHERE protocol_address LIKE '%corporate%'