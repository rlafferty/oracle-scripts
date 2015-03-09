-- This script returns detailed records that did not pass the Applimation Archive Rules to be eligible to Archive 
-- This is based on the xa_6015_po_headers_interim interim table.  You may need to change it to reflect the current
-- cycle you are executing 

-- Line(s) updated after parameter date 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, pol.line_num, pol.last_update_date "PO LINE LAST UPDATE", pol.cancel_flag, pol.cancel_date, pol.closed_code
from po.po_headers_all poh, po.po_lines_all pol
where poh.po_header_id = pol.po_header_id
and poh.po_header_id IN (SELECT L.po_header_id
					 	 FROM PO.po_lines_all L, xa_6015_po_headers_interim X
						 WHERE X.po_header_id = L.po_header_id 
						 AND TRUNC(L.last_update_date) >to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and pol.po_line_id IN (SELECT L.po_line_id
					 	 FROM PO.po_lines_all L, xa_6015_po_headers_interim X
						 WHERE X.po_header_id = L.po_header_id 
						 AND TRUNC(L.last_update_date) >to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
order by poh.segment1, pol.line_num						 


--Line Location(s) updated after parameter date 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, pol.line_num, pol.last_update_date "PO LINE LAST UPDATE", pol.cancel_flag, pol.cancel_date, pol.closed_code, poll.approved_date "Shipment Approved", poll.last_update_date "Shipment Last Update"
from po.po_headers_all poh, po.po_lines_all pol, po.po_line_locations_all poll
where poh.po_header_id = pol.po_header_id
and pol.po_line_id = poll.po_line_id
and  poh.po_header_id IN (SELECT L.PO_HEADER_ID
	 				  	  FROM PO.po_line_locations_all L, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = L.po_header_id
						  AND TRUNC(L.last_update_date) >to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and  pol.po_line_id IN (SELECT L.PO_LINE_ID
	 				  	  FROM PO.po_line_locations_all L, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = L.po_header_id
						  AND TRUNC(L.last_update_date) >to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and  poll.line_location_id IN (SELECT L.LINE_LOCATION_ID
	 				  	  FROM PO.po_line_locations_all L, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = L.po_header_id
						  AND TRUNC(L.last_update_date) >to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
order by poh.segment1, pol.line_num, poll.approved_date						 

-- Distributions(s) updated after parameter date  
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, pol.line_num, pol.last_update_date "PO LINE LAST UPDATE", pol.cancel_flag, pol.cancel_date, pol.closed_code, poll.approved_date "Shipment Approved", poll.last_update_date "Shipment Last Update", pod.distribution_num, pod.last_update_date "Distribution Last Update"
from po.po_headers_all poh, po.po_lines_all pol, po.po_line_locations_all poll, po.po_distributions_all pod
where poh.po_header_id = pol.po_header_id
and pol.po_line_id = poll.po_line_id
and poll.line_location_id = pod.line_location_id
and  poh.po_header_id IN (SELECT D.po_header_id
	 				  	  FROM PO.po_distributions_all D, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = D.po_header_id
						  AND TRUNC(D.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and  pol.po_line_id IN (SELECT D.po_line_id
	 				  	  FROM PO.po_distributions_all D, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = D.po_header_id
						  AND TRUNC(D.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and  poll.line_location_id IN (SELECT D.line_location_id
	 				  	  FROM PO.po_distributions_all D, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = D.po_header_id
						  AND TRUNC(D.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and  pod.po_distribution_id IN (SELECT D.po_distribution_id
	 				  	  FROM PO.po_distributions_all D, xa_6015_po_headers_interim X
						  WHERE X.po_header_id = D.po_header_id
						  AND TRUNC(D.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
order by poh.segment1, pol.line_num, poll.approved_date, pod.distribution_num						 

-- Blanket Release(s) updated after parameter date or not approved 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, por.release_num, por.last_update_date "PO RELEASE LAST UPDATE", por.RELEASE_DATE, por.approved_flag
from po.po_headers_all poh, po.po_releases_all por
where poh.po_header_id = por.po_header_id
and poh.po_header_id IN (SELECT R.po_header_id
			   	   	 	 FROM PO.po_releases_all R, PO.po_headers_all H, xa_6015_po_headers_interim X
				   		 WHERE X.po_header_id =H.po_header_id
				   		 AND H.type_lookup_code IN ('PLANNED', 'BLANKET')
				   		 AND R.po_header_id = H.po_header_id
				   		 AND TRUNC(R.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and por.po_release_id IN (SELECT R.po_release_id
			   	   	 	 FROM PO.po_releases_all R, PO.po_headers_all H, xa_6015_po_headers_interim X
				   		 WHERE X.po_header_id = H.po_header_id
				   		 AND H.type_lookup_code IN ('PLANNED', 'BLANKET')
				   		 AND R.po_header_id = H.po_header_id
				   		 AND TRUNC(R.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
order by poh.segment1, por.release_num

-- Receipt(s) updated after parameter date  
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, prt.TRANSACTION_TYPE, prt.transaction_date, prt.last_update_date "PO RECEIPT LAST UPDATE"
from po.po_headers_all poh, po.rcv_transactions prt
where poh.po_header_id = prt.po_header_id
and poh.po_header_id IN (SELECT R.po_header_id
			       	 	 FROM PO.rcv_transactions R, xa_6015_po_headers_interim X
				   		 WHERE X.po_header_id = R.po_header_id
				   		 AND trunc(R.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
and prt.TRANSACTION_ID IN (SELECT R.transaction_id
			       	 	 FROM PO.rcv_transactions R, xa_6015_po_headers_interim X
				   		 WHERE X.po_header_id = R.po_header_id
				   		 AND trunc(R.last_update_date) > to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr'))
order by poh.segment1, prt.transaction_date

-- POs not fully received 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, pol.line_num, pol.last_update_date "PO LINE LAST UPDATE", pol.cancel_flag, pol.cancel_date, pol.closed_code, poll.approved_date "Shipment Approved", poll.last_update_date "Shipment Last Update", poll.receipt_required_flag, poll.quantity, poll.quantity_received, poll.quantity - poll.quantity_received "QTY REMAINING"
from po.po_headers_all poh, po.po_lines_all pol, po.po_line_locations_all poll
where poh.po_header_id = pol.po_header_id
and pol.po_line_id = poll.po_line_id
and poh.po_header_id  in (select l.po_header_id  
   				      	  from po.po_line_locations_all l , amagent.XA_6015_PO_HEADERS_INTERIM X
  						  where    l.po_header_id = X.po_header_id    
						  and   l.RECEIPT_REQUIRED_FLAG = 'Y'  
  						  and (trunc(l.NEED_BY_DATE) >  to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr') 
  						  and  l.QUANTITY - l.QUANTITY_RECEIVED <> 0) )
and pol.po_line_id  in (select l.po_line_id  
   				      	  from po.po_line_locations_all l , amagent.XA_6015_PO_HEADERS_INTERIM X
  						  where    l.po_header_id = X.po_header_id    
						  and   l.RECEIPT_REQUIRED_FLAG = 'Y'  
  						  and (trunc(l.NEED_BY_DATE) >  to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr') 
  						  and  l.QUANTITY - l.QUANTITY_RECEIVED <> 0) )
and poll.line_location_id  in (select l.line_location_id  
   				      	  from po.po_line_locations_all l , amagent.XA_6015_PO_HEADERS_INTERIM X
  						  where    l.po_header_id = X.po_header_id    
						  and   l.RECEIPT_REQUIRED_FLAG = 'Y'  
  						  and (trunc(l.NEED_BY_DATE) >  to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr') 
  						  and  l.QUANTITY - l.QUANTITY_RECEIVED <> 0) )
order by poh.segment1, pol.line_num, poll.approved_date						 
				  
-- Expired Blankets and Contracts with Active releases  						  
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, por.release_num, por.authorization_status, por.last_update_date "PO RELEASE LAST UPDATE", por.RELEASE_DATE, por.approved_flag
from po.po_headers_all poh, po.po_releases_all por
where poh.po_header_id = por.po_header_id
and poh.po_header_id in (select distinct (r.po_header_id )
			   	   	 	 from po.po_releases_all r , XA_6015_PO_HEADERS_INTERIM X
				   		 where r.po_header_id  = X.po_header_id 
				   		 and X.type_lookup_code in ('BLANKET', 'CONTRACT')
				   		 and trunc(X.end_date) < to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr') 
				   		 and (trunc(r.last_update_date ) > to_date('31-DEC-'||to_char(trunc(:p_period_to  - 760),'RRRR'),'dd-mon-rrrr')  
				     	  or r.authorization_status <> 'APPROVED'  )) 
and por.po_release_id in (select distinct (r.po_release_id )
			   	   	 	 from po.po_releases_all r , XA_6015_PO_HEADERS_INTERIM X
				   		 where r.po_header_id  = X.po_header_id 
				   		 and X.type_lookup_code in ('BLANKET', 'CONTRACT')
				   		 and trunc(X.end_date ) < to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr') 
				   		 and (trunc(r.last_update_date ) > to_date('31-DEC-'||to_char(trunc(:p_period_to  - 760),'RRRR'),'dd-mon-rrrr')  
				     	  or r.authorization_status <> 'APPROVED'  )) 
order by poh.segment1, por.release_num
						  
-- Active BPO  						  
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, poh.cancel_flag, poh.closed_code
from po.po_headers_all poh, XA_6015_PO_HEADERS_INTERIM xa
where poh.po_header_id = xa.po_header_id
and poh.authorization_status = 'APPROVED'
and poh.type_lookup_code in ('BLANKET', 'CONTRACT')
and poh.po_header_id not in(select po_header_id 
				   	      from XA_6015_PO_HEADERS_INTERIM
						  where authorization_status = 'APPROVED'
						  and type_lookup_code in ('BLANKET', 'CONTRACT')
						  and  trunc(end_date) < to_date(to_char(trunc(:p_period_to  - 760),'DD-MON-RRRR'),'dd-mon-rrrr') 
						  union
						  select po_header_id 
						  from XA_6015_PO_HEADERS_INTERIM
						  where authorization_status = 'APPROVED'
						  and type_lookup_code in ('BLANKET', 'CONTRACT')
						  and cancel_flag  = 'Y' 
						  union
						  select po_header_id 
						  from XA_6015_PO_HEADERS_INTERIM
						  where authorization_status = 'APPROVED'
						  and type_lookup_code in ('BLANKET', 'CONTRACT')
						  and CLOSED_CODE in ('CLOSED','FINALLY CLOSED' ))
order by poh.segment1

-- Requisition(s) not purgeable 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, poh.cancel_flag, poh.closed_code, prh.segment1 "Req Nbr", prh.last_update_date "REQ Last Update"
from po.po_headers_all poh, po.po_requisition_headers_all prh, XA_6015_po_req_match_interim X
where x.purge_requisition_header_id = prh.requisition_header_id
and X.purge_po_header_id = poh.po_header_id
and X.purgeable_flag IS NULL
order by poh.type_lookup_code, poh.segment1

-- PO not approved and Incomplete or Inprocess or Rejected 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, poh.cancel_flag, poh.closed_code
from po.po_headers_all poh, XA_6015_PO_HEADERS_INTERIM xa
where poh.po_header_id = xa.po_header_id
and DECODE(NVL(poh.approved_flag,'N'),'Y',0,DECODE (poh.authorization_status , 'REJECTED',0,'INCOMPLETE',0,'IN PROCESS',0,null,0,'REQUIRES REAPPROVAL',0,1)) <> 0
order by poh.segment1



-- PO not cancelled or closed or Inprocess or Incomplete or Rejected 
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, poh.cancel_flag, poh.closed_code
from po.po_headers_all poh, XA_6015_PO_HEADERS_INTERIM xa
where poh.po_header_id = xa.po_header_id
and DECODE(poh.cancel_flag,'Y',0,DECODE(poh.closed_code,'FINALLY CLOSED',0,'CLOSED',0,decode (poh.authorization_status, 'APPROVED',0,'IN PROCESS',0,'INCOMPLETE',0,'REJECTED',0,'REQUIRES REAPPROVAL',0,null,0,'REQUIRES REAPPROVAL',0,1))) <> 0
order by poh.segment1


-- References contract line that is not purgeable
select poh.segment1 "PO NBR", poh.type_lookup_code, poh.last_update_date "PO LAST UPDATE", poh.authorization_status, poh.approved_flag, pol.line_num, pol.last_update_date "PO LINE LAST UPDATE", pol.cancel_flag, pol.cancel_date, pol.closed_code
from po.po_headers_all poh, po.po_lines_all pol
where poh.po_header_id = pol.po_header_id
and     exists (select null
 	        	from PO.po_lines_all pl
	      		where pl.po_header_id =  poh.po_header_id
	      		and   pl.contract_num is not null
	      		and   not exists 
				(select null
				from  XA_6015_PO_HEADERS_INTERIM phi,
				      PO.po_headers_all ph
                   		where phi.po_header_id = ph.po_header_id
				and   ph.segment1 = pl.contract_num))
--AND poh.purgeable_flag || '' = 'Y'