runtime
=======

*nix系统运行环境及安装配置
搭建系统环境全程以INSTALL为主手动进行，soft目录中有部分必须的软件包。
整个环境拟以system用户为系统支撑账户，nginx前置url分发，后端业务处理由runtime用户apache、svn、php、mysql和resin或其它软件组成

相对根路径，如windows建议采用e:/runtime，Unix/Linux采用/home/runtime，结构如下：

<pre>
${RUNTIME}            项目安装根路径
|
|-->apps            应用软件安装目录
|     |
|     |-->httpd     Apache安装路径
|     |-->redis     Redis安装路径
|     |-->resin     ResinPro安装路径
|     |-->nginx     Nginx安装路径
|     |-->mysql     MySQL Server安装路径
|     |-->php       php/cgi/fastcgi安装路径
|
|-->bin             执行文件目录
|
|-->build           工程编译工具文件目录
|
|-->etc             配置文件目录
|      |
|      |-->httpd    Apache扩展模块配置文件目录
|      |-->nginx    Nginx扩展配置文件目录
|      |-->resind   Resin Pro扩展配置文件目录
|
|-->data            数据库等等数据文件
|
|-->docs            文档目录
|
|-->include         C/C++头文件目录
|
|-->lib             C/C++/Java库文件目录
|
|-->logs            日志目录
|      |
|      |-->apps     应用程序日志文件根目录
|      |-->httpd    Apache日志文件目录, 软链接到apps/httpd/logs
|      |-->nginx    Nginx日志文件目录, 软链接到apps/nginx/logs
|      |-->resin    Resin日志文件目录, 软链接到apps/resin/log
|
|-->tools           工具文件目录
|
|-->temp            临时目录
|
|-->html
|      |
|      |-->htdocs     PHP等解析型脚本语言工程目录
|      |-->webapps    J2EE工程目录


</pre>