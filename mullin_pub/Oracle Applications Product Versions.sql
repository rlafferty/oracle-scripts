-- This query gives product version info 
SELECT app_short_name, MAX(patch_level)
FROM ad_patch_driver_minipks
GROUP BY app_short_name
 

