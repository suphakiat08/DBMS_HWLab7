DROP TRIGGER IF EXISTS auction_operation;

DELIMITER $$
CREATE TRIGGER auction_operation
  AFTER INSERT ON Auction_Log
  FOR EACH ROW
BEGIN
  IF(New.Action = "create") THEN
    INSERT INTO Auction(AUC_ID, PROD_ID, Bid) 
    VALUES(New.AUC_ID, New.PROD_ID, New.Bid);
    
  ELSEIF(New.Action = "delete") THEN
    DELETE FROM Auction WHERE AUC_ID=New.AUC_ID;
    
  ELSEIF(New.Action = "update") THEN 
    SELECT Bid INTO @OLD_Bid 
    FROM Auction WHERE AUC_ID=New.AUC_ID;
 
    IF(New.Bid > @OLD_Bid) THEN
      UPDATE Auction SET Bid=New.Bid WHERE AUC_ID=New.AUC_ID;
    END IF;

  END IF;
END $$


DELIMITER ;
