select * --'execute sys.dbms_shared_pool.keep( '''||owner||'.'||name||''', ''p'' )'
from v$db_object_cache
where kept = 'NO' and executions > 100
and type  not in ('CURSOR', 'NOT LOADED')
and loads > 10
order by loads desc, executions desc

select 'execute sys.dbms_shared_pool.keep( '''||owner||'.'||name||''', ''p'' )'
from v$db_object_cache
where name = 'INV_RCV_INTEGRATION_PVT'

select * --'execute sys.dbms_shared_pool.keep( '''||owner||'.'||name||''', ''p'' )'
from v$db_object_cache
where kept = 'YES' and executions = 0
and type  not in ('TRIGGER','CURSOR', 'NOT LOADED')
and owner <> 'SYS'
order by sharable_mem desc, executions desc

select *
from V$SHARED_POOL_RESERVED

select *
from V$LIBRARYCACHE 

select *
from v$sqlarea
where hash_value = '2226139191'

select sql_text, hash_value,version_count, loads, executions, buffer_gets, buffer_gets/executions "Gets Per Exec", cpu_time
from v$sqlarea
where loads > 20
and executions > 5000
and buffer_gets/executions > 1000
order by cpu_time  desc

where hash_value = '1053795750'

order by cpu_time desc


select *
from dba_db_links

May 17 12:41pm
execute sys.dbms_shared_pool.keep( 'APPS.GEPL_PO_LINES_ALERT_AU' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_AP_INV_DIST_BI_TR' , 'r' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVC_UPDATE_DESCRIPTION' , 'r' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVOAAP_INVDISTREVERSE_TR' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_PO_IP_LINES_ALL_ARU' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AX_AP_INVOICES_ARU3' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_AP_INV_DIST_AI_TR' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_ICX_SESSION_AIUR_TRG' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_RESET_LANG_ICX' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AW_CONC' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AW_CONC_UPD' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AX_AP_INVOICE_DIST_BRU1' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AX_AP_INVOICE_DIST_ARDI1' , 'r' )
execute sys.dbms_shared_pool.keep( 'SYS.DBMS_UTILITY' , 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.MTL_SUPPLY_T' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_AP_INV_AI_TR' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AX_AP_INVOICE_DIST_ARU1' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_AP_INVOICE_DIST_T1' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_AP_INVOICE_DIST_T3' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_SIA_AP_INVOICES_ALL_T1' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_EXP_HOLD_T1' , 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_GFM' , 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_CAT_SRCH_LOOKUP' , 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_NOTIFICATION' , 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_INVVIEW_PKG' , 'p' )

May 17 19:58
execute sys.dbms_shared_pool.keep( 'SYS.DBMS_SPACE_ADMIN', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_DOC_INV_POUSERID_FNC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_ERROR_RQSTSETID_FNC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GEPL_CHECK_VALUE_SET_VALUE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HR_MULTI_MESSAGE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PER_PER_SHD', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_ENGINE_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_NUMBER', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_ENTITY_MGR', 'p' )
execute sys.dbms_shared_pool.keep( 'SYS.DBMS_LOB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_VP_UTIL_PK', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_WF_UTIL_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_CORE_S', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PER_ASG_SHD', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_FLEX_DESCVAL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_TAX_ENGINE_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_FWKMON', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PA_PROJECT_UTILS', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_PARAM_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_CORE_S2', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVT_WORKFLOW_UTILITY', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MV_AUTHENTICATE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PA_PROJ_ELEMENTS_UTILS', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AME_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.SRP_ATTACHED_DOCUMENTS_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_RCO_VALIDATION_GRP', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_NOTIFICATIONS_SV3', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GL_CURRENCY_API', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.POR_RCV_POST_QUERY_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.SF_FILTER_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.SF_FILTER_DISPATCH', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.SF_FILTER_F151', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.INV_ITEM_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'SABRIX.DOTIME', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.ICX_PLUG_UTILITIES', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_WF_ENGINE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PA_SECURITY', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_LE_PK', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_WEB_CONFIG', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.SFOA_AP_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GESSS_WF_ENGINE_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_STD_DW_FEEDS_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_WF_PO_CHARGE_ACC', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.SF_CLIENT_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_INVOICES_UTILITY_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'SYS.DBMS_SESSION', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_INQ_SV', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.JDR_MDS_INTERNAL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_FLEX_EXT', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PA_CC_UTILS', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_DIRECTORY', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.JDR_CUSTOM_INTERNAL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HXC_MAPPING_UTILITIES', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_CHARGE_ALLOCATIONS_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_DIST_VALIDATION_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVOA_INVOICE', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVOA_INVOICE_API', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_ACCOUNTING_EVENTS_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PA_UTILS2', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_EXTENDED_WITHHOLDING_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.RCV_ROI_HEADER', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FNDCP_CRM', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GEPL_POR_AUTONOMOUS_TRANS_PRC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_ACCOUNT_GEN_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.POR_RCV_TRANSACTION_SV', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_WF_PO_BUDGET_ACC', 'p' )
execute sys.dbms_shared_pool.keep( 'SYS.UTL_SMTP', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_WF_PO_RULE_ACC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_EXP_AP_HOLDS_T2', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_RESET_LANG_FND', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GEAE_PLA_AUTOM_ATTACH_AIUR_TRG', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.AW_DBWAKE_TRIG', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_EXP_AP_HOLDS_T1', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.IGI_AP_INVOICE_DIST_T2', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_PO_IP_ELANCE_HEADERS_ALL', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.JL_BR_AP_TAX_HOLDS', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_AP_INV_BI_TR', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GEAE_PLLA_BIUR_TRIG', 'r' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVX_RESUBMIT_AP_DIST_TR', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GEAE_PHA_AUTOM_ATTACH_AIUR_TRG', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_PO_IP_HEADERS_ALL_ARU', 'r' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_FLEX_VAL_RULE_LINES_T3', 'r' )

May 18 09:13
execute sys.dbms_shared_pool.keep( 'APPS.PO_CHORD_WF0', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_INVOICE_DISTRIBUTIONS_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_CONC_DATE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_LOCAL_SYNCH', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MV_SCHEME', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.POR_UTIL_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PORCPTWF', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GMA_CORE_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.ICX_CAT_UTIL_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_UTILITY_V2PUB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PER_HRTCA_MERGE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_COMMON_PUB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_PARTY_V2PVT', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_PARTY_PAR', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PA_INSTALL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.BEN_EXT_CHLG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GEMS_GATEKEEPER_VALIDATION', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WFA_SEC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_CAT_SRCH_LOOKUP', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_PARTY_V2PUB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_REGISTRY_VALIDATE_V2PUB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_PARTY_PUB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PER_HRWF_SYNCH', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_EP_CARD_PKG_21', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.SF_PREFERENCE_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PER_PER_BUS', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_CAT_SRCH_PRICEBREAK_FNC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.HZ_PERSON_PROFILES_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GHR_HISTORY_API', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.MVOA_APPS_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MVOA_FND_UTIL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.INV_LE_TIMEZONE_PUB', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AP_APPROVAL_MATCHED_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_XML', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.FND_VSET', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.ECX_ACTIONS', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_DOC_VIEWER_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'SYS.PLITBLM', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.MV_MARKUP', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_POAPPROVAL_PKG1', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.ECX_PRINT_LOCAL', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_DOC_APPROVER_FNC', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AME_ENGINE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.PO_COMMUNICATION_PVT', 'p' )
execute sys.dbms_shared_pool.keep( 'MARKVIEW.GECM_GET_METADATA', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECGCF_REQ_APPROVAL_PKG', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.WF_QUEUE', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.AW_OAE3', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.GECM_ECX_PO_UTILS', 'p' )
execute sys.dbms_shared_pool.keep( 'APPS.INV_RCV_INTEGRATION_PVT', 'p' );
