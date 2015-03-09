-- This script return summary info on Applimation Archive Cycle records that did not pass edits 
-- This is based on the xa_6015_po_headers_interim Interim table.  You may need to change this based 
-- on the cycle you are running. 

select sum(PO_NOT_CANCEL_OR_FINAL_CLOSED),
  sum(PO_NOT_APPROVED),
  sum(PO_UNPURGABLE_TYPE_LOOKUP_CODE),
  sum(PO_NEWER_PO_LINES),
  sum(PO_NEWER_PO_LINE_LOCATIONS),
  sum(PO_NEWER_PO_DISTRIBUTIONS),
  sum(PO_AP_INVOICE_DIST_EXISTS),
  sum(PO_NEWER_PO_RELEASES),
  sum(PO_NEWER_RCV_TRANSACTIONS),
  sum(PO_EXISTING_MTL_TRANSACTIONS),
  sum(PO_IN_WIP),
  sum(PO_IN_MRP),
  sum(PO_REF_OPEN_REQ),
  sum(PO_REF_SUPPLIER_SCHED),
  sum(PO_MATCH_NONPURGEABLE_REQ),
  sum(PO_EXPECTING_INVOICES),
  sum(PO_NOT_FULLY_RECEIVED),
  sum(EXPIRED_BLA_CON_ACTIVE_RELEASE),
  sum(CANCELLED_BLA_CON_ACTIVE_REL),
  sum(ACTIVE_BPO_WITH_NO_RELEASE)
from xa_6015_po_headers_interim



