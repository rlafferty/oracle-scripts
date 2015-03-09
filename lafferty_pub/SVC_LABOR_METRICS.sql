SELECT time_type,
          fiscal_year,
          fiscal_quarter,
          fiscal_month,
          fiscal_week,
          customer_name_phonetic,
          fleet_name,
          finance_contract_name,
          service_contract_name,
          service_org_code,
          service_org_name,
          workorder_number,
          service_sheet_id,
          road_number,
          locomotive_type_code,
          service_contract_type,
          employee_id,
          first_name,
          last_name,
          work_shift,
          work_shift_code,
          skill_class,
          date_worked,
          creation_date,
          nh,
          normal_minutes,
          oh,
          overtime_minutes,
          overtime_type_code,
          service_sheet_comment,
          service_program_type_code,
          service_workorder_id,
          inshop_date,
          outshop_date,
          inshop_reason,
          wo_status,
          NVL (normal_hours, 0) normal_hours,
          NVL (overtime_hours, 0) overtime_hours,
          NVL (total_hours, 0) total_hours,
          overtime_type,
          record_type_code,
          service_type_code,
          service_type,
          program_name,
          service_item,
          reason,
          reason_code,
          defect_id,
          fmi_flag,
          cmr_inshop_category,
          date_value
     FROM ( (  SELECT DECODE (NVL (labr.record_type_code, 'LOCO TIME'),
                              'DEFECT', 'DEFECT',
                              'LOCO TIME', 'LOCO TIME',
                              'Previous Day Defect', 'DEFECT')
                         time_type,
                      parent_fiscal_year_name AS fiscal_year,
                      cx_fiscal_quarter AS fiscal_quarter,
                      SUBSTR (parent_fiscal_month_name, 6, 3) AS fiscal_month,
                      dd.fiscal_week,
                      dd.date_value,
                      (SELECT c.customer_name
                         FROM gets_lms_customer_service_orgs so,
                              gets_master_customer_dim c
                        WHERE     so.customer_id = c.lms_customer_key
                              AND so.service_organization_id =
                                     labr.service_organization_id)
                         customer_name_phonetic,
                      labr.fleet_name,
                      (SELECT fc.finance_contract_name
                         FROM gets_dw_idw.gets_finance_contract_d fc
                        WHERE cm.finance_contract_key = fc.finance_contract_key)
                         finance_contract_name,
                      labr.contract_name service_contract_name,
                      labr.service_organization_code service_org_code,
                      w.warehouse_name service_org_name,
                      (SELECT WO_NUM
                         FROM svc_lms_srvc_wo_f wo
                        WHERE wo.srvc_wo_key = lab.srvc_wo_key)
                         workorder_number,
                      lab.srvc_sht_key service_sheet_id,
                      labr.road_number,
                      l.locomotive_type_code,
                      labr.service_contract_type,
                      (SELECT EMPLOYEE_ID
                         FROM GETS_DW_SVC.SVC_LMS_EMPLY_D e
                        WHERE lab.lms_emply_key = e.lms_emply_key)
                         employee_id,
                      (SELECT FRST_NM
                         FROM GETS_DW_SVC.SVC_LMS_EMPLY_D e
                        WHERE lab.lms_emply_key = e.lms_emply_key)
                         first_name,
                      (SELECT LST_NM
                         FROM GETS_DW_SVC.SVC_LMS_EMPLY_D e
                        WHERE lab.lms_emply_key = e.lms_emply_key)
                         last_name,
                      (SELECT WRK_SHFT_NM
                         FROM svc_lms_wrk_shft_d s
                        WHERE lab.wrk_shft_key = s.wrk_shft_key)
                         work_shift,
                      (SELECT WRK_SHFT_CD
                         FROM svc_lms_wrk_shft_d s
                        WHERE lab.wrk_shft_key = s.wrk_shft_key)
                         work_shift_code,
                      labr.skill_class,
                      lab.lbr_wrked_on_dttm AS date_worked,
                      lab.creation_date,
                      lab.normal_hours AS nh,
                      lab.normal_minutes,
                      lab.overtime_hours AS oh,
                      lab.overtime_minutes,
                      (SELECT OVRTM_TYP_CD
                         FROM svc_lms_ovrtm_typ_d ot
                        WHERE lab.ovrtm_typ_key = ot.ovrtm_typ_key)
                         overtime_type_code,
                      (SELECT SRVC_SHT_CMNT_TXT
                         FROM svc_lms_srvc_sht_f ssf
                        WHERE ssf.srvc_sht_key = ss.srvc_sht_key)
                         service_sheet_comment,
                      (SELECT SRVC_PROG_CD
                         FROM svc_lms_srvc_prog_f pc
                        WHERE ss.srvc_prog_key = pc.srvc_prog_key)
                         service_program_type_code,
                      -- ssr.service_workorder_id,
                      ss.srvc_wo_key AS service_workorder_id,
                      (SELECT WO_PLNND_IN_SHP_DTTM
                         FROM svc_lms_srvc_wo_f wo
                        WHERE wo.srvc_wo_key = lab.srvc_wo_key)
                         inshop_date,
                      (SELECT WO_PLNND_OUT_SHP_DTTM
                         FROM svc_lms_srvc_wo_f wo
                        WHERE wo.srvc_wo_key = lab.srvc_wo_key)
                         outshop_date,
                      (SELECT INSHP_RSN_TYP_CD
                         FROM svc_lms_srvc_wo_f wo, svc_lms_inshp_rsn_typ_d ins
                        WHERE     wo.srvc_wo_key = lab.srvc_wo_key
                              AND wo.inshp_rsn_typ_key = ins.inshp_rsn_typ_key)
                         inshop_reason,
                      (SELECT CASE
                                 WHEN wo.worder_close_date IS NULL THEN 'OPEN'
                                 ELSE 'CLOSED'
                              END
                                 wo_status
                         FROM gets_dw_rel.gets_lms_dw_workorder wo
                        WHERE wo.service_workorder_id =
                                 labr.service_workorder_id)
                         wo_status,
                      SUM (labr.normal_hours) + SUM (labr.normal_minutes) / 60
                         normal_hours,
                        SUM (labr.overtime_hours)
                      + SUM (labr.overtime_minutes) / 60
                         overtime_hours,
                        (  SUM (labr.normal_hours)
                         + SUM (labr.normal_minutes) / 60)
                      + (  SUM (labr.overtime_hours)
                         + SUM (labr.overtime_minutes) / 60)
                         total_hours,
                      (SELECT OVRTM_TYP_NM
                         FROM svc_lms_ovrtm_typ_d ovr
                        WHERE ovr.ovrtm_typ_key = lab.ovrtm_typ_key)
                         overtime_type,
                      labr.record_type_code,
                      labr.service_type_code,
                      labr.service_type,
                      (SELECT srvc_prog_nm
                         FROM svc_lms_srvc_prog_f srvc
                        WHERE srvc.srvc_prog_key = ss.srvc_prog_key)
                         program_name,
                      (SELECT product_number
                         FROM jarosods.product_mas pmas
                        WHERE pmas.product_key = ss.service_item_product_key)
                         service_item,
                      (SELECT non_loco_tm_rsn_desc
                         FROM svc_lms_non_loco_tm_rsn_d rsn
                        WHERE rsn.non_loco_tm_rsn_key = lab.non_loco_tm_rsn_key)
                         reason,
                      (SELECT non_loco_tm_rsn_cd
                         FROM svc_lms_non_loco_tm_rsn_d rsn
                        WHERE rsn.non_loco_tm_rsn_key = lab.non_loco_tm_rsn_key)
                         reason_code,
                      (SELECT dfct_sht_key
                         FROM svc_lms_dfct_sht_f dfct
                        WHERE (dfct.dfct_sht_key) = lab.dfct_sht_key)
                         defect_id,
                      ssr.fmi_flag,
                      (SELECT (CASE INSHP_RSN_TYP_CD
                                  WHEN 'OH' THEN 'OH'
                                  WHEN 'QM' THEN 'QM'
                                  WHEN 'RM' THEN 'RM'
                                  WHEN 'FL' THEN 'US'
                                  WHEN 'FM' THEN 'US'
                                  WHEN 'GR' THEN 'US'
                                  ELSE 'OTHER'
                               END)
                         FROM svc_lms_srvc_wo_f wo, svc_lms_inshp_rsn_typ_d ins
                        WHERE     wo.srvc_wo_key = lab.srvc_wo_key
                              AND wo.inshp_rsn_typ_key = ins.inshp_rsn_typ_key)
                         cmr_inshop_category
                 FROM gets_dw_rel.gets_lms_dw_labor labr,
                      svc_lms_lbr_f lab,
                      svc_lms_srvc_sht_f ss,
                      gets_dw_rel.gets_lms_dw_service_sheet ssr,
                      gets_dw_idw.gets_lms_fleet_dim f,
                      gets_dw_rel.gets_lms_dw_locomotive l,
                      gets_dw_idw.gets_lms_service_contract_dim sc,
                      gets_dw_idw.msa_contract_model_dim cm,
                      jarosods.warehouse_mas w,
                      jarosdm.date_dim dd
                WHERE     lab.md_lookup_value = TO_CHAR (labr.service_labor_id)
                      AND TO_CHAR (lab.srvc_sht_key) = ss.srvc_sht_key(+)
                      AND labr.service_sheet_id = ssr.service_sheet_id(+)
                      AND f.fleet_id = l.fleet_id
                      AND l.locomotive_id = labr.locomotive_id
                      AND sc.contract_number = f.contract_number
                      AND cm.service_contract_id = sc.service_contract_id(+)
                      AND dd.date_key = labr.date_worked
                      AND labr.service_organization_id = w.warehouse_id
             --Sc_lms_srvc_sheet_f ss
             --svc_lms_lbr_f lab
             --   and to_char(labr.date_worked,'YYYY') >= '2010'
             --WHERE    lab.date_worked BETWEEN TO_DATE ('1/1/2011', 'mm/dd/yyyy')
             --                             AND TO_DATE ('4/03/2011', 'mm/dd/yyyy')
             ----AND      lab.customer_name_phonetic = 'CSX'
             GROUP BY parent_fiscal_year_name,
                      cx_fiscal_quarter,
                      SUBSTR (parent_fiscal_month_name, 6, 3),
                      dd.fiscal_week,
                      labr.service_organization_id,
                      labr.fleet_name,
                      cm.finance_contract_key,
                      labr.contract_name,
                      labr.service_organization_code,
                      w.warehouse_name,
                      lab.srvc_wo_key,
                      lab.srvc_sht_key,
                      labr.road_number,
                      l.locomotive_type_code,
                      labr.service_contract_type,
                      labr.record_type_code,
                      labr.service_type_code,
                      labr.service_type,
                      ss.srvc_prog_key,
                      --ss.service_item,
                      -- lab.reason,
                      --lab.lms_dfct_key,
                      ssr.fmi_flag,
                      --lab.overtime_type,
                      dd.date_value,
                      labr.service_workorder_id,
                      lab.ovrtm_typ_key,
                      ss.service_item_product_key,
                      lab.non_loco_tm_rsn_key,
                      lab.dfct_sht_key,
                      labr.skill_class,
                      lab.lbr_wrked_on_dttm,
                      lab.creation_date,
                      lab.normal_hours,
                      lab.normal_minutes,
                      lab.overtime_hours,
                      lab.overtime_minutes,
                      ssr.service_workorder_id,
                      lab.lms_emply_key,
                      lab.wrk_shft_key,
                      ss.srvc_sht_key,
                      ss.srvc_wo_key
             UNION ALL
               SELECT 'NON LOCO TIME' time_type,
                      parent_fiscal_year_name AS fiscal_year,
                      cx_fiscal_quarter AS fiscal_quarter,
                      SUBSTR (parent_fiscal_month_name, 6, 3) AS fiscal_month,
                      fw.fiscal_week,
                      fw.date_value AS date_value,
                      labr.customer_name_phonetic,
                      '' AS fleet_name,
                      '' AS finance_contract_name,
                      labr.contract_name service_contract_name,
                      labr.service_organization_code service_org_code,
                      w.warehouse_name service_org_name,
                      (SELECT WO_NUM
                         FROM svc_lms_srvc_wo_f wo
                        WHERE wo.srvc_wo_key = lab.srvc_wo_key)
                         workorder_number,
                      lab.srvc_sht_key,
                      labr.road_number,
                      '' AS locomotive_type_code,
                      labr.service_contract_type,
                      (SELECT EMPLOYEE_ID
                         FROM GETS_DW_SVC.SVC_LMS_EMPLY_D e
                        WHERE lab.lms_emply_key = e.lms_emply_key)
                         employee_id,
                      (SELECT FRST_NM
                         FROM GETS_DW_SVC.SVC_LMS_EMPLY_D e
                        WHERE lab.lms_emply_key = e.lms_emply_key)
                         first_name,
                      (SELECT LST_NM
                         FROM GETS_DW_SVC.SVC_LMS_EMPLY_D e
                        WHERE lab.lms_emply_key = e.lms_emply_key)
                         last_name,
                      (SELECT WRK_SHFT_NM
                         FROM svc_lms_wrk_shft_d s
                        WHERE lab.wrk_shft_key = s.wrk_shft_key)
                         work_shift,
                      (SELECT WRK_SHFT_CD
                         FROM svc_lms_wrk_shft_d s
                        WHERE lab.wrk_shft_key = s.wrk_shft_key)
                         work_shift_code,
                      labr.skill_class,
                      /*
                      (SELECT SKILL_CLS_NM
                       FROM   svc_lms_skill_cls_d sk
                       WHERE  lab.skill_cls_key=
                                                       sk.skill_cls_key)
                                                                  skill_class,*/
                      lab.lbr_wrked_on_dttm AS date_worked,
                      lab.creation_date,
                      lab.normal_hours AS nh,
                      lab.normal_minutes,
                      lab.overtime_hours AS oh,
                      lab.overtime_minutes,
                      (SELECT OVRTM_TYP_CD
                         FROM svc_lms_ovrtm_typ_d ot
                        WHERE lab.ovrtm_typ_key = ot.ovrtm_typ_key)
                         overtime_type_code,
                      (SELECT SRVC_SHT_CMNT_TXT
                         FROM svc_lms_srvc_sht_f ssf
                        WHERE ssf.srvc_sht_key = ss.srvc_sht_key)
                         service_sheet_comment,
                      (SELECT SRVC_PROG_CD
                         FROM svc_lms_srvc_prog_f pc
                        WHERE ss.srvc_prog_key = pc.srvc_prog_key)
                         service_program_type_code,
                      ss.srvc_wo_key AS service_workorder_id,
                      -- ssr.service_workorder_id,
                      (SELECT WO_PLNND_IN_SHP_DTTM
                         FROM svc_lms_srvc_wo_f wo
                        WHERE wo.srvc_wo_key = lab.srvc_wo_key)
                         inshop_date,
                      (SELECT WO_PLNND_OUT_SHP_DTTM
                         FROM svc_lms_srvc_wo_f wo
                        WHERE wo.srvc_wo_key = lab.srvc_wo_key)
                         outshop_date,
                      (SELECT INSHP_RSN_TYP_CD
                         FROM svc_lms_srvc_wo_f wo, svc_lms_inshp_rsn_typ_d ins
                        WHERE     wo.srvc_wo_key = lab.srvc_wo_key
                              AND wo.inshp_rsn_typ_key = ins.inshp_rsn_typ_key)
                         inshop_reason,
                      (SELECT CASE
                                 WHEN w.worder_close_date IS NULL THEN 'OPEN'
                                 ELSE 'CLOSED'
                              END
                                 wo_status
                         FROM gets_dw_rel.gets_lms_dw_workorder w
                        WHERE w.service_workorder_id =
                                 labr.service_workorder_id)
                         wo_status,
                      SUM (labr.normal_hours) + SUM (labr.normal_minutes) / 60
                         normal_hours,
                        SUM (labr.overtime_hours)
                      + SUM (labr.overtime_minutes) / 60
                         overtime_hours,
                        (  SUM (labr.normal_hours)
                         + SUM (labr.normal_minutes) / 60)
                      + (  SUM (labr.overtime_hours)
                         + SUM (labr.overtime_minutes) / 60)
                         total_hours,
                      (SELECT OVRTM_TYP_NM
                         FROM svc_lms_ovrtm_typ_d ovr
                        WHERE ovr.ovrtm_typ_key = lab.ovrtm_typ_key)
                         overtime_type,
                      labr.record_type_code,
                      labr.service_type_code,
                      NVL (labr.service_type, 'NON LOCO TIME') service_type,
                      (SELECT srvc_prog_nm
                         FROM svc_lms_srvc_prog_f srvc
                        WHERE srvc.srvc_prog_key = ss.srvc_prog_key)
                         program_name,
                      (SELECT product_number
                         FROM jarosods.product_mas pmas
                        WHERE pmas.product_key = ss.service_item_product_key)
                         service_item,
                      (SELECT non_loco_tm_rsn_desc
                         FROM svc_lms_non_loco_tm_rsn_d rsn
                        WHERE rsn.non_loco_tm_rsn_key = lab.non_loco_tm_rsn_key)
                         reason,
                      (SELECT non_loco_tm_rsn_cd
                         FROM svc_lms_non_loco_tm_rsn_d rsn
                        WHERE rsn.non_loco_tm_rsn_key = lab.non_loco_tm_rsn_key)
                         reason_code,
                      (SELECT dfct_sht_key
                         FROM svc_lms_dfct_sht_f dfct
                        WHERE (dfct.dfct_sht_key) = lab.dfct_sht_key)
                         defect_id,
                      ssr.fmi_flag,
                      (SELECT (CASE INSHP_RSN_TYP_CD
                                  WHEN 'OH' THEN 'OH'
                                  WHEN 'QM' THEN 'QM'
                                  WHEN 'RM' THEN 'RM'
                                  WHEN 'FL' THEN 'US'
                                  WHEN 'FM' THEN 'US'
                                  WHEN 'GR' THEN 'US'
                                  ELSE 'OTHER'
                               END)
                         FROM svc_lms_srvc_wo_f wo, svc_lms_inshp_rsn_typ_d ins
                        WHERE     wo.srvc_wo_key = lab.srvc_wo_key
                              AND wo.inshp_rsn_typ_key = ins.inshp_rsn_typ_key)
                         cmr_inshop_category
                 FROM svc_lms_lbr_f lab,
                      svc_lms_srvc_sht_f ss,
                      gets_dw_rel.gets_lms_dw_labor labr,
                      gets_dw_rel.gets_lms_dw_service_sheet ssr,
                      jarosdm.date_dim fw,
                      jarosods.warehouse_mas w
                WHERE     fw.date_value = TRUNC (labr.date_worked)
                      AND TO_CHAR (labr.service_labor_id) = lab.md_lookup_value
                      AND lab.srvc_sht_key = ss.srvc_sht_key(+)
                      AND labr.service_sheet_id = ssr.service_sheet_id(+)
                      AND labr.service_organization_id = w.warehouse_id
                      AND reason IS NOT NULL
             --  AND      to_char(date_worked,'YYYY') >= '2010'
             --            AND      lab.date_worked BETWEEN TO_DATE ('1/1/2011',
             --                                                      'mm/dd/yyyy')
             --                                         AND TO_DATE ('3/25/2011',
             --                                                      'mm/dd/yyyy')
             GROUP BY parent_fiscal_year_name,
                      cx_fiscal_quarter,
                      SUBSTR (parent_fiscal_month_name, 6, 3),
                      fw.fiscal_week,
                      fw.date_value,
                      labr.customer_name_phonetic        --   , lab.fleet_name
                                                --  , fc.finance_contract_name
                      ,
                      labr.contract_name,
                      labr.service_organization_code,
                      w.warehouse_name,
                      lab.srvc_wo_key,
                      lab.srvc_sht_key,
                      labr.road_number            --  , l.locomotive_type_code
                                      ,
                      labr.service_contract_type,
                      labr.record_type_code,
                      labr.service_type_code,
                      labr.service_type,
                      ss.srvc_prog_key,
                      ss.service_item_product_key,
                      lab.non_loco_tm_rsn_key,
                      lab.dfct_sht_key,
                      ssr.fmi_flag,
                      LAB.OVRTM_TYP_key,
                      labr.service_workorder_id,
                      labr.service_workorder_id,
                      lab.ovrtm_typ_key,
                      ss.service_item_product_key,
                      lab.non_loco_tm_rsn_key,
                      lab.dfct_sht_key,
                      labr.skill_class,
                      lab.lbr_wrked_on_dttm,
                      lab.creation_date,
                      lab.normal_hours,
                      lab.normal_minutes,
                      lab.overtime_hours,
                      lab.overtime_minutes,
                      ssr.service_workorder_id,
                      lab.lms_emply_key,
                      lab.wrk_shft_key,
                      ss.srvc_sht_key,
                      ss.srvc_wo_key)