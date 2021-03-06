WITH dependencies
     AS (                                    -- top down through the heirarchy
         SELECT /*+ no_merge */
               referenced_type AS parent_type,
                    referenced_owner AS parent_schema,
                    referenced_name AS parent_object,
                    TYPE AS child_type,
                    owner AS child_schema,
                    name AS child_object,
                    connect_by_root referenced_name as ROOT,
                    LEVEL hlevel
               FROM dba_dependencies
         START WITH referenced_owner || '.' || referenced_name IN
                       (SELECT DISTINCT 'JAROSODS.' || tgt.TABLE_NAME
                          FROM GET_UTIL.R12_OBJECT_CHANGE_TRACKER chg,
                               JAROSCONNECT.MD_SOURCE_TABLES@ERP src,
                               JAROSCONNECT.MD_TARGET_TABLES@ERP tgt
                         WHERE     tgt.TABLE_KEY = src.TABLE_KEY
                               AND src.SOURCE_TABLE_NAME = CHG.TABLE_NAME)
         CONNECT BY     referenced_owner = PRIOR owner
                    AND referenced_name = PRIOR name
                    AND referenced_type = PRIOR TYPE
         UNION
             -- bottom up through the heirarchy
             SELECT /*+ no_merge */
                   referenced_type AS parent_type,
                    referenced_owner AS parent_schema,
                    referenced_name AS parent_object,
                    TYPE AS child_type,
                    owner AS child_schema,
                    name AS child_object,
                    ' ' as ROOT,
                    LEVEL hlevel
               FROM dba_dependencies
         START WITH owner || '.' || name IN
                       (SELECT DISTINCT 'JAROSODS.' || tgt.TABLE_NAME
                          FROM GET_UTIL.R12_OBJECT_CHANGE_TRACKER chg,
                               JAROSCONNECT.MD_SOURCE_TABLES@ERP src,
                               JAROSCONNECT.MD_TARGET_TABLES@ERP tgt
                         WHERE     tgt.TABLE_KEY = src.TABLE_KEY
                               AND src.SOURCE_TABLE_NAME = CHG.TABLE_NAME)
         CONNECT BY     owner = PRIOR referenced_owner
                    AND name = PRIOR referenced_name
                    AND TYPE = PRIOR referenced_type
         ORDER BY 1, 2)
  SELECT d.hlevel AS DEPENDENCY_LEVEL,
         d.parent_type,
         d.parent_schema,
         d.parent_object,
         d.child_type,
         d.child_schema,
         d.child_object,
         o.last_ddl_time,
         d.ROOT,
         CASE WHEN d.hlevel = 1 THEN 'ROOT LEVEL' ELSE NULL END AS IS_ROOT
    FROM dependencies d, dba_objects o
   WHERE     o.owner = d.child_schema
         AND o.object_type = d.child_type
         AND d.child_object = o.object_name
ORDER BY 1,3,4 ASC
/