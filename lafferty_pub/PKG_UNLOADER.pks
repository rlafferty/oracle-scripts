create or replace package gets_dw_sas.pkg_unloader as

    procedure dump_data (
        p_query in varchar2,
        p_directory in varchar2 default 'UTF8_DIR',  /* default directory for data pump in oracle 10g */
        p_file_name in varchar2    default 'sample.dat',
        p_delimited in varchar2 default '|',
        p_status   out number );
    
end pkg_unloader;    
/
create or replace package body gets_dw_sas.pkg_unloader as

        procedure dump_data (
            p_query in varchar2,
            p_directory in varchar2 default 'UTF8_DIR',
            p_file_name in varchar2 default 'sample.dat',
            p_delimited in varchar2 default '|',
            p_status   out number )        /* 0 - Sucess / other than 0 is error */ 
        as
            l_exec_status number;
            l_file_handle utl_file.file_type;
            l_desc_tab    dbms_sql.desc_tab;
            l_column_count number ;
            l_line varchar2(32760) := null;
            l_column_value varchar2(4000);            
            g_cursor number := dbms_sql.open_cursor;
            l_nls_values nls_database_parameters.value%type;
        begin
            p_status := 0;
            select value
            into l_nls_values
            from nls_database_parameters
            where parameter = 'NLS_DATE_FORMAT';
            
            execute immediate ' alter session set nls_date_format = ''ddmmyyyyhh24miss'' ';
            
            l_file_handle := utl_file.fopen (p_directory,p_file_name,'w',32760);
            
            dbms_sql.parse(g_cursor,p_query,dbms_sql.native);
            dbms_sql.describe_columns (g_cursor,l_column_count,l_desc_tab);
            
            for i in 1..l_column_count
            loop
                dbms_sql.define_column (g_cursor,i,l_column_value,4000);
            end loop;
            
            l_exec_status := dbms_sql.execute(g_cursor);
            
            while ( dbms_sql.fetch_rows(g_cursor) > 0 )
            loop
                l_line := null;
                for i in 1..l_column_count
                loop
                    dbms_sql.column_value(g_cursor,i,l_column_value);
                    l_line := l_line ||p_delimited||l_column_value;
                end loop;
                l_line := l_line || chr(13) || chr(10); /* line  terminator in windows */
                utl_file.put(l_file_handle,l_line);
            end loop;
            
            utl_file.fclose(l_file_handle);
            
            execute immediate ' alter session set nls_date_format = '''|| l_nls_values ||'''';
            
        exception
            when others then
                if dbms_sql.is_open(g_cursor) then
                    dbms_sql.close_cursor(g_cursor);
                end if;
                
                if utl_file.is_open (l_file_handle) then
                    utl_file.fclose(l_file_handle);
                end if;
                p_status := sqlcode;
                raise_application_error ( -20458,sqlerrm);
        end dump_data;
end pkg_unloader;
/

