# Configmap & Secret

## Demo

Gunakan cluster local untuk melakukan demo ini.

1. Deploy terlebih dahulu mosquitto tanpa volume configmap
    ```bash
    kubectl apply -f mosquitto.yaml
    ```
    Cek kondisi pod: `kubectl get pod`
    ```console
    NAME                         READY   STATUS    RESTARTS   AGE
    mosquitto-5ddd49c445-pbmlb   1/1     Running   0          80s
    ```

2. Masuk ke dalam pod untuk mengetahui lokasi konfigurasi file mosquitto
    ```bash
    kubectl exec -it mosquitto-5ddd49c445-pbmlb -- /bin/sh
    ```
    Di dalam container masuk ke dalam file `mosquito.conf`
    ```bash
    cd mosquitto/config/
    less mosquito.conf
    ```
    Setelah selesai, hapus pod
    ```bash
    kubectl delete -f mosquitto.yaml
    ```
3. Kita akan melakukan overwrite file .conf menggunakan configmap volume
    
    Deploy terlebih dahulu configmap dan secret nya

    ```bash
    kubectl apply -f mosquitto-cm.yaml
    kubectl apply -f mosquitto-secret.yaml
    ```

    Tambahkan konfigurasi volume agar di mount ke pod
    ```yaml
    volumes:
        - name: mosquitto-conf
          configMap:
            name: mosquitto-config-file
        - name: mosquitto-secret
          secret:
            secretName: mosquitto-secret-file    
    ```
    Tambahkan konfigurasi volume agar di mount ke container

    ```yaml
    ### di dalam spec containers
         volumeMounts:
            - name: mosquitto-conf
              mountPath: /mosquitto/config
            - name: mosquitto-secret
              mountPath: /mosquitto/secret  
              readOnly: true
    ```
    Deploy mosquitto deployment dengan volume

    ```bash
    kubectl apply -f mosquitto-deployment.yaml
    ```
4. Masuk ke dalam pod yang untuk mengetahui lokasi konfigurasi file configmap dan secret

    ```bash
    kubectl exec -it mosquitto-5ddd49c445-pbmlb -- /bin/sh
    ```
    Di dalam container masuk ke dalam directory secret dan lihat isi secret.file
    ```bash
    cd mosquitto/secret/
    cat secret.file
    ```
    Di dalam container masuk ke dalam file `mosquito.conf`, lihat isi file nya sudah di overwrite.
    ```bash
    cd mosquitto/config/
    cat mosquito.conf
    ```

### Referensi
https://youtu.be/tAqRLna15JI (Confimap)

https://youtu.be/spg_Ac3A0Ro (Secret)

https://youtu.be/Ir87iMAm7cM (Demo)
