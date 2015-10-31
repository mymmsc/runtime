#### 一、前期准备

   1. 添加用户组

    ```Bash
      groupadd runtime
    ```

   2. 添加用户
<pre>useradd -g runtime system
useradd -g runtime svn
useradd -g runtime runtime
</pre>
   3. 编辑 .bashrc
   4. screen -S labs
      screen -X labs

   5. 修改linux的软硬件限制文件/etc/security/limits.conf. 在文件尾部添加如下代码:
    ```Bash
    * soft nofile 65535
    * hard nofile 65535
    ```

   6. 修改当前用户的 .bashrc, 添加以下内容
<pre>
# User specific aliases and functions
if [ -f ~/etc/profile.msf ]; then
        . ~/etc/profile.msf
fi
alias myls="ls --color=auto"
alias ls="myls"
alias ll="ls -l"
</pre>

   7. 开发环境
<pre>
   1) ftp://ftp.vim.org/pub/vim/unix/vim-7.2.tar.bz2
   2) http://ftp.gnu.org/gnu/m4/m4-1.4.13.tar.bz2
   2) http://ftp.gnu.org/gnu/autoconf/autoconf-2.64.tar.bz2
   3) http://ftp.gnu.org/gnu/automake/automake-1.11.tar.bz2
   4) http://ftp.gnu.org/gnu/libtool/libtool-2.2.4.tar.bz2
   5) http://ftp.gnu.org/gnu/libiconv/libiconv-1.13.tar.gz
   6) ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz
      ftp://xmlsoft.org/libxml2/libxslt-1.1.24.tar.gz
      http://www.monkey.org/~provos/libevent-2.0.10-stable.tar.gz
   7) http://www.ethereal.com/distribution/ethereal-0.99.0.tar.bz2
   8) perl 
      -). http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/perl-5.12.3.tar.gz
      a. PERL安装MySQL库
        perl> perl -MCPAN -e "install DBI"
        perl> perl -MCPAN -e "install DBD::mysql"
      b. http://www.cpan.org/modules/by-module/DBD/DBI-1.608.tar.gz
         http://www.cpan.org/modules/by-module/DBD/DBD-mysql-4.011.tar.gz
</pre> 
1. httpd-2.4.x
   1) http://www.openssl.org/source/openssl-1.0.0g.tar.gz      
      a) ./config --prefix=$MSF_RUNTIME --openssldir=$MSF_APPS/openssl no-threads shared
   2) http://archive.apache.org/dist/httpd/httpd-2.4.7.tar.bz2
   3) 开发版源代码
      > svn co http://svn.apache.org/repos/asf/httpd/httpd/trunk/ httpd
      > libtoolize --automake --force
      http://archive.apache.org/dist/apr/apr-1.5.0.tar.bz2
      http://archive.apache.org/dist/apr/apr-util-1.5.3.tar.bz2
      ./configure --prefix=$MSF_APPS/httpd --enable-dav=shared --enable-proxy=shared --enable-proxy-connect=shared --enable-proxy-ftp=shared --enable-proxy-http=shared --enable-so --enable-shared --enable-rewrite=shared --disable-userdir --enable-cache --enable-disk-cache --enable-mem-cache --enable-deflate --enable-ssl --enable-headers --enable-vhost-alias --with-mpm=event --with-mpm=worker --with-mpm=prefork --with-status --with-ssl=$MSF_APPS --enable-module=so --enable-logio=shared --enable-dbd=shared --with-apr=$MSF_APPS --with-apr-util=$MSF_APPS
      a) httpd.conf 末尾增加
         Include /home/labs/conf/apache2/*.conf


2. SQLite 3.7.x
   1) http://sqlite.org/sqlite-autoconf-3071000.tar.gz
   2) 编译
     ./configure --prefix=$MSF_RUNTIME --enable-threadsafe --enable-cross-thread-connections --disable-tcl --enable-threads-override-locks
     ./configure --prefix=$MSF_RUNTIME --enable-threadsafe
   3) http://download.oracle.com/berkeley-db/db-5.3.15.tar.gz
      > cd build_unix
      > ../dist/configure --prefix=$MSF_RUNTIME --enable-java
3. MySQL Server
   1) http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz/from/http://mysql.he.net/
      a. apt-cache search ncurses
      b. sudo apt-get install libncurses5-dev
   2) 编译
     如果出现/bin/rm: cannot remove `libtoolT': No such file or directory, 需要执行以下三条指令
     > autoreconf --force --install
     > libtoolize --automake --force
     > automake --force --add-missing
     > ./configure --prefix=$MSF_APPS/mysql --with-charset=utf8 --without-debug --with-client-ldflags=-all-static --with-mysqld-ldflags=-all-static --with-mysqld-user=dbamysql --with-extra-charsets=all --with-unix-socket-path=$MSF_APPS/mysql --localstatedir=$MSF_RUNTIME/data/mysql --with-tcp-port=18036 --enable-thread-safe-client --with-big-tables --with-readline --with-ssl --with-embedded-server --enable-local-infile --with-plugins=all

   3) 初始化MySQL
      > mkdir ~/runtime/mysql/etc #复制my.cnf到etc下
      > mkdir ~/runtime/mysql/logs
      > cd ~/runtime/mysql
      > bin/mysql_install_db
   4) 启动MySQL
      > bin/mysqld_safe &
   5) 修改root用户密码
      > bin/mysqladmin -u root -p password 123456
      使用 mysqladmin 命令行 修改 用户名密码的方式。最正确的格式如下：
      > mysqladmin -u root -p password 123456
      接下来会提示
       Enter password:
      如果你是第一次登陆还没修改过密码，直接回车就可以了（我使用的是mysql5.0版本，4.0以前版本初始密码都是root）。
      这是 root 密码就修改成了  123456 。
      不要使用下面这种格式，否则密码就修改成了 '123456' 这个8位字符，而不是6位的了。
      > mysqladmin -u root -p password '123456'
   6) 创建所有权限的新用户
     > Grant all privileges on *.* to 'runtime'@'%' identified by ‘123456’ with grant option;

4. 安装 Subversion
   1) 下载软件包
     a. http://www.webdav.org/neon/neon-0.28.4.tar.gz
     b. http://apache.etoak.com/apr/apr-1.3.5.tar.bz2
     c. http://apache.etoak.com/apr/apr-util-1.3.7.tar.bz2
     b. http://apache.etoak.com/subversion/subversion-1.7.4.tar.bz2 
   2) 编译
     a. neon-0.28.4
        ./configure --prefix=$MSF_RUNTIME
     b. apr-1.3.5
        ./configure --prefix=$MSF_RUNTIME
     c. apr-util-1.3.7
        ./configure --prefix=$MSF_RUNTIME --with-apr=../apr-1.3.5 --with-dbm=db47 --with-sqlite3=$MSF_RUNTIME --with-berkeley-db=$MSF_RUNTIME
     b. subversion-1.7.3
        ./configure --prefix=$MSF_RUNTIME --with-apxs=$MSF_APPS/httpd/bin/apxs --with-apr=$MSF_RUNTIME --with-apr-util=$MSF_RUNTIME --with-sqlite=$MSF_RUNTIME --with-berkeley-db=HEADER:$MSF_RUNTIME/db40/include:LIB_SEARCH_DIRS:$MSF_RUNTIME/db40/lib

5. 安装 php
   http://www.zlib.net/zlib-1.2.3.tar.gz
   ftp://xmlsoft.org/libxml2/libxml2-2.7.3.tar.gz
   http://downloads.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.6.8.tar.bz2?use_mirror=jaist
   http://sourceforge.net/projects/libpng/files/02-libpng-devel/1.5.0beta36/libpng-1.5.0beta36.tar.bz2/download
   http://www.ijg.org/files/jpegsrc.v8d.tar.gz
   1) http://cn.php.net/get/php-5.4.23.tar.bz2/from/cn2.php.net/mirror
      http://cn2.php.net/get/php-5.5.7.tar.bz2/from/this/mirror
   2) 编译
     ./configure --prefix=$MSF_APPS/php --with-apxs2=$MSF_APPS/httpd/bin/apxs --with-config-file-path=$MSF_APPS/php/etc --with-curl=$MSF_RUNTIME --with-gettext --with-iconv --with-openssl=$MSF_RUNTIME --with-zlib=/usr --enable-ftp --enable-sockets --enable-wddx --enable-mbstring=all --enable-calendar --with-libxml-dir=$MSF_RUNTIME --enable-bcmath --enable-shmop --with-gd --with-mysql=$MSF_APPS/mysql --with-mysqli=$MSF_APPS/mysql/bin/mysql_config --with-mcrypt=$MSF_RUNTIME --with-png-dir=$MSF_RUNTIME --enable-fpm --with-pdo-mysql=$MSF_APPS/mysql
   3) https://phpmyadmin.svn.sourceforge.net/svnroot/phpmyadmin/trunk/phpMyAdmin/libraries/
   4) http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.2/phpMyAdmin-4.1.2-all-languages.zip?r=http%3A%2F%2Fwww.phpmyadmin.net%2Fhome_page%2Findex.php&ts=1388101651&use_mirror=jaist
   Q&A:
    报错提示：httpd: Syntax error on line 53 of /usr/local/apache/conf/httpd.conf: Cannot load /usr/local/apache/modules/libphp5.so into server: /usr/local/apache/modules/libphp5.so: cannot restore segment prot after reloc: Permission denied
    chcon -t texrel_shlib_t /home/labs/runtime/apache2/modules/libphp5.so

解决方法：
1关闭SELINUX的方法:
vi /etc/selinux/config 将SELINUX=enforcing 改成SELINUX=disabled 需要重启

2不关闭SELINUX的方法:
# setenforce 0
# chcon -t shlib_t /usr/local/apache/modules/libphp5.so
# service httpd restart
# setenforce 1

6. 安装glib2 
   1)  http://download.gnome.org/sources/glib/2.22/glib-2.22.0.tar.bz2

7. 安装Resin
   0) 设定临时环境变量
      RESIN_VERSION=4.0.36
   1) 直接下载: 
      http://www.caucho.com/download/resin-pro-${RESIN_VERSION}.tar.gz
      从SVN服务器下载:
      svn co http://runtime.googlecode.com/svn/trunk/resin resin
   2) 编译安装
   ./configure --prefix=$MSF_APPS/resin-pro-${RESIN_VERSION} --with-openssl=$MSF_RUNTIME --with-resin-log=$MSF_RUNTIME/logs/resin --with-resin-init.d=$MSF_APPS/resin-pro-${RESIN_VERSION}/sbin/resin.server
   3) sed -i -e 's/root-directory="."/root-directory="$MSF_RUNTIME\/html\/webapps"/g' $MSF_APPS/resin/conf/resin.xml

8. 安装Nginx
   1) https://nginx-upstream-jvm-route.googlecode.com/files/nginx-upstream-jvm-route-0.1.tar.gz
   2) patch -p0 < ../nginx-upstream-jvm-route/jvm_route.patch
   3) export NGINX_VER=1.5.2
  ./configure --prefix=$MSF_APPS/nginx --pid-path=$MSF_APPS/nginx/nginx.pid --lock-path=$MSF_APPS/nginx/nginx.lock --with-http_ssl_module --with-http_dav_module --with-http_flv_module --with-http_realip_module --with-http_gzip_static_module --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-pcre=$MSF_RUNTIME/temp/pcre-8.33 --with-zlib=$MSF_RUNTIME/temp/zlib-1.2.8 --http-client-body-temp-path=$MSF_RUNTIME/tmp/nginx/client --http-proxy-temp-path=$MSF_RUNTIME/tmp/nginx/proxy --http-fastcgi-temp-path=$MSF_RUNTIME/tmp/nginx/fastcgi --http-uwsgi-temp-path=$MSF_RUNTIME/tmp/nginx/uwsgi --http-scgi-temp-path=$MSF_RUNTIME/tmp/nginx/scgi --add-module=../nginx-upstream-jvm-route
   4) chown root nginx
   5) chmod u+s nginx

9. 安装Subversion



SUPPORTED=en_US.UTF-8:en_US:en:zh_CN.GB18030:zh_CN:zh:zh_TW.big5:zh_TW:zh:ja_JP.UTF-8:ja_JP:ja:ko_KR.eucKR:ko_KR:ko









[root@localhost root]# more /etc/sysconfig/clock
ZONE="America/New_York"
UTC=false
ARC=false

SELECT jid, IF(length(trim(nick)) > 0,nick,b.nick_name), subscription, ask, server, subscribe, type,grp,newcast FROM rosterusers a, vcard b WHERE a.username = '20009@pica' and a.jid = b.username
INSERT INTO vcard (username, nick_name, createtime) VALUES ('20008@pica', '20008', now());


1。mysql数据库没有增量备份的机制，当数据量太大的时候备份是一个很大的问题。还好mysql数据库提供了一种主从备份的机制，其实就是把主数据库的所有的数据同时写到备份数据库中。实现mysql数据库的热备份。

2。要想实现双机的热备首先要了解主从数据库服务器的版本的需求。要实现热备mysql的版本都要高于3.2，还有一个基本的原则就是作为从数据库的数据库版本可以高于主服务器数据库的版本，但是不可以低于主服务器的数据库版本。
3。设置主数据库服务器：
a.首先查看主服务器的版本是否是支持热备的版本。然后查看my.cnf(类unix)或者my.ini(windows)中mysqld配置块的配置有没有log-bin(记录数据库更改日志)，因为mysql的复制机制是基于日志的复制机制，所以主服务器一定要支持更改日志才行。然后设置要写入日志的数据库或者不要写入日志的数据库。这样只有您感兴趣的数据库的更改才写入到数据库的日志中。

server-id=1 //数据库的id这个应该默认是1就不用改动
log-bin=log_name //日志文件的名称，这里可以制定日志到别的目录 如果没有设置则默认主机名的一个日志名称
binlog-do-db=db_name //记录日志的数据库
binlog-ignore-db=db_name //不记录日志的数据库 
以上的如果有多个数据库用","分割开
然后设置同步数据库的用户帐号
mysql> GRANT REPLICATION SLAVE ON *.*
-> TO 'repl'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
4.0.2以前的版本, 因为不支持REPLICATION 要使用下面的语句来实现这个功能
mysql> GRANT FILE ON *.*
-> TO 'repl'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
设置好主服务器的配置文件后重新启动数据库
b.锁定现有的数据库并备份现在的数据
锁定数据库
mysql> FLUSH TABLES WITH READ LOCK;
备份数据库有两种办法一种是直接进入到mysql的data目录然后打包你需要备份数据库的文件夹，第二种是使用mysqldump的方式来备份数据库但是要加上"--master-data " 这个参数，建议使用第一种方法来备份数据库
c.查看主服务器的状态
mysql> show master status\G;
+---------------+----------+--------------+------------------+
| File | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+---------------+----------+--------------+------------------+
| mysql-bin.003 | 73 | test | manual,mysql |
+---------------+----------+--------------+------------------+
记录File 和 Position 项目的值，以后要用的。
d.然后把数据库的锁定打开
mysql> UNLOCK TABLES;
4。设置从服务器
a.首先设置数据库的配置文件
server-id=n //设置数据库id默认主服务器是1可以随便设置但是如果有多台从服务器则不能重复。
master-host=db-master.mycompany.com //主服务器的IP地址或者域名
master-port=3306 //主数据库的端口号
master-user=pertinax //同步数据库的用户
master-password=freitag //同步数据库的密码
master-connect-retry=60 //如果从服务器发现主服务器断掉，重新连接的时间差
report-host=db-slave.mycompany.com //报告错误的服务器
b.把从主数据库服务器备份出来的数据库导入到从服务器中
c.然后启动从数据库服务器，如果启动的时候没有加上"--skip-slave-start"这个参数则进入到mysql中
mysql> slave stop; //停止slave的服务
d.设置主服务器的各种参数
mysql> CHANGE MASTER TO
-> MASTER_HOST='master_host_name', //主服务器的IP地址
-> MASTER_USER='replication_user_name', //同步数据库的用户
-> MASTER_PASSWORD='replication_password', //同步数据库的密码
-> MASTER_LOG_FILE='recorded_log_file_name', //主服务器二进制日志的文件名(前面要求记住的参数)
-> MASTER_LOG_POS=recorded_log_position; //日志文件的开始位置(前面要求记住的参数)
e.启动同步数据库的线程
mysql> slave start;
查看数据库的同步情况吧。如果能够成功同步那就恭喜了！
查看主从服务器的状态
mysql> SHOW PROCESSLIST\G //可以查看mysql的进程看看是否有监听的进程
如果日志太大清除日志的步骤如下 
1.锁定主数据库 
mysql> FLUSH TABLES WITH READ LOCK; 
2.停掉从数据库的slave 
mysql> slave stop; 
3.查看主数据库的日志文件名和日志文件的position 
show master status; 
+---------------+----------+--------------+------------------+ 
| File | Position | Binlog_do_db | Binlog_ignore_db | 
+---------------+----------+--------------+------------------+ 
| louis-bin.001 | 79 | | mysql | 
+---------------+----------+--------------+------------------+ 
4.解开主数据库的锁 
mysql> unlock tables; 
5.更新从数据库中主数据库的信息 
mysql> CHANGE MASTER TO 
-> MASTER_HOST='master_host_name', //主服务器的IP地址 
-> MASTER_USER='replication_user_name', //同步数据库的用户 
-> MASTER_PASSWORD='replication_password', //同步数据库的密码 
-> MASTER_LOG_FILE='recorded_log_file_name', //主服务器二进制日志的文件名(前面要求记住的参数) 
-> MASTER_LOG_POS=recorded_log_position; //日志文件的开始位置(前面要求记住的参数) 
6.启动从数据库的slave 
mysql> slave start;


#chmod  a+trwx  /home/public
export LUA_CFLAGS="-I/usr/local/include" LUA_LIBS="-L/usr/local/lib -llua -ldl" LDFLAGS="-lm"


#################
1. apache + subversion 
1) label svn repository files as httpd_sys_content_rw_t:

>> chcon -R -t httpd_sys_content_rw_t /path/to/your/svn/repo
2) set selinux boolean httpd_unified --> on

>> setsebool -P httpd_unified=1
I prefer 2nd possibility. You can play also with other selinux booleans connected with httpd:

etsebool -a | grep httpd



####################
CentOS配置SSH证书登录验证:
1）先添加一个维护账号：msa
2）然后su - msa
3）ssh-keygen -t rsa
   指定密钥路径和输入口令之后，即在/home/msa/.ssh/中生成公钥和私钥：id_rsa id_rsa.pub
4）cat id_rsa.pub > authorized_keys
   至于为什么要生成这个文件，因为sshd_config里面写的就是这个。
   然后chmod 400 authorized_keys，稍微保护一下。
5）用psftp把把id_rsa拉回本地，然后把服务器上的id_rsa和id_rsa.pub干掉
6）配置/etc/ssh/sshd_config
   Protocol 2
   ServerKeyBits 1024
   PermitRootLogin no  #禁止root登录而已，与本文无关，加上安全些
   #以下三行没什么要改的，把默认的#注释去掉就行了
   RSAAuthentication yes
   PubkeyAuthentication yes
   AuthorizedKeysFile    .ssh/authorized_keys
   PasswordAuthentication no
   PermitEmptyPasswords no
7）重启sshd
   /sbin/service sshd restart
8）转换证书格式，迁就一下putty
   运行puttygen，转换id_rsa为putty的ppk证书文件
9）配置putty登录
   在connection--SSH--Auth中，点击Browse,选择刚刚转换好的证书。
   然后在connection-Data填写一下auto login username，例如我的是msa
   在session中填写服务器的IP地址，高兴的话可以save一下
10）解决一点小麻烦
    做到这一步的时候，很可能会空欢喜一场，此时就兴冲冲的登录，没准登不进去：
    No supported authentication methods available
    这时可以修改一下sshd_config，把
    PasswordAuthentication no临时改为：
    PasswordAuthentication yes 并重启sshd
    这样可以登录成功，退出登录后，再重新把PasswordAuthentication的值改为no，重启sshd。
    以后登录就会正常的询问你密钥文件的密码了，答对了就能高高兴兴的登进去。
    至于psftp命令，加上个-i参数，指定证书文件路径就行了。

>> 批量转换ipa中的png文件
for i in `ls *.png`; do pngcrush -revert-iphone-optimizations $i ../$i; done
>> 批量修改文件编码
find ./ -name *.java -exec sh -c "cp {} {}.bak;iconv -f gb18030 -t UTF8 {} > abc.a; mv abc.a  {}" \;
