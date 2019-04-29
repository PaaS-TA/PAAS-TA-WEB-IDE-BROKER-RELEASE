# PAAS-TA-WEB-IDE-BROKER-RELEASE Guide
bosh 2.0 PAAS-TA-WEB-IDE-BROKER-RELEASE

1.WebIde Configuration
------------------------
- mysql :: 1 machine
- web-ide-broker :: 1 machine

2.Deploy
--------
>`$ sh deploy-vsphere.sh`

3.src
------
src 폴더에 각 package의 설치파일이 위치해야 한다.

src <br>
├── java <br>
│     └── jre-8u77-linux-x64.tar.gz <br>
├── mariadb <br>
│     └── mariadb-10.1.22-linux-x86_64.tar.gz <br>
├── web-ide-broker <br>
│      └── web-ide-broker.jar <br>
└── README.md <br>      
<br>

- 다운로드 위치 
>PAAS-TA-WEB-IDE-BROKER-RELEASE : **<http://45.248.73.44/index.php/s/rY7WyjyWzgcwDSQ/download>**
