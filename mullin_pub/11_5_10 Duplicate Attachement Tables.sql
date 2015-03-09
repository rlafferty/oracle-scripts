-- This creates the GEDBA_DUPL_LOBS table to store the duplicate Attachments from the Requisition to PO Process
-- The data reflects all Duplicates from Req to PO up to April 9, 2007 
-- Took approx 20 mins to execute and requires 50MB of storage 
create table GEDBA_DUPL_LOBS
as select rha.requisition_header_id, 
      fdt.document_id req_doc_id,
      fdt2.document_id pol_doc_id,
      fl.file_name req_file_name,
      fdt.media_id req_media_id,
      fdt2.media_id pol_media_id,
      fd.usage_type req_usage_type,
      fad.attached_document_id req_fad_att_doc_id,
      fad.entity_name req_entity_name,
      rla.requisition_line_id, poh.type_lookup_code, poh.po_header_id, pol.po_line_id, plla.line_location_id, plla.po_release_id,
      fdt2.description pol_doc_desc, 
      fl2.file_name pol_file_name,
      fad2.attached_document_id pol_fad_att_doc_id,
      fad2.entity_name pol_entity_name,
      fdt.program_update_date req_prg_update,
      fdt2.program_update_date po_prg_update
from fnd_attached_documents fad,
	 fnd_documents fd,
	 fnd_documents_tl fdt,
	 fnd_lobs fl,
	 po_requisition_headers_all rha,
	 po_requisition_lines_all rla,
	 po_line_locations_all plla,
	 po_lines_all pol,
	 po_headers_all poh,
	 fnd_attached_documents fad2,
	 fnd_documents fd2,
	 fnd_documents_tl fdt2,
	 fnd_lobs fl2
where fad.entity_name = 'REQ_HEADERS'
and fad.document_id = fd.document_id
and fd.document_id = fdt.document_id
and fdt.media_id = fl.file_id
and fdt.language = 'US'
and fd.datatype_id = 6
and fad.pk1_value = to_char(rha.requisition_header_id)
and rha.requisition_header_id = rla.requisition_header_id
and rla.line_location_id = plla.line_location_id
and plla.po_line_id = pol.po_line_id
and pol.po_header_id = poh.po_header_id
and rha.org_id = poh.org_id
and to_char(pol.po_line_id) = fad2.pk1_value  
and fad2.entity_name = 'PO_LINES'
and fad2.document_id = fd2.document_id
and fd2.document_id = fdt2.document_id
and fdt2.media_id = fl2.file_id
and fdt2.language = 'US'
and fd2.datatype_id = 6
and fl.file_name = fl2.file_name
and fad.document_id <> fad2.document_id
and fl.file_id <> fl2.file_id 
and fdt2.program_update_date is not null;

-- This creates the GEDBA_DUPL_SHIP_LOBS table to store the duplicate Attachments from the Blanket to Release Process
-- The data reflects all Duplicates from Req to PO up to April 9, 2007 
-- Took approx 2 mins to execute and requires approx 10MB of storage 
create table gedba_dupl_ship_lobs
as select rha.requisition_header_id, 
      fdt.document_id req_doc_id,
   	  fdt2.document_id pol_doc_id,
      fl.file_name req_file_name,
      fdt.media_id req_media_id,
	  fdt2.media_id pol_media_id,
      fd.usage_type req_usage_type,
      fad.attached_document_id req_fad_att_doc_id,
      fad.entity_name req_entity_name,
      rla.requisition_line_id, poh.type_lookup_code, poh.po_header_id,  plla.line_location_id, plla.po_release_id, pla.release_num,
      fdt2.description pol_doc_desc, 
      fl2.file_name pol_file_name,
      fad2.attached_document_id pol_fad_att_doc_id,
      fad2.entity_name pol_entity_name,
      fdt.program_update_date req_prg_update,
      fdt2.program_update_date po_prg_update
from fnd_attached_documents fad,
	 fnd_documents fd,
	 fnd_documents_tl fdt,
	 fnd_lobs fl,
	 po_requisition_headers_all rha,
	 po_requisition_lines_all rla,
	 po_line_locations_all plla,
	 po_headers_all poh,
         po_releases_all pla,
	 fnd_attached_documents fad2,
	 fnd_documents fd2,
	 fnd_documents_tl fdt2,
	 fnd_lobs fl2
where fad.entity_name = 'REQ_HEADERS'
and fad.document_id = fd.document_id
and fd.document_id = fdt.document_id
and fdt.media_id = fl.file_id
and fdt.language = 'US'
and fd.datatype_id = 6
and fad.pk1_value = to_char(rha.requisition_header_id)
and rha.requisition_header_id = rla.requisition_header_id
and rla.line_location_id = plla.line_location_id
and plla.po_header_id = poh.po_header_id
and rha.org_id = poh.org_id
and pla.po_release_id = plla.po_release_id
and to_char(plla.line_location_id) = fad2.pk1_value  
and fad2.entity_name = 'PO_SHIPMENTS'
and fad2.document_id = fd2.document_id
and fd2.document_id = fdt2.document_id
and fdt2.media_id = fl2.file_id
and fdt2.language = 'US'
and fd2.datatype_id = 6
and fl.file_name = fl2.file_name
and fad.document_id <> fad2.document_id
and fl.file_id <> fl2.file_id
and fdt2.program_update_date is not null;
