-- This script counts the current records in Applimation Archive Schema Tables 

select count(*)
from amarchall.fnd_attached_documents

select count(*)
from amarchall.fnd_documents

select count(*)
from amarchall.fnd_documents_long_text

select count(*)
from amarchall.fnd_documents_short_text

select count(*)
from amarchall.fnd_lobs

select count(*)
from amarchall.fnd_documents_tl

select count(*)
from amarchall.po_action_history

select count(*)
from amarchall.po_distributions_all

select count(*)
from amarchall.po_distributions_archive_all

select count(*)
from amarchall.po_headers_all

select count(*)
from amarchall.po_headers_archive_all

select count(*)
from amarchall.po_lines_all

select count(*)
from amarchall.po_lines_archive_all

select count(*)
from amarchall.po_line_LOCATIONs_all

select count(*)
from amarchall.po_line_locations_archive_all

select count(*)
from amarchall.po_releases_all

select count(*)
from amarchall.po_releases_archive_all

select count(*)
from amarchall.po_requisition_headers_all

select count(*)
from amarchall.po_requisition_lines_all

select count(*)
from amarchall.po_req_distributions_all

select count(*)
from amarchall.RCV_RECEIVING_SUB_LEDGER

select count(*)
from amarchall.rcv_shipment_headers

select count(*)
from amarchall.rcv_shipment_lines

select count(*)
from amarchall.rcv_transactions
