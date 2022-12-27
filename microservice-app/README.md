# NOTE

## Cara Aplikasi Online Butik Berkerja

1. Terdapat service frontend yang nantinya akan memforward trafik user ke service ad, checkout, shipping, currency, recommendation dan cat.

2. Selain itu cart service membutuhkan redis untuk menyimpan data. 

3. Load generator (optional) digunakan untuk membuat banyak traffik demi menguji banyak request ke frontend service.

## NOTE 2
1. **Email service** butuh list env yaitu: 
    - env: PORT

2. List image puclic setiap service
    -  Email Service: gcr.io/google-samples/microservices-demo/emailservice
    - 

3. Kita mendapatkan informasi dari developer untuk melakukan deployment, maka dari itu informasi yang perlu diketahui adalah:
    - Bagaimana satu aplikasi terkoneksi dengan service lainnya?
    - Apa nama Image untuk setiap microservice?
    - Apa ENV yang dibutuhkan untuk setiap microservice?
    - Pada port berapa saja microservice berjalan?

4. Fungsi Redis adalah sebagai message broker dan In-Memory database yaitu temporary storage untuk cart info.

5. **Recommendation service** saling berbicara dengan **Product Catalog Service** dengan menkonfigurasi endpoint (Service Name + Service Port). - 
    - env: PRODUCT_CATALOG_SERVICE_ADDR, (dibuat sendiri)

6. Urutan Deployment Service: Email, Recommendation, Product Catalog, Payment, Currency, 

7. Jika suatu service berkomunikasi dengan lebih dari satu service tambahkan endpoint address.

8. Redis container berkomunikasi dengan volume untuk melakukan presistensi data. Jenis volume yang digunakan adalah emptyDir sifatnya akan tetap exist di dalam container dengan syarat pod tetap running dan data akan tetap ada meski container crash.

9. Checkout service terkoneksi langsung dengan 6 microservice lainnya. Maka dari itu perlu didefinisikan 6 endpoint service pada env checkout deployment.

10. Definisikan dimulai dari service penyendiri dulu, lalu ke service extrovert. Supaya mudah untuk melakukan konfigurasi endpoint di akhir.

11. Buat konfigurasi eksternal akses dalam frontend service agar bisa diakses internet. 

12. Manifest currency dan payment service bermasalah. 

## Security Best Practice

• Production and Security Best Practices (Demo Lanjutan)
Best Practice 1 - Pinned (Tag) Version untuk setiap Container Image
Best Practice 2 - Liveness Probe untuk setiap Container
Best Practice 3 - Readiness Probe untuk setiap Container
Best Practice 4 - Resource request untuk setiap container
Best Practice 5 - Resource Limit untuk setiap container
Best Practice 6 - Ingress sebagai External Service Receiver
Best Practice 7 - Lebih Dari 1 Replica untuk Deployment

• Create a Helm Chart for Microservice (Demo Lanjutan)
Struktur Dasar dari Helm Chart
Membuat Basic Template File
Konfigurasi Dynamic Environment Variable
Helm Rendering Process
Step by step Membuat Shared Helm Chart untuk setiap microservice

• Deploy Microservice with Helmfile (Demo)
Apa itu helmfile
Membuat helmfile
Step by step cara men-deploy microservice dengan helmfile
