BEGIN
   DBMS_ADVISOR.TUNE_MVIEW (
      :task_name,
      'CREATE MATERIALIZED VIEW GETS_DW_SVC.X_SVC_DW_WIP_JOBS_MTL_RQMTS_MV
NOCACHE
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS
SELECT
      a.inventory_item_id,
       PM.product_number item,
       a.organization_id,
       WM.WAREHOUSE_code org_code,
       a.wip_entity_key,
       b.wip_entity_name order_number,
       a.operation_seq_number,
       b.LAST_UPDATE_DATETIME,                        
       B.LAST_UPDATED_BY,                             
       b.CREATION_DATETIME,                              
       a.component_sequence_id,
       DEP_MAS.department_long_name,          
       d.meaning supply_type,
       a.DATE_REQUIRED_DATETIME,
       a.QTY_REQUIRED,
       a.QTY_ISSUED,
       a.QTY_PER_ASSEMBLY,
       a.COMMENTS,
       a.SUPPLY_SUBINVENTORY,
       a.LOCATOR_CODE SUPPLY_LOCATOR,
       a.MRP_NET_FLAG,
       a.QTY_MPS_REQUIRED,
       a.MPS_DATE_REQUIRED_DATE,
       a.QTY_RELIEVED_MATL_COMPLETION,
       a.QTY_RELIEVED_MATL_SCRAP,
       a.ROWID AS A_ROWID,
       b.ROWID AS B_ROWID,
       d.ROWID AS D_ROWID,
       DEP_MAS.ROWID AS DEP_MAS_ROWID,
       PM.ROWID AS PM_ROWID,
       WM.ROWID AS WM_ROWID
  FROM jarosods.MFG_WIPOPREQUIREMENTS_DET a,
       JAROSODS.WIP_ENTITY_MAS B,
       jarosods.lookup_codes_ref d,
       jarosods.DEPARTMENT_MAS DEP_MAS,
       jarosods.PRODUCT_MAS PM,
       jarosods.Warehouse_mas WM
 WHERE     A.WIP_ENTITY_KEY = B.WIP_ENTITY_KEY
       AND A.DEPARTMENT_KEY = DEP_MAS.DEPARTMENT_KEY(+)
       AND D.LOOKUP_CODE(+) = TO_CHAR (A.WIP_SUPPLY_TYPE)
       AND PM.PRODUCT_KEY = A.PRODUCT_KEY
       AND WM.WAREHOUSE_KEY = A.WAREHOUSE_KEY
       AND D.MD_SOURCE_SYSTEM(+) = A.MD_SOURCE_SYSTEM
       AND a.MD_SOURCE_SYSTEM = 1
       AND B.MD_SOURCE_SYSTEM = 1');
END;