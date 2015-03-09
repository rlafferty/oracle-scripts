select a.PROFILE_OPTION_NAME, b.profile_option_value, b.level_id, b.level_value, b.last_update_date, b.last_updated_by
from fnd_profile_options a, fnd_profile_option_values b
where b.profile_option_value like '%/tmp%'
and a.application_id = b.application_id
and a.profile_option_id = b.profile_option_id