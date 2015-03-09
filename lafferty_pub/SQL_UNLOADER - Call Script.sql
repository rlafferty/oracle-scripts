     SET LINESIZE 150;
      SET SERVEROUTPUT on SIZE 1000000 FORMAT WRAPPED;
      --
      declare
        --
        l_rows    number;
        --
        begin
          l_rows := gets_dw_sas.unloader.run
                    ( p_cols       => '*',
                      p_town       => 'GETS_DW_SAS',
                      p_tname      => 'GETS_SVC_RX_WO_MV',
                      p_mode       => 'replace',
                      p_dbdir      => 'UTF8_DIR',
                      p_filename   => 'GETS_SVC_RX_WO_MV',
                      p_separator  => '|',
                      p_enclosure  => '',
                      p_terminator => '|',
                      p_ctl        => 'YES',
                      p_header     => 'YES' );
        --
        dbms_output.put_line( to_char(l_rows) ||
                              ' rows extracted to ascii file' );
        --
      end;
      /



# tar -cvzf  RELDAT_CCD_MAIN_BNSF.tar.gz RELDAT_CCD_MAIN_BNSF*