#这个Dockerfile用于构建一个基于Nginx的Docker镜像，
# 其中包含了一些自定义的配置和静态文件。下面是对每一行的详细分析：
 #
 #FROM nginx:
 #这一行指定了基础镜像为nginx。Docker会从Docker Hub（或其他配置的镜像仓库）
 # 拉取官方的Nginx镜像作为构建新镜像的起点。
FROM nginx
# 设置工作目录为/usr/share/nginx/html/。
# 这是Nginx默认的静态文件服务目录，后续的COPY命令会将文件复制到这个目录下。
WORKDIR /usr/share/nginx/html/
# 将用户切换到root。这是因为接下来的操作（如复制文件到特定目录）可能需要root权限。
# 但请注意，在容器运行时通常不推荐使用root用户，
#  因为这可能增加安全风险。这里使用root是为了构建过程的需要，而Nginx本身运行时通常会使用非root用户。
USER root
# 将当前上下文目录下的docker/nginx.conf文件复制到容器内的/etc/nginx/conf.d/default.conf。
# 这实际上是替换了Nginx默认的配置文件，以便使用自定义的配置。
COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf
# 将当前上下文目录下的dist目录（及其内容）复制到容器内的/usr/share/nginx/html/。
# 这通常包含了前端应用构建后的静态文件，如HTML、CSS、JavaScript等。
COPY ./dist  /usr/share/nginx/html/
# 告诉Docker容器在运行时应该监听80端口。这通常是HTTP服务的默认端口，Nginx会在这个端口上提供静态文件服务。
EXPOSE 80
# 设置容器启动后要执行的命令。这里启动Nginx，并使用-g选项来设置全局指令daemon off;。
# 通常，当Nginx作为系统服务运行时，它会以守护进程的形式在后台运行（如果Nginx在后台运行，容器可能会立即退出，因为Docker会认为容器内没有活动的进程。）
# 这是设置为off，在启动Nginx服务器时，就可以让它在 前台 运行，而不是作为守护进程在后台运行
CMD ["nginx", "-g", "daemon off;"]
