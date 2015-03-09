--# The following query return the patch run times for a given time period summarized by Merged Patch run.
--# Only US and D languages were used to ensure that both US and LA patches are included but if you specify more than
--# one translation the patch timings Run Time column is duplicated.
--# Parameters used to get patch run times for 11.5.10 Post Upgrade Patches in QA are:
--# :1 = ssi1 
--# :2 = 04/01/2006 
--# :3 = 05/02/2006 
--# :4 = 04/01/2006 
--# :5 = 05/02/2006 
SELECT *
  FROM (SELECT   pr.patch_top,
                 ad_pa_validate_criteriaset.get_concat_mergepatches
                                                           (pd.patch_driver_id),
				 MIN(start_date),MAX (end_date), sum((end_date - start_date) * 1440) "Run Time"
            FROM ad_appl_tops AT,
                 ad_patch_driver_langs l,
                 ad_patch_runs pr,
                 ad_patch_drivers pd,
                 ad_applied_patches ap
           WHERE pr.appl_top_id = AT.appl_top_id
             AND AT.applications_system_name = :1
             AND pr.patch_driver_id = pd.patch_driver_id
             AND pd.applied_patch_id = ap.applied_patch_id
             AND pd.patch_driver_id = l.patch_driver_id
             AND (   (pr.start_date >= :2 AND pr.start_date < :3)
                  OR (pr.end_date >= :4 AND pr.end_date < :5)
                 )
             AND l.LANGUAGE IN ('US','D')
        GROUP BY pr.patch_top,
                 ad_pa_validate_criteriaset.get_concat_mergepatches
                                                           (pd.patch_driver_id)
        ORDER BY pr.patch_top);
		

