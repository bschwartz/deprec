# Copyright 2006-2008 by Mike Bailey. All rights reserved.
Capistrano::Configuration.instance(:must_exist).load do 
namespace :deprec do namespace :memcache do
      
  set :memcache_ip, '127.0.0.1'
  set :memcache_port, 11211
  set :memcache_memory, 256
  
  # XXX needs thought/work
  task :start, :roles => :search do
    run "memcached -d -m #{memcache_memory} -l #{memcache_ip} -p #{memcache_port}"
  end
  
  # XXX needs thought/work
  task :stop, :roles => :search do
    run "killall memcached"
  end
  
  # XXX needs thought/work
  task :restart, :roles => :search do
    stop
    start
  end
  
  task :install, :roles => :search do
    version = 'memcached-1.2.6'
    set :src_package, {
      :file => version + '.tar.gz',   
      :dir => version,  
      :url => "http://www.danga.com/memcached/dist/#{version}.tar.gz",
      :unpack => "tar zxf #{version}.tar.gz;",
      :configure => %w{
        ./configure
        --prefix=/usr/local 
        ;
        }.reject{|arg| arg.match '#'}.join(' '),
      :make => 'make;',
      :install => 'make install;',
      :post_install => 'install -b scripts/memcached-init /etc/init.d/memcached;'
    }
    apt.install( {:base => %w(libevent-dev)}, :stable )
    deprec2.download_src(src_package, src_dir)
    deprec2.install_from_src(src_package, src_dir)
  end
  
end end
end