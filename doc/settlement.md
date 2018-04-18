# 结算逻辑

|operation|timestamp|status|settlement|
|---|---|---|---|
|create tube|t0|stopped||u
|auto start|t1|running||
|manual stop|t2|stopped|t2-t1|
|manual start|t3|running||
|auto stop|t4|stopped|t4-t3|

启动时检查余额, 设置在最大余额使用到期时检查余额.
关闭时结算余额, 取消之前的余额检查.
每天定时检查余额, 如果余额充足则跳过, 如果余额到期则先关闭tube进行结算.

所有结算发生在tube关闭操作.
