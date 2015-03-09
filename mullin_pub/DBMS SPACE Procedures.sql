declare
unf number; 
unfb number; 
fs1 number; 
fs1b number; 
fs2 number; 
fs2b number; 
fs3 number; 
fs3b number; 
fs4 number; 
fs4b number; 
full number; 
fullb number; 
--
cursor get_segs is
select owner, segment_name seg, decode(segment_type,'LOBINDEX','INDEX',decode(segment_type,'LOBSEGMENT','LOB',segment_type)) seg_type
from dba_segments
where tablespace_name = 'GECUST';
--
begin
dbms_output.enable(2000000);
for recs in get_segs loop
dbms_space.space_usage(recs.owner, recs.seg, 
                        recs.seg_type, 
                        unf, unfb, 
                        fs1, fs1b, 
                        fs2, fs2b, 
                        fs3, fs3b, 
                        fs4, fs4b, 
                        full, fullb); 
--
dbms_output.put_line('Owner: '||recs.owner);
dbms_output.put_line('Segment Name: '||recs.seg);
dbms_output.put_line('Segment Type: '||recs.seg_type);
dbms_output.put_line('Unformated Blocks: '||unf) ; 
dbms_output.put_line('Unformated Bytes: '||unfb); 
dbms_output.put_line('Number of blocks that has at least 0 to 25% free space: '||fs1); 
dbms_output.put_line('Number of bytes that has at least 0 to 25% free space: '||fs1b); 
dbms_output.put_line('Number of blocks that has at least 25 to 50% free space: '||fs2); 
dbms_output.put_line('Number of bytes that has at least 25 to 50% free space: '||fs2b); 
dbms_output.put_line('Number of blocks that has at least 50 to 75% free space: '||fs3); 
dbms_output.put_line('Number of bytes that has at least 50 to 75% free space: '||fs3b); 
dbms_output.put_line('Number of blocks that has at least 75 to 100% free space: '||fs4); 
dbms_output.put_line('Number of bytes that has at least 75 to 100% free space: '||fs4b); 
dbms_output.put_line('Total number of blocks that are full in the segment: '||full); 
dbms_output.put_line('Total number of bytes that are full in the segment: '||fullb);
dbms_output.put_line(' ');
end loop;
end;
 

DECLARE
total_blocks 				number;
total_bytes	 				number;
unused_blocks				number;
unused_bytes				number;   
last_used_extent_file_id	number;
last_used_extent_block_id	number;   
last_used_block				number;
--
cursor get_segs is
select owner, segment_name seg, decode(segment_type,'LOBINDEX','INDEX',decode(segment_type,'LOBSEGMENT','LOB',segment_type)) seg_type
from dba_segments
where tablespace_name = 'LOBD';
--
begin
dbms_output.enable(2000000);
for recs in get_segs loop
dbms_space.unused_space(recs.owner,recs.seg, 
                        recs.seg_type,   total_blocks,
   						total_bytes,   unused_blocks,
   						unused_bytes,   last_used_extent_file_id,
   						last_used_extent_block_id,   last_used_block); 
--
dbms_output.put_line('Owner: '||recs.owner);
dbms_output.put_line('Segment Name: '||recs.seg);
dbms_output.put_line('Segment Type: '||recs.seg_type);
dbms_output.put_line('Total Blocks: '||total_blocks);
dbms_output.put_line('Total Bytes: '||total_bytes);
dbms_output.put_line('Unused Blocks: '||unused_blocks);
dbms_output.put_line('Unused Bytes: '||unused_bytes);
dbms_output.put_line('Last Used Extent File ID: '||last_used_extent_file_id);
dbms_output.put_line('Last Used Extent Block ID: '||last_used_extent_block_id);
dbms_output.put_line('Last Used Block: '||last_used_block);
dbms_output.put_line(' ');
end loop;
end;