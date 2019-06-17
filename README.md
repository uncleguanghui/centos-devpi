# 快速部署Devpi-Server

本项目用于以`root`身份在Centos快速部署Devpi-Server，以及在本地，以当前用户创建索引并修改本地pip配置

# 上手指南

## clone

```
git clone https://github.com/uncleguanghui/centos-devpi.git
cd centos-devpi
```

进来后可以看到

```
.
├── README.md
├── client_init.sh  # 本地配置脚本
├── deploy_centos.sh  # 服务器端部署脚本
└── devpi.ini  # supervisor配置

0 directories, 4 files
```

## 服务器端部署

```
sh deploy_centos.sh
```

## 本地配置

当服务器端部署完成后，设置URL为服务器ip+端口，如10.10.10.10:8013

```
URL=devpi部署URL
sh client_init.sh
```