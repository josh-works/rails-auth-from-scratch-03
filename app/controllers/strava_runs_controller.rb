require 'csv'
class StravaRunsController < ApplicationController
  def index
    @runs = get_run_data    
  end
  
  private
  
  def get_run_data
    polyLines = [
      "kyuqFzsgaSI@ED@HC?MBAHNl@b@v@x@nBLRJb@RDh@o@\m@|AqBjAqA|AqAh@g@pByA~@_Az@s@~DcEbB{A`@[l@]A@FA??dAs@dAiAvCqCt@{@`DyCxAoAf@k@\QZYX]hBcB~@s@dCuBvAyAfA_AR@HH`AbCNTN?DOFDKJCK@OADEIBLLGDBQEK[IE_@y@BDAPGJ?FGBS@s@v@I@KMKG?BHDGE@@@CSF}NlIsFnD]X[V~Q{I^k@\o@lBmBn@]\R@Q^G",
      "mqsqFj`faS@X?Ig@h@}@p@IGa@gAMMKAOFIJKDSX]XEHQLCHe@^oAlAoAdAc@Zo@h@QHSGGe@Sa@gAiCmAcCQo@KGGKgAeCOUGSKICJ?JHL?j@@z@Ad@E\Wp@w@bAiDtCuAvAa@P]FIFYX]NI?QMq@H{AGc@BgAEF?BNACJFAEAA@BA?CKCBICL??DG?@CEAJ?ABBEG?DBEADAGE@?DB@HGHGAKII?wCTg@?]CI@SC_@Bk@EUBGF]`ASXQv@Cj@?l@Iz@BNEZ_@n@s@`Aa@Tg@TKHY\yA|@APDLLJPFXZDJDd@?d@BTJVNRTr@GXKPUTSLW\SLe@f@CF?HX\l@lAPf@FHFDHIHCDDCAJSB??ECBDA"
    ]
    polyLines
  end
end
