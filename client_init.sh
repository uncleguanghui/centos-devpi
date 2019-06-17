# 下当服务器端部署完成后，本地客户端也需要初始化一下，修改pip源，以及创建索引方便以后发布包

# 安装
pip install devpi -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install requests urllib3 --force --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple

# 设置
if [ $URL ]; then
    devpi use $URL
else
    echo "请在 client_init.sh 文件的头部，添加devpi的地址，如: URL=http://XX.XX.XX.XX:XXXX"
    exit 1
fi

# 修改本地pip源
devpi use --set-cfg $URL/root/stable

# 创建用户并登陆
devpi user -c $USER password=''
devpi login $USER --password=''

# 创建索引
devpi index -c dev bases=root/stable

# 退出
devpi logoff