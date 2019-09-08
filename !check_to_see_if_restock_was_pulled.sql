select * from restockrunhistory (nolock) where rundate > '8/23/19'
and parameters like '%3PS20004OT%'


select storeid, shippingboxid, count (*) cartons from orderheader (Nolock) where storeid in ('3PS20004OU','3PS20004QZ','3PS20004OT')
and status not in('rcv','cmp')
group by storeid, shippingboxid
order by storeid

select restockid,
	productid,
	locationid,
	title,
	originalqty,
	'Pulled' = (select max(restockqty) from zrestockhistory zr (nolock) where zr.restockid = z.restockid),
	'Needed' = originalqty -(select max(restockqty) from zrestockhistory zr (nolock) where zr.restockid = z.restockid)
from zrestockhistory z (nolock)
where createdate > '2019-08-24 03:02:46.000' and createdate < '2019-08-24 03:02:47.830'
and restockuserid = 'spRCRrestock3PLZpicks'
and  (select max(restockqty) from zrestockhistory zr (nolock) where zr.restockid = z.restockid) <> originalqty