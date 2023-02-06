# Best Practice

1. **Pinned (Tag) Version for each Container Image**
    Contoh: `nginx:1.19.8`
    Hal ini karena bisa jadi bisa merusak aplikasi. Lalu jika tidak didefinisikan, secara otomatis akan melakukan pull versi terbaru.

2. **Liveness Probe di setiap container**
    Akan melakukan pengecekan respond dari state liveness dari container yang ada di dalam pod setiap sekian detik. Dengan fitur liveness, container akan otomatis di restart apabila terdapat crash.
    
    Contoh:
    ```yaml
    containers:
        livenessProbe:
            periodSeconds: 5
            exec:
                command: ["/bin/grpc_health_probe", "-addr:8080"]
    ```

3. **Readiness Probe di setiap container**
    Akan melakukan pengecekan kesiapan aplikasi dalam container untuk dipakai. Dengan fitur liveness, container akan otomatis di restart apabila terdapat crash.

    Contoh:
    ```yaml
    containers:
        readinessProbe:
            periodSeconds: 5
            exec:
                command: ["/bin/grpc_health_probe", "-addr:8080"]
    ```

4. **Resource Request di setiap container**

    Contoh:
    ```yaml
    containers:
        resources:
            requests:
                cpu: 100m
                memory: 64Mi         
    ```

5. **Resource Limit di setiap container**

    Contoh:
    ```yaml
    containers:
        resources:
            limits:
                cpu: 200m
                memory: 128Mi         
    ```
6. **Jangan Expose Melalui NodePort**
    Gunakan LoadBalancer atau Ingress. Melalui single entry point agar security dan akses aplikasi lebih terjaga.

7. **Konfigurasi Deployment Lebih dari 1 Replica**
    Jika satu pod crash, maka aplikasi tidak akan bisa di akses sampai pod baru di restart. Jika menggunakan replica, maka jika satu down akan di backup oleh pod replika yang lain, sehingga aplikasi memiliki 0 downtime.

8. **Konfigurasikan worker node lebih dari 1**
    Mengihindari single point of failure, seperi server crash, server reboot, server maintainance, server broken, dll. Namun dengan syarat kita sudah melakukan replikasi terhadap node kita, agar isi data sama.

9. **Gunakan Label Setiap Saat dalam deployment**
    Sebagai custum identifier.

10. **Gunakan namespace untuk memisahkan resource aplikasi**

