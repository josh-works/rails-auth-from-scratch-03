require "test_helper"

class StravaRunsTest < ActiveSupport::TestCase
  test "strava run initialize" do
    id = 6679367265
    polyline = "efyqFzj_aSBI?B?APEJANDF?NMPAPIb@@\\CLIVIN@fBVLARKFKDCVAZe@REDIPQBIHKNAJEN@NKDIJAZKTCJGXBFDJLDPAZHZ?XJf@HLL`@F^@^CVB\\CZ?`AA\\I^?RI^g@nAGXFZNTDNPX\\Rb@DNHp@HTC?DKTABB?@ECB?D?A@@G??A@BB??CB?@BA@?C?@ABD?E?ACBGHKDC?FUR?A?BCC?@@A@@CHAA^Px@T`BVnBd@tAV`D~@zB`@l@Vh@`@tAnAbBvBz@|@zAtAtAfAPTNVt@hBj@jArAbCv@lAl@pAj@bBj@hCb@`EPv@Tr@LPl@j@l@z@Xl@Rn@j@xAHJJE\\YLYD]A{@Ky@iAaFAOH]DENAF@FDLXp@dCv@`Ed@pBd@`DTnAz@|CvCbMbA|DpE~LnApCx@tBtJrSz@nAJTHXD`@ZtCb@`DXpA`@nAT`@jArA|CtD|AxAlCxBf@f@r@xBbBzDVt@j@pATr@ATm@f@kAxAqAfAgD`DiB|AwCxCmCvBuBtBcAx@iE~DuDbDyDvDkA~@CF@NVZh@`Aj@|@DPEC@B?CFE@SFBG?FC?AA@FQB@IPFIBKD?DG?CC?DE?BCE@BC?@GBFA?B?CCBBEBAGBA?@?AC@AD?AKFH??KCEF@FD?CCA@A@FACABB@?CDA?@E?ACCAD@IMDF?BE@AA?@?GDDE?BEA@CCD@AB?ECDB@ECF@AA?@AAD@G@?C@@CA@BBAGEFHEE?DACB?ACDBGCCFBIDDMAHBEEBDEI?DF@ICBD@E?D?CF@GAD?IBFAEA@FBE?CBDEB@@?CD@BGDD?FCEBBABAA@B@CGA?C@F?IA@?P@AGJ@BAG@A@DEDBEJ@C@AKC@B?C?H@K?MRERE?OUOk@GAEIOg@m@aAAEDO\\SRWLSBKNKJA^]JS?UKOa@iAGu@K_@@GZKb@YTC`@SPGHED?JIRCDBLCJKXAPIJOTQHUTc@Na@nAkBVOLSVITQRERWD@^M\\[^OHOLIX]d@y@^ETMXAZLx@Fr@XLOZSHITCPGBYECFMbBuAj@k@^QT_@VMj@{@\\YPWFGPCVKlAeAf@m@NGFKHADINOJQRQLCFEDM@DJORK^i@@@?JJZBCBFAABGH@GKC?@BC?@KAHCEDJ?@MJADAAC@OKBIPIPFDCEB@@CHJCQ?UDGHCA@DEADA"
    
    run = StravaRun.new(id: id, polyline: polyline)
    
    assert_equal id, run.id
    assert_equal polyline, run.polyline
  end
  
  def test_download_activites
    StravaRun.download_activites
    
    
  end
end