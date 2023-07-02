1 - main-cobol program SORTREP6.CBL ve main JCL SORTREP6.JCL'dir.

2 - Bu programaları çalıştırmaya başlamadan önce sırasıyla

3 - ORTREP2.JCL -> SUBMIT edilip main programda input olarak kullanılacak record-keyler yaratılır.

4 - SORTREP3.JCL -> SUBMIT edilip main programda SORTREP2.JCL'den yaratilan record-keyler ile eslenmesi gereken kisi bilgilerinin tutuldugu recordlar QSAM.AA dosyasi ve recordların sizelerinin kucultuldugu QSAM.BB dosyasi yaratilir.

4 - SORTREP4.JCL -> SUBMIT edilip QSAM.BB'deki tüm veriler VSAM.AA dosyasinin icine yazilir ve main-programda kisi bilgilerini tutan input olarak bu VSAM dosyasi kullanılır.

4 - son olarak SORTREP6.JCL dosyasi SUBMIT edilir ve .INP ile QSAM.AA daki veriler programın output dosyasi olan QSAM.ZZdeki veriler ile karsilastirilir.

4 - ancak .INP dosyasının boyutu küçültülüp binary hale getirildiği icin VSCODE ortamında açılamayacaktır. Bu yüzden .INP dosyasi verilerinin SORTREP2.JCL'de  //SORTIN   DD * altında girilen inputlar olduğu düşünülmelidir.

4 -eger SORTREP2.JCL'de  
//SYSIN    DD *
  SORT FIELDS=COPY
  OUTREC FIELDS=(1,5,ZD,TO=PD,LENGTH=3,
                 6,3,ZD,TO=BI,LENGTH=2)
talimatı kaldırılırsa .INP dosyasi görüntülenecektir fakat SORTREP6.CBL'un hatasız çalışması için gerekli düzenlemelerin yapılması gerektiği unutulmamalıdır.