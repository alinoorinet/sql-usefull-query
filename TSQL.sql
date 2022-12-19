SELECT 
	u.std_no,u.username,w.amount as 'wallet(R)'
FROM 
	wallet w
INNER JOIN users u ON u.id = w.user_id
WHERE 
    w.id IN (SELECT 
            MAX(id)
        FROM
            wallet
        GROUP BY user_id)
