select 	 p.productid,
	p.ean,
	p.title,
	p.cartonqty,
	sum (orderqty)onOrder,
	'#SPpcs' = isnull((select unitqty from stock (nolock) where locationid like '#SP%' and productid = p.productid),0),
  'P_Bin' = (select locationid from location (nolock) where locationid like 'pn%' and productid = p.productid),
  'P_BinPcs' = isnull((select unitqty from stock (nolock) where locationid like 'pn%' and productid = p.productid),0),
  'ECBin' = (select locationid from location (nolock) where locationid like 'ec%' and productid = p.productid),
  'EcBinPcs' = isnull((select unitqty from stock (nolock) where locationid like 'ec%' and productid = p.productid),0),
	'EC Owned' = (select sum(availableqty+onorderqty) from stocksummary (nolock) where productid = p.productid and companyid like 'ec%'),
  'MZ' = (select Top 1 (locationid) from location  (nolock) where locationid like 'm%' and productid = p.productid),
  'MZ locations' = (select count(locationid) from location  (nolock) where locationid like 'm%' and productid = p.productid),
  'MZ Cartons' = isnull((select sum(cartonqty) from stock  (nolock) where locationid like 'm%' and productid = p.productid),0),	
  'MZ pcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like 'm%' and productid = p.productid),0),
  'X2Ovr' = (select Top 1 (locationid) from location  (nolock) where locationid like '2%' and productid = p.productid),
  'X2OvrPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '2%' and productid = p.productid),0),
  'NBOvr' = (select Top 1 (locationid) from location  (nolock) where locationid like 'n%' and productid = p.productid),
  'NBOvrPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like 'n%' and productid = p.productid),0),
  'FTOvr' = (select Top 1 (locationid) from location  (nolock) where locationid like 's3%' and productid = p.productid),
  'FTOvrPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like 's3%' and productid = p.productid),0),
  '#rc2Pcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '#rc2%' and productid = p.productid),0),
  '#rcnPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '#rcn%' and productid = p.productid),0),
  '#3pPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '#3p%' and productid = p.productid),0),
  '#EcomPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '#ecom%' and productid = p.productid),0),
  '#do pcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '#do%' and productid = p.productid),0),
  '#tr pcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like '#tr%' and productid = p.productid),0),
  'BbPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like 'BB%' and productid = p.productid),0),
  'BbPcs' = isnull((select sum(unitqty) from stock  (nolock) where locationid like 'TAB%' and productid = p.productid),0),
  'NB' = (isnull((select unitqty from stock (nolock) where locationid like 'p%' and productid = p.productid),0)
	  +isnull((select sum(unitqty) from stock  (nolock) where locationid like 'n%' and productid = p.productid),0),
	  +isnull((select sum(unitqty) from stock  (nolock) where locationid like '#sp%' and productid = p.productid),0)
	  +isnull((select sum(unitqty) from stock  (nolock) where locationid like '#rcn%' and productid = p.productid),0)),
  'pcsNeeded' = (sum(od.orderqty))
    -isnull((select unitqty from stock (nolock) where locationid like 'p%' and productid = p.productid),0)
    -isnull((select SUM (unitqty) from stock (nolock) where locationid like '#3p%' and productid = p.productid ),0)
    -isnull((select SUM (unitqty) from stock (nolock) where locationid like 'n%' and productid = p.productid ),0)
    -isnull((select SUM (unitqty) from stock (nolock) where locationid like '#sp%' and productid = p.productid ),0)
    -isnull((select SUM (unitqty) from stock (nolock) where locationid like 's%' and productid = p.productid ),0)
    -isnull((select SUM (unitqty) from stock (nolock) where locationid like 'BB%' and productid = p.productid ),0)
   - isnull((select sum(unitqty) from stock  (nolock) where locationid like '#do%' and productid = p.productid),0)
   - isnull((select sum(unitqty) from stock  (nolock) where locationid like '#tr%' and productid = p.productid),0)
    -isnull((select SUM (unitqty) from stock (nolock) where locationid like '#rcn%' and productid = p.productid ),0)
from orderdetail od (nolock) 
	join orderheader oh (nolock) on od.orderid = oh.orderid
	join product p (nolock) on od.productid = p.productid
where (storeid like 'bt%' or storeid like '3%')
and  storeid not  in ('BT20000384','BT20000385') 
and oh.status  in ('ord','tub','opn')

group by   p.productid,
	p.ean,
	p.title,
	p.cartonqty
having  (sum(od.orderqty)
  -isnull((select unitqty from stock (nolock) where locationid like 'p%' and productid = p.productid),0)
  -isnull((select SUM (unitqty) from stock (nolock) where locationid like '#3p%' and productid = p.productid ),0)
  -isnull((select SUM (unitqty) from stock (nolock) where locationid like 'n%' and productid = p.productid ),0)
  -isnull((select SUM (unitqty) from stock (nolock) where locationid like 's%' and productid = p.productid ),0)
  -isnull((select SUM (unitqty) from stock (nolock) where locationid like 'BB%' and productid = p.productid ),0)
  -isnull((select sum(unitqty) from stock  (nolock) where locationid like '#do%' and productid = p.productid),0)
  -isnull((select sum(unitqty) from stock  (nolock) where locationid like '#tr%' and productid = p.productid),0)
	-isnull((select sum (unitqty) from stock (nolock) where locationid like '#rcn%' and productid = p.productid),0))>0	


