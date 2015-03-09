
-- This query returns PO Header's with file attachments for org_id 121 
select pha.segment1, fd.category_id
from po_headers_all pha, fnd_attached_documents fad, fnd_documents fd
where pha.po_header_id = fad.pk1_value
and fad.ENTITY_NAME = 'PO_HEADERS'
and fad.document_id = fd.document_id
and fd.datatype_id = 6
and pha.org_id = 121
order by 1 desc

-- This query returns Req Header's with file attachments for org_id 121 
select prha.segment1, fd.category_id
from po_requisition_headers_all prha,fnd_attached_documents fad, fnd_documents fd
where prha.requisition_header_id = fad.pk1_value
and fad.ENTITY_NAME = 'REQ_HEADERS'
and fad.document_id = fd.document_id
and fd.datatype_id = 6
and prha.org_id = 121
order by 1 desc

-- This query returns Req Line's with file attachments for org_id 121 
select prha.segment1, fd.category_id
from po_requisition_headers_all prha, po_requisition_lines_all prla,fnd_attached_documents fad, fnd_documents fd
where prla.requisition_header_id = prha.requisition_header_id
and prla.requisition_line_id = fad.pk1_value
and fad.ENTITY_NAME = 'REQ_LINES'
and fad.document_id = fd.document_id
and fd.datatype_id = 6
and prha.org_id = 121
order by 1 desc


-- This query looks for any Documents that no longer exist in FND_LOBS 
select count(*)
from fnd_documents_tl fdt
where exists ( Select 'Y'
               from fnd_documents fd
               where fdt.document_id = fd.document_id
               and fd.datatype_id = 6
               and not exists (Select 'Y' from fnd_lobs fl
                               where nvl(fdt.media_id,-1) = fl.file_id))
                               --and nvl(fdt.media_id,-1) <> 0;

							  