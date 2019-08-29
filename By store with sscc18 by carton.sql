select oh.storeid,
	p.upc,
	p.ean,
	p.title,
	oh.orderreferencenumber,
	sum (od.orderqty) OnOrder,
	sum (od.pickqty) Picked,
	oh.shippingcartonid,
	oa.manualvalue,
	pd.palletid
from orderheader oh(Nolock)
	join orderheaderattribute oa (Nolock) on oh.orderid = oa.orderid
	join orderdetail od (nolock) on oh.orderid = od.orderid
	join product p (nolock) on od.productid = p.productid
	join palletdetail pd (Nolock) on oh.shippingcartonid = pd.shippingcartonid
where oh.storeid = 'BT19002732'
and oa.attribute = 'ccid'
group by oh.storeid,
	p.upc,
	p.ean,
	p.title,
	oh.orderreferencenumber,
	oh.shippingcartonid,
	oa.manualvalue,
	pd.palletid