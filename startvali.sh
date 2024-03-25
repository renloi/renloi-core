renloi \
    --datadir ./chaindata/node1 \
    --networkid 268 \
    --mine \
    --port 32669 \
    --nat extip:127.0.0.1 \
    --gpo.percentile 0 \
    --gpo.maxprice 100 \
    --gpo.ignoreprice 0 \
    --unlock 0 \
    --password ./chaindata/node1/pass.txt \
    --syncmode=full \
    --snapshot=false \
    console
