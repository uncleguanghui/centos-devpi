# ########################## 配置项 ##########################

dir_parent=$(cd `dirname $0`;pwd)
conf_supervisor=$dir_parent/devpi.ini

server=/bin/devpi-server
dir_devpi=/data/devpi
dir_supervisor_config=/etc/supervisor/config.d
target_conf=$dir_supervisor_config/devpi.ini

PYTHON_VERSION=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1}'`

# ########################## 关闭服务 ##########################

# 若服务启动，则杀死
for pid in $(pidof -x devpi); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : devpi : 程序正在运行， PID $pid"
        kill -9 $pid
    fi
done

# ########################## 安装并配置 ##########################

# 设置缓存地址
if [ ! -d "$dir_devpi" ]; then
    mkdir -p $dir_devpi
fi

# 安装
if [ ! -f "$server" ]; then
    pip install devpi -i https://pypi.tuna.tsinghua.edu.cn/simple
    # 当环境为python2时，直接运行是有问题的，需要更新requests和urllib3
    if [ $PYTHON_VERSION == 2 ];then
        pip install requests urllib3 --force --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple
    fi

    # 初始化目录
    devpi-server --serverdir /data/devpi --init
fi

# 配置supervisor
if [ -d "$dir_supervisor_config" ]; then
    if [ ! -f "$target_conf" ]; then
        cp $conf_supervisor $target_conf
        supervisorctl update
    fi
else
    echo "请安装supervisor，以防止服务器重启后devpi服务挂掉：https://github.com/uncleguanghui/centos-supervisor"
    exit 1
fi
supervisorctl start devpi

# ########################## 初始化 ##########################

IP=$(hostname -I | awk '{print $1}')
URL=$IP:8013

# 连接并登陆
devpi use $URL
devpi login root --password ''

# 修改密码
devpi user -m root password=qweasd123

# 修改镜像地址
devpi index root/pypi mirror_url="https://pypi.tuna.tsinghua.edu.cn/simple"

# 创建不可修改的索引
devpi index -c stable volatile=False bases=root/pypi

# 退出
devpi logoff

# 修改本地pip配置
devpi use --set-cfg $URL/root/stable
