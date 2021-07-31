delete from [WarehouseVision].[dbo].[WV_LOG_FILE] where wvform = 'importing processing' and  wvline =12
insert into [WarehouseVision].[dbo].[WV_LOG_FILE] (siteno,wvform,wvline,wvstack,wvERROR,wvdate,wvlog_id)
values ('MONITOR','importing processing',12,'1','start',GETDATE(),'Monitor')

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set cubic_code = cartonnumber
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD], [WarehouseVision].[dbo].[CartonRules]
where (CtnWidth = loc_width) and
(SUBSTRING(cubic_code,1,2)= CartonNumber)
and (LEN(cubic_code) = 4)

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set cubic_code = cartonnumber
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD], [WarehouseVision].[dbo].[CartonRules]
where (CtnWidth = loc_width) and
(SUBSTRING(cubic_code,3,2)= CartonNumber)
and (LEN(cubic_code) = 4)


update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set cubic_code = cartonnumber
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD], [WarehouseVision].[dbo].[CartonRules]
where (CtnWidth = loc_width) and (Ctnheight = loc_height)
and ((cubic_code) = '9999')

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set location_no = SUBSTRING(location_no,1,8) + ((SUBSTRING(location_no,6,2) + ((loc_height +1)*(seq_value -1)) )*10)
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
WHERE multi_level >1 and seq_value >1

update msc_location_build
set row = ceiling((SUBSTRING(location_no,4,2)/2)+.11)-3,
SIDE = SUBSTRING(location_no,1,1) + case when SUBSTRING(location_no,4,2)<50 then 'LOW' else 'HIGH' end,
activity = STOCKING_LEVELS.activity, USPD = STOCKING_LEVELS.uspd,
workindex =
case when SUBSTRING(location_no,4,2)<50 then
(ceiling((SUBSTRING(location_no,4,2)/2)+.11) - 3) * (36*2) + abs(SUBSTRING(location_no,6,2) - 40)
else
(ceiling((SUBSTRING(location_no,4,2)-43/2)+.11) - 3) * (36*2) + abs(SUBSTRING(location_no,6,2) - 40)
end
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
left join [WarehouseVision].[dbo].[STOCKING_LEVELS] on (STOCKING_LEVELS.Siteno = msc_location_build.Siteno) and (STOCKING_LEVELS.item = msc_location_build.sku)


update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set activity = 0
where activity is null

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set uspd = 0
where uspd is null

 


 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set Capacity = LOC_CAPCTY
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
inner join  [WarehouseVision].[dbo].[IMPORT_108_WMS_ATTRIBUTES] on IMPORT_108_WMS_ATTRIBUTES.SiteNO = MSC_LOCATION_BUILD.Siteno
and  IMPORT_108_WMS_ATTRIBUTES.sku = MSC_LOCATION_BUILD.sku
and  IMPORT_108_WMS_ATTRIBUTES.bin_loc = MSC_LOCATION_BUILD.LOCATION_NO
and IMPORT_108_WMS_ATTRIBUTES.Siteno = MSC_LOCATION_BUILD.siteno

  
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1  where substring(location_no,4,2) = '03' and substring(location_no,1,1) >='1'   ---------Not sure what this statement is doing
and substring(location_no,1,1) <='3' and siteno <> 'ATL'


 

 

/*** ATL ***/
/*** ATL ***/
/*** ATL ***/
/*** ATL ***/

 
 
/****
Old Section: Aisles 27 to 61
Low side: Facing 03 to 28 no end cap                                           --------------There are endcaps present 02 & 32
High side: Facing 33 to 55 no end cap 
****/

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set row = ceiling((SUBSTRING(location_no,4,2)/2))-0,
SIDE = SUBSTRING(location_no,1,1) + case when SUBSTRING(location_no,4,2)<32 then 'LOW' else 'HIGH' end,
activity = [WarehouseVision].[dbo].[STOCKING_LEVELS].activity, USPD = [WarehouseVision].[dbo].[STOCKING_LEVELS].uspd,
workindex = --work index is the total distance from the conveyor belt to the item and back. this includes getting a ladder and putting it back if needed (ladder is arbitrary 100 right now)
case when SUBSTRING(location_no,4,2)<29 then
(ceiling((CAST(RIGHT(LEFT(location_no,5),2) AS int) / 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
else
(ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int) -32) / 2.0))) * (36*2) +
--(ceiling(((SUBSTRING(location_no,4,2)-32)/2)) - 0) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
end
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
left join [WarehouseVision].[dbo].[STOCKING_LEVELS] on ([WarehouseVision].[dbo].[STOCKING_LEVELS].Siteno = msc_location_build.Siteno) and ([WarehouseVision].[dbo].[STOCKING_LEVELS].item = msc_location_build.sku)
where msc_location_build.siteno = 'ATL'
and SUBSTRING(location_no,2,2) <='61' 
and (SUBSTRING(location_no,1,1) ='1' or SUBSTRING(location_no,1,1) ='2' or SUBSTRING(location_no,1,1) ='3')

 
--ATL: 3rd floor bins aisle 27 low number side?

 
/****
New Section Aisles 62 and above
Low side: Facing 02 (end cap) to 30
High side: Facing 50 (end cap) to 80 
****/

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set row = ceiling((SUBSTRING(location_no,4,2)/2)+.11)-0,
SIDE = SUBSTRING(location_no,1,1) + case when SUBSTRING(location_no,4,2)<49 then 'LOW' else 'HIGH' end,
activity = STOCKING_LEVELS.activity, USPD = STOCKING_LEVELS.uspd,
workindex =
case when SUBSTRING(location_no,4,2)<51 then
(ceiling((CAST(RIGHT(LEFT(location_no,5),2) AS int) / 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
              else

(ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int) -50) / 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
end
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
left join [WarehouseVision].[dbo].[STOCKING_LEVELS] on (STOCKING_LEVELS.Siteno = msc_location_build.Siteno) and (STOCKING_LEVELS.item = msc_location_build.sku)
where msc_location_build.siteno = 'ATL'
and SUBSTRING(location_no,2,2) >='62'
and (SUBSTRING(location_no,1,1) ='1' or SUBSTRING(location_no,1,1) ='2' or SUBSTRING(location_no,1,1) ='3')

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set workindex = 36
WHERE ((
SUBSTRING(location_no,2,2) <='61' and ((side = '1high') or (side = '1LOW') or (side = '2high') or (side = '2LOW') or (side ='3high') or (side = '3LOW'))
and ((substring(location_no,4,2) = '02') or (substring(location_no,4,2) = '32')) --------------------------------------------------------- Setting these as 01 and 31 to reflect ATL Endcap shelves
)
OR (
SUBSTRING(location_no,2,2) >='62' and ((side = '1high') or (side = '1LOW') or (side = '2high') or (side = '2LOW') or (side ='3high') or (side = '3LOW'))
and ((substring(location_no,4,2) = '02') or (substring(location_no,4,2) = '50')) --------------------------------------------------------- Setting these as 01 and 31 to reflect ATL Endcaps shelves
))
AND siteno = 'ATL'

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1  where substring(location_no,4,2) = '01' and substring(location_no,1,1) >='1'   ---------Not sure what this statement is doing
and substring(location_no,1,1) <='3' and siteno = 'ATL'

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1  where substring(location_no,4,2) = '31' and substring(location_no,1,1) >='1'   ---------Not sure what this statement is doing
and substring(location_no,1,1) <='3' and siteno = 'ATL'
 

--individual exception locations:

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 56 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

where substring(location_no,2,2) = '26' and substring(location_no,1,1) >='1'
and substring(location_no,1,1) <='3' and siteno = 'ATL' 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 72 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

where substring(location_no,4,2) = '32' and substring(location_no,1,1) >='1'
and substring(location_no,1,1) <='3' and siteno = 'ATL'



update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1536 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
where substring(location_no,2,2) = '27' and substring(location_no,4,2) = '55'
and substring(location_no,1,1) = '3' and siteno = 'ATL'



update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1728 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

where substring(location_no,2,2) = '27' and substring(location_no,4,2) = '57'
and substring(location_no,1,1) = '3' and siteno = 'ATL'

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1920 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
              
where substring(location_no,2,2) = '27' and substring(location_no,4,2) = '59'
and substring(location_no,1,1) = '3' and siteno = 'ATL'

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 2112 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

where substring(location_no,2,2) = '27' and substring(location_no,4,2) = '61'
and substring(location_no,1,1) = '3' and siteno = 'ATL'

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 2304 +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

where substring(location_no,2,2) = '27' and substring(location_no,4,2) = '63'
and substring(location_no,1,1) = '3' and siteno = 'ATL'

 

update Location_Definitions set Work_Value = workindex
from [WarehouseVision].[dbo].[Location_Definitions]
inner join [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] on MSC_LOCATION_BUILD.siteno = Location_Definitions.siteno
and MSC_LOCATION_BUILD.LOCATION_NO = Location_Definitions.LOCATION_NO

 

 

--issue with location in new section for aisles 62, 63, 64. same end bin labeled as bins 25-30

 
 

/*** ELK ***/
/*** ELK ***/
/*** ELK ***/
/*** ELK ***/


--high side: bins 47-77
--low side: bins 03-37

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set row = ceiling((SUBSTRING(location_no,4,2)/2))-0,
SIDE = SUBSTRING(location_no,1,1) + case when SUBSTRING(location_no,4,2)<47 then 'LOW' else 'HIGH' end,
activity = [WarehouseVision].[dbo].[STOCKING_LEVELS].activity, USPD = [WarehouseVision].[dbo].[STOCKING_LEVELS].uspd,
workindex =
case when SUBSTRING(location_no,4,2)<47 then
(ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int)-6)/ 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

              + CASE WHEN ((SUBSTRING(location_no,4,2)='37') or (SUBSTRING(location_no,4,2)='36')) THEN 228 ELSE
              CASE WHEN ((SUBSTRING(location_no,4,2)<='35') and (SUBSTRING(location_no,4,2)>='19')) THEN 108 ELSE
              CASE WHEN ((SUBSTRING(location_no,4,2)<'78') and (SUBSTRING(location_no,4,2)>'62')) THEN 108 ELSE 0 END END END
              
else
(ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int) -49) / 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 

              + CASE WHEN ((SUBSTRING(location_no,4,2)='37') or (SUBSTRING(location_no,4,2)='36')) THEN 228 ELSE
              CASE WHEN ((SUBSTRING(location_no,4,2)<='35') and (SUBSTRING(location_no,4,2)>='19')) THEN 108 ELSE
              CASE WHEN ((SUBSTRING(location_no,4,2)<'78') and (SUBSTRING(location_no,4,2)>'62')) THEN 108 ELSE 0 END END END
end
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
left join [WarehouseVision].[dbo].[STOCKING_LEVELS] on ([WarehouseVision].[dbo].[STOCKING_LEVELS].Siteno = msc_location_build.Siteno) and ([WarehouseVision].[dbo].[STOCKING_LEVELS].item = msc_location_build.sku)
where msc_location_build.siteno = 'ELK'
  and (SUBSTRING(location_no,1,1) ='1' or SUBSTRING(location_no,1,1) ='2' or SUBSTRING(location_no,1,1) ='3')

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1  where substring(location_no,4,2) = '03' and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'ELK'

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 1  where substring(location_no,4,2) = '47' and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'ELK'

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 36  where (substring(location_no,4,2) = '05' or substring(location_no,4,2) = '49') and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'ELK'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END


update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 36  where (substring(location_no,2,2) = '26' or substring(location_no,2,2) = '27') and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='2' and siteno = 'ELK'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 36  where (substring(location_no,2,2) = '66' or substring(location_no,2,2) = '67')  
and substring(location_no,1,1) ='3' and siteno = 'ELK'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
 

update Location_Definitions set Work_Value = workindex
from [WarehouseVision].[dbo].[Location_Definitions]
inner join [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] on MSC_LOCATION_BUILD.siteno = Location_Definitions.siteno
and MSC_LOCATION_BUILD.LOCATION_NO = Location_Definitions.LOCATION_NO

 

 
--notes
--bin 36 in aisle 30, 34, 36, 37, 41
--bin #35 locations only exist in these aisles as well
--location 1-45-37, 1-45-36 supposed to be where it is?
--location 1-58-37, 1-58-36 supposed to have different y coordinate than those around it?
--only some end locations have a 37 associated with it
--why are ELK-1-66-50, ELK-1-66-51 in random locations?
--what should work index be for aisles 26 and 27 on floors 1 and 2, and aisles 66 and 67 on floor 3
--second floor: why is 6-04-05 located on this level
--no bin 35 locations on second floor
--floor 3: aisles 66 and 67 are same as 26 and 27?
--end cap locations are switched: low numbered end cap is on high number side and vice versa

 
 

/*** CMB ***/
/*** CMB ***/
/*** CMB ***/
/*** CMB ***/

 

 

--high side: bins 24-34
--low side: bins 04-14

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] --
set row = ceiling((SUBSTRING(location_no,4,2)/2))-0, --
SIDE = SUBSTRING(location_no,1,1) + case when (SUBSTRING(location_no,4,2)<18 or SUBSTRING(location_no,4,2)=91) then 'LOW' else 'HIGH' end, --
activity = [WarehouseVision].[dbo].[STOCKING_LEVELS].activity, USPD = [WarehouseVision].[dbo].[STOCKING_LEVELS].uspd, --
workindex =
case when SUBSTRING(location_no,4,2)<18 then
((ceiling((CAST(RIGHT(LEFT(location_no,5),2) AS int)-4)/ 2.0))) * (36*2) + -- ask Sameer about adding to this before we multiply because CMB racks start at 05 not 08 and distance looks same
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 
 
when SUBSTRING(location_no,2,2)<'91' and substring(location_no,4,2) < '35' then
((ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int) -24) / 2.0)))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
else 0
         
end
from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
left join [WarehouseVision].[dbo].[STOCKING_LEVELS] on ([WarehouseVision].[dbo].[STOCKING_LEVELS].Siteno = msc_location_build.Siteno) and ([WarehouseVision].[dbo].[STOCKING_LEVELS].item = msc_location_build.sku)
where msc_location_build.siteno = 'CMB'
  and (SUBSTRING(location_no,1,1) ='1' or SUBSTRING(location_no,1,1) ='2' or SUBSTRING(location_no,1,1) ='3' or SUBSTRING(location_no,1,1) ='4')

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 504  where substring(location_no,2,2) = '91' and substring(location_no,1,1) >='1' --check output on these locations
and substring(location_no,1,1) <='4' and siteno = 'CMB'
+
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 516  where substring(location_no,2,2) = '92' and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='4' and siteno = 'CMB'
+
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 36 where (substring(location_no,4,2) = '04' or substring(location_no,4,2) = '24') and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='4' and siteno = 'CMB'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 

update Location_Definitions set Work_Value = workindex
from [WarehouseVision].[dbo].[Location_Definitions]
inner join [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] on MSC_LOCATION_BUILD.siteno = Location_Definitions.siteno
and MSC_LOCATION_BUILD.LOCATION_NO = Location_Definitions.LOCATION_NO

 

 

 

 

/*** RNO ***/
/*** RNO ***/
/*** RNO ***/
/*** RNO ***/

 

 

--low side: bins 05-34
--high side: bins 47-77

 

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
set row = ceiling((SUBSTRING(location_no,4,2)/2))-0,
SIDE = SUBSTRING(location_no,1,1) + case when SUBSTRING(location_no,4,2)<47 then 'LOW' else 'HIGH' end,
activity = [WarehouseVision].[dbo].[STOCKING_LEVELS].activity, USPD = [WarehouseVision].[dbo].[STOCKING_LEVELS].uspd,
workindex =
case when SUBSTRING(location_no,4,2)<47 then
(ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int)-6)/ 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
              +
              CASE WHEN ((SUBSTRING(location_no,4,2)<='34') and (SUBSTRING(location_no,4,2)>='24')) THEN 84 ELSE 0 END

 else
(ceiling(((CAST(RIGHT(LEFT(location_no,5),2) AS int) -49) / 2.0))) * (36*2) +
              CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END
              +
              CASE WHEN ((SUBSTRING(location_no,4,2)<'78') and (SUBSTRING(location_no,4,2)>='62')) THEN 84 ELSE 0 END
end

from [WarehouseVision].[dbo].[MSC_LOCATION_BUILD]
left join [WarehouseVision].[dbo].[STOCKING_LEVELS] on ([WarehouseVision].[dbo].[STOCKING_LEVELS].Siteno = msc_location_build.Siteno) and ([WarehouseVision].[dbo].[STOCKING_LEVELS].item = msc_location_build.sku)
where msc_location_build.siteno = 'RNO'
  and (SUBSTRING(location_no,1,1) ='1' or SUBSTRING(location_no,1,1) ='2' or SUBSTRING(location_no,1,1) ='3')

 


update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 36  where (substring(location_no,4,2) = '05' or substring(location_no,4,2) = '47') and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'RNO'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 840  where (substring(location_no,4,2) = '78' or substring(location_no,4,2) = '79') and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'RNO'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 

update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 840  where (substring(location_no,4,2) = '01' or substring(location_no,4,2) = '02') and substring(location_no,2,2) = '67' and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'RNO'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 
update [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] set workindex = 840  where substring(location_no,4,2) = '' and substring(location_no,2,2) = '67' and substring(location_no,1,1) >='1'  
and substring(location_no,1,1) <='3' and siteno = 'RNO'
+             CASE WHEN SUBSTRING(location_no,6,2)<'07' THEN 12 ELSE
              CASE WHEN SUBSTRING(location_no,6,2)>='22' THEN 100 ELSE 0 END END

 

update Location_Definitions set Work_Value = workindex
from [WarehouseVision].[dbo].[Location_Definitions]
inner join [WarehouseVision].[dbo].[MSC_LOCATION_BUILD] on MSC_LOCATION_BUILD.siteno = Location_Definitions.siteno
and MSC_LOCATION_BUILD.LOCATION_NO = Location_Definitions.LOCATION_NO

 

 

/* notes for RNO
are the locations 78+ on aisles 50+ picking locations?
are bins 47 and 49 on aisle 28 closer?
bins on aisle 66 picking locations?
is work index of 36 correct for end cap bins? on protrack they look further
aisles where high side has extra bin right before second rack?
*/
