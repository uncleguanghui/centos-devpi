# ########################## 配置项 ##########################

dir_parent=$(cd `dirname $0`;pwd)
conf_supervisor=$dir_parent/devpi.ini

server=/bin/devpi-server
dir_devpi=/data/devpi
dir_supervisor_config=/etc/supervisor/config.d

# ########################## 安装并配置 ##########################

# 安装
if [ ! -f "$server" ]; then
    pip install devpi -i https://pypi.tuna.tsinghua.edu.cn/simple
fi

# 设置缓存地址
if [ ! -d "$dir_devpi" ]; then
    mkdir -p $dir_devpi
fi

# 配置supervisor
if [ -d "$dir_supervisor_config" ]; then
    if [ ! -d "$dir_supervisor_config" ]; then
        cp $conf_supervisor $dir_supervisor_config
        supervisorctl update
    else
        echo "请安装supervisor，以防止服务器重启后devpi服务挂掉：https://github.com/uncleguanghui/centos-supervisor"
    fi
fi

